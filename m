Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbaEAIyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 04:54:54 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:36851 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaEAIyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 04:54:49 -0400
Date: Thu, 1 May 2014 17:54:47 +0900
From: Simon Horman <horms@verge.net.au>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Marek Vasut <marex@denx.de>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Huang Shijie <b32955@freescale.com>, linux-mtd@lists.infradead.org,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH v2 02/12] ARM: defconfigs: add MTD_SPI_NOR (new
 dependency for M25P80)
Message-ID: <20140501085447.GB20410@verge.net.au>
References: <1398925607-7482-1-git-send-email-computersforpeace@gmail.com>
 <1398925607-7482-3-git-send-email-computersforpeace@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398925607-7482-3-git-send-email-computersforpeace@gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ CC linux-sh and Magnus Damm (shmobile co-maintainer) ]

On Wed, Apr 30, 2014 at 11:26:37PM -0700, Brian Norris wrote:
> These defconfigs contain the CONFIG_M25P80 symbol, which is now
> dependent on the MTD_SPI_NOR symbol. Add CONFIG_MTD_SPI_NOR to satisfy
> the new dependency.
> 
> At the same time, drop the now-nonexistent CONFIG_MTD_CHAR symbol.
> 
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
> This patch catches all the configs I couldn't find a sub-arch for, plus the ARM
> multiplatform defconfigs
> 
>  arch/arm/configs/bockw_defconfig    | 2 +-
>  arch/arm/configs/koelsch_defconfig  | 1 +
>  arch/arm/configs/lager_defconfig    | 1 +

The above changes are for shmobile SoC defconfigs which I maintain
(as is one other patch in the series).
While the below ones are not.


With regards to updating shmobile configuration options,
we have recently moved towards using Kconfig rather than
defconfig in cases where selecting A means we really ought
to select B too. Something along the lines of:

	select CONFIG_MTD_SPI_NOR if CONFIG_MTD_M25P80

Do you consider that CONFIG_MTD_SPI_NOR should always
be selected if CONFIG_MTD_M25P80 if selected?

If so, perhaps it would be best to update the CONFIG_MTD_M25P80 Kconfig
node to select CONFIG_MTD_M25P80. This would probably imply that most
if not all of this series would no longer be needed.

If not, would you be able to make a patch to add something like
the above snippet to arch/arm/shmobile/Kconfig (probably more than once)
and drop the changes to shmobile defconfigs from this series?


>  arch/arm/configs/multi_v5_defconfig | 1 +
>  arch/arm/configs/multi_v7_defconfig | 1 +
>  5 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/configs/bockw_defconfig b/arch/arm/configs/bockw_defconfig
> index e816140d81c5..28339e072a71 100644
> --- a/arch/arm/configs/bockw_defconfig
> +++ b/arch/arm/configs/bockw_defconfig
> @@ -50,11 +50,11 @@ CONFIG_DEVTMPFS_MOUNT=y
>  # CONFIG_PREVENT_FIRMWARE_BUILD is not set
>  # CONFIG_FW_LOADER is not set
>  CONFIG_MTD=y
> -CONFIG_MTD_CHAR=y

The above change seems unrelated to the subject of the patch.

If its valid then I'd prefer it submitted as a separate patch.

>  CONFIG_MTD_BLOCK=y
>  CONFIG_MTD_CFI=y
>  CONFIG_MTD_CFI_AMDSTD=y
>  CONFIG_MTD_M25P80=y
> +CONFIG_MTD_SPI_NOR=y
>  CONFIG_SCSI=y
>  CONFIG_BLK_DEV_SD=y
>  CONFIG_NETDEVICES=y
> diff --git a/arch/arm/configs/koelsch_defconfig b/arch/arm/configs/koelsch_defconfig
> index 86faab565a96..dcd55f20d36e 100644
> --- a/arch/arm/configs/koelsch_defconfig
> +++ b/arch/arm/configs/koelsch_defconfig
> @@ -42,6 +42,7 @@ CONFIG_ATA=y
>  CONFIG_SATA_RCAR=y
>  CONFIG_MTD=y
>  CONFIG_MTD_M25P80=y
> +CONFIG_MTD_SPI_NOR=y
>  CONFIG_NETDEVICES=y
>  # CONFIG_NET_VENDOR_ARC is not set
>  # CONFIG_NET_CADENCE is not set
> diff --git a/arch/arm/configs/lager_defconfig b/arch/arm/configs/lager_defconfig
> index 58702440472a..c4dbd778458b 100644
> --- a/arch/arm/configs/lager_defconfig
> +++ b/arch/arm/configs/lager_defconfig
> @@ -53,6 +53,7 @@ CONFIG_DEVTMPFS=y
>  CONFIG_DEVTMPFS_MOUNT=y
>  CONFIG_MTD=y
>  CONFIG_MTD_M25P80=y
> +CONFIG_MTD_SPI_NOR=y
>  CONFIG_BLK_DEV_SD=y
>  CONFIG_ATA=y
>  CONFIG_SATA_RCAR=y
> diff --git a/arch/arm/configs/multi_v5_defconfig b/arch/arm/configs/multi_v5_defconfig
> index aa3dfb084fed..aaf23933fb91 100644
> --- a/arch/arm/configs/multi_v5_defconfig
> +++ b/arch/arm/configs/multi_v5_defconfig
> @@ -56,6 +56,7 @@ CONFIG_MTD_PHYSMAP=y
>  CONFIG_MTD_M25P80=y
>  CONFIG_MTD_NAND=y
>  CONFIG_MTD_NAND_ORION=y
> +CONFIG_MTD_SPI_NOR=y
>  CONFIG_BLK_DEV_LOOP=y
>  CONFIG_EEPROM_AT24=y
>  # CONFIG_SCSI_PROC_FS is not set
> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
> index d4e8a47a2f7c..9937db16050c 100644
> --- a/arch/arm/configs/multi_v7_defconfig
> +++ b/arch/arm/configs/multi_v7_defconfig
> @@ -108,6 +108,7 @@ CONFIG_CMA_SIZE_MBYTES=64
>  CONFIG_OMAP_OCP2SCP=y
>  CONFIG_MTD=y
>  CONFIG_MTD_M25P80=y
> +CONFIG_MTD_SPI_NOR=y
>  CONFIG_BLK_DEV_LOOP=y
>  CONFIG_ICS932S401=y
>  CONFIG_APDS9802ALS=y
> -- 
> 1.8.3.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
