Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaAQOgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:36:48 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35477 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbaAQOgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:36:46 -0500
Message-ID: <52D93FCA.1090202@ti.com>
Date: Fri, 17 Jan 2014 20:05:54 +0530
From: Balaji T K <balajitk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Tony Lindgren <tony@atomide.com>, Amarinder Bindra <a-bindra@ti.com>,
        Chris Ball <cjb@laptop.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: Multiple CCR definitions
References: <CAMuHMdVLat9-EMnCX=usthZLrP2YhCCT7-a3nhSQmgLvn_ftBg@mail.gmail.com> <CAGo_u6or57HEqRQjSjUXFpRNiFNbJyRYrsPX19Gf97J-sg4iHQ@mail.gmail.com>
In-Reply-To: <CAGo_u6or57HEqRQjSjUXFpRNiFNbJyRYrsPX19Gf97J-sg4iHQ@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 January 2014 12:09 AM, Nishanth Menon wrote:
> +linux-omap as well.
>
> On Thu, Jan 16, 2014 at 7:07 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Tue, Sep 10, 2013 at 11:05 PM, Linux Kernel Mailing List
>> <linux-kernel@vger.kernel.org> wrote:
>>>      mmc: omap_hsmmc: use the generic config for omap2plus devices
>>>
>>>      OMAP's hs_mmc driver is used for MMC controller operation on many
>>>      omap2plus SoCs (OMAP2430, OMAP3, 4, 5 and AM335x).
>>>
>>>      Considering that the device tree entries are already present for these,
>>>      allow the driver to be built using the config ARCH_OMAP2PLUS rather
>>>      than individually adding a config for each SoC to enable the
>>>      support.
>>>
>>>      Use COMPILE_TEST to enable the build for other platforms.
>>>
>>>      Signed-off-by: Amarinder Bindra <a-bindra@ti.com>
>>>      Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
>>>      Cc: Nishanth Menon <nm@ti.com>
>>>      Acked-by: Felipe Balbi <balbi@ti.com>
>>>      Acked-by: Balaji T K <balajitk@ti.com>
>>>      Signed-off-by: Chris Ball <cjb@laptop.org>
>>> ---
>>>   drivers/mmc/host/Kconfig |    6 +++---
>>>   1 files changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
>>> index 84102bc..b8ce939 100644
>>> --- a/drivers/mmc/host/Kconfig
>>> +++ b/drivers/mmc/host/Kconfig
>>> @@ -284,11 +284,11 @@ config MMC_OMAP
>>>
>>>   config MMC_OMAP_HS
>>>          tristate "TI OMAP High Speed Multimedia Card Interface support"
>>> -       depends on SOC_OMAP2430 || ARCH_OMAP3 || ARCH_OMAP4
>>> +       depends on ARCH_OMAP2PLUS || COMPILE_TEST
>>
>> sh-allmodconfig (http://kisskb.ellerman.id.au/kisskb/buildresult/10477672/):
>> include/linux/omap-dma.h:171:8: error: expected identifier before
>> numeric constant
>> make[4]: *** [drivers/mmc/host/omap_hsmmc.o] Error 1
>>
>> It fails because sh #defines "CCR", which is one of the enum values in
>> include/linux/omap-dma.h.
>>
>> I expect a similar failure on blackfin, which also has #define CCR.
>>
>> Possible solutions:
>>    1. Rename CCR in sh/bfin to e.g. SH_CCR resp. BF_CCR.
>>    2. Use "depends on ARCH_OMAP2PLUS || (COMPILE_TEST && ARM)

omap-dma.h will be needed until all OMAPs are converted to DT only boot.
So depends on ARCH_OMAP2PLUS || (COMPILE_TEST && ARM) looks good to me

>>    3. Stop using include/linux/omap-dma.h, as it says:
>>
>>       *  Legacy OMAP DMA handling defines and functions
>>       *
>>       *  NOTE: Do not use these any longer.
>>       *
>>       *  Use the generic dmaengine functions as defined in
>>       *  include/linux/dmaengine.h.
>>

>> Gr{oetje,eeting}s,
>>
>>                          Geert
>>
>> --
>> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>>
>> In personal conversations with technical people, I call myself a hacker. But
>> when I'm talking to journalists I just say "programmer" or something like that.
>>                                  -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

