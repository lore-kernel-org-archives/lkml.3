Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab3ISIkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 04:40:19 -0400
Received: from gloria.sntech.de ([95.129.55.99]:35643 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab3ISIkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 04:40:17 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 20/26] ARM: rockchip: remove custom .init_time hook
Date: Thu, 19 Sep 2013 10:40:09 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com> <1379526839-14798-21-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1379526839-14798-21-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201309191040.10683.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 18. September 2013, 19:53:53 schrieb Sebastian Hesselbarth:
> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
> remove custom .init_time hooks.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Acked-by: Heiko Stuebner <heiko@sntech.de>


> ---
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Heiko Stuebner <heiko@sntech.de>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-rockchip/rockchip.c |    9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/arch/arm/mach-rockchip/rockchip.c
> b/arch/arm/mach-rockchip/rockchip.c index 724d2d8..82c0b07 100644
> --- a/arch/arm/mach-rockchip/rockchip.c
> +++ b/arch/arm/mach-rockchip/rockchip.c
> @@ -19,18 +19,10 @@
>  #include <linux/init.h>
>  #include <linux/of_platform.h>
>  #include <linux/irqchip.h>
> -#include <linux/dw_apb_timer.h>
> -#include <linux/clk-provider.h>
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
>  #include <asm/hardware/cache-l2x0.h>
> 
> -static void __init rockchip_timer_init(void)
> -{
> -	of_clk_init(NULL);
> -	clocksource_of_init();
> -}
> -
>  static void __init rockchip_dt_init(void)
>  {
>  	l2x0_of_init(0, ~0UL);
> @@ -47,6 +39,5 @@ static const char * const rockchip_board_dt_compat[] = {
> 
>  DT_MACHINE_START(ROCKCHIP_DT, "Rockchip Cortex-A9 (Device Tree)")
>  	.init_machine	= rockchip_dt_init,
> -	.init_time	= rockchip_timer_init,
>  	.dt_compat	= rockchip_board_dt_compat,
>  MACHINE_END

