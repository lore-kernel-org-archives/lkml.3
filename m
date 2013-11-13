Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553Ab3KMPd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:33:28 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47201 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757159Ab3KMPd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:33:26 -0500
Message-ID: <52839B9C.8090707@ti.com>
Date: Wed, 13 Nov 2013 09:32:44 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Sricharan R <r.sricharan@ti.com>, Rajendra Nayak <rnayak@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <marc.zyngier@arm.com>,
        <grant.likely@linaro.org>, <mark.rutland@arm.com>,
        <robherring2@gmail.com>, <tglx@linutronix.de>,
        <santosh.shilimkar@ti.com>, <galak@codeaurora.org>
Subject: Re: [PATCH V3 7/7] ARM: DRA: Enable Crossbar IP support for DRA7XX
References: <1383657257-3458-1-git-send-email-r.sricharan@ti.com> <1383657257-3458-8-git-send-email-r.sricharan@ti.com> <5281BF70.4050708@ti.com> <5281C0E9.8020104@ti.com>
In-Reply-To: <5281C0E9.8020104@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 11:47 PM, Sricharan R wrote:
> Hi Rajendra,
> 
> On Tuesday 12 November 2013 11:11 AM, Rajendra Nayak wrote:
>> On Tuesday 05 November 2013 06:44 PM, Sricharan R wrote:
>>> Enable the crossbar IP support for DRA7xx soc.
>>>
>>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>> Cc: Rajendra Nayak <rnayak@ti.com>
>>> Cc: Tony Lindgren <tony@atomide.com>
>>> Signed-off-by: Sricharan R <r.sricharan@ti.com>
>>> ---
>>>  arch/arm/mach-omap2/Kconfig        |    1 +
>>>  arch/arm/mach-omap2/omap4-common.c |    4 ++++
>>>  2 files changed, 5 insertions(+)
>>>
>>> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
>>> index b5fb5f7..2086c65 100644
>>> --- a/arch/arm/mach-omap2/Kconfig
>>> +++ b/arch/arm/mach-omap2/Kconfig
>>> @@ -141,6 +141,7 @@ config SOC_DRA7XX
>>>  	select ARM_GIC
>>>  	select HAVE_SMP
>>>  	select COMMON_CLK
>>> +	select IRQ_CROSSBAR
>>>  
>>>  comment "OMAP Core Type"
>>>  	depends on ARCH_OMAP2
>>> diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
>>> index 5791143..274cbfa 100644
>>> --- a/arch/arm/mach-omap2/omap4-common.c
>>> +++ b/arch/arm/mach-omap2/omap4-common.c
>>> @@ -22,6 +22,7 @@
>>>  #include <linux/of_platform.h>
>>>  #include <linux/export.h>
>>>  #include <linux/irqchip/arm-gic.h>
>>> +#include <linux/irqchip/irq-crossbar.h>
>>>  #include <linux/of_address.h>
>>>  #include <linux/reboot.h>
>>>  
>>> @@ -282,9 +283,12 @@ void __init omap_gic_of_init(void)
>>>  
>>>  skip_errata_init:
>>>  	omap_wakeupgen_init();
>>> +	if (soc_is_dra7xx())
>>> +		crossbar_init();
>> Its good if this is called irqcrossbar_init() to avoid confusion
>> with the dma crossbar which also exists in dra7 devices.
>>
>  Ya makes sense. Will change this.
Also why not call it without explicit soc check? there is already
parse for of_find_matching_node(NULL, crossbar_match); to see if we
have a match in the crossbar_init. OR call it from dra7 init without
SoC check dependency?

Rationale - with more TI SoCs trending towards crossbar, we dont need
to keep adding to the soc_is checks, further, we intend to remove
soc_is checks in it's entirety..


-- 
Regards,
Nishanth Menon
