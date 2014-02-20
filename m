Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbaBTPQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 10:16:41 -0500
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:16931 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbaBTPQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 10:16:39 -0500
Message-ID: <53061C55.9060708@emulex.com>
Date: Thu, 20 Feb 2014 10:16:37 -0500
From: James Smart <james.smart@emulex.com>
Reply-To: <james.smart@emulex.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 11/22] lpfc: Remove superfluous call to pci_disable_msix()
References: <cover.1391512266.git.agordeev@redhat.com> <6341596a5594023854c22f5ab6ad0a439d26d762.1391512266.git.agordeev@redhat.com>
In-Reply-To: <6341596a5594023854c22f5ab6ad0a439d26d762.1391512266.git.agordeev@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

The change is fine - but not really necessary.  The pci_disable_msix() 
call explicitly checks for enablement so it's safe.

It really is a superfluous change - but if James wants to take it:
Acked-by: James Smart  <james.smart@emulex.com>


-- james  s



On 2/4/2014 6:16 AM, Alexander Gordeev wrote:
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: James Smart <james.smart@emulex.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>   drivers/scsi/lpfc/lpfc_init.c |    9 ++++++---
>   1 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 68c94cc..a9df97a 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -8078,7 +8078,7 @@ lpfc_sli_enable_msix(struct lpfc_hba *phba)
>   	if (rc) {
>   		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
>   				"0420 PCI enable MSI-X failed (%d)\n", rc);
> -		goto msi_fail_out;
> +		goto vec_fail_out;
>   	}
>   	for (i = 0; i < LPFC_MSIX_VECTORS; i++)
>   		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
> @@ -8156,6 +8156,8 @@ irq_fail_out:
>   msi_fail_out:
>   	/* Unconfigure MSI-X capability structure */
>   	pci_disable_msix(phba->pcidev);
> +
> +vec_fail_out:
>   	return rc;
>   }
>   
> @@ -8644,7 +8646,7 @@ enable_msix_vectors:
>   	} else if (rc) {
>   		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
>   				"0484 PCI enable MSI-X failed (%d)\n", rc);
> -		goto msi_fail_out;
> +		goto vec_fail_out;
>   	}
>   
>   	/* Log MSI-X vector assignment */
> @@ -8696,9 +8698,10 @@ cfg_fail_out:
>   			 &phba->sli4_hba.fcp_eq_hdl[index]);
>   	}
>   
> -msi_fail_out:
>   	/* Unconfigure MSI-X capability structure */
>   	pci_disable_msix(phba->pcidev);
> +
> +vec_fail_out:
>   	return rc;
>   }
>   

