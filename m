Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3LBBoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 20:44:17 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:59701 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab3LBBoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 20:44:15 -0500
Message-ID: <529BE59C.8070003@huawei.com>
Date: Mon, 2 Dec 2013 09:42:52 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        "Dan Williams" <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Ashok Raj <ashok.raj@intel.com>
CC: <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>
Subject: Re: [Patch Part1 V2 07/17] iommu/vt-d. trivial: check suitable flag
 in function detect_intel_iommu()
References: <1385715030-20553-1-git-send-email-jiang.liu@linux.intel.com> <1385715030-20553-9-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1385715030-20553-9-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is the same as the last.:)

On 2013/11/29 16:50, Jiang Liu wrote:
> Flag irq_remapping_enabled is only set by intel_enable_irq_remapping(),
> which is called after detect_intel_iommu(). So we should check flag
> disable_irq_remap instead of irq_remapping_enabled in function
> detect_intel_iommu().
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/iommu/dmar.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
> index f3043a2..77a066b 100644
> --- a/drivers/iommu/dmar.c
> +++ b/drivers/iommu/dmar.c
> @@ -561,7 +561,7 @@ int __init detect_intel_iommu(void)
>  
>  		dmar = (struct acpi_table_dmar *) dmar_tbl;
>  
> -		if (ret && irq_remapping_enabled && cpu_has_x2apic &&
> +		if (ret && !disable_irq_remap && cpu_has_x2apic &&
>  		    dmar->flags & 0x1)
>  			pr_info("Queued invalidation will be enabled to support x2apic and Intr-remapping.\n");
>  
> 


-- 
Thanks!
Yijing

