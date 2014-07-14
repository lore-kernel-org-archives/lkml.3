Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbaGNUsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:48:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734AbaGNUsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:48:52 -0400
Date: Mon, 14 Jul 2014 13:48:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vaibhav Shinde <v.bhav.shinde@gmail.com>
Cc: tj@kernel.org, linux-kernel@vger.kernel.org, oleg@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: task's thread_info print in kernel oops
Message-Id: <20140714134851.718deef4a2b43c9a360ab237@linux-foundation.org>
In-Reply-To: <CAB5gott47+n7r_XUgxQHfxtc5zG78Ecn_xSQ4jp3fj9Ryd8QoQ@mail.gmail.com>
References: <CAB5gott47+n7r_XUgxQHfxtc5zG78Ecn_xSQ4jp3fj9Ryd8QoQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014 00:46:55 +0530 Vaibhav Shinde <v.bhav.shinde@gmail.com> wrote:

> Dear All,
> 
> 
> During the kernel oops i observed the below debug message which shows the
> address of task's thread_info struct
> 
> task: ffff880468e61a80 ti: ffff88026bc86000 task.ti: ffff88026bc86000
> 
> ti: <current_thread_info()>
> task.ti <task_thread_info(current)
> 
> As per my understanding, both the function calls will return the address of
> thread_info() struct of the current task,
> so it would be always the same.
> 
> If so, could we apply the below change ?
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index b4e8500..904aeef 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -2902,9 +2902,8 @@ void show_regs_print_info(const char *log_lvl)
>  {
>         dump_stack_print_info(log_lvl);
> 
> -       printk("%stask: %p ti: %p task.ti: %p\n",
> -              log_lvl, current, current_thread_info(),
> -              task_thread_info(current));
> +       printk("%stask: %p ti: %p\n",
> +              log_lvl, current, current_thread_info());
>  }

ia64 defines __HAVE_THREAD_FUNCTIONS and implements a custom
task_thread_info().  Whether the resulting output is useful I cannot
say...


