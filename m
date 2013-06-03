Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab3FCCPw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 22:15:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54198 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab3FCCPp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 22:15:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 10/10] arm: add basic support for Rockchip RK3066a boards
Date: Mon, 03 Jun 2013 04:15:46 +0200
Message-ID: <5760087.7O4UgypAot@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <201306030102.20890.heiko@sntech.de>
References: <201306030055.15413.heiko@sntech.de> <201306030102.20890.heiko@sntech.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:LtyZhVJ1QoNKDChdqhxvP1VmeCG4KXw0lao0GiaUvS+
 j3Uhiiol/NmF8M4axX3RyhXkMee0T3ZYbPD9sWePl9IZFoTk9N
 joOE7sbgSvbbI8pZ68+BS7Fd8cINFP4z0Oo0mbKL7/Roxvnn9U
 2uWS4sKjzte4CDqI0aFQDsbHcAeJ9MOtNPFfVRJJR+ugfCK6Nx
 llr0/1zZ9lHE3WAdRrs1BlcI8yzt6vi1Vfb6WqxtXj0FbjW+4c
 2JMuQLtHGXmZTdnuL1Y635wO/Cywjga8q0GDOouVQMMzkhREEO
 EY8bnMVZBnss6GRGrs/llHa1/UiKK5ivdWYPRpgr2jvH7Kx7Df
 LXh+9+aW3Dq3JXON17hE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 June 2013 01:02:20 Heiko Stübner wrote:
> index 0000000..094b37d
> --- /dev/null
> +++ b/arch/arm/mach-rockchip/rockchip.c

If all goes well, this file can be removed again in 3.11 since it's
all generic, but let's add it for now.

> +
> +static void __init rockchip_timer_init(void)
> +{
> +       rockchip_init_clocks();
> +       dw_apb_timer_init();
> +}

Can't you use 

	of_clk_init(NULL);
	clocksource_of_init();

here and change the two drivers to provide the respective macros?

> +
> +static void __init rockchip_dt_init(void)
> +{
> +#ifdef CONFIG_CACHE_L2X0
> +       l2x0_of_init(0, ~0UL);
> +#endif
> +       of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> +}

We still need to find a common location to call l2x0_of_init.

> +
> +static const char * const rockchip_board_dt_compat[] = {
> +       "rockchip,rk2928", /* single core */
> +       "rockchip,rk30xx", /* dual cores */
> +       "rockchip,rk31xx", /* dual and quad cores */
> +       NULL,
> +};

Please use real numbers instead of wildcards: rockchip,rk3066
not rockchip,rk30xx.

> +DT_MACHINE_START(ROCKCHIP_DT, "Rockchip Cortex-A9 (Device Tree)")
> +       .map_io         = debug_ll_io_init,
> +       .init_machine   = rockchip_dt_init,
> +       .init_time      = rockchip_timer_init,
> +       .dt_compat      = rockchip_board_dt_compat,
> +MACHINE_END

The map_io line can already get removed.

What about SMP support? Still working on it?

	Arnd
