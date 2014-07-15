Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaGOOY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:24:29 -0400
Received: from mail.kernel.org ([198.145.19.201]:60656 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbaGOOY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:24:26 -0400
Date: Tue, 15 Jul 2014 11:24:21 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 24/41] perf tools: Add cpu to struct thread
Message-ID: <20140715142421.GD3301@kernel.org>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
 <1405332185-4050-25-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405332185-4050-25-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jul 14, 2014 at 01:02:48PM +0300, Adrian Hunter escreveu:
> Tools may wish to track on which cpu a thread
> is running.  Add 'cpu' to struct thread for
> that purpose.
> 
> This will be used to determine the cpu when
> decoding a per-thread Instruction Trace.

Humm, is this the last cpu we got some event telling the cpu was running
on? Continuing looking at the patches...

- Arnaldo
 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/thread.c | 1 +
>  tools/perf/util/thread.h | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
> index b9a3ee4..2f8c0c1 100644
> --- a/tools/perf/util/thread.c
> +++ b/tools/perf/util/thread.c
> @@ -69,6 +69,7 @@ struct thread *thread__new(pid_t pid, pid_t tid)
>  		thread->pid_ = pid;
>  		thread->tid = tid;
>  		thread->ppid = -1;
> +		thread->cpu = -1;
>  		INIT_LIST_HEAD(&thread->comm_list);
>  
>  		comm_str = malloc(32);
> diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
> index b4269af..e4920ff 100644
> --- a/tools/perf/util/thread.h
> +++ b/tools/perf/util/thread.h
> @@ -17,6 +17,7 @@ struct thread {
>  	pid_t			pid_; /* Not all tools update this */
>  	pid_t			tid;
>  	pid_t			ppid;
> +	int			cpu;
>  	char			shortname[3];
>  	bool			comm_set;
>  	bool			dead; /* if set thread has exited */
> -- 
> 1.8.3.2
