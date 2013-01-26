Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab3AZQYq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 11:24:46 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60446 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab3AZQYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 11:24:44 -0500
MIME-Version: 1.0
In-Reply-To: <1351933030-1462-1-git-send-email-anish198519851985@gmail.com>
References: <1351933030-1462-1-git-send-email-anish198519851985@gmail.com>
Date: Sat, 26 Jan 2013 17:24:42 +0100
Message-ID: <CAFTL4hx8JRft0Xy02vRdOQptNcTA1TxhB+x_pzRphMxqUDgBMA@mail.gmail.com>
Subject: Re: [PATCH] IRQ CORE: irq_work_queue function return value not used.
From: Frederic Weisbecker <fweisbec@gmail.com>
To: anish kumar <anish198519851985@gmail.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        tglx@linutronix.de, mingo@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/3 anish kumar <anish198519851985@gmail.com>:
> From: anish kumar <anish198519851985@gmail.com>
>
> As no one is using the return value of irq_work_queue function
> it is better to just make it void.
>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: anish kumar <anish198519851985@gmail.com>
> ---
>  kernel/irq_work.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> index 1588e3b..4829a31 100644
> --- a/kernel/irq_work.c
> +++ b/kernel/irq_work.c
> @@ -79,17 +79,16 @@ static void __irq_work_queue(struct irq_work *work)
>   *
>   * Can be re-enqueued while the callback is still in progress.
>   */
> -bool irq_work_queue(struct irq_work *work)
> +void irq_work_queue(struct irq_work *work)

Please also update the headers in include/linux/irq_work.h accordingly.

Thanks.

>  {
>         if (!irq_work_claim(work)) {
>                 /*
>                  * Already enqueued, can't do!
>                  */
> -               return false;
> +               return;
>         }
>
>         __irq_work_queue(work);
> -       return true;
>  }
>  EXPORT_SYMBOL_GPL(irq_work_queue);
>
> --
> 1.7.1
>
