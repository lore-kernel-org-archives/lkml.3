Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab3LDPBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:01:03 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:48560 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448Ab3LDPBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:01:00 -0500
Message-ID: <529F439E.6070101@linaro.org>
Date: Wed, 04 Dec 2013 23:00:46 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Jon Masters <jonathan@jonmasters.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>
Subject: Re: [RFC part1 PATCH 2/7] ARM64 : Add dummy asm/cpu.h
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org> <1386088611-2801-3-git-send-email-hanjun.guo@linaro.org> <20131203171345.GC16025@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131203171345.GC16025@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年12月04日 01:13, Mark Rutland wrote:
> On Tue, Dec 03, 2013 at 04:36:46PM +0000, Hanjun Guo wrote:
>> ACPI requires a cpu.h, add a dummy one copied from arm. This will need
>> updated or replaced as ACPI based cpu hotplug for armv8 is worked out.
> What exactly requires cpu.h, and why?

CPI core will include this file and can not be compiled without it.

ACPI based CPU hotplug needs some functions below:
#ifdef CONFIG_HOTPLUG_CPU
extern int arch_register_cpu(int num);
extern void arch_unregister_cpu(int);
#endif

>
> Why copy the file verbatim rather than factoring it out?

ACPI based cpu hotplug is not implemented in this patch
set and will send out as drivers, so will factoring it
out at that time.
  

>> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>   arch/arm64/include/asm/cpu.h |   25 +++++++++++++++++++++++++
>>   1 file changed, 25 insertions(+)
>>   create mode 100644 arch/arm64/include/asm/cpu.h
>>
>> diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
>> new file mode 100644
>> index 0000000..dbeb98d
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
>> +	u32		cpuid;
> We use a u64 elsewhere for the mpidr_el1 in arm64.

Good catch, will fix it

Thanks
Hanjun

