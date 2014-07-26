Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229AbaGZIQA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 04:16:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbaGZIP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 04:15:58 -0400
Date: Sat, 26 Jul 2014 09:24:09 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org, Neela Syam Kolli <megaraidlinux@lsi.com>
Subject: Re: [PATCH v2 RESEND 13/23] megaraid: Fail resume if MSI-X
 re-initialization failed
Message-ID: <20140726082408.GG21129@agordeev.usersys.redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <3d2402ebfad625e508bb13257e1560abf92594cd.1405533479.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d2402ebfad625e508bb13257e1560abf92594cd.1405533479.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 08:05:17PM +0200, Alexander Gordeev wrote:
> Currently the driver fails to analize MSI-X re-enablement
> status on resuming and always assumes the success. This
> update checks the MSI-X initialization result and fails
> to resume if MSI-Xs re-enablement failed.

Hi Neela,

Could you please review megaraid patches in this series?

Thanks!

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 112799b..ba06102 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -5134,9 +5134,10 @@ megasas_resume(struct pci_dev *pdev)
>  		goto fail_ready_state;
>  
>  	/* Now re-enable MSI-X */
> -	if (instance->msix_vectors)
> -		pci_enable_msix(instance->pdev, instance->msixentry,
> -				instance->msix_vectors);
> +	if (instance->msix_vectors &&
> +	    pci_enable_msix(instance->pdev, instance->msixentry,
> +			    instance->msix_vectors))
> +		goto fail_reenable_msix;
>  
>  	switch (instance->pdev->device) {
>  	case PCI_DEVICE_ID_LSI_FUSION:
> @@ -5245,6 +5246,7 @@ fail_init_mfi:
>  
>  fail_set_dma_mask:
>  fail_ready_state:
> +fail_reenable_msix:
>  
>  	pci_disable_device(pdev);
>  
> -- 
> 1.7.7.6
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
