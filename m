Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaDYSTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 14:19:18 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:59196 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaDYSTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 14:19:16 -0400
Date: Fri, 25 Apr 2014 12:19:11 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frank Haverkamp <haver@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/2] GenWQE: Use pci_enable_msi_exact() instead of
 pci_enable_msi_block()
Message-ID: <20140425181911.GI32246@google.com>
References: <cover.1397458024.git.agordeev@redhat.com>
 <6e4ebc84c90c5f8e49a931e915ec373576ad416a.1397458024.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e4ebc84c90c5f8e49a931e915ec373576ad416a.1397458024.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 09:14:06AM +0200, Alexander Gordeev wrote:
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
> Cc: linux-pci@vger.kernel.org
> Acked-by: Frank Haverkamp <haver@linux.vnet.ibm.com>

Greg, since you acked this rather than saying you applied it, I applied
this to my pci/msi branch.  If you'd rather take it yourself, just let me
know.

Bjorn

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
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
