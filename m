Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbaJEBT2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 21:19:28 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:51190 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaJEBT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 21:19:27 -0400
Message-ID: <54309DFA.1030305@gmail.com>
Date: Sun, 05 Oct 2014 09:25:14 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, wim@iguana.be,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/watchdog/Kconfig: Let XILINX_WATCHDOG and TEGRA_WATCHDOG
 depend on HAS_IOMEM
References: <542FC064.1030604@gmail.com> <54308E48.6020809@roeck-us.net>
In-Reply-To: <54308E48.6020809@roeck-us.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/14 8:18, Guenter Roeck wrote:
> On 10/04/2014 02:39 AM, Chen Gang wrote:
>> They need HAS_IOMEM, so let them depend on it, the related error (with
>> allmodconfig under um):
>>
>>      MODPOST 1205 modules
>>    ERROR: "syscall" [fs/hostfs/hostfs.ko] undefined!
>>    ERROR: "devm_ioremap_resource" [drivers/watchdog/tegra_wdt.ko] undefined!
>>    ERROR: "devm_ioremap_resource" [drivers/watchdog/of_xilinx_wdt.ko] undefined!
>>
> Headline is a bit excessive ("watchdog: ..." would have been sufficient,
> the first error is irrelevant as you found out yourself, and you got an
> extra empty line here. Otherwise looks good.
> 
> Can you resubmit with that fixed ?
> 

OK, thank, I shall send patch v2 for it.

> On a side note, guess the conclusion was to not provide a dummy for
> devm_ioremap_resource if HAS_IOMEM is not defined. Too bad.
>

For me, it is checked during config time, so need report error during
compiling or building time instead of dummy.

And I'd like to let devm_ioremap* quoted by "#if HAS_IOMEM", so can
find this issue during compiling time, not in linking time (which can
save builder's time resource).


Thanks. 

>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>   drivers/watchdog/Kconfig | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
>> index a51ccf3..d0ddf90 100644
>> --- a/drivers/watchdog/Kconfig
>> +++ b/drivers/watchdog/Kconfig
>> @@ -132,6 +132,7 @@ config WM8350_WATCHDOG
>>
>>   config XILINX_WATCHDOG
>>       tristate "Xilinx Watchdog timer"
>> +    depends on HAS_IOMEM
>>       select WATCHDOG_CORE
>>       help
>>         Watchdog driver for the xps_timebase_wdt ip core.
>> @@ -472,7 +473,7 @@ config SIRFSOC_WATCHDOG
>>
>>   config TEGRA_WATCHDOG
>>       tristate "Tegra watchdog"
>> -    depends on ARCH_TEGRA || COMPILE_TEST
>> +    depends on (ARCH_TEGRA || COMPILE_TEST) && HAS_IOMEM
>>       select WATCHDOG_CORE
>>       help
>>         Say Y here to include support for the watchdog timer
>>
> 

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
