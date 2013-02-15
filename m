Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3BORVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:21:54 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33023 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3BORVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:21:53 -0500
Date: Fri, 15 Feb 2013 18:21:49 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 2/9] ARM: imx: MACH_MX31ADS_WM1133_EV1 needs
 REGULATOR_WM8350
Message-ID: <20130215172149.GU1906@pengutronix.de>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
 <1360882071-4072668-3-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360882071-4072668-3-git-send-email-arnd@arndb.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:21:10 up 237 days,  8:32, 73 users,  load average: 0.07, 0.22,
 0.35
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 11:47:44PM +0100, Arnd Bergmann wrote:
> MACH_MX31ADS_WM1133_EV1 already depends on REGULATOR_WM8350,
> but that still allows REGULATOR_WM8350 to be a loadable
> module. Depending on REGULATOR_WM8350 to be built-in
> ensures we cannot create a broken configuration.
> 
> Without this patch, building allmodconfig results in:
> 
> arch/arm/mach-imx/built-in.o: In function `mx31_wm8350_init':
> arch/arm/mach-imx/mach-mx31ads.c:461: undefined reference to `wm8350_register_regulator'
> arch/arm/mach-imx/mach-mx31ads.c:471: undefined reference to `wm8350_dcdc_set_slot'
> arch/arm/mach-imx/mach-mx31ads.c:473: undefined reference to `wm8350_isink_set_flash'
> arch/arm/mach-imx/mach-mx31ads.c:480: undefined reference to `wm8350_dcdc25_set_mode'
> arch/arm/mach-imx/mach-mx31ads.c:485: undefined reference to `wm8350_register_led'
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Axel Lin <axel.lin@gmail.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>

Hail to devicetree probing where such things don't happen.

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> ---
>  arch/arm/mach-imx/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
> index 7b11d33..4c9c6f9 100644
> --- a/arch/arm/mach-imx/Kconfig
> +++ b/arch/arm/mach-imx/Kconfig
> @@ -480,7 +480,7 @@ config MACH_MX31ADS_WM1133_EV1
>  	bool "Support Wolfson Microelectronics 1133-EV1 module"
>  	depends on MACH_MX31ADS
>  	depends on MFD_WM8350_I2C
> -	depends on REGULATOR_WM8350
> +	depends on REGULATOR_WM8350 = y
>  	select MFD_WM8350_CONFIG_MODE_0
>  	select MFD_WM8352_CONFIG_MODE_0
>  	help
> -- 
> 1.8.1.2
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
