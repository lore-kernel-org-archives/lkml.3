Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab3LJREH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 12:04:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413Ab3LJRD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:03:59 -0500
Message-ID: <52A7495D.6010905@redhat.com>
Date: Tue, 10 Dec 2013 12:03:25 -0500
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Hanjun Guo <guohanjun@huawei.com>,
        dmaengine@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2] Enhance dmar to support device hotplug
References: <1385022116-228-1-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1385022116-228-1-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 03:21 AM, Yijing Wang wrote:
> This is the v2 patch, the v1 link: http://marc.info/?l=linux-pci&m=138364004628824&w=2
>
> v1->v2: keep (pci_dev *) pointer array in dmar_drhd_uni, only use pci device id
> 		to update pci_dev * pointer info during device hotplug in intel iommu
> 		driver notifier.
>
> Currently, DMAR driver save target pci devices pointers for drhd/rmrr/atsr
> in (pci_dev *) array, but never update these info after initialization.
> It's not safe, because pci devices maybe hot added or removed during
> system running. They will have new pci_dev * pointer. So if there have
> two IOMMUs or more in system, these devices will find a wrong drhd during
> DMA mapping. And DMAR faults will occur. This patch save pci device id
> as well as (pci_dev *) to fix this issue. Pci device id will be used to update
> pci_dev * poninter during device hotplug in intel iommu driver notifier.
> Other, here use list to manage target devices for IOMMU,
> we can easily use list helper.
>
> Yijing Wang (1):
>    IOMMU: enhance dmar to support device hotplug
>
>   drivers/iommu/dmar.c        |   82 +++++++++++-----------
>   drivers/iommu/intel-iommu.c |  161 +++++++++++++++++++++++++++++-------------
>   include/linux/dmar.h        |   24 ++++--
>   3 files changed, 167 insertions(+), 100 deletions(-)
>
>
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
>

Can this bug & fix be demonstrated by configuring & de-configuring VFs
on an SRIOV device, since that effectively looks like a hot-add & hot-remove ?


