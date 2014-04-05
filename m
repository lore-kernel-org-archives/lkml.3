Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaDEMCa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 08:02:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38642 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaDEMC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 08:02:29 -0400
MIME-Version: 1.0
In-Reply-To: <1396685343-94097-1-git-send-email-jet.chen@intel.com>
References: <abd38155f8293923de5953cc063f9e2d7ecb3f04.1396679170.git.viresh.kumar@linaro.org>
	<1396685343-94097-1-git-send-email-jet.chen@intel.com>
Date: Sat, 5 Apr 2014 17:32:28 +0530
Message-ID: <CAKohpok=Bnb+CCPc0jCxwetaTv3nNmtMZKfc3ZP3QGccpiKTxw@mail.gmail.com>
Subject: Re: [PATCH] queue_timer_on_next_cpu() should be static
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jet Chen <jet.chen@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 April 2014 13:39, Jet Chen <jet.chen@intel.com> wrote:
> the new introduced function queue_timer_on_next_cpu() should be defined as static
>
> Signed-off-by: Jet Chen <jet.chen@intel.com>
> ---
>  kernel/time/clocksource.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index 9e96853..1c00e10 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -251,7 +251,7 @@ void clocksource_mark_unstable(struct clocksource *cs)
>         spin_unlock_irqrestore(&watchdog_lock, flags);
>  }
>
> -void queue_timer_on_next_cpu(void)
> +static void queue_timer_on_next_cpu(void)
>  {
>         /*
>          * Cycle through CPUs to check if the CPUs stay synchronized to each

Thanks, will merge this into my patch.
