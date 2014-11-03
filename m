Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaKCRpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:45:19 -0500
Received: from down.free-electrons.com ([37.187.137.238]:55229 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752197AbaKCRpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:45:15 -0500
Message-ID: <5457BF27.8000108@free-electrons.com>
Date: Mon, 03 Nov 2014 18:45:11 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        devicetree@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/17] clocksource: time-armada-370-xp: add suspend/resume
 support
References: <1414151970-6626-1-git-send-email-thomas.petazzoni@free-electrons.com> <1414151970-6626-6-git-send-email-thomas.petazzoni@free-electrons.com>
In-Reply-To: <1414151970-6626-6-git-send-email-thomas.petazzoni@free-electrons.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 24/10/2014 13:59, Thomas Petazzoni wrote:
> This commit adds a set of suspend/resume syscore_ops to respectively
> save and restore a number of timer registers, in order to make sure
> the clockevent and clocksource devices continue to work properly
> accross a suspend/resume cycle.
  across

> 
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/clocksource/time-armada-370-xp.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
> index 0451e62..1a32dcb 100644
> --- a/drivers/clocksource/time-armada-370-xp.c
> +++ b/drivers/clocksource/time-armada-370-xp.c
> @@ -43,6 +43,7 @@
>  #include <linux/module.h>
>  #include <linux/sched_clock.h>
>  #include <linux/percpu.h>
> +#include <linux/syscore_ops.h>
>  
>  /*
>   * Timer block registers.
> @@ -223,6 +224,28 @@ static struct notifier_block armada_370_xp_timer_cpu_nb = {
>  	.notifier_call = armada_370_xp_timer_cpu_notify,
>  };
>  
> +static u32 timer_ctrl_reg, timer_local_ctrl_reg;

We don't need to restore any other timer than the timer 0, but it
would worth mentioning that we save and restore only this one
by naming the variable timer0_ctrl_reg and timer0_local_ctrl_reg

Besides this and the typo:

Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>


Thanks,

Gregory


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
