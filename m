Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422696Ab3FUNwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 09:52:16 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:48032 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161356Ab3FUNwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 09:52:13 -0400
MIME-Version: 1.0
In-Reply-To: <51C427E1.2000800@ti.com>
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
	<1371762407-24544-6-git-send-email-joelagnel@ti.com>
	<51C427E1.2000800@ti.com>
Date: Fri, 21 Jun 2013 08:52:12 -0500
Message-ID: <CAD=GYpb54bitcg0gnfhzxbvig3etRPY6fs=FOQu5nYkio5NRZw@mail.gmail.com>
Subject: Re: [PATCH v12 05/11] edma: config: Enable config options for EDMA
From: Joel A Fernandes <agnel.joel@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Joel A Fernandes <joelagnel@ti.com>, Tony Lindgren <tony@atomide.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 5:16 AM, Sekhar Nori <nsekhar@ti.com> wrote:
> On 6/21/2013 2:36 AM, Joel A Fernandes wrote:
>> From: Joel A Fernandes <agnel.joel@gmail.com>
>>
>> Build TI_EDMA by default for ARCH_DAVINCI and ARCH_OMAP2PLUS
>>
>> Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
>
> You should sign-off with author e-mail address.
>
>> ---
>>  arch/arm/Kconfig            |    1 +
>>  arch/arm/mach-omap2/Kconfig |    1 +
>>  drivers/dma/Kconfig         |    2 +-
>>  3 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index b1c66a4..7d58cd9 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -841,6 +841,7 @@ config ARCH_DAVINCI
>>       select HAVE_IDE
>>       select NEED_MACH_GPIO_H
>>       select TI_PRIV_EDMA
>> +     select DMADEVICES
>
> It is generally a bad idea to force select on something that can be
> enabled using menuconfig. Unless used carefully, select causes "unmet
> direct dependency" warnings which folks are already fighting hard to
> fix. This leads to what Russell referred in the past as "select madness" [1]

Are you concerned with bloat issues? I know your point of view but the idea
was to build these options by default for these platforms even though
in some cases
it might not be used. I have seen folks including myself select the wrong
option. Having the build system automatically select the correct option for the
most common cases can be very useful I feel and not require manual
configuration.

> In this particular case, it is perfectly okay to have a DaVinci platform
> without DMA engine support. Drivers figure out they don't have DMA
> support and switch to PIO mode.

Drivers can still use PIO mode if they wish even though DMA is built into the
kernel right.

>>       select USE_OF
>>       select ZONE_DMA
>>       help
>> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
>> index f91b07f..c02f083 100644
>> --- a/arch/arm/mach-omap2/Kconfig
>> +++ b/arch/arm/mach-omap2/Kconfig
>> @@ -17,6 +17,7 @@ config ARCH_OMAP2PLUS
>>       select PROC_DEVICETREE if PROC_FS
>>       select SOC_BUS
>>       select SPARSE_IRQ
>> +     select DMADEVICES
>>       select TI_PRIV_EDMA
>>       select USE_OF
>>       help
>> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
>> index 3215a3c..b2d6f15 100644
>> --- a/drivers/dma/Kconfig
>> +++ b/drivers/dma/Kconfig
>> @@ -216,7 +216,7 @@ config TI_EDMA
>>       depends on ARCH_DAVINCI || ARCH_OMAP
>>       select DMA_ENGINE
>>       select DMA_VIRTUAL_CHANNELS
>> -     default n
>> +     default y
>
> Can't see why DMA support should default to y.
>

For same reason as above.

Thanks,
Joel
