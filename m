Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaGMT6q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 15:58:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbaGMT6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 15:58:38 -0400
Date: Sun, 13 Jul 2014 21:57:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Vaibhav Shinde <v.bhav.shinde@gmail.com>
Cc: tj@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: task's thread_info print in kernel oops
Message-ID: <20140713195708.GA6528@redhat.com>
References: <CAB5gott47+n7r_XUgxQHfxtc5zG78Ecn_xSQ4jp3fj9Ryd8QoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB5gott47+n7r_XUgxQHfxtc5zG78Ecn_xSQ4jp3fj9Ryd8QoQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14, Vaibhav Shinde wrote:
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

I too do not know, but perhaps this can help to detect that PER_CPU(kernel_stack)
or task->stack was corrupted.

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
>
>  #endif
>
>
>
> Thanks,
> Vaibhav

