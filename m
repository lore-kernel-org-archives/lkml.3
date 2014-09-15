Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaIOHyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 03:54:37 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:55585 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaIOHyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 03:54:35 -0400
Message-ID: <54169B1B.1070709@huawei.com>
Date: Mon, 15 Sep 2014 15:54:03 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Vinod Koul" <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
CC: Ashok Raj <ashok.raj@intel.com>, Tony Luck <tony.luck@intel.com>,
        <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>,
        <linux-hotplug@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>
Subject: Re: [Patch Part3 V5 0/8] Enable support of Intel DMAR device hotplug
References: <1410487848-6027-1-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1410487848-6027-1-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A02020A.54169B33.0047,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 4ef003fae526be35c711deef1e156b1c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I built and boot this series in Huawei RH5885 (Intel(R) Xeon(R) CPU E7- 4807, two IOHs and two IOMMUs),
It works fine, IRQ remap and DMA remap are both look good.
But because my platform BIOS has no _DSM, so I didn't test the hotplug case yet.

Thanks!
Yijing.


On 2014/9/12 10:10, Jiang Liu wrote:
> When hot plugging a descrete IOH or a physical processor with embedded
> IIO, we need to handle DMAR(or IOMMU) unit in the PCIe host bridge if
> DMAR is in use. This patch set tries to enhance current DMAR/IOMMU/IR
> drivers to support hotplug and is based on latest Linus master branch.
> 
> All prerequisite patches to support DMAR device hotplug have been merged
> into the mainstream kernel, and this is the last patch set to enable
> DMAR device hotplug.
> 
> You may access the patch set at:
> https://github.com/jiangliu/linux.git iommu/hotplug_v5
> 
> This patch set has been tested on Intel development machine.
> Appreciate any comments and tests.
> 
> Patch 1-4 enhances DMAR framework to support hotplug
> Patch 5 enhances Intel interrupt remapping driver to support hotplug
> Patch 6 enhances error handling in Intel IR driver
> Patch 7 enhance Intel IOMMU to support hotplug
> Patch 8 enhance ACPI pci_root driver to handle DMAR units
> 
> Jiang Liu (8):
>   iommu/vt-d: Introduce helper function dmar_walk_resources()
>   iommu/vt-d: Dynamically allocate and free seq_id for DMAR units
>   iommu/vt-d: Implement DMAR unit hotplug framework
>   iommu/vt-d: Search for ACPI _DSM method for DMAR hotplug
>   iommu/vt-d: Enhance intel_irq_remapping driver to support DMAR unit
>     hotplug
>   iommu/vt-d: Enhance error recovery in function
>     intel_enable_irq_remapping()
>   iommu/vt-d: Enhance intel-iommu driver to support DMAR unit hotplug
>   pci, ACPI, iommu: Enhance pci_root to support DMAR device hotplug
> 
>  drivers/acpi/pci_root.c             |   16 +-
>  drivers/iommu/dmar.c                |  532 ++++++++++++++++++++++++++++-------
>  drivers/iommu/intel-iommu.c         |  297 ++++++++++++++-----
>  drivers/iommu/intel_irq_remapping.c |  233 +++++++++++----
>  include/linux/dmar.h                |   50 +++-
>  5 files changed, 888 insertions(+), 240 deletions(-)
> 


-- 
Thanks!
Yijing

