Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3FYAhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 20:37:14 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33097 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3FYAhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 20:37:13 -0400
Message-ID: <51C8E637.2060106@codeaurora.org>
Date: Mon, 24 Jun 2013 17:37:11 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: john.stultz@linaro.org, tglx@linutronix.de, shc_work@mail.ru,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] ARM: mach-clps711x: common: Use linux/sched_clock.h
References: <1372118615-14805-1-git-send-email-festevam@gmail.com>
In-Reply-To: <1372118615-14805-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/13 17:03, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>
> Commit 38ff87f7 (sched_clock: Make ARM's sched_clock generic for all 
> architectures) changed the header to <linux/sched_clock.h>, so adapt it in order
> to fix the following build error:
>
> arch/arm/mach-clps711x/common.c:37:29: fatal error: asm/sched_clock.h: No such file or directory
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---

Is this one in the arm-soc tree? I plan to make a sweep after 3.11-rc1
and fix up all the stragglers (looks like just this one) and remove the
dummy asm header that just got merged into the tip tree.

>  arch/arm/mach-clps711x/common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-clps711x/common.c b/arch/arm/mach-clps711x/common.c
> index 4ca2f3c..134641d 100644
> --- a/arch/arm/mach-clps711x/common.c
> +++ b/arch/arm/mach-clps711x/common.c
> @@ -29,12 +29,12 @@
>  #include <linux/clockchips.h>
>  #include <linux/clocksource.h>
>  #include <linux/clk-provider.h>
> +#include <linux/sched_clock.h>
>  
>  #include <asm/exception.h>
>  #include <asm/mach/irq.h>
>  #include <asm/mach/map.h>
>  #include <asm/mach/time.h>
> -#include <asm/sched_clock.h>
>  #include <asm/system_misc.h>
>  
>  #include <mach/hardware.h>


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

