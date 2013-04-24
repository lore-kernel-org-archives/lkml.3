Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab3DXOSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:18:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069Ab3DXOSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:18:12 -0400
Date: Wed, 24 Apr 2013 16:17:24 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 12/14] perf ftrace: Use pager for displaying result
Message-ID: <20130424141724.GH971@krava.brq.redhat.com>
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
 <1366705872-12132-13-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366705872-12132-13-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 05:31:10PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> It's convenient to use pager when seeing many lines of result.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-ftrace.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
> index 97293cee5597..f4efa1475cf9 100644
> --- a/tools/perf/builtin-ftrace.c
> +++ b/tools/perf/builtin-ftrace.c
> @@ -188,6 +188,7 @@ static int do_ftrace_live(struct perf_ftrace *ftrace)
>  	signal(SIGINT, sig_handler);
>  	signal(SIGUSR1, sig_handler);
>  	signal(SIGCHLD, sig_handler);
> +	signal(SIGPIPE, sig_handler);
>  
>  	if (setup_tracing_files(ftrace) < 0)
>  		goto out_reset;
> @@ -1461,6 +1462,8 @@ __cmd_ftrace_live(struct perf_ftrace *ftrace, int argc, const char **argv)
>  						  argv, false, true) < 0)
>  		goto out_maps;
>  
> +	setup_pager();
> +
>  	ret = do_ftrace_live(ftrace);
>  
>  out_maps:
> @@ -1582,6 +1585,8 @@ __cmd_ftrace_show(struct perf_ftrace *ftrace, int argc, const char **argv)
>  	if (ftrace->dirname == NULL)
>  		ftrace->dirname = DEFAULT_DIRNAME;
>  
> +	setup_pager();
> +
>  	ret = do_ftrace_show(ftrace);
>  
>  	perf_evlist__delete_maps(ftrace->evlist);
> @@ -1643,6 +1648,7 @@ __cmd_ftrace_report(struct perf_ftrace *ftrace, int argc, const char **argv)
>  	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
>  	perf_hpp__init();
>  
> +	setup_pager();
>  	setup_sorting();
>  
>  	symbol_conf.exclude_other = false;
> -- 
> 1.7.11.7
> 

for some reason I'm able to get any output for 'live' command only
when using --no-pager option. I dont get any data for:

  # ./perf ftrace live ls

  not even ls output

But sometime I dont even get ftrace output for:

  # ./perf --no-pager ftrace live ls

  just ls output


I wonder there's some race with reading trace_pipe file,
I haven't checked deeply yet..

jirka
