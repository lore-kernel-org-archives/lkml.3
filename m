Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934914AbaKNCet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 21:34:49 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:26228 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934682AbaKNCes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 21:34:48 -0500
Date: Thu, 13 Nov 2014 21:34:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 3/3] trace: Replace single-character seq_puts with
 seq_putc
Message-ID: <20141113213436.347351cb@gandalf.local.home>
In-Reply-To: <1415479332-25944-4-git-send-email-linux@rasmusvillemoes.dk>
References: <1410513954-28909-5-git-send-email-linux@rasmusvillemoes.dk>
	<1415479332-25944-1-git-send-email-linux@rasmusvillemoes.dk>
	<1415479332-25944-4-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  8 Nov 2014 21:42:12 +0100
Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> Printing a single character to a seqfile might as well be done with
> seq_putc instead of seq_puts; this avoids a strlen() call and a memory
> access. It also shaves another few bytes off the generated code.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  kernel/trace/ftrace.c                |  2 +-
>  kernel/trace/trace_events_trigger.c  |  4 ++--
>  kernel/trace/trace_functions_graph.c |  4 ++--
>  kernel/trace/trace_kprobe.c          | 10 +++++-----
>  kernel/trace/trace_printk.c          |  2 +-
>  kernel/trace/trace_uprobe.c          |  4 ++--
>  6 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 7890718..9ffd006 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2969,7 +2969,7 @@ static int t_show(struct seq_file *m, void *v)
>  		}
>  	}	
>  
> -	seq_puts(m, "\n");
> +	seq_putc(m, '\n');

Ah, you did it here. Well, it is fine to have it in the first patch
anyway.

-- Steve

