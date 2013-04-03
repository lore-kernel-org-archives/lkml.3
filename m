Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab3DCHWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 03:22:52 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:53808 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab3DCHWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 03:22:51 -0400
Message-ID: <515BD8C8.5060701@atmel.com>
Date: Wed, 3 Apr 2013 09:22:48 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Arnd Bergmann <arnd@arndb.de>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [GIT PULL] at91: soc for 3.10 #2
References: <5152B357.3020500@atmel.com> <201303271902.00068.arnd@arndb.de> <CAOesGMiy7q-xbc0SN78d7cvZmLgywy1PH7_Srw_=pzErSkrt-g@mail.gmail.com>
In-Reply-To: <CAOesGMiy7q-xbc0SN78d7cvZmLgywy1PH7_Srw_=pzErSkrt-g@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 02:26 AM, Olof Johansson :
> On Wed, Mar 27, 2013 at 12:01 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Wednesday 27 March 2013, Nicolas Ferre wrote:
>>
>>> ----------------------------------------------------------------
>>> Introduction of new Atmel Cortex-A5: SAMA5D3 family.
>>> - Modify AT91 Kconfig to plit ARMv4/5 and ARMv7 arch
>>> - Modify PMC driver (clocks)
>>> - Core SAMA5 support
>>> - Board file, DT files and defconfig
>>
>> Looks really good. Olof said he'd take over merging tomorrow,
>> so I'll leave it for him.
>>
>>> ----------------------------------------------------------------
>>> Ludovic Desroches (6):
>>>       ARM: at91: change name template in AT91_SOC_START macro
>>>       ARM: at91: add AT91_SAM9_TIME entry to select at91sam926x_time.c compilation
>>>       ARM: at91: introduce the core type choice to split ARMv4/5 and ARMv7 arch
>>>       ARM: at91: introduce SAMA5 support
>>>       ARM: at91: dt: add device tree files for SAMA5D3 family
>>>       ARM: at91: add defconfig for SAMA5
>>
>> There is one obvious change that would be nice to include here,
>> can you add this on top (either Nicolas or Olof)?
>>
>> 8<---------
>> Subject: ARM: at91: make ATAGS support conditional on CONFIG_ATAGS
>>
>> We have the global CONFIG_ATAGS symbol that is used to determine
>> whether ATAGS based boot is possible or not. Since we are
>> splitting out the legacy boards from the main Kconfig on at91,
>> we can use that symbol to easily hide the old options.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>
>> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
>> index 0280238..119a0a4 100644
>> --- a/arch/arm/mach-at91/Kconfig
>> +++ b/arch/arm/mach-at91/Kconfig
>> @@ -137,8 +137,9 @@ config SOC_AT91SAM9N12
>>           Select this if you are using Atmel's AT91SAM9N12 SoC.
>>
>>  # ----------------------------------------------------------
>> -
>> +if ATAGS
>>  source arch/arm/mach-at91/Kconfig.non_dt
>> +endif
>>  endif # SOC_SAM_V4_V5
>>
>>  comment "Generic Board Type"
> 
> Actually, it's not that simple. With this patch, I get:
> 
> arch/arm/Kconfig:1841:error: recursive dependency detected!
> arch/arm/Kconfig:1841:  symbol USE_OF is selected by MACH_AT91RM9200_DT
> arch/arm/mach-at91/Kconfig:147: symbol MACH_AT91RM9200_DT depends on
> SOC_AT91RM9200
> arch/arm/mach-at91/Kconfig:74:  symbol SOC_AT91RM9200 is selected by
> ARCH_AT91RM9200
> arch/arm/mach-at91/Kconfig.non_dt:12:   symbol ARCH_AT91RM9200 is part
> of choice <choice>
> arch/arm/mach-at91/Kconfig.non_dt:6:    choice <choice> contains symbol <choice>
> arch/arm/mach-at91/Kconfig.non_dt:6:    choice <choice> contains symbol ATAGS
> arch/arm/Kconfig:1850:  symbol ATAGS depends on USE_OF
> 
> Also, USE_OF isn't set at that point (it's controlled by the next
> section), so it can't be used as a replacement.
> 
> Also, isn't it a bit backwards in the first place to first set ATAGS
> vs no-ATAGS, and then get to choose what hardware you want to build
> for?

True, I was thinking it was a common pattern.

> I'll take off the last patch from the branch and re-merge it (since I
> hadn't pushed it out yet), the above can be sorted out separately.

Thanks Olof for taking care about this! We will come back on this later
or simply decide that it is not worth it / not logical...

Best regards,
-- 
Nicolas Ferre
