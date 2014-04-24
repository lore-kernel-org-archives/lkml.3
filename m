Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaDXTqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:46:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaDXTqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:46:33 -0400
Date: Thu, 24 Apr 2014 12:49:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: linux-usb@vger.kernel.org, sarah.a.sharp@linux.intel.com,
        linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@redhat.com>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/5] xhci: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
Message-ID: <20140424194926.GB12809@kroah.com>
References: <1398169382-12097-1-git-send-email-mathias.nyman@linux.intel.com>
 <1398169382-12097-3-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398169382-12097-3-git-send-email-mathias.nyman@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 03:22:59PM +0300, Mathias Nyman wrote:
> From: Alexander Gordeev <agordeev@redhat.com>
> 
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/usb/host/xhci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index 988ed5f..b0b8399 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -291,7 +291,7 @@ static int xhci_setup_msix(struct xhci_hcd *xhci)
>  		xhci->msix_entries[i].vector = 0;
>  	}
>  
> -	ret = pci_enable_msix(pdev, xhci->msix_entries, xhci->msix_count);
> +	ret = pci_enable_msix_exact(pdev, xhci->msix_entries, xhci->msix_count);

Why is this change needed for 3.15-final?

