Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaG2KHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:07:31 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:28344 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbaG2KH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:07:28 -0400
X-IronPort-AV: E=Sophos;i="5.01,756,1400025600"; 
   d="scan'208";a="157230988"
Message-ID: <53D7725C.5010405@citrix.com>
Date: Tue, 29 Jul 2014 11:07:24 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Ethan Zhao <ethan.zhao@oracle.com>, <bhelgaas@google.com>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gleb@kernel.org>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <konrad.wilk@oracle.com>, <boris.ostrovsky@oracle.com>,
        <xen-devel@lists.xenproject.org>
CC: <alex.williamson@redhat.com>, <alexander.h.duyck@intel.com>,
        <ethan.kernel@gmail.com>
Subject: Re: [PATCH 3/4 v3] xen-pciback: use pci device flag operation helper
 function
References: <1406606791-8834-1-git-send-email-ethan.zhao@oracle.com> <1406606791-8834-4-git-send-email-ethan.zhao@oracle.com>
In-Reply-To: <1406606791-8834-4-git-send-email-ethan.zhao@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/14 05:06, Ethan Zhao wrote:
> Use pci device flag operation helper functions when set device
> to assigned or deassigned state.
> 
> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>

Konrad already reviewed this but you've not included his reviewed-by tag.

I don't understand why we bother with this flag on Xen since we never
use it but:

Acked-by: David Vrabel <david.vrabel@citrix.com>

I'm expecting this to go via the PCI tree.

David

> --- a/drivers/xen/xen-pciback/pci_stub.c
> +++ b/drivers/xen/xen-pciback/pci_stub.c
> @@ -133,7 +133,7 @@ static void pcistub_device_release(struct kref *kref)
>  	xen_pcibk_config_free_dyn_fields(dev);
>  	xen_pcibk_config_free_dev(dev);
>  
> -	dev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
> +	pci_clear_dev_assigned(dev);
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
> 

