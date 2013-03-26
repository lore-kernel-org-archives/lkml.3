Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934271Ab3CZNcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:32:45 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:65376 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933914Ab3CZNco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:32:44 -0400
MIME-Version: 1.0
In-Reply-To: <51505C59.1040607@infradead.org>
References: <1364210495-7938-1-git-send-email-prabhakar.csengg@gmail.com> <51505C59.1040607@infradead.org>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 26 Mar 2013 19:02:21 +0530
Message-ID: <CA+V-a8u2kHoCWW4xbKkPoUQkBHaJHJA=0xdp=kbCUCO2PcY8+w@mail.gmail.com>
Subject: Re: [PATCH] ARM: davinci: use is IS_ENABLED macro
To: Randy Dunlap <rdunlap@infradead.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Sekhar Nori <nsekhar@ti.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Mon, Mar 25, 2013 at 7:46 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 03/25/13 04:21, Prabhakar lad wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> This patches replaces #if defined() by IS_ENABLED macro, which provides
>> better readability.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> Cc: Sekhar Nori <nsekhar@ti.com>
>> ---
>>  Note: This patch is compile tested only for davinci_all_defconfig
>>        and da8xx_omapl_defconfig.
>
> Source files that use IS_ENABLED() etc. should also
> #include <linux/kconfig.h>
>
> Is that already done in all of these source files?
>
as mentioned in  my NOTE when I built with the above
mentioned  *defconfig's all the files which were modified
in this patch got built (.o files were created), which indicates
#include <linux/kconfig.h> is included :-)

Regards,
--Prabhakar

