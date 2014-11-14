Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934693AbaKNCcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 21:32:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:7582 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933518AbaKNCcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 21:32:07 -0500
Date: Thu, 13 Nov 2014 21:31:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 1/3] trace: Replace seq_printf by simpler equivalents
Message-ID: <20141113213158.12fcca7d@gandalf.local.home>
In-Reply-To: <1415479332-25944-2-git-send-email-linux@rasmusvillemoes.dk>
References: <1410513954-28909-5-git-send-email-linux@rasmusvillemoes.dk>
	<1415479332-25944-1-git-send-email-linux@rasmusvillemoes.dk>
	<1415479332-25944-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  8 Nov 2014 21:42:10 +0100
Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:


> -	seq_printf(m, "\n");
> +	seq_puts(m, "\n");




>  
> @@ -840,7 +840,7 @@ static int probes_seq_show(struct seq_file *m, void *v)
>  
>  	for (i = 0; i < tk->tp.nr_args; i++)
>  		seq_printf(m, " %s=%s", tk->tp.args[i].name, tk->tp.args[i].comm);
> -	seq_printf(m, "\n");
> +	seq_puts(m, "\n");
>  
>  	return 0;
>  }
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 33ff6a2..184aec1 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -606,7 +606,7 @@ static int probes_seq_show(struct seq_file *m, void *v)
>  	for (i = 0; i < tu->tp.nr_args; i++)
>  		seq_printf(m, " %s=%s", tu->tp.args[i].name, tu->tp.args[i].comm);
>  
> -	seq_printf(m, "\n");
> +	seq_puts(m, "\n");

These can actually be seq_putc(m, '\n');

I saw this because one of them conflicted with a change I already had.

No need to resend, I'll just update them myself. Trivial enough.

-- Steve

>  	return 0;
>  }
>  

