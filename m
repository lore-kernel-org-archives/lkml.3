Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532Ab3GDDai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 23:30:38 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:44197 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001Ab3GDDah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 23:30:37 -0400
Date: Thu, 4 Jul 2013 06:30:26 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH] clocksource/cadence_ttc: Reuse clocksource as sched_clock
Message-ID: <20130704033026.GX4288@tarshish>
References: <1372888216-10726-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372888216-10726-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Soren,

On Wed, Jul 03, 2013 at 02:50:16PM -0700, Soren Brinkmann wrote:
> Reuse the TTC clocksource timer as sched clock, too. Since only a single
> sched clock is supported in Linux, this feature optional and can be
> selected through Kconfig.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---

[...]

> diff --git a/drivers/clocksource/cadence_ttc_timer.c 
> b/drivers/clocksource/cadence_ttc_timer.c
> index 4cbe28c..ef0f52b 100644
> --- a/drivers/clocksource/cadence_ttc_timer.c
> +++ b/drivers/clocksource/cadence_ttc_timer.c
> @@ -22,6 +22,7 @@
>  #include <linux/of_irq.h>
>  #include <linux/slab.h>
>  #include <linux/clk-provider.h>
> +#include <asm/sched_clock.h>

This has changed to linux/sched_clock.h in the tip tree. See 
https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?h=timers/core&id=38ff87f77af0b5a93fc8581cff1d6e5692ab8970.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
