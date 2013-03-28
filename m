Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab3C1I5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 04:57:21 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:17832 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab3C1I5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 04:57:18 -0400
Message-ID: <515405E1.1060105@atmel.com>
Date: Thu, 28 Mar 2013 09:57:05 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [GIT PULL] at91: soc for 3.10 #2
References: <5152B357.3020500@atmel.com> <201303271902.00068.arnd@arndb.de>
In-Reply-To: <201303271902.00068.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 08:01 PM, Arnd Bergmann :
> On Wednesday 27 March 2013, Nicolas Ferre wrote:
> 
>> ----------------------------------------------------------------
>> Introduction of new Atmel Cortex-A5: SAMA5D3 family.
>> - Modify AT91 Kconfig to plit ARMv4/5 and ARMv7 arch
>> - Modify PMC driver (clocks)
>> - Core SAMA5 support
>> - Board file, DT files and defconfig
> 
> Looks really good. Olof said he'd take over merging tomorrow,
> so I'll leave it for him.
> 
>> ----------------------------------------------------------------
>> Ludovic Desroches (6):
>>       ARM: at91: change name template in AT91_SOC_START macro
>>       ARM: at91: add AT91_SAM9_TIME entry to select at91sam926x_time.c compilation
>>       ARM: at91: introduce the core type choice to split ARMv4/5 and ARMv7 arch
>>       ARM: at91: introduce SAMA5 support
>>       ARM: at91: dt: add device tree files for SAMA5D3 family
>>       ARM: at91: add defconfig for SAMA5
> 
> There is one obvious change that would be nice to include here,
> can you add this on top (either Nicolas or Olof)?

Yes, I include it in a v2 pull-request now.

Olof, can you please take this new one with Arnd's patch included?


> 8<---------
> Subject: ARM: at91: make ATAGS support conditional on CONFIG_ATAGS
> 
> We have the global CONFIG_ATAGS symbol that is used to determine
> whether ATAGS based boot is possible or not. Since we are
> splitting out the legacy boards from the main Kconfig on at91,
> we can use that symbol to easily hide the old options.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>


Thanks, a lot, bye,


> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 0280238..119a0a4 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -137,8 +137,9 @@ config SOC_AT91SAM9N12
>  	  Select this if you are using Atmel's AT91SAM9N12 SoC.
>  
>  # ----------------------------------------------------------
> -
> +if ATAGS
>  source arch/arm/mach-at91/Kconfig.non_dt
> +endif
>  endif # SOC_SAM_V4_V5
>  
>  comment "Generic Board Type"
> 


-- 
Nicolas Ferre
