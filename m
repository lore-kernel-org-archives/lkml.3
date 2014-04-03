Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846AbaDCGQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 02:16:29 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:55427 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933518AbaDCGQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 02:16:28 -0400
Subject: Re: [PATCH] GenWQE: Use pci_enable_msi_exact() instead of
 pci_enable_msi_block()
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
In-Reply-To: <1396439576-10263-1-git-send-email-agordeev@redhat.com>
References: <1396439576-10263-1-git-send-email-agordeev@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Thu, 03 Apr 2014 08:16:21 +0200
Message-ID: <1396505781.12440.1.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040306-8372-0000-0000-000009325B0E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

Am Mittwoch, den 02.04.2014, 13:52 +0200 schrieb Alexander Gordeev:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Frank Haverkamp <haver@linux.vnet.ibm.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/misc/genwqe/card_utils.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
> index 6b1a6ef..294f667 100644
> --- a/drivers/misc/genwqe/card_utils.c
> +++ b/drivers/misc/genwqe/card_utils.c
> @@ -628,7 +628,7 @@ int genwqe_set_interrupt_capability(struct genwqe_dev *cd, int count)
>  	int rc;
>  	struct pci_dev *pci_dev = cd->pci_dev;
> 
> -	rc = pci_enable_msi_block(pci_dev, count);
> +	rc = pci_enable_msi_exact(pci_dev, count);
>  	if (rc == 0)
>  		cd->flags |= GENWQE_FLAG_MSI_ENABLED;
>  	return rc;

fine with me, if it works like it did before.

Acked-by: Frank Haverkamp <haver@linux.vnet.ibm.com>

