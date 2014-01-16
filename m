Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaAPSkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:40:03 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:51681 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaAPSj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:39:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVLat9-EMnCX=usthZLrP2YhCCT7-a3nhSQmgLvn_ftBg@mail.gmail.com>
References: <CAMuHMdVLat9-EMnCX=usthZLrP2YhCCT7-a3nhSQmgLvn_ftBg@mail.gmail.com>
Date: Thu, 16 Jan 2014 12:39:58 -0600
X-Google-Sender-Auth: AePsQQi_yPBkipYUk1ggHljPUfk
Message-ID: <CAGo_u6or57HEqRQjSjUXFpRNiFNbJyRYrsPX19Gf97J-sg4iHQ@mail.gmail.com>
Subject: Re: Multiple CCR definitions (was: Re: mmc: omap_hsmmc: use the
 generic config for omap2plus devices)
From: Nishanth Menon <nm@ti.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Tony Lindgren <tony@atomide.com>
Cc: Amarinder Bindra <a-bindra@ti.com>, Chris Ball <cjb@laptop.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+linux-omap as well.

On Thu, Jan 16, 2014 at 7:07 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Tue, Sep 10, 2013 at 11:05 PM, Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org> wrote:
>>     mmc: omap_hsmmc: use the generic config for omap2plus devices
>>
>>     OMAP's hs_mmc driver is used for MMC controller operation on many
>>     omap2plus SoCs (OMAP2430, OMAP3, 4, 5 and AM335x).
>>
>>     Considering that the device tree entries are already present for these,
>>     allow the driver to be built using the config ARCH_OMAP2PLUS rather
>>     than individually adding a config for each SoC to enable the
>>     support.
>>
>>     Use COMPILE_TEST to enable the build for other platforms.
>>
>>     Signed-off-by: Amarinder Bindra <a-bindra@ti.com>
>>     Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
>>     Cc: Nishanth Menon <nm@ti.com>
>>     Acked-by: Felipe Balbi <balbi@ti.com>
>>     Acked-by: Balaji T K <balajitk@ti.com>
>>     Signed-off-by: Chris Ball <cjb@laptop.org>
>> ---
>>  drivers/mmc/host/Kconfig |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
>> index 84102bc..b8ce939 100644
>> --- a/drivers/mmc/host/Kconfig
>> +++ b/drivers/mmc/host/Kconfig
>> @@ -284,11 +284,11 @@ config MMC_OMAP
>>
>>  config MMC_OMAP_HS
>>         tristate "TI OMAP High Speed Multimedia Card Interface support"
>> -       depends on SOC_OMAP2430 || ARCH_OMAP3 || ARCH_OMAP4
>> +       depends on ARCH_OMAP2PLUS || COMPILE_TEST
>
> sh-allmodconfig (http://kisskb.ellerman.id.au/kisskb/buildresult/10477672/):
> include/linux/omap-dma.h:171:8: error: expected identifier before
> numeric constant
> make[4]: *** [drivers/mmc/host/omap_hsmmc.o] Error 1
>
> It fails because sh #defines "CCR", which is one of the enum values in
> include/linux/omap-dma.h.
>
> I expect a similar failure on blackfin, which also has #define CCR.
>
> Possible solutions:
>   1. Rename CCR in sh/bfin to e.g. SH_CCR resp. BF_CCR.
>   2. Use "depends on ARCH_OMAP2PLUS || (COMPILE_TEST && ARM)
>   3. Stop using include/linux/omap-dma.h, as it says:
>
>      *  Legacy OMAP DMA handling defines and functions
>      *
>      *  NOTE: Do not use these any longer.
>      *
>      *  Use the generic dmaengine functions as defined in
>      *  include/linux/dmaengine.h.
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
