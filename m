Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab3LENwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 08:52:49 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:45066 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab3LENwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 08:52:47 -0500
Message-ID: <52A08522.6040203@linaro.org>
Date: Thu, 05 Dec 2013 21:52:34 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Jon Masters <jonathan@jonmasters.org>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [RFC part3 PATCH 1/2] clocksource / arch_timer: Use ACPI GTDT
 table to initialize arch timer
References: <1386088891-2917-1-git-send-email-hanjun.guo@linaro.org> <1386088891-2917-2-git-send-email-hanjun.guo@linaro.org> <201312050443.21858.arnd@arndb.de>
In-Reply-To: <201312050443.21858.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年12月05日 11:43, Arnd Bergmann wrote:
> On Tuesday 03 December 2013, Hanjun Guo wrote:
>
>> +#ifdef CONFIG_ACPI
>> +void __init arch_timer_acpi_init(void)
>> +{
> ...
>> +}
>> +#else
>> +void __init arch_timer_acpi_init(void) { return; };
>> +#endif
>>   
> The #else clause is broken in combination with
>
>> diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
>> index 6d26b40..2654edf 100644
>> --- a/include/clocksource/arm_arch_timer.h
>> +++ b/include/clocksource/arm_arch_timer.h
>> @@ -66,6 +66,11 @@ static inline struct timecounter *arch_timer_get_timecounter(void)
>>   	return NULL;
>>   }
>>   
>> +static inline void arch_timer_acpi_init(void)
>> +{
>> +	return;
>> +}
>> +
>>   #endif
>>   
> this inline function. Have you build-tested this with CONFIG_ACPI disabled?

Good catch! Thank you very much, will fix it in next version.

Thanks
hanjun
