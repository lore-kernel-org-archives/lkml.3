Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbaB0VoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:44:08 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:39491 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaB0VoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:44:05 -0500
Message-ID: <530FB19F.3050209@gmail.com>
Date: Thu, 27 Feb 2014 22:43:59 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ARM: mvebu: move DT Dove to MVEBU
References: <1393536486-3827-1-git-send-email-sebastian.hesselbarth@gmail.com> <1393536486-3827-4-git-send-email-sebastian.hesselbarth@gmail.com> <20140227214039.GJ1872@titan.lakedaemon.net>
In-Reply-To: <20140227214039.GJ1872@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 10:40 PM, Jason Cooper wrote:
> On Thu, Feb 27, 2014 at 10:28:04PM +0100, Sebastian Hesselbarth wrote:
>> With all the DT support preparation done, we are able to move Dove
>> to MVEBU easily. Legacy non-DT mach-dove is left untouched to rot
>> for a while before removal. Also, convert SATA PHY Kconfig entry,
>> which is DT-only.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Pawel Moll <pawel.moll@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
>> Cc: Kumar Gala <galak@codeaurora.org>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Jason Cooper <jason@lakedaemon.net>
>> Cc: Andrew Lunn <andrew@lunn.ch>
>> Cc: Gregory Clement <gregory.clement@free-electrons.com>
>> Cc: Kishon Vijay Abraham I <kishon@ti.com>
>> Cc: devicetree@vger.kernel.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>   arch/arm/boot/dts/Makefile                           | 12 ++++++------
>>   arch/arm/mach-dove/Kconfig                           | 12 ------------
>>   arch/arm/mach-dove/Makefile                          |  1 -
>>   arch/arm/mach-mvebu/Kconfig                          | 12 ++++++++++++
>>   arch/arm/mach-mvebu/Makefile                         |  1 +
>>   arch/arm/{mach-dove/board-dt.c => mach-mvebu/dove.c} | 20 ++++++++------------
>>   drivers/phy/Kconfig                                  |  2 +-
>>   7 files changed, 28 insertions(+), 32 deletions(-)
>>   rename arch/arm/{mach-dove/board-dt.c => mach-mvebu/dove.c} (61%)
>>
>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>> index 032030361bef..376a2573e500 100644
>> --- a/arch/arm/boot/dts/Makefile
>> +++ b/arch/arm/boot/dts/Makefile
>> @@ -55,11 +55,6 @@ dtb-$(CONFIG_ARCH_BERLIN) += \
>>   	berlin2cd-google-chromecast.dtb
>>   dtb-$(CONFIG_ARCH_DAVINCI) += da850-enbw-cmc.dtb \
>>   	da850-evm.dtb
>> -dtb-$(CONFIG_ARCH_DOVE) += dove-cm-a510.dtb \
>> -	dove-cubox.dtb \
>> -	dove-d2plug.dtb \
>> -	dove-d3plug.dtb \
>> -	dove-dove-db.dtb
>>   dtb-$(CONFIG_ARCH_EFM32) += efm32gg-dk3750.dtb
>>   dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-origen.dtb \
>>   	exynos4210-smdkv310.dtb \
>> @@ -132,7 +127,12 @@ dtb-$(CONFIG_ARCH_MVEBU) += armada-370-db.dtb \
>>   	armada-xp-gp.dtb \
>>   	armada-xp-netgear-rn2120.dtb \
>>   	armada-xp-matrix.dtb \
>> -	armada-xp-openblocks-ax3-4.dtb
>> +	armada-xp-openblocks-ax3-4.dtb \
>> +	dove-cm-a510.dtb \
>> +	dove-cubox.dtb \
>> +	dove-d2plug.dtb \
>> +	dove-d3plug.dtb \
>> +	dove-dove-db.dtb
>
> This is going to conflict badly with
>
>    a02dd0271d01 ARM: mvebu: select dtbs from MACH_ARMADA_*
>
> Perhaps you could mimic what Andrew did in his series:
>
> dove := dove-cm-a510.dtb \
> 	dove-cubox.dtb \
> 	dove-d2plug.dtb \
> 	dove-d3plug.dtb \
> 	dove-dove-db.dtb
> dtb-$(CONFIG_ARCH_DOVE) += $(dove)
> dtb-$(CONFIG_MACH_DOVE) += $(dove)

Ok, will do - except dtb-$(CONFIG_ARCH_DOVE) above.. there is no
DT in ARCH_DOVE after this patch.

> We plan on re-alphabetizing next window to prevent bad conflicts in this
> window.

Good!

Sebastian
