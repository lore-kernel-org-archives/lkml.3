Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056Ab3HSTGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 15:06:09 -0400
Received: from mail-gh0-f172.google.com ([209.85.160.172]:60560 "EHLO
	mail-gh0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3HSTGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 15:06:08 -0400
Date: Mon, 19 Aug 2013 16:06:03 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf trace: Make command line arguments consistent with
 perf-record
Message-ID: <20130819190603.GA1959@ghostprotocols.net>
References: <1376931870-19912-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376931870-19912-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 19, 2013 at 11:04:30AM -0600, David Ahern escreveu:
> Common arguments like thread id, CPU list, mmap pages, etc should be
> consistent across perf commands.

Ok, at some point I'll add a 'perf strace' alias that will resume trying
to map the 'strace' single letter options.

Can you check if this clashes with the -o patch I added today?

- Arnaldo
 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/builtin-trace.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> index da7ae01..55f1287 100644
> --- a/tools/perf/builtin-trace.c
> +++ b/tools/perf/builtin-trace.c
> @@ -637,17 +637,17 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
>  	const struct option trace_options[] = {
>  	OPT_STRING('p', "pid", &trace.opts.target.pid, "pid",
>  		    "trace events on existing process id"),
> -	OPT_STRING(0, "tid", &trace.opts.target.tid, "tid",
> +	OPT_STRING('t', "tid", &trace.opts.target.tid, "tid",
>  		    "trace events on existing thread id"),
> -	OPT_BOOLEAN(0, "all-cpus", &trace.opts.target.system_wide,
> +	OPT_BOOLEAN('a', "all-cpus", &trace.opts.target.system_wide,
>  		    "system-wide collection from all CPUs"),
> -	OPT_STRING(0, "cpu", &trace.opts.target.cpu_list, "cpu",
> +	OPT_STRING('C', "cpu", &trace.opts.target.cpu_list, "cpu",
>  		    "list of cpus to monitor"),
> -	OPT_BOOLEAN(0, "no-inherit", &trace.opts.no_inherit,
> +	OPT_BOOLEAN('i', "no-inherit", &trace.opts.no_inherit,
>  		    "child tasks do not inherit counters"),
> -	OPT_UINTEGER(0, "mmap-pages", &trace.opts.mmap_pages,
> +	OPT_UINTEGER('m', "mmap-pages", &trace.opts.mmap_pages,
>  		     "number of mmap data pages"),
> -	OPT_STRING(0, "uid", &trace.opts.target.uid_str, "user",
> +	OPT_STRING('u', "uid", &trace.opts.target.uid_str, "user",
>  		   "user to profile"),
>  	OPT_CALLBACK(0, "duration", &trace, "float",
>  		     "show only events with duration > N.M ms",
> -- 
> 1.7.10.1
