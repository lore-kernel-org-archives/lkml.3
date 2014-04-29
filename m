Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670AbaD2K51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 06:57:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932384AbaD2K50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 06:57:26 -0400
Date: Tue, 29 Apr 2014 12:56:54 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v3 2/3] perf record: Propagate exit status of a command
 line workload
Message-ID: <20140429105654.GB1148@krava.brq.redhat.com>
References: <1398346054-3322-1-git-send-email-namhyung@kernel.org>
 <1398346054-3322-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398346054-3322-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 10:27:33PM +0900, Namhyung Kim wrote:

SNIP

> Reported-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-record.c |  121 ++++++++++++++++++-------------------------
>  1 file changed, 51 insertions(+), 70 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index eb524f91bffe..b1523d8a6191 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -152,26 +152,6 @@ static void sig_handler(int sig)
>  	signr = sig;

looks like there's no use for 'signr' now.. could be removed

>  }
>  
> -static void record__sig_exit(int exit_status __maybe_unused, void *arg)
> -{
> -	struct record *rec = arg;
> -	int status;
> -
> -	if (rec->evlist->workload.pid > 0) {
> -		if (!child_finished)
> -			kill(rec->evlist->workload.pid, SIGTERM);
> -
> -		wait(&status);
> -		if (WIFSIGNALED(status))
> -			psignal(WTERMSIG(status), rec->progname);
> -	}
> -
> -	if (signr == -1 || signr == SIGUSR1)
> -		return;
> -
> -	signal(signr, SIG_DFL);

I was wondering what was this one for and found:

  perf_counter tools: Propagate signals properly
  commit f7b7c26e01e51fe46097e11f179dc71ce7950084
  Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
  Date:   Wed Jun 10 15:55:59 2009 +0200

but I dont think we need to do that

thanks,
jirka
