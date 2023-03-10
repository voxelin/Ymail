FROM denoland/deno:alpine
EXPOSE 7000
WORKDIR /app

# Cache the dependencies as a layer (the following two steps are re-run only when deps.ts is modified).
# Ideally cache deps.ts will download and compile _all_ external files used in main.ts.
COPY deps.deno.ts .
RUN deno cache deps.deno.ts

# These steps will be re-run upon each file change in your working directory:
ADD . .
# Compile the main app so that it doesn't need to be compiled each startup/entry.
RUN deno cache api/edge.ts --lock=deno.lock --lock-write

CMD ["task", "edge"]