Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbaBUHnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 02:43:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:49652 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaBUHnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 02:43:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,517,1389772800"; 
   d="scan'208";a="485340902"
Message-ID: <53070393.5020005@linux.intel.com>
Date: Fri, 21 Feb 2014 15:43:15 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Donald Dutile <ddutile@redhat.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        stable@vger.kernel.org
Subject: Re: [PATCH v5 10/33] iommu, irq: Allocate irq_desc for dmar_msi with
 local node
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org> <1388707565-16535-11-git-send-email-yinghai@kernel.org>
In-Reply-To: <1388707565-16535-11-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/1/3 8:05, Yinghai Lu wrote:
> iommu irq's irq_desc should be on local node ram.
> 
> Fix the return value checking problem.
>   create_irq() will return -1 when fail to allocate.
>   create_irq_nr() will return 0 when fail to allocate.
> here only check !irq, so need to change it to use create_irq_nr instead.
> 
> -v2: According to Sebastian, add cc to stable.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Donald Dutile <ddutile@redhat.com>
> Acked-by: Donald Dutile <ddutile@redhat.com>
> Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> Cc: stable@vger.kernel.org
> ---
>  drivers/iommu/dmar.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
> index 8b452c9..f4eaa50 100644
> --- a/drivers/iommu/dmar.c
> +++ b/drivers/iommu/dmar.c
> @@ -1277,7 +1277,7 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
>  	if (iommu->irq)
>  		return 0;
>  
> -	irq = create_irq();
> +	irq = create_irq_nr(0, iommu->node);
Hi Yinghai,
	How about create_irq_nrq(1, iommu->node) here to clearly state
that 0 is not a valid irq number for dmar here?
Thanks!
Gerry

>  	if (!irq) {
>  		pr_err("IOMMU: no free vectors\n");
>  		return -EINVAL;
> 
