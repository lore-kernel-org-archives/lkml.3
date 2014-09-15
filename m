Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaIOCZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 22:25:28 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:49841 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbaIOCZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 22:25:26 -0400
Message-ID: <54164E00.6080109@huawei.com>
Date: Mon, 15 Sep 2014 10:25:04 +0800
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
Subject: Re: [Patch Part3 V5 6/8] iommu/vt-d: Enhance error recovery in function
 intel_enable_irq_remapping()
References: <1410487848-6027-1-git-send-email-jiang.liu@linux.intel.com> <1410487848-6027-7-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1410487848-6027-7-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.54164E11.0007,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: d4b10eb9892d22979cf38265b79db7f9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/12 10:10, Jiang Liu wrote:
> Enhance error recovery in function intel_enable_irq_remapping()
> by tearing down all created data structures.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/iommu/intel_irq_remapping.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
> index 7cf31a29f77a..81f110aae6df 100644
> --- a/drivers/iommu/intel_irq_remapping.c
> +++ b/drivers/iommu/intel_irq_remapping.c
> @@ -701,9 +701,11 @@ static int __init intel_enable_irq_remapping(void)
>  	return eim ? IRQ_REMAP_X2APIC_MODE : IRQ_REMAP_XAPIC_MODE;
>  
>  error:
> -	/*
> -	 * handle error condition gracefully here!
> -	 */
> +	for_each_iommu(iommu, drhd)
> +		if (ecap_ir_support(iommu->ecap)) {
> +			iommu_disable_irq_remapping(iommu);
> +			intel_teardown_irq_remapping(iommu);
> +		}
>  
>  	if (x2apic_present)
>  		pr_warn("Failed to enable irq remapping.  You are vulnerable to irq-injection attacks.\n");

Reviewed-by: Yijing Wang <wangyijing@huawei.com>


> 


-- 
Thanks!
Yijing

