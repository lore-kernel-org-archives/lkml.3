Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbaAJCQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 21:16:35 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:59481 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaAJCQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 21:16:31 -0500
MIME-Version: 1.0
In-Reply-To: <20140109120135.GJ29041@8bytes.org>
References: <52CE0252.4090106@oracle.com>
	<20140109120135.GJ29041@8bytes.org>
Date: Fri, 10 Jan 2014 10:16:30 +0800
Message-ID: <CABawtvO5jOOanD_5Bzt6ebNOJaMUTvKNs8V9wah5QW_mBC1EFA@mail.gmail.com>
Subject: Re: [PATCH Trivial] intel-iommu: check return value of
 device_to_iommu() before using it
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: ethan zhao <ethan.zhao@oracle.com>, dwmw2@infradead.org,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        jiang.liu@linux.intel.com, iommu@lists.linux-foundation.org,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 9, 2014 at 8:01 PM, Joerg Roedel <joro@8bytes.org> wrote:
> On Thu, Jan 09, 2014 at 09:58:42AM +0800, ethan zhao wrote:
>>  drivers/iommu/intel-iommu.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
>> index 40203ad..5b4531a 100644
>> --- a/drivers/iommu/intel-iommu.c
>> +++ b/drivers/iommu/intel-iommu.c
>> @@ -1105,6 +1105,8 @@ static struct device_domain_info
>> *iommu_support_dev_iotlb(
>>      struct device_domain_info *info;
>>      struct intel_iommu *iommu = device_to_iommu(segment, bus, devfn);
>>
>> +    if (!iommu)
>> +        return NULL;
>>      if (!ecap_dev_iotlb_support(iommu->ecap))
>>          return NULL;
>
> This call can not fail, iommu_support_dev_iotlb() is only called from
> domain_context_mapping_one() which does the iommu==NULL check on its
> own before the call.
>
Agree, till now, was checked in domain_context_mapping_one(), but how
about if we query information with iommu_support_dev_iotlb() in other
code ?

Thanks,
Ethan
>
>         Joerg
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
