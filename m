Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaBCPKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:10:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbaBCPKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:10:16 -0500
Date: Mon, 3 Feb 2014 13:09:15 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 3/3] perf tools: Add readable output for callchain debug
Message-ID: <20140203150915.GA2352@infradead.org>
References: <1391427883-13443-1-git-send-email-jolsa@redhat.com>
 <1391427883-13443-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391427883-13443-3-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 03, 2014 at 12:44:43PM +0100, Jiri Olsa escreveu:
> Adding people readable output for callchain debug,
> to get following '-v' output:
> 
>   $ perf record -v -g ls
>   callchain: type DWARF
>   callchain: stack dump size 4096
>   ...

Applied, but then I tried:

[acme@zoo linux]$ perf evlist -v
cycles: sample_freq=4000, size: 96, sample_type:
IP|TID|TIME|CALLCHAIN|PERIOD, disabled: 1, inherit: 1, mmap: 1, comm: 1,
freq: 1, enable_on_exec: 1, sample_id_all: 1, exclude_guest: 1
[acme@zoo linux]$ 


I.e. using the tool that provides info about 'perf.data' files, and
there I couldn't figure it out which kind of callchains was used, can
you fix it there too?

- Arnaldo
 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/builtin-record.c | 4 +++-
>  tools/perf/perf.h           | 3 ++-
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 3f7ec8a..679758f 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -741,7 +741,9 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
>  
>  static void callchain_debug(struct record_opts *opts)
>  {
> -	pr_debug("callchain: type %d\n", opts->call_graph);
> +	static const char *str[CALLCHAIN_MAX] = { "NONE", "FP", "DWARF" };
> +
> +	pr_debug("callchain: type %s\n", str[opts->call_graph]);
>  
>  	if (opts->call_graph == CALLCHAIN_DWARF)
>  		pr_debug("callchain: stack dump size %d\n",
> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index 6dabc15..c30e1ae 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -251,7 +251,8 @@ void pthread__unblock_sigwinch(void);
>  enum perf_call_graph_mode {
>  	CALLCHAIN_NONE,
>  	CALLCHAIN_FP,
> -	CALLCHAIN_DWARF
> +	CALLCHAIN_DWARF,
> +	CALLCHAIN_MAX
>  };
>  
>  struct record_opts {
> -- 
> 1.8.3.1
