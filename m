Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbaFLJwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 05:52:46 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:63102 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673AbaFLJwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 05:52:45 -0400
MIME-Version: 1.0
In-Reply-To: <5394097C.9030006@gmail.com>
References: <5394097C.9030006@gmail.com>
Date: Thu, 12 Jun 2014 17:52:44 +0800
Message-ID: <CAFW=ztkZ0O=84wUO1+UzS3RzPsr9bk=z1Say6A2+wQte8SOq7Q@mail.gmail.com>
Subject: Re: [PATCH] arch/score/kernel/process.c: Remove useless varialbes
 'ti' and 'regs'
From: Liqin Chen <liqin.linux@gmail.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's ok for S+core
Thanks.

Acked-by: Chen Liqin<liqin.linux@gmail.com>

2014-06-08 14:58 GMT+08:00 Chen Gang <gang.chen.5i5j@gmail.com>:
> They are useless, so remove them, the related warning (with
> allmodconfig under score):
>
>     CC      arch/score/kernel/process.o
>   arch/score/kernel/process.c: In function 'copy_thread':
>   arch/score/kernel/process.c:76:18: warning: unused variable 'regs' [-Wunused-variable]
>     struct pt_regs *regs = current_pt_regs();
>                     ^
>   arch/score/kernel/process.c:74:22: warning: unused variable 'ti' [-Wunused-variable]
>     struct thread_info *ti = task_thread_info(p);
>                         ^
>
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/score/kernel/process.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/score/kernel/process.c b/arch/score/kernel/process.c
> index a1519ad3..50bf1b0 100644
> --- a/arch/score/kernel/process.c
> +++ b/arch/score/kernel/process.c
> @@ -71,9 +71,7 @@ void flush_thread(void) {}
>  int copy_thread(unsigned long clone_flags, unsigned long usp,
>                 unsigned long arg, struct task_struct *p)
>  {
> -       struct thread_info *ti = task_thread_info(p);
>         struct pt_regs *childregs = task_pt_regs(p);
> -       struct pt_regs *regs = current_pt_regs();
>
>         p->thread.reg0 = (unsigned long) childregs;
>         if (unlikely(p->flags & PF_KTHREAD)) {
> --
> 1.7.11.7
