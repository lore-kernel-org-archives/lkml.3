Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab3KURDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:03:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52937 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab3KURDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:03:00 -0500
Message-ID: <528E3CBC.7090204@infradead.org>
Date: Thu, 21 Nov 2013 09:02:52 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] um: Rename print_stack_trace to do_stack_trace
References: <1385022715-21398-1-git-send-email-richard@nod.at>
In-Reply-To: <1385022715-21398-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/13 00:31, Richard Weinberger wrote:
> We cannot use print_stack_trace because the name conflicts
> with linux/stacktrace.h.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Richard Weinberger <richard@nod.at>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  arch/um/kernel/sysrq.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/um/kernel/sysrq.c b/arch/um/kernel/sysrq.c
> index 4d6fdf6..799d7e4 100644
> --- a/arch/um/kernel/sysrq.c
> +++ b/arch/um/kernel/sysrq.c
> @@ -19,7 +19,7 @@ struct stack_frame {
>  	unsigned long return_address;
>  };
>  
> -static void print_stack_trace(unsigned long *sp, unsigned long bp)
> +static void do_stack_trace(unsigned long *sp, unsigned long bp)
>  {
>  	int reliable;
>  	unsigned long addr;
> @@ -94,5 +94,5 @@ void show_stack(struct task_struct *task, unsigned long *stack)
>  	}
>  	printk(KERN_CONT "\n");
>  
> -	print_stack_trace(sp, bp);
> +	do_stack_trace(sp, bp);
>  }
> 


-- 
~Randy
