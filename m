Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaHSJpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 05:45:22 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38866 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaHSJpU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 05:45:20 -0400
Message-ID: <53F31D14.70006@arm.com>
Date: Tue, 19 Aug 2014 10:47:00 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
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
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Al Stone <al.stone@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v2 02/18] ARM64 / ACPI: Get RSDP and ACPI boot-time tables
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org> <1407166105-17675-3-git-send-email-hanjun.guo@linaro.org> <53F24632.7030903@arm.com> <53F31A6D.5090104@linaro.org>
In-Reply-To: <53F31A6D.5090104@linaro.org>
X-OriginalArrivalTime: 19 Aug 2014 09:45:15.0094 (UTC) FILETIME=[472F5F60:01CFBB92]
X-MC-Unique: 114081910451616901
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 19/08/14 10:35, Hanjun Guo wrote:
> On 2014-8-19 2:30, Sudeep Holla wrote:
>> On 04/08/14 16:28, Hanjun Guo wrote:
>>> From: Al Stone <al.stone@linaro.org>
>>>
>>> As we want to get ACPI tables to parse and then use the information
>>> for system initialization, we should get the RSDP (Root System
>>> Description Pointer) first, it then locates Extended Root Description
>>> Table (XSDT) which contains all the 64-bit physical address that
>>> pointer to other boot-time tables.
>>>
>>> Introduce acpi.c and its related head file in this patch to provide
>>> fundamental needs of extern variables and functions for ACPI core,
>>> and then get boot-time tables as needed.
>>>     - asm/cpu.h need for ACPI core and will be updated in the future to
>>>       add definitions for arch_(un)register_cpu which are required for
>>>       ACPI based physical CPU hotplug;
>>

[...]

>>> +/*
>>> + * acpi_boot_table_init() called from setup_arch(), always.
>>> + *    1. find RSDP and get its address, and then find XSDT
>>> + *    2. extract all tables and checksums them all
>>> + *
>>> + * We can parse ACPI boot-time tables such as FADT, MADT after
>>> + * this function is called.
>>> + */
>>> +void __init acpi_boot_table_init(void)
>>> +{
>>> +    /* If acpi_disabled, bail out */
>>> +    if (acpi_disabled)
>>> +        return;
>>> +
>>> +    /* Initialize the ACPI boot-time table parser. */
>>> +    if (acpi_table_init()) {
>>
>> Can't we call acpi_table_init directly in setup ?
>> IIUC x86 has acpi_boot_table_init as it parses Boot Flags
>> table(ACPI_SIG_BOOT)
>
> Yes, we can. But I think it not a big deal to dot that, if that
> makes the code more readable, I will update it.
>

I agree, but I actually wanted to check if we ever have to use/parse
Simple Boot Flag Table on ARM64 which is reserved but not part of ACPI
spec. I assume x86 use either for Legacy reason or firmware expects it.

Regards,
Sudeep

