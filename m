Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaAOCFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:05:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:25531 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751730AbaAOCFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:05:48 -0500
Date: Tue, 14 Jan 2014 21:05:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 03/17] tools lib traceevent: Get rid of malloc_or_die()
 in trace_seq_init()
Message-ID: <20140114210546.5bb3c85c@gandalf.local.home>
In-Reply-To: <1389750340-15965-4-git-send-email-namhyung@kernel.org>
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
	<1389750340-15965-4-git-send-email-namhyung@kernel.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 10:45:26 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> Use plain malloc() and check its return value.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  tools/lib/traceevent/trace-seq.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/lib/traceevent/trace-seq.c b/tools/lib/traceevent/trace-seq.c
> index 941d35d2cf87..339a0ffa21d5 100644
> --- a/tools/lib/traceevent/trace-seq.c
> +++ b/tools/lib/traceevent/trace-seq.c
> @@ -47,8 +47,11 @@ void trace_seq_init(struct trace_seq *s)
>  	s->len = 0;
>  	s->readpos = 0;
>  	s->buffer_size = TRACE_SEQ_BUF_SIZE;
> -	s->buffer = malloc_or_die(s->buffer_size);
> -	s->state = TRACE_SEQ__GOOD;
> +	s->buffer = malloc(s->buffer_size);
> +	if (s->buffer != NULL)
> +		s->state = TRACE_SEQ__GOOD;
> +	else
> +		s->state = TRACE_SEQ__MEM_ALLOC_FAILED;
>  }
>  
>  /**

