Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbaGaIQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 04:16:47 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37307 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952AbaGaIQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 04:16:44 -0400
Message-ID: <53D9FB1E.5080007@linaro.org>
Date: Thu, 31 Jul 2014 16:15:26 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sudeep Holla <sudeep.holla@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>
CC: "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH 08/19] ACPI / table: Print GIC information when MADT is
 parsed
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org> <1406206825-15590-9-git-send-email-hanjun.guo@linaro.org> <53D937B5.5040404@arm.com>
In-Reply-To: <53D937B5.5040404@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-7-31 2:21, Sudeep Holla wrote:
> On 24/07/14 14:00, Hanjun Guo wrote:
>> When MADT is parsed, print GIC information to make the boot
>> log look pretty.
>>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>> ---
>>   drivers/acpi/tables.c |   39 ++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 38 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
>> index 6d5a6cd..8bb8159 100644
>> --- a/drivers/acpi/tables.c
>> +++ b/drivers/acpi/tables.c
>> @@ -183,6 +183,44 @@ void acpi_table_print_madt_entry(struct
>> acpi_subtable_header *header)
>>           }
>>           break;
>>
>> +    case ACPI_MADT_TYPE_GENERIC_INTERRUPT:
>> +        {
>> +            struct acpi_madt_generic_interrupt *p =
>> +                (struct acpi_madt_generic_interrupt *)header;
>> +            pr_info("GICC (acpi_id[0x%04x] cpu_address[0x%08llx]
>> MPDIR[0x%llx] %s)\n",
> 
> What exactly does cpu_address mean ? Better s/cpu_address/address

Agreed.

> 
>> +                p->uid, p->base_address, p->mpidr,
>> +                (p->flags & ACPI_MADT_ENABLED) ? "enabled" : "disabled");
>> +
>> +        }
>> +        break;
>> +
>> +    case ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR:
>> +        {
>> +            struct acpi_madt_generic_distributor *p =
>> +                (struct acpi_madt_generic_distributor *)header;
>> +            pr_info("GIC Distributor (id[0x%04x] address[0x%08llx]
>> gsi_base[%d])\n",
>> +                p->gic_id, p->base_address, p->global_irq_base);
>> +        }
>> +        break;
>> +
>> +    case ACPI_MADT_TYPE_GIC_MSI_FRAME:
>> +        {
>> +            struct acpi_madt_gic_msi_frame *p =
>> +                (struct acpi_madt_gic_msi_frame *)header;
>> +            pr_info("GIC MSI Frame (address[0x%08llx] msi_fame_id[%d])\n",
>> +                p->base_address, p->gic_msi_frame_id);
>> +        }
>> +        break;
>> +
>> +    case ACPI_MADT_TYPE_GIC_REDISTRIBUTOR:
>> +        {
>> +            struct acpi_madt_gic_redistributor *p =
>> +                (struct acpi_madt_gic_redistributor *)header;
>> +            pr_info("GIC Redistributor (address[0x%08llx] region_size[0x%x])\n",
>> +                p->base_address, p->region_size);
>> +        }
>> +        break;
>> +
> 
> You may need to rework on the variable names when you rebase on ACPICA 20140724

Yes, I'm working on it :)

Thanks
Hanjun

