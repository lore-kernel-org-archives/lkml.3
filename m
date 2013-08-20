Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab3HTH1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:27:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51014 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab3HTH1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:27:03 -0400
Date: Tue, 20 Aug 2013 09:26:42 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 06/17] ARM: imx: remove custom .init_time hook
Message-ID: <20130820072642.GJ31036@pengutronix.de>
Mail-Followup-To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Russell King <linux@arm.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>, Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1376964271-22715-7-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376964271-22715-7-git-send-email-sebastian.hesselbarth@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:17:23 up 20 days, 16:21, 42 users,  load average: 0.03, 0.09,
 0.11
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 04:04:20AM +0200, Sebastian Hesselbarth wrote:
> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
> remove custom .init_time hooks.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Notes:
> - Although mx5_clocks_common_init() is shared with non-DT, removing
>   of_clk_init(NULL) should be fine, as it only registers DT clk providers.
> - For imx6q, printing of silicon revision has been moved from .init_time
>   to .init_machine hook.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Sascha Hauer <kernel@pengutronix.de>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-imx/clk-imx51-imx53.c |   12 ------------
>  arch/arm/mach-imx/common.h          |    2 --
>  arch/arm/mach-imx/imx51-dt.c        |    6 ------
>  arch/arm/mach-imx/mach-imx53.c      |    6 ------
>  arch/arm/mach-imx/mach-imx6q.c      |   14 +++-----------
>  arch/arm/mach-imx/mach-imx6sl.c     |    7 -------
>  arch/arm/mach-imx/mach-vf610.c      |    9 ---------
>  7 files changed, 3 insertions(+), 53 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/clk-imx51-imx53.c b/arch/arm/mach-imx/clk-imx51-imx53.c
> index 1a56a33..5955a54 100644
> --- a/arch/arm/mach-imx/clk-imx51-imx53.c
> +++ b/arch/arm/mach-imx/clk-imx51-imx53.c
> @@ -131,8 +131,6 @@ static void __init mx5_clocks_common_init(unsigned long rate_ckil,
>  {
>  	int i;
>  
> -	of_clk_init(NULL);
> -
>  	clk[dummy] = imx_clk_fixed("dummy", 0);
>  	clk[ckil] = imx_obtain_fixed_clock("ckil", rate_ckil);
>  	clk[osc] = imx_obtain_fixed_clock("osc", rate_osc);
> @@ -569,13 +567,3 @@ int __init mx53_clocks_init(unsigned long rate_ckil, unsigned long rate_osc,
>  
>  	return 0;
>  }
> -
> -int __init mx51_clocks_init_dt(void)
> -{
> -	return mx51_clocks_init(0, 0, 0, 0);
> -}
> -
> -int __init mx53_clocks_init_dt(void)
> -{
> -	return mx53_clocks_init(0, 0, 0, 0);
> -}
> diff --git a/arch/arm/mach-imx/common.h b/arch/arm/mach-imx/common.h
> index 4517fd7..0ce8313 100644
> --- a/arch/arm/mach-imx/common.h
> +++ b/arch/arm/mach-imx/common.h
> @@ -68,8 +68,6 @@ extern int mx53_clocks_init(unsigned long ckil, unsigned long osc,
>  extern int mx25_clocks_init_dt(void);
>  extern int mx27_clocks_init_dt(void);
>  extern int mx31_clocks_init_dt(void);
> -extern int mx51_clocks_init_dt(void);
> -extern int mx53_clocks_init_dt(void);
>  extern struct platform_device *mxc_register_gpio(char *name, int id,
>  	resource_size_t iobase, resource_size_t iosize, int irq, int irq_high);
>  extern void mxc_set_cpu_type(unsigned int type);
> diff --git a/arch/arm/mach-imx/imx51-dt.c b/arch/arm/mach-imx/imx51-dt.c
> index 53e43e5..bece8a6 100644
> --- a/arch/arm/mach-imx/imx51-dt.c
> +++ b/arch/arm/mach-imx/imx51-dt.c
> @@ -34,17 +34,11 @@ static const char *imx51_dt_board_compat[] __initdata = {
>  	NULL
>  };
>  
> -static void __init imx51_timer_init(void)
> -{
> -	mx51_clocks_init_dt();
> -}
> -
>  DT_MACHINE_START(IMX51_DT, "Freescale i.MX51 (Device Tree Support)")
>  	.map_io		= mx51_map_io,
>  	.init_early	= imx51_init_early,
>  	.init_irq	= mx51_init_irq,
>  	.handle_irq	= imx51_handle_irq,
> -	.init_time	= imx51_timer_init,

On i.MX5 the init_time hook calls mx5x_clocks_init_dt which calls
mx5x_clocks_init which not only calls of_clk_init() but also registers
all clocks in the system. You can't remove it.

I am missing some

CLK_OF_DECLARE(imx51, "fsl,imx51-ccm", imx51_clocks_init);
CLK_OF_DECLARE(imx53, "fsl,imx53-ccm", imx53_clocks_init);

Somewhere.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
