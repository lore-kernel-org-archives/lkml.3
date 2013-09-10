Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab3IJG6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 02:58:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53378 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab3IJG6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 02:58:45 -0400
Date: Tue, 10 Sep 2013 08:58:38 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH][RESEND] ARM: imx: remove IRQF_DISABLED
Message-ID: <20130910065838.GC30088@pengutronix.de>
Mail-Followup-To: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
	kernel@pengutronix.de, linux@arm.linux.org.uk,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Shawn Guo <shawn.guo@linaro.org>
References: <1378271079-24945-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378271079-24945-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:57:59 up 16 days, 16:28, 33 users,  load average: 0.02, 0.10,
 0.20
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 07:04:39AM +0200, Michael Opdenacker wrote:
> This flag is a NOOP since 2.6.35 and can be removed.
> 
> This is an update for 3.11 of a patch already sent for 3.10
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

(added shawn to Cc)

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
>  arch/arm/mach-imx/Kconfig             | 2 +-
>  arch/arm/mach-imx/epit.c              | 2 +-
>  arch/arm/mach-imx/mach-armadillo5x0.c | 3 +--
>  arch/arm/mach-imx/mach-mx31_3ds.c     | 2 +-
>  arch/arm/mach-imx/mach-pcm037.c       | 3 +--
>  arch/arm/mach-imx/mx31lilly-db.c      | 3 +--
>  arch/arm/mach-imx/time.c              | 2 +-
>  7 files changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
> index f546560..799a92f 100644
> --- a/arch/arm/mach-imx/Kconfig
> +++ b/arch/arm/mach-imx/Kconfig
> @@ -22,7 +22,7 @@ config MXC_IRQ_PRIOR
>  	help
>  	  Select this if you want to use prioritized IRQ handling.
>  	  This feature prevents higher priority ISR to be interrupted
> -	  by lower priority IRQ even IRQF_DISABLED flag is not set.
> +	  by lower priority IRQ.
>  	  This may be useful in embedded applications, where are strong
>  	  requirements for timing.
>  	  Say N here, unless you have a specialized requirement.
> diff --git a/arch/arm/mach-imx/epit.c b/arch/arm/mach-imx/epit.c
> index e02de18..074b1a8 100644
> --- a/arch/arm/mach-imx/epit.c
> +++ b/arch/arm/mach-imx/epit.c
> @@ -171,7 +171,7 @@ static irqreturn_t epit_timer_interrupt(int irq, void *dev_id)
>  
>  static struct irqaction epit_timer_irq = {
>  	.name		= "i.MX EPIT Timer Tick",
> -	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
> +	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
>  	.handler	= epit_timer_interrupt,
>  };
>  
> diff --git a/arch/arm/mach-imx/mach-armadillo5x0.c b/arch/arm/mach-imx/mach-armadillo5x0.c
> index 368a6e3..58b864a 100644
> --- a/arch/arm/mach-imx/mach-armadillo5x0.c
> +++ b/arch/arm/mach-imx/mach-armadillo5x0.c
> @@ -404,8 +404,7 @@ static int armadillo5x0_sdhc1_init(struct device *dev,
>  
>  	/* When supported the trigger type have to be BOTH */
>  	ret = request_irq(gpio_to_irq(IOMUX_TO_GPIO(MX31_PIN_ATA_DMACK)),
> -			  detect_irq,
> -			  IRQF_DISABLED | IRQF_TRIGGER_FALLING,
> +			  detect_irq, IRQF_TRIGGER_FALLING,
>  			  "sdhc-detect", data);
>  
>  	if (ret)
> diff --git a/arch/arm/mach-imx/mach-mx31_3ds.c b/arch/arm/mach-imx/mach-mx31_3ds.c
> index 1ed9161..50044a2 100644
> --- a/arch/arm/mach-imx/mach-mx31_3ds.c
> +++ b/arch/arm/mach-imx/mach-mx31_3ds.c
> @@ -311,7 +311,7 @@ static int mx31_3ds_sdhc1_init(struct device *dev,
>  	}
>  
>  	ret = request_irq(gpio_to_irq(IOMUX_TO_GPIO(MX31_PIN_GPIO3_1)),
> -			  detect_irq, IRQF_DISABLED |
> +			  detect_irq,
>  			  IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
>  			  "sdhc1-detect", data);
>  	if (ret) {
> diff --git a/arch/arm/mach-imx/mach-pcm037.c b/arch/arm/mach-imx/mach-pcm037.c
> index bc0261e..45303bd6 100644
> --- a/arch/arm/mach-imx/mach-pcm037.c
> +++ b/arch/arm/mach-imx/mach-pcm037.c
> @@ -371,8 +371,7 @@ static int pcm970_sdhc1_init(struct device *dev, irq_handler_t detect_irq,
>  #endif
>  
>  	ret = request_irq(gpio_to_irq(IOMUX_TO_GPIO(MX31_PIN_SCK6)), detect_irq,
> -			IRQF_DISABLED | IRQF_TRIGGER_FALLING,
> -				"sdhc-detect", data);
> +			IRQF_TRIGGER_FALLING, "sdhc-detect", data);
>  	if (ret)
>  		goto err_gpio_free_2;
>  
> diff --git a/arch/arm/mach-imx/mx31lilly-db.c b/arch/arm/mach-imx/mx31lilly-db.c
> index d4361b8..649fe49 100644
> --- a/arch/arm/mach-imx/mx31lilly-db.c
> +++ b/arch/arm/mach-imx/mx31lilly-db.c
> @@ -130,8 +130,7 @@ static int mxc_mmc1_init(struct device *dev,
>  	gpio_direction_input(gpio_wp);
>  
>  	ret = request_irq(gpio_to_irq(IOMUX_TO_GPIO(MX31_PIN_GPIO1_1)),
> -			  detect_irq,
> -			  IRQF_DISABLED | IRQF_TRIGGER_FALLING,
> +			  detect_irq, IRQF_TRIGGER_FALLING,
>  			  "MMC detect", data);
>  	if (ret)
>  		goto exit_free_wp;
> diff --git a/arch/arm/mach-imx/time.c b/arch/arm/mach-imx/time.c
> index cd46529..9b6638a 100644
> --- a/arch/arm/mach-imx/time.c
> +++ b/arch/arm/mach-imx/time.c
> @@ -250,7 +250,7 @@ static irqreturn_t mxc_timer_interrupt(int irq, void *dev_id)
>  
>  static struct irqaction mxc_timer_irq = {
>  	.name		= "i.MX Timer Tick",
> -	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
> +	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
>  	.handler	= mxc_timer_interrupt,
>  };
>  
> -- 
> 1.8.1.2
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
