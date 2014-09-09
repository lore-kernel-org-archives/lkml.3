Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbaIIQPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:15:19 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33593 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbaIIQPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:15:16 -0400
Message-ID: <540F2765.7000705@linaro.org>
Date: Wed, 10 Sep 2014 00:14:29 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jon Masters <jcm@redhat.com>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>, linaro-acpi@lists.linaro.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Charles.Garcia-Tobin@arm.com, Robert Richter <rric@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Sudeep Holla <Sudeep.Holla@arm.com>
Subject: Re: [PATCH v3 09/17] ARM64 / ACPI: Parse MADT for SMP initialization
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org> <1409583475-6978-10-git-send-email-hanjun.guo@linaro.org> <540E80BD.20801@redhat.com> <540E88A2.1000606@linaro.org> <540E93A0.4040306@redhat.com> <540F2422.90105@linaro.org> <540F24FF.2060302@redhat.com>
In-Reply-To: <540F24FF.2060302@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年09月10日 00:04, Jon Masters wrote:
> On 09/09/2014 12:00 PM, Hanjun Guo wrote:
>> On 2014年09月09日 13:44, Jon Masters wrote:
>>> On 09/09/2014 12:57 AM, Hanjun Guo wrote:
>>>> Hi Jon,
>>>>
>>>> On 2014年09月09日 12:23, Jon Masters wrote:
>>>>> On 09/01/2014 10:57 AM, Hanjun Guo wrote:
>>>>>> MADT contains the information for MPIDR which is essential for
>>>>>> SMP initialization, parse the GIC cpu interface structures to
>>>>>> get the MPIDR value and map it to cpu_logical_map(), and add
>>>>>> enabled cpu with valid MPIDR into cpu_possible_map.
>>>>>>
>>>>>> ACPI 5.1 only has two explicit methods to boot up SMP, PSCI and
>>>>>> Parking protocol, but the Parking protocol is only specified for
>>>>>> ARMv7 now, so make PSCI as the only way for the SMP boot protocol
>>>>>> before some updates for the ACPI spec or the Parking protocol spec.
>>>>>> +	/* CPU 0 was already initialized */
>>>>>> +	if (cpu) {
>>>>>> +		if (cpu_ops[cpu]->cpu_init(NULL, cpu))
>>>>>> +			return -EOPNOTSUPP;
>>>>>> +
>>>>>> +		/* map the logical cpu id to cpu MPIDR */
>>>>>> +		cpu_logical_map(cpu) = mpidr;
>>>>> I'm not sure it's worth noting in a comment or just in the dialogue that
>>>>> none of these MPIDR values is literally the value in the MPIDR. Linux
>>>>> doesn't store that anyway (even in the cpu_logical_map), since it is
>>>>> pre-filtered against MPIDR_HWID_BITMASK to remove the non-affinity level
>>>>> bits. And since the ACPI5.1 specification requires that non-affinity
>>>>> bits be zero everything works. But it relies upon this assumption so it
>>>>> might be worth explicitly masking out the bits when making the call into:
>>>>>
>>>>>        acpi_map_gic_cpu_interface(processor->arm_mpidr,
>>>>>                processor->flags & ACPI_MADT_ENABLED);
>>>>>
>>>>> During the parsing of the processor object's MPIDR value.
>>>> Yes, I agree with you. When I tested this patch set on our
>>>> ARM64 platform, I found this problem too. some firmware
>>>> will just present the real MPIDR value to OS which some reserved
>>>> bit set to 1, and it will lead to some logic problem in this patch.
>>>> (actually firmware didn't obey with ACPI spec)
>>>>
>>>> I had updated the patch with:
>>>>
>>>> +	acpi_map_gic_cpu_interface(processor->arm_mpidr & MPIDR_HWID_BITMASK,
>>>> +		processor->flags & ACPI_MADT_ENABLED);
>>>>
>>>> and then the problem was gone :)
>>> Did I miss an updated patch posting then? It is possible...
>> No, you didn't miss it, I'm still working on the new version, sorry I didn't
>> clarify that in my previous email.
> Thanks. If you could copy me on the next posting that would rock. 

Sure I will.

> In a
> few hours we should have another platform posted as an example. In
> addition, a couple of lower priority patches (building upon the core
> ACPI pieces) should be posted as well.

That will be great! :)

Thanks
Hanjun

