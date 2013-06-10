Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3FJI1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 04:27:30 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:11635 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab3FJI10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 04:27:26 -0400
Message-ID: <51B58DE2.2020301@atmel.com>
Date: Mon, 10 Jun 2013 10:27:14 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [PATCHv4] ARM: at91: Fix link breakage when !CONFIG_PHYLIB
References: <1370425843-6802-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1370425843-6802-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 11:50, Alexandre Belloni :
> Fixes:
> arch/arm/mach-at91/built-in.o: In function `ksz9021rn_phy_fixup':
> :(.text+0x1174): undefined reference to `mdiobus_write'
> :(.text+0x1188): undefined reference to `mdiobus_write'
> :(.text+0x119c): undefined reference to `mdiobus_write'
> :(.text+0x11b0): undefined reference to `mdiobus_write'
> arch/arm/mach-at91/built-in.o: In function `sama5_dt_device_init':
> :(.init.text+0x1e34): undefined reference to `phy_register_fixup_for_uid'
>
> when CONFIG_PHYLIB is not selected.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

As Arnd told it was not so urgent and that it seems that we have to be 
strict for sending other 3.10-fixes, I stack this one on a at91-3.11-soc 
branch.

Thanks, best regards,

> ---
>   arch/arm/mach-at91/Kconfig          | 1 +
>   arch/arm/mach-at91/board-dt-sama5.c | 3 ++-
>   2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 0280238..699b71e 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -163,6 +163,7 @@ config MACH_SAMA5_DT
>   	bool "Atmel SAMA5 Evaluation Kits with device-tree support"
>   	depends on SOC_SAMA5
>   	select USE_OF
> +	select PHYLIB if NETDEVICES
>   	help
>   	  Select this if you want to experiment device-tree with
>   	  an Atmel Evaluation Kit.
> diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
> index 705305e..ad95f6a 100644
> --- a/arch/arm/mach-at91/board-dt-sama5.c
> +++ b/arch/arm/mach-at91/board-dt-sama5.c
> @@ -62,7 +62,8 @@ static int ksz9021rn_phy_fixup(struct phy_device *phy)
>
>   static void __init sama5_dt_device_init(void)
>   {
> -	if (of_machine_is_compatible("atmel,sama5d3xcm"))
> +	if (of_machine_is_compatible("atmel,sama5d3xcm") &&
> +	    IS_ENABLED(CONFIG_PHYLIB))
>   		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
>   			ksz9021rn_phy_fixup);
>
>


-- 
Nicolas Ferre
