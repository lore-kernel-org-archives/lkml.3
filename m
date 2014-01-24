Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbaAXOlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 09:41:46 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:50922 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaAXOlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 09:41:44 -0500
Message-ID: <52E27BA1.4080909@linaro.org>
Date: Fri, 24 Jan 2014 22:41:37 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>
Subject: Re: [PATCH 02/20] ARM64 : Add dummy asm/cpu.h
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <1389961514-13562-3-git-send-email-hanjun.guo@linaro.org> <20140123161505.GB23939@localhost>
In-Reply-To: <20140123161505.GB23939@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年01月24日 00:15, Catalin Marinas wrote:
> On Fri, Jan 17, 2014 at 12:24:56PM +0000, Hanjun Guo wrote:
>> ACPI requires a cpu.h, add a dummy one copied from arm. This will need
>> updated or replaced as ACPI based cpu hotplug or cpu topology for armv8
>> is worked out.
>>
>> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>   arch/arm64/include/asm/cpu.h |   25 +++++++++++++++++++++++++
>>   1 file changed, 25 insertions(+)
>>   create mode 100644 arch/arm64/include/asm/cpu.h
>>
>> diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
>> new file mode 100644
>> index 0000000..8625eb1
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/cpu.h
>> @@ -0,0 +1,25 @@
>> +/*
>> + *  Copyright (C) 2004-2005 ARM Ltd.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +#ifndef __ASM_ARM_CPU_H
>> +#define __ASM_ARM_CPU_H
>> +
>> +#include <linux/percpu.h>
>> +#include <linux/cpu.h>
>> +#include <linux/topology.h>
>> +
>> +struct cpuinfo_arm {
>> +	struct cpu	cpu;
>> +	u64		cpuid;
>> +#ifdef CONFIG_SMP
>> +	unsigned int	loops_per_jiffy;
>> +#endif
>> +};
>> +
>> +DECLARE_PER_CPU(struct cpuinfo_arm, cpu_data);
>> +
>> +#endif
> Could you not leave this file empty until you add the code that actually
> makes use of cpu_data?

Of course, I will update in next version :)

Thanks
Hanjun

