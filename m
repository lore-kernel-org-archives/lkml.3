Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaITXtL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 19:49:11 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60617 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751067AbaITXtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 19:49:09 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Amit Pundir <amit.pundir@linaro.org>
Cc: linux-kernel@vger.kernel.org, Todd Poynor <toddpoynor@google.com>,
        Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH v2] PM: Print pending wakeup IRQ preventing suspend
Date: Sun, 21 Sep 2014 02:08:53 +0200
Message-ID: <1869677.4PrY1mNKsC@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411082555-4425-1-git-send-email-amit.pundir@linaro.org>
References: <1411082555-4425-1-git-send-email-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 19, 2014 04:52:35 AM Amit Pundir wrote:
> From: Todd Poynor <toddpoynor@google.com>
> 
> Currently when a pending wakeup irq stops suspend, it can be difficult
> to determine why suspend was prevented and which IRQ was actually
> responsible. In order to help debug such situation, this patch prints the
> IRQ number and action name of that pending wakeup irq.
> 
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Len Brown <len.brown@intel.com>
> Cc: linux-pm@vger.kernel.org
> Cc: Android Kernel Team <kernel-team@android.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Todd Poynor <toddpoynor@google.com>
> [Amit Pundir: Reworded the commit message]
> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> ---
> Resending this patch assuming that it might have got lost in between merge
> window rush last time and now people might have some time to look at it.
>  
>  kernel/irq/pm.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
> index abcd6ca..c2bc8d9 100644
> --- a/kernel/irq/pm.c
> +++ b/kernel/irq/pm.c
> @@ -109,8 +109,13 @@ int check_wakeup_irqs(void)

check_wakeup_irqs() is going away in 3.18, please see linux-next (or the
pm-genirq branch of linux-pm.git) for details.

>  		 * can abort suspend.
>  		 */
>  		if (irqd_is_wakeup_set(&desc->irq_data)) {
> -			if (desc->depth == 1 && desc->istate & IRQS_PENDING)
> +			if (desc->depth == 1 && desc->istate & IRQS_PENDING) {
> +				pr_info("Wakeup IRQ %d %s pending, suspend aborted\n",
> +					irq,
> +					desc->action && desc->action->name ?
> +					desc->action->name : "");
>  				return -EBUSY;
> +			}
>  			continue;
>  		}
>  		/*
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
