Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbaFLPTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:19:46 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:46820 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752900AbaFLPTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:19:45 -0400
Date: Thu, 12 Jun 2014 11:19:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: Get rid of obsolete global_start_up variable
Message-ID: <20140612111941.2699a898@gandalf.local.home>
In-Reply-To: <1402584972-17824-1-git-send-email-namhyung@kernel.org>
References: <1402584972-17824-1-git-send-email-namhyung@kernel.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014 23:56:12 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> It seems like it's a leftover from commit 4104d326b670 ("ftrace:
> Remove global function list and call function directly").  As it
> isn't updated at all, checking its value is meaningless.
> 
> Let's get rid of it.

Thanks, I added this to my 3.17 queue.

-- Steve

> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/ftrace.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index cc07b7fc4372..071908f58e7a 100644
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

