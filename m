Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab3INLbl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 07:31:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11007 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab3INLbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 07:31:40 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=IUAB6XBAk1cA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=10LPOIgpgYkA:10 a=pGLkceISAAAA:8 a=pSnE_Gf4ntdRVt0mp-8A:9 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=TNySWaWTJngDQgeP:21 a=ApdrRFGhVdCNXiyc:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Sat, 14 Sep 2013 07:31:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Wang YanQing <udknight@gmail.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] trace: show more and exactly help information about
 snapshot
Message-ID: <20130914073138.1cd6026c@gandalf.local.home>
In-Reply-To: <20130914045916.GA4243@udknight>
References: <20130914045916.GA4243@udknight>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Sep 2013 12:59:16 +0800
Wang YanQing <udknight@gmail.com> wrote:

> Actually, they both are correct:
> 
> 	default:
> 		if (tr->allocated_snapshot) {
> 			if (iter->cpu_file == RING_BUFFER_ALL_CPUS)
> 				tracing_reset_online_cpus(&tr->max_buffer);
> 			else
> 				tracing_reset(&tr->max_buffer,	iter->cpu_file);
> 		}
> 		break;
> 	}
> 
> It does nothing if it isn't allocated.
> 
> Perhaps we need it to say "(but does not allocate or free)"
> 
> -- Steve
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  I think "Clears and frees" are reasonable, and
>  "Clears and allocates are not so reasonable, so
>  we don't need to say not allocate. But it is help 
>  information, so make it more clearer is also acceptable. :)

I'm getting ready to go to Linux Con / Linux Plumbers. I wont be able to
get to this before, and may not be able to get to it while I'm there.
As the original is technically correct, I'll put this into my 3.13
queue.

Thanks,

-- Steve


>  
>  kernel/trace/trace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 7974ba2..d5f7c4d 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2760,7 +2760,7 @@ static void show_snapshot_main_help(struct seq_file *m)
>  	seq_printf(m, "# echo 0 > snapshot : Clears and frees snapshot buffer\n");
>  	seq_printf(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n");
>  	seq_printf(m, "#                      Takes a snapshot of the main buffer.\n");
> -	seq_printf(m, "# echo 2 > snapshot : Clears snapshot buffer (but does not allocate)\n");
> +	seq_printf(m, "# echo 2 > snapshot : Clears snapshot buffer (but does not allocate or free)\n");
>  	seq_printf(m, "#                      (Doesn't have to be '2' works with any number that\n");
>  	seq_printf(m, "#                       is not a '0' or '1')\n");
>  }

