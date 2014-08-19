Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaHSLap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:30:45 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:61546 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaHSLan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:30:43 -0400
Message-ID: <53F33501.2060009@linaro.org>
Date: Tue, 19 Aug 2014 19:29:05 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sudeep Holla <sudeep.holla@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>
CC: "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v2 09/18] ACPI / processor: Make it possible to get CPU
 hardware ID via GICC
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org> <1407166105-17675-10-git-send-email-hanjun.guo@linaro.org> <53F2472F.5060400@arm.com>
In-Reply-To: <53F2472F.5060400@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-8-19 2:34, Sudeep Holla wrote:
[...]
>>
>> +#include <asm/smp_plat.h>
>> +
>>   /* Basic configuration for ACPI */
>>   #ifdef    CONFIG_ACPI
>>   /*
>> @@ -59,6 +61,18 @@ static inline void disable_acpi(void)
>>       acpi_noirq = 1;
>>   }
>>
>> +u32 pack_mpidr_into_32_bits(u64 mpidr);
>> +
>> +/*
>> + * The ACPI processor driver for ACPI core code needs this macro
>> + * to find out this cpu was already mapped (mapping from CPU hardware
>> + * ID to CPU logical ID) or not.
>> + *
>> + * cpu_logical_map(cpu) is the mapping of MPIDR and the logical cpu,
>> + * and MPIDR is the cpu hardware ID we needed.
> 
> You need to specify this is packed version of cpu_logical_map or
> better is to move pack_mpidr_into_32_bits here along with the
> description you have so that it's easy to understand.

Agreed, I will make pack_mpidr_into_32_bits() as inline function here and
specify that it is the packed version we needed.

Thanks
Hanjun

