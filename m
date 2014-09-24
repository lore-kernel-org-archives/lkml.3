Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbaIXPD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:03:26 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:32960 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaIXPDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:03:16 -0400
Message-ID: <5422DD2F.4090308@atmel.com>
Date: Wed, 24 Sep 2014 17:03:11 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <u.kleine-koenig@pengutronix.de>,
        <gerg@uclinux.org>, Olof Johansson <olof@lixom.net>,
        ARM Maintainers <arm@kernel.org>, <linux-kernel@vger.kernel.org>,
        Patrice Vilchez <patrice.vilchez@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [RFC PATCH] ARM: at91: remove no-MMU at91x40 support
References: <1411568281-3924-1-git-send-email-nicolas.ferre@atmel.com> <3700375.DRR5iB2NGi@wuerfel>
In-Reply-To: <3700375.DRR5iB2NGi@wuerfel>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/09/2014 16:47, Arnd Bergmann :
> On Wednesday 24 September 2014 16:18:01 Nicolas Ferre wrote:
>> As there is currently no-one to take care of this old !MMU target and as its
>> support in recent kernels is a bit rotten, remove this at91x40 support and the
>> board file associated with it (at91eb01).
>> There are modern ARM !MMU in Mainline now so this target is not interesting for
>> building tests anymore. It would be better to start from these modern ARM !MMU
>> platforms to reintroduce at91x40 support if needed.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
>> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
>> index 807b22dadcb6..f3bd8abd25c0 100644
>> --- a/arch/arm/mach-at91/Kconfig
>> +++ b/arch/arm/mach-at91/Kconfig
>> @@ -18,26 +18,22 @@ config HAVE_AT91_DBGU2
>>  config AT91_USE_OLD_CLK
>>  	bool
>>  
>> -config AT91_PMC_UNIT
>> -	bool
>> -	default !ARCH_AT91X40
>> -
>>  config COMMON_CLK_AT91
>>  	bool
>> -	default AT91_PMC_UNIT && USE_OF && !AT91_USE_OLD_CLK
>> +	default USE_OF && !AT91_USE_OLD_CLK
>>  	select COMMON_CLK
>>  
>>  config OLD_CLK_AT91
>>  	bool
>> -	default AT91_PMC_UNIT && AT91_USE_OLD_CLK
>> +	default AT91_USE_OLD_CLK
>>  
>>  config AT91_SAM9_ALT_RESET
>>  	bool
>> -	default !ARCH_AT91X40
>> +	default y
>>  
>>  config AT91_SAM9G45_RESET
>>  	bool
>> -	default !ARCH_AT91X40
>> +	default y
>>  
>>  config AT91_SAM9_TIME
>>  	bool
> 
> I think these can be simplified further: AT91_SAM9G45_RESET and
> AT91_SAM9_ALT_RESET can just go away and the files put into
> obj-y.

Yes, I had the same idea before realizing that these two directives will
move away in a patch already sent for 3.18. So, as this material is
probably 3.19-ish, I kept them as they are and keep in mind to remove
them when I merge them with 3.18-rc1...

> OLD_CLK_AT91 is the same as AT91_USE_OLD_CLK, so you could
> just use that instead. I suspect the 'USE_OF' dependency for
> COMMON_CLK_AT91 can also go away, since all platforms are
> either board file based and select AT91_USE_OLD_CLK, or they
> are DT based and don't.

Here also, I didn't want to touch more because we need to remove the
arch/arm/mach-at91/Kconfig.non_dt file very soon (3.19) and I don't want
to change this file (or all the SoC files) before the chunks related to
these directives simply go away.

Tell me if it makes sense.

Bye,
-- 
Nicolas Ferre
