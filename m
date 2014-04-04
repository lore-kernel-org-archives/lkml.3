Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaDDOCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:02:45 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:63265 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbaDDOCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:02:43 -0400
Message-ID: <533EBB80.4080307@linaro.org>
Date: Fri, 04 Apr 2014 15:02:40 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linaro-kernel@lists.linaro.org
CC: Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: Fix DEBUG_LL for multi-platform kernels (without
 PL01X)
References: <1396610269-11580-1-git-send-email-daniel.thompson@linaro.org> <8799740.0uZJLUBGY1@wuerfel>
In-Reply-To: <8799740.0uZJLUBGY1@wuerfel>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/14 12:39, Arnd Bergmann wrote:
>> Problem is fixed by only deploying the compatibility options for SPEAr
>> when ARCH_MULTIPLATFORM is not set.
> 
> The assumption is actually wrong: SPEAr does not support single
> platform builds any more. The PLAT_SPEAR_SINGLE symbol in Kconfig
> is a leftover from an earlier patch I did that never got merged,
> and we should just remove that.

Thanks. I did make a wrong conclusion based on that symbol.


>> ---
>>  arch/arm/Kconfig.debug | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
>> index 0531da8..f10c784 100644
>> --- a/arch/arm/Kconfig.debug
>> +++ b/arch/arm/Kconfig.debug
>> @@ -991,9 +991,9 @@ config DEBUG_LL_INCLUDE
>>  config DEBUG_UART_PL01X
>>         def_bool ARCH_EP93XX || \
>>                 ARCH_INTEGRATOR || \
>> -               ARCH_SPEAR3XX || \
>> -               ARCH_SPEAR6XX || \
>> -               ARCH_SPEAR13XX || \
>> +               (ARCH_SPEAR3XX && !ARCH_MULTIPLATFORM) || \
>> +               (ARCH_SPEAR6XX && !ARCH_MULTIPLATFORM) || \
>> +               (ARCH_SPEAR13XX && !ARCH_MULTIPLATFORM) || \
>>                 ARCH_VERSATILE
> 
> Removing the SPEAR lines seems correct here, but the lines
> you add don't make any sense.

Will fix.

