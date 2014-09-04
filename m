Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaIDKKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:10:18 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39981 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaIDKKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:10:15 -0400
Message-ID: <54083A94.2040105@linaro.org>
Date: Thu, 04 Sep 2014 12:10:28 +0200
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>, linaro-acpi@lists.linaro.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Charles.Garcia-Tobin@arm.com, Robert Richter <rric@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Sudeep Holla <Sudeep.Holla@arm.com>
Subject: Re: [PATCH v3 13/17] ARM64 / ACPI: Add GICv2 specific ACPI boot support
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org> <1409583475-6978-14-git-send-email-hanjun.guo@linaro.org> <2893693.4bZJXXENof@wuerfel>
In-Reply-To: <2893693.4bZJXXENof@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.09.2014 20:42, Arnd Bergmann wrote:
> On Monday 01 September 2014 22:57:51 Hanjun Guo wrote:
>> +       /* Collect CPU base addresses */
>> +       count = acpi_parse_entries(sizeof(struct acpi_table_madt),
>> +                                  gic_acpi_parse_madt_cpu, table,
>> +                                  ACPI_MADT_TYPE_GENERIC_INTERRUPT,
>> +                                  ACPI_MAX_GIC_CPU_INTERFACE_ENTRIES);
>> +       if (count < 0) {
>> +               pr_err("Error during GICC entries parsing\n");
>> +               return -EFAULT;
>> +       } else if (!count) {
>> +               /* No GICC entries provided, use address from MADT header */
>> +               struct acpi_table_madt *madt = (struct acpi_table_madt *)table;
>> +
>> +               if (!madt->address)
>> +                       return -EFAULT;
>> +
>> +               cpu_phy_base = (u64)madt->address;
>> +       }
>
> After I read through ACPI-5.1 section 5.2.12.14, I wonder if this is the
> best way to treat a missing ACPI_MADT_TYPE_GENERIC_INTERRUPT table.
>
> Do we expect to see those in practice? It seems like using the x86 local
> APIC address as a fallback for the GIC address is not something we
> should do unless we absolutely have to support a system that doesn't
> have the GIC table.

No, we do not expect and hopefully there will be no such :)

But, we are trying to be as much as possible inline with 5.1 spec, 
5.2.12.14 says:
[...]
If provided here (CPU physical base address), the "Local Interrupt 
Controller Address" field in the MADT must be ignored by the OSPM.
[...]

Regards,
Tomasz



