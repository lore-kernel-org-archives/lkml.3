Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab3JNKtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:49:12 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:50304 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab3JNKtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:49:08 -0400
MIME-Version: 1.0
In-Reply-To: <1381489240-29626-1-git-send-email-bigeasy@linutronix.de>
References: <1381489240-29626-1-git-send-email-bigeasy@linutronix.de>
Date: Mon, 14 Oct 2013 12:49:07 +0200
Message-ID: <CAMSQXEFfOwsyGM=6STY6k0hCjiJHtz8i8SgBuyX476Ak8+e1Ow@mail.gmail.com>
Subject: Re: [PATCH] genirq: Set the irq thread policy without checking CAP_SYS_NICE
From: Ivo Sieben <meltedpianoman@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Thomas Pfaff <tpfaff@pcs.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch looks OK to me.. but I'm not an expert.

Regards,
Ivo Sieben

2013/10/11 Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
> From: Thomas Pfaff <tpfaff@pcs.com>
>
> In commit ee23871389 ("genirq: Set irq thread to RT priority on
> creation") we moved the assigment of the thread's priority from the
> thread's function into __setup_irq(). That function may run in user
> context for instance if the user opens an UART node and then driver
> calls requests in the ->open() callback. That user may not have
> CAP_SYS_NICE and so the irq thread won't run with the SCHED_OTHER
> policy.
>
> This patch uses sched_setscheduler_nocheck() so we omit the CAP_SYS_NICE
> check which is otherwise required for the SCHED_OTHER policy.
>
> Cc: Ivo Sieben <meltedpianoman@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Thomas Pfaff <tpfaff@pcs.com>
> [bigeasy: rewrite the changelog]
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  kernel/irq/manage.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 514bcfd..3e59f95 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -956,7 +956,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>                         goto out_mput;
>                 }
>
> -               sched_setscheduler(t, SCHED_FIFO, &param);
> +               sched_setscheduler_nocheck(t, SCHED_FIFO, &param);
>
>                 /*
>                  * We keep the reference to the task struct even if
> --
> 1.8.4.rc3
>
