Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbbAGJt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:49:59 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:42957 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbbAGJtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:49:53 -0500
Message-ID: <54AD0125.9060601@linaro.org>
Date: Wed, 07 Jan 2015 17:49:25 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Catalin Marinas <catalin.marinas@arm.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Jon Masters <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        phoenix.liyi@huawei.com, Timur Tabi <timur@codeaurora.org>,
        suravee.suthikulpanit@amd.com, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org, Hanjun Guo <hanjun.guo@linaro.com>
Subject: Re: [PATCH v6 01/17] ACPI / processor: Convert apic_id to phys_id
 to make it arch agnostic
References: <1420368918-5086-1-git-send-email-hanjun.guo@linaro.org> <1420368918-5086-2-git-send-email-hanjun.guo@linaro.org> <1463717.XWsK98imMv@vostro.rjw.lan>
In-Reply-To: <1463717.XWsK98imMv@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015年01月07日 09:50, Rafael J. Wysocki wrote:
> On Sunday, January 04, 2015 06:55:02 PM Hanjun Guo wrote:
>> From: Hanjun Guo <hanjun.guo@linaro.com>
>>
>> apic_id in MADT table is the CPU hardware id which identify
>> it self in the system for x86 and ia64, OSPM will use it for
>> SMP init to map APIC ID to logical cpu number in the early
>> boot, when the DSDT/SSDT (ACPI namespace) is scanned later, the
>> ACPI processor driver is probed and the driver will use acpi_id
>> in DSDT to get the apic_id, then map to the logical cpu number
>> which is needed by the processor driver.
>>
>> Before ACPI 5.0, only x86 and ia64 were supported in ACPI spec,
>> so apic_id is used both in arch code and ACPI core which is
>> pretty fine. Since ACPI 5.0, ARM is supported by ACPI and
>> APIC is not available on ARM, this will confuse people when
>> apic_id is both used by x86 and ARM in one function.
>>
>> So convert apic_id to phys_id (which is the original meaning)
>> in ACPI processor dirver to make it arch agnostic, but leave the
>> arch dependent code unchanged, no functional change.
>>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>
> I've queued up this one and [2/17] for 3.19-rc4 as I promised I'd push these
> two for 3.19.

Great, thanks a lot. I thought you will queued them for 3.20 :)

Regards
Hanjun
