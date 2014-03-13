Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaCMD4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 23:56:40 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:39357 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbaCMD4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 23:56:39 -0400
Date: Wed, 12 Mar 2014 21:56:34 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 2/4] portdrv: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Message-ID: <20140313035634.GA26657@google.com>
References: <cover.1394128952.git.agordeev@redhat.com>
 <b1f560f01a176784ebfff28b84574d2850413729.1394128952.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1f560f01a176784ebfff28b84574d2850413729.1394128952.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 09:11:22PM +0100, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org

Applied to pci/msi for v3.15, thanks!

> ---
>  drivers/pci/pcie/portdrv_core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
> index 986f8ea..0b1efb2 100644
> --- a/drivers/pci/pcie/portdrv_core.c
> +++ b/drivers/pci/pcie/portdrv_core.c
> @@ -99,7 +99,7 @@ static int pcie_port_enable_msix(struct pci_dev *dev, int *vectors, int mask)
>  	for (i = 0; i < nr_entries; i++)
>  		msix_entries[i].entry = i;
>  
> -	status = pci_enable_msix(dev, msix_entries, nr_entries);
> +	status = pci_enable_msix_exact(dev, msix_entries, nr_entries);
>  	if (status)
>  		goto Exit;
>  
> @@ -171,7 +171,7 @@ static int pcie_port_enable_msix(struct pci_dev *dev, int *vectors, int mask)
>  		pci_disable_msix(dev);
>  
>  		/* Now allocate the MSI-X vectors for real */
> -		status = pci_enable_msix(dev, msix_entries, nvec);
> +		status = pci_enable_msix_exact(dev, msix_entries, nvec);
>  		if (status)
>  			goto Exit;
>  	}
> -- 
> 1.7.7.6
> 
