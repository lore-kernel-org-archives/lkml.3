Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070Ab3CLR7C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 13:59:02 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:32840 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284Ab3CLR7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 13:59:00 -0400
Message-ID: <513F6CE0.2090600@wwwdotorg.org>
Date: Tue, 12 Mar 2013 11:58:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Danny Huang <dahuang@nvidia.com>
CC: linux@arm.linux.org.uk, hdoyu@nvidia.com, olof@lixom.net,
        gregkh@linuxfoundation.org, arnd@arndb.de, josephl@nvidia.com,
        pdeschrijver@nvidia.com, pgaikwad@nvidia.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: tegra: expose chip ID and revision
References: <1363089667-15737-1-git-send-email-dahuang@nvidia.com>
In-Reply-To: <1363089667-15737-1-git-send-email-dahuang@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 06:01 AM, Danny Huang wrote:
> Expose Tegra chip ID and revision in /sys/devices/soc for user mode
> usage

> diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
> index d1c4893..b7abcfa 100644
> --- a/arch/arm/mach-tegra/Kconfig
> +++ b/arch/arm/mach-tegra/Kconfig
> @@ -17,6 +17,7 @@ config ARCH_TEGRA_2x_SOC
>  	select PINCTRL_TEGRA20
>  	select PL310_ERRATA_727915 if CACHE_L2X0
>  	select PL310_ERRATA_769419 if CACHE_L2X0
> +	select SOC_BUS
>  	select USB_ARCH_HAS_EHCI if USB_SUPPORT
>  	select USB_ULPI if USB
>  	select USB_ULPI_VIEWPORT if USB_SUPPORT
> @@ -36,6 +37,7 @@ config ARCH_TEGRA_3x_SOC
>  	select PINCTRL
>  	select PINCTRL_TEGRA30
>  	select PL310_ERRATA_769419 if CACHE_L2X0
> +	select SOC_BUS
>  	select USB_ARCH_HAS_EHCI if USB_SUPPORT
>  	select USB_ULPI if USB
>  	select USB_ULPI_VIEWPORT if USB_SUPPORT
> @@ -51,6 +53,7 @@ config ARCH_TEGRA_114_SOC
>  	select CPU_V7
>  	select PINCTRL
>  	select PINCTRL_TEGRA114
> +	select SOC_BUS
>  	help

I assume we'll want this feature for all Tegra SoCs. Can't we select it
from ARCH_TEGRA, rather than separately for each chip? CONFIG_ARCH_TEGRA
is defined in arch/arm/Kconfig.
