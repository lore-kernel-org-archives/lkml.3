Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbaBUXSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:18:39 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:40716 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbaBUXSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:18:36 -0500
MIME-Version: 1.0
In-Reply-To: <53070393.5020005@linux.intel.com>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
	<1388707565-16535-11-git-send-email-yinghai@kernel.org>
	<53070393.5020005@linux.intel.com>
Date: Fri, 21 Feb 2014 15:18:36 -0800
X-Google-Sender-Auth: -RNzCSsT-O6PcbO5bebEyiCOM4I
Message-ID: <CAE9FiQV8B271XCJQV=80S6pZDOVxG9LG0gaj9G98dCRetjkMUg@mail.gmail.com>
Subject: Re: [PATCH v5 10/33] iommu, irq: Allocate irq_desc for dmar_msi with
 local node
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Donald Dutile <ddutile@redhat.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 11:43 PM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
>
>
> On 2014/1/3 8:05, Yinghai Lu wrote:
>> iommu irq's irq_desc should be on local node ram.
>>
>> Fix the return value checking problem.
>>   create_irq() will return -1 when fail to allocate.
>>   create_irq_nr() will return 0 when fail to allocate.
>> here only check !irq, so need to change it to use create_irq_nr instead.
>>
>> -v2: According to Sebastian, add cc to stable.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: Joerg Roedel <joro@8bytes.org>
>> Cc: Donald Dutile <ddutile@redhat.com>
>> Acked-by: Donald Dutile <ddutile@redhat.com>
>> Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
>> Cc: stable@vger.kernel.org
>> ---
>>  drivers/iommu/dmar.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
>> index 8b452c9..f4eaa50 100644
>> --- a/drivers/iommu/dmar.c
>> +++ b/drivers/iommu/dmar.c
>> @@ -1277,7 +1277,7 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
>>       if (iommu->irq)
>>               return 0;
>>
>> -     irq = create_irq();
>> +     irq = create_irq_nr(0, iommu->node);
> Hi Yinghai,
>         How about create_irq_nrq(1, iommu->node) here to clearly state
> that 0 is not a valid irq number for dmar here?

Should be the same. that 0 or 1 will be from in __create_irqs().

And we have
        if (from < nr_irqs_gsi)
                from = nr_irqs_gsi;
in __create_irqs().

Thanks

Yinghai
