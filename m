Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaIOCVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 22:21:44 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:46217 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbaIOCV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 22:21:28 -0400
Message-ID: <54164D01.4060003@huawei.com>
Date: Mon, 15 Sep 2014 10:20:49 +0800
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
Subject: Re: [Patch Part3 V5 5/8] iommu/vt-d: Enhance intel_irq_remapping
 driver to support DMAR unit hotplug
References: <1410487848-6027-1-git-send-email-jiang.liu@linux.intel.com> <1410487848-6027-6-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1410487848-6027-6-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020208.54164D18.00CB,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 88c1d861924a06b1ab7effd75a94e195
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static void ir_remove_ioapic_hpet_scope(struct intel_iommu *iommu)
> +{
> +	int i;
>  
> -			ir_parse_one_hpet_scope(scope, iommu);
> -		}
> -		start += scope->length;
> -	}
> +	for (i = 0; i < MAX_HPET_TBS; i++)
> +		if (ir_hpet[i].iommu == iommu)
> +			ir_hpet[i].iommu = NULL;

Hi Gerry, why not reset whole ir_hpe and ir_ioapic data struct?



>  
> -	return 0;
> +	for (i = 0; i < MAX_IO_APICS; i++)
> +		if (ir_ioapic[i].iommu == iommu)
> +			ir_ioapic[i].iommu = NULL;
>  }
>  

