Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457AbaGUNrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:47:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:24585 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932153AbaGUNrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:47:08 -0400
Date: Mon, 21 Jul 2014 09:47:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: kill global_start_up
Message-ID: <20140721094706.60eb3877@gandalf.local.home>
In-Reply-To: <20140720151814.GA32439@redhat.com>
References: <20140720151814.GA32439@redhat.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jul 2014 17:18:14 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> global_start_up is read-only and always zero. It seems that 4104d326
> "ftrace: Remove global function list and call function directly" simply
> forgot to remove this no longer used variable.
> 

Sure, just after I got done testing my entire 3.17 queue and posted it
for linux-next, you decide to send me yet another fix! ;-)

Thanks, applied.

I'll wait and see what other fixes you send me before I run my 10 hour
tests.

-- Steve

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/ftrace.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 5b372e3..4586f8d 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2053,7 +2053,6 @@ static void ftrace_run_update_code(int command)
>  
>  static ftrace_func_t saved_ftrace_func;
>  static int ftrace_start_up;
> -static int global_start_up;
>  
>  static void control_ops_free(struct ftrace_ops *ops)
>  {
> @@ -2117,8 +2116,7 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
>  
>  	ftrace_hash_rec_disable(ops, 1);
>  
> -	if (!global_start_up)
> -		ops->flags &= ~FTRACE_OPS_FL_ENABLED;
> +	ops->flags &= ~FTRACE_OPS_FL_ENABLED;
>  
>  	command |= FTRACE_UPDATE_CALLS;
>  

