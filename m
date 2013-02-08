Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947098Ab3BHU6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 15:58:05 -0500
Received: from mail-ia0-f182.google.com ([209.85.210.182]:40158 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947017Ab3BHU6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 15:58:03 -0500
MIME-Version: 1.0
In-Reply-To: <511563F6.1080009@redhat.com>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
	<1360351703-20571-9-git-send-email-yinghai@kernel.org>
	<511563F6.1080009@redhat.com>
Date: Fri, 8 Feb 2013 12:58:02 -0800
X-Google-Sender-Auth: Dzok72jCiNhO8c4J5aAcc0gBi9U
Message-ID: <CAE9FiQV5VnQNprc6DjGS0+qG-dpzDYDG-q68J9VmrigEdr9XFw@mail.gmail.com>
Subject: Re: [PATCH v2 08/26] iommu, irq: Allocate irq_desc for dmar_msi with
 local node
From: Yinghai Lu <yinghai@kernel.org>
To: Don Dutile <ddutile@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 8, 2013 at 12:45 PM, Don Dutile <ddutile@redhat.com> wrote:
> On 02/08/2013 02:28 PM, Yinghai Lu wrote:
>>
>> iommu irq's irq_desc should be on local node ram.
>>
>> Fix the return value checking problem.
>>
>> create_irq() will return -1 when fail to allocate.
>> create_irq_nr() will return 0 when fail to allocate.
>>
>> here only check !irq, so need to change it to use create_irq_nr instead.
>>
>> Signed-off-by: Yinghai Lu<yinghai@kernel.org>
>> Cc: Joerg Roedel<joro@8bytes.org>
>> Cc: Donald Dutile<ddutile@redhat.com>
>> ---
>>   drivers/iommu/dmar.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
>> index 174bb65..316b5a2 100644
>> --- a/drivers/iommu/dmar.c
>> +++ b/drivers/iommu/dmar.c
>> @@ -1263,7 +1263,7 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
>>         if (iommu->irq)
>>                 return 0;
>>
>> -       irq = create_irq();
>> +       irq = create_irq_nr(0, iommu->node);
>>         if (!irq) {
>>                 pr_err("IOMMU: no free vectors\n");
>>                 return -EINVAL;
>
> Good catch!
>
> you can add my ack to it.
>

Thanks.
