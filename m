Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbaBLTOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:14:30 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:64897 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbaBLTO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:14:29 -0500
Date: Wed, 12 Feb 2014 12:14:25 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI/MSI: Fix cut-and-paste errors in documentation
Message-ID: <20140212191425.GA5554@google.com>
References: <1392201325-11173-1-git-send-email-agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392201325-11173-1-git-send-email-agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 11:35:25AM +0100, Alexander Gordeev wrote:
> Function pci_enable_msi_range() is used in examples where
> pci_enable_msix_range() should have been used instead.
> 
> Reported-by: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

Applied to pci/misc for v3.15, thanks!

Bjorn

> ---
>  Documentation/PCI/MSI-HOWTO.txt |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
> index a8d0100..43c5a5f 100644
> --- a/Documentation/PCI/MSI-HOWTO.txt
> +++ b/Documentation/PCI/MSI-HOWTO.txt
> @@ -257,8 +257,8 @@ possible, likely up to the limit returned by pci_msix_vec_count() function:
>  
>  static int foo_driver_enable_msix(struct foo_adapter *adapter, int nvec)
>  {
> -	return pci_enable_msi_range(adapter->pdev, adapter->msix_entries,
> -				    1, nvec);
> +	return pci_enable_msix_range(adapter->pdev, adapter->msix_entries,
> +				     1, nvec);
>  }
>  
>  Note the value of 'minvec' parameter is 1.  As 'minvec' is inclusive,
> @@ -269,8 +269,8 @@ In this case the function could look like this:
>  
>  static int foo_driver_enable_msix(struct foo_adapter *adapter, int nvec)
>  {
> -	return pci_enable_msi_range(adapter->pdev, adapter->msix_entries,
> -				    FOO_DRIVER_MINIMUM_NVEC, nvec);
> +	return pci_enable_msix_range(adapter->pdev, adapter->msix_entries,
> +				     FOO_DRIVER_MINIMUM_NVEC, nvec);
>  }
>  
>  4.3.1.2 Exact number of MSI-X interrupts
> @@ -282,8 +282,8 @@ parameters:
>  
>  static int foo_driver_enable_msix(struct foo_adapter *adapter, int nvec)
>  {
> -	return pci_enable_msi_range(adapter->pdev, adapter->msix_entries,
> -				    nvec, nvec);
> +	return pci_enable_msix_range(adapter->pdev, adapter->msix_entries,
> +				     nvec, nvec);
>  }
>  
>  4.3.1.3 Specific requirements to the number of MSI-X interrupts
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
