Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbaGVRfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 13:35:05 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26479 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129AbaGVRfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 13:35:03 -0400
Date: Tue, 22 Jul 2014 13:34:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ethan Zhao <ethan.zhao@oracle.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com,
        kvm@vger.kernel.org, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        alex.williamson@redhat.com, alexander.h.duyck@intel.com,
        ethan.kernel@gmail.com
Subject: Re: [PATCH 3/4] xen-pciback: use pci device flag operation helper
 function
Message-ID: <20140722173444.GB14061@konrad-lan.dumpdata.com>
References: <1406045944-1587-1-git-send-email-ethan.zhao@oracle.com>
 <1406045944-1587-4-git-send-email-ethan.zhao@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406045944-1587-4-git-send-email-ethan.zhao@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 12:19:03AM +0800, Ethan Zhao wrote:
> Use pci device flag operation helper functions when set device
> to assigned or deassigned state.
> 
> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/xen-pciback/pci_stub.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
> index 62fcd48..71f69f1 100644
> --- a/drivers/xen/xen-pciback/pci_stub.c
> +++ b/drivers/xen/xen-pciback/pci_stub.c
> @@ -133,7 +133,7 @@ static void pcistub_device_release(struct kref *kref)
>  	xen_pcibk_config_free_dyn_fields(dev);
>  	xen_pcibk_config_free_dev(dev);
>  
> -	dev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
> +	pci_set_dev_deassigned(dev);
>  	pci_dev_put(dev);
>  
>  	kfree(psdev);
> @@ -404,7 +404,7 @@ static int pcistub_init_device(struct pci_dev *dev)
>  	dev_dbg(&dev->dev, "reset device\n");
>  	xen_pcibk_reset_device(dev);
>  
> -	dev->dev_flags |= PCI_DEV_FLAGS_ASSIGNED;
> +	pci_set_dev_assigned(dev);
>  	return 0;
>  
>  config_release:
> -- 
> 1.7.1
> 
