Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaEZVCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 17:02:17 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:56554 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751232AbaEZVCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 17:02:13 -0400
Date: Mon, 26 May 2014 23:02:11 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] watchdog: iop_wdt only builds for mach-iop13xx
Message-ID: <20140526210211.GA23548@spo001.leaseweb.com>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de> <1399560990-1402858-1-git-send-email-arnd@arndb.de> <1399560990-1402858-8-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399560990-1402858-8-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

> All three iop variants we support in Linux (iop32x, iop33x and
> iop13xx) seem to have support for the watchdog hardware, but this
> driver fails to build for the first two of these because it
> uses the IOP13XX_WDTCR_IB_RESET macro that is only defined for
> iop13xx.
> 
> This clarifies the dependency in Kconfig to avoid randconfig
> build errors. It is unlikely that anyone will ever miss support
> for this driver on the ancient iop3xx platforms, so we don't
> need to bother trying to fix it properly.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: linux-watchdog@vger.kernel.org
> ---
>  drivers/watchdog/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 2b4c1fc..e244548 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -272,7 +272,7 @@ config PNX4008_WATCHDOG
>  
>  config IOP_WATCHDOG
>  	tristate "IOP Watchdog"
> -	depends on PLAT_IOP
> +	depends on ARCH_IOP13XX
>  	select WATCHDOG_NOWAYOUT if (ARCH_IOP32X || ARCH_IOP33X)
>  	help
>  	  Say Y here if to include support for the watchdog timer

Patch has been added to linux-watchdog-next.

Kind regards,
Wim.

