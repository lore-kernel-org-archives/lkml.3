Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbaKSH4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 02:56:53 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:52493 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149AbaKSH4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 02:56:52 -0500
Message-ID: <546C4D3C.2010007@samsung.com>
Date: Wed, 19 Nov 2014 16:56:44 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] ARM: exynos_defconfig: Use 16 minors per MMC block device
References: <1415966317-11170-1-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1415966317-11170-1-git-send-email-k.kozlowski@samsung.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/14 20:58, Krzysztof Kozlowski wrote:
> 16 minors per MMC block device are required to boot Rinato (Gear 2)
> board because up to 15 partitions are used.
> 
> With default 8 minors booting failed with:
> [    1.329092] mmcblk0: mmc0:0001 F5X5MA 3.64 GiB
> [    1.329448] mmcblk0boot0: mmc0:0001 F5X5MA partition 1 4.00 MiB
> [    1.329627] mmcblk0boot1: mmc0:0001 F5X5MA partition 2 4.00 MiB
> [    1.329808] mmcblk0rpmb: mmc0:0001 F5X5MA partition 3 512 KiB
> [    1.335717]  mmcblk0: p1 p2 p3 p4 p5 p6 p7
> [    1.436553] Waiting for root device /dev/mmcblk0p15...
> 
> while the correct list of partitions on mmcblk0 for Gear 2 is:
> [    1.436651]  mmcblk0: p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 p13 p14 p15
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  arch/arm/configs/exynos_defconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
> index 72058b8a6f4d..aa32931bdd30 100644
> --- a/arch/arm/configs/exynos_defconfig
> +++ b/arch/arm/configs/exynos_defconfig
> @@ -134,6 +134,7 @@ CONFIG_USB_STORAGE=y
>  CONFIG_USB_DWC3=y
>  CONFIG_USB_HSIC_USB3503=y
>  CONFIG_MMC=y
> +CONFIG_MMC_BLOCK_MINORS=16
>  CONFIG_MMC_SDHCI=y
>  CONFIG_MMC_SDHCI_S3C=y
>  CONFIG_MMC_SDHCI_S3C_DMA=y

Applied, thanks.

- Kukjin