>
>>  arch/arm/mach-davinci/board-da830-evm.c   |    2 +-
>>  arch/arm/mach-davinci/board-da850-evm.c   |    3 +--
>>  arch/arm/mach-davinci/board-dm644x-evm.c  |    9 +++------
>>  arch/arm/mach-davinci/board-dm646x-evm.c  |    3 +--
>>  arch/arm/mach-davinci/board-neuros-osd2.c |    6 ++----
>>  arch/arm/mach-davinci/devices.c           |    2 +-
>>  arch/arm/mach-davinci/usb.c               |    2 +-
>>  7 files changed, 10 insertions(+), 17 deletions(-)
>>
>> diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
>> index 6da25ee..68ade71 100644
>> --- a/arch/arm/mach-davinci/board-da830-evm.c
>> +++ b/arch/arm/mach-davinci/board-da830-evm.c
>> @@ -298,7 +298,7 @@ static const short da830_evm_emif25_pins[] = {
>>       -1
>>  };
>>
>> -#if defined(CONFIG_MMC_DAVINCI) || defined(CONFIG_MMC_DAVINCI_MODULE)
>> +#if IS_ENABLED(CONFIG_MMC_DAVINCI)
>>  #define HAS_MMC      1
>>  #else
>>  #define HAS_MMC      0
>> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
>> index c2dfe06..3475769 100644
>> --- a/arch/arm/mach-davinci/board-da850-evm.c
>> +++ b/arch/arm/mach-davinci/board-da850-evm.c
>> @@ -335,8 +335,7 @@ static const short da850_evm_nor_pins[] = {
>>       -1
>>  };
>>
>> -#if defined(CONFIG_MMC_DAVINCI) || \
>> -    defined(CONFIG_MMC_DAVINCI_MODULE)
>> +#if IS_ENABLED(CONFIG_MMC_DAVINCI)
>>  #define HAS_MMC 1
>>  #else
>>  #define HAS_MMC 0
>> diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
>> index 71735e7..d0f6365 100644
>> --- a/arch/arm/mach-davinci/board-dm644x-evm.c
>> +++ b/arch/arm/mach-davinci/board-dm644x-evm.c
>> @@ -750,22 +750,19 @@ static int davinci_phy_fixup(struct phy_device *phydev)
>>       return 0;
>>  }
>>
>> -#if defined(CONFIG_BLK_DEV_PALMCHIP_BK3710) || \
>> -    defined(CONFIG_BLK_DEV_PALMCHIP_BK3710_MODULE)
>> +#if IS_ENABLED(CONFIG_BLK_DEV_PALMCHIP_BK3710)
>>  #define HAS_ATA 1
>>  #else
>>  #define HAS_ATA 0
>>  #endif
>>
>> -#if defined(CONFIG_MTD_PHYSMAP) || \
>> -    defined(CONFIG_MTD_PHYSMAP_MODULE)
>> +#if IS_ENABLED(CONFIG_MTD_PHYSMAP)
>>  #define HAS_NOR 1
>>  #else
>>  #define HAS_NOR 0
>>  #endif
>>
>> -#if defined(CONFIG_MTD_NAND_DAVINCI) || \
>> -    defined(CONFIG_MTD_NAND_DAVINCI_MODULE)
>> +#if IS_ENABLED(CONFIG_MTD_NAND_DAVINCI)
>>  #define HAS_NAND 1
>>  #else
>>  #define HAS_NAND 0
>> diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
>> index de7adff..c84fdd5 100644
>> --- a/arch/arm/mach-davinci/board-dm646x-evm.c
>> +++ b/arch/arm/mach-davinci/board-dm646x-evm.c
>> @@ -117,8 +117,7 @@ static struct platform_device davinci_nand_device = {
>>       },
>>  };
>>
>> -#if defined(CONFIG_BLK_DEV_PALMCHIP_BK3710) || \
>> -    defined(CONFIG_BLK_DEV_PALMCHIP_BK3710_MODULE)
>> +#if IS_ENABLED(CONFIG_BLK_DEV_PALMCHIP_BK3710)
>>  #define HAS_ATA 1
>>  #else
>>  #define HAS_ATA 0
>> diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
>> index 1c98107..8bd0a43 100644
>> --- a/arch/arm/mach-davinci/board-neuros-osd2.c
>> +++ b/arch/arm/mach-davinci/board-neuros-osd2.c
>> @@ -168,15 +168,13 @@ static struct davinci_mmc_config davinci_ntosd2_mmc_config = {
>>  };
>>
>>
>> -#if defined(CONFIG_BLK_DEV_PALMCHIP_BK3710) || \
>> -     defined(CONFIG_BLK_DEV_PALMCHIP_BK3710_MODULE)
>> +#if IS_ENABLED(CONFIG_BLK_DEV_PALMCHIP_BK3710)
>>  #define HAS_ATA 1
>>  #else
>>  #define HAS_ATA 0
>>  #endif
>>
>> -#if defined(CONFIG_MTD_NAND_DAVINCI) || \
>> -     defined(CONFIG_MTD_NAND_DAVINCI_MODULE)
>> +#if IS_ENABLED(CONFIG_MTD_NAND_DAVINCI)
>>  #define HAS_NAND 1
>>  #else
>>  #define HAS_NAND 0
>> diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
>> index 4c48a36..df135de 100644
>> --- a/arch/arm/mach-davinci/devices.c
>> +++ b/arch/arm/mach-davinci/devices.c
>> @@ -119,7 +119,7 @@ void __init davinci_init_ide(void)
>>       platform_device_register(&ide_device);
>>  }
>>
>> -#if  defined(CONFIG_MMC_DAVINCI) || defined(CONFIG_MMC_DAVINCI_MODULE)
>> +#if IS_ENABLED(CONFIG_MMC_DAVINCI)
>>
>>  static u64 mmcsd0_dma_mask = DMA_BIT_MASK(32);
>>
>> diff --git a/arch/arm/mach-davinci/usb.c b/arch/arm/mach-davinci/usb.c
>> index 34509ff..5764d65 100644
>> --- a/arch/arm/mach-davinci/usb.c
>> +++ b/arch/arm/mach-davinci/usb.c
>> @@ -17,7 +17,7 @@
>>  #define DA8XX_USB0_BASE      0x01e00000
>>  #define DA8XX_USB1_BASE      0x01e25000
>>
>> -#if defined(CONFIG_USB_MUSB_HDRC) || defined(CONFIG_USB_MUSB_HDRC_MODULE)
>> +#if IS_ENABLED(CONFIG_USB_MUSB_HDRC)
>>  static struct musb_hdrc_eps_bits musb_eps[] = {
>>       { "ep1_tx", 8, },
>>       { "ep1_rx", 8, },
>>
>
>
> --
> ~Randy
