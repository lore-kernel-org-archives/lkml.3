Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaAIMBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:01:46 -0500
Received: from 8bytes.org ([85.214.48.195]:39730 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaAIMBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:01:38 -0500
Date: Thu, 9 Jan 2014 13:01:35 +0100
From: Joerg Roedel <joro@8bytes.org>
To: ethan zhao <ethan.zhao@oracle.com>
Cc: dwmw2@infradead.org, yinghai@kernel.org, bhelgaas@google.com,
        jiang.liu@linux.intel.com, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH Trivial] intel-iommu: check return value of
 device_to_iommu() before using it
Message-ID: <20140109120135.GJ29041@8bytes.org>
References: <52CE0252.4090106@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CE0252.4090106@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jan  9 13:01:37 2014
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 52ce8fa120861585018256
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 09:58:42AM +0800, ethan zhao wrote:
>  drivers/iommu/intel-iommu.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 40203ad..5b4531a 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -1105,6 +1105,8 @@ static struct device_domain_info
> *iommu_support_dev_iotlb(
>      struct device_domain_info *info;
>      struct intel_iommu *iommu = device_to_iommu(segment, bus, devfn);
> 
> +    if (!iommu)
> +        return NULL;
>      if (!ecap_dev_iotlb_support(iommu->ecap))
>          return NULL;

This call can not fail, iommu_support_dev_iotlb() is only called from
domain_context_mapping_one() which does the iommu==NULL check on its
own before the call.


	Joerg


