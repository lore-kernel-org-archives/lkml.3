Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab3LBBnJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 20:43:09 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:22165 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab3LBBnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 20:43:07 -0500
Message-ID: <529BE547.9030508@huawei.com>
Date: Mon, 2 Dec 2013 09:41:27 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        "Dan Williams" <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Ashok Raj <ashok.raj@intel.com>
CC: <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>
Subject: Re: [Patch Part1 V2 04/17] iommu/vt-d: fix resource leakage on error
 recovery path in iommu_init_domains()
References: <1385715030-20553-1-git-send-email-jiang.liu@linux.intel.com> <1385715030-20553-5-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1385715030-20553-5-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/11/29 16:50, Jiang Liu wrote:
> Release allocated resources on error recovery path in function
> iommu_init_domains().
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/iommu/intel-iommu.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index b8e3b48..2398876 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -1273,6 +1273,8 @@ static int iommu_init_domains(struct intel_iommu *iommu)
>  			GFP_KERNEL);
>  	if (!iommu->domains) {
>  		printk(KERN_ERR "Allocating domain array failed\n");
> +		kfree(iommu->domain_ids);
> +		iommu->domain_ids = NULL;
>  		return -ENOMEM;
>  	}
>  
> 

Acked-by: Yijing Wang <wangyijing@huawei.com>

-- 
Thanks!
Yijing

