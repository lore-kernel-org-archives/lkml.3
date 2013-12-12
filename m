Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab3LLLsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 06:48:01 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:47550 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab3LLLr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 06:47:56 -0500
Message-ID: <52A9A200.6050007@huawei.com>
Date: Thu, 12 Dec 2013 19:46:08 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Don Dutile <ddutile@redhat.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Vinod Koul <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>,
        "Hanjun Guo" <guohanjun@huawei.com>, <dmaengine@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2] Enhance dmar to support device hotplug
References: <1385022116-228-1-git-send-email-wangyijing@huawei.com> <52A7495D.6010905@redhat.com>
In-Reply-To: <52A7495D.6010905@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/11 1:03, Don Dutile wrote:
> On 11/21/2013 03:21 AM, Yijing Wang wrote:
>> This is the v2 patch, the v1 link: http://marc.info/?l=linux-pci&m=138364004628824&w=2
>>
>> v1->v2: keep (pci_dev *) pointer array in dmar_drhd_uni, only use pci device id
>>         to update pci_dev * pointer info during device hotplug in intel iommu
>>         driver notifier.
>>
>> Currently, DMAR driver save target pci devices pointers for drhd/rmrr/atsr
>> in (pci_dev *) array, but never update these info after initialization.
>> It's not safe, because pci devices maybe hot added or removed during
>> system running. They will have new pci_dev * pointer. So if there have
>> two IOMMUs or more in system, these devices will find a wrong drhd during
>> DMA mapping. And DMAR faults will occur. This patch save pci device id
>> as well as (pci_dev *) to fix this issue. Pci device id will be used to update
>> pci_dev * poninter during device hotplug in intel iommu driver notifier.
>> Other, here use list to manage target devices for IOMMU,
>> we can easily use list helper.
>>
>> Yijing Wang (1):
>>    IOMMU: enhance dmar to support device hotplug
>>
>>   drivers/iommu/dmar.c        |   82 +++++++++++-----------
>>   drivers/iommu/intel-iommu.c |  161 +++++++++++++++++++++++++++++-------------
>>   include/linux/dmar.h        |   24 ++++--
>>   3 files changed, 167 insertions(+), 100 deletions(-)
>>
>>
>> _______________________________________________
>> iommu mailing list
>> iommu@lists.linux-foundation.org
>> https://lists.linuxfoundation.org/mailman/listinfo/iommu
>>
> 
> Can this bug & fix be demonstrated by configuring & de-configuring VFs
> on an SRIOV device, since that effectively looks like a hot-add & hot-remove ?

Hi Don,
   It seems can not be demonstrated by configuring & de-configuring VFs, because
if we only hotplug VFs, the device scope info saved in drhd->devices array will not
become stale. In my platform, the target device scope devices are root port, so only
we remove and rescan root port, we can trigger this problem.

Thanks!
Yijing.

> 
> 
> 
> .
> 


-- 
Thanks!
Yijing

