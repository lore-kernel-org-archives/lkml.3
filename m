Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaBVVNc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 16:13:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbaBVVNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 16:13:31 -0500
Date: Sat, 22 Feb 2014 23:18:24 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] virtio: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
Message-ID: <20140222211824.GA9777@redhat.com>
References: <1392804931-30671-9-git-send-email-agordeev@redhat.com>
 <87eh2yblsk.fsf@rustcorp.com.au>
 <20140221165946.GJ17353@dhcp-26-207.brq.redhat.com>
 <20140221170128.GK17353@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221170128.GK17353@dhcp-26-207.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 06:01:28PM +0100, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.


Acked-by: Michael S. Tsirkin <mst@redhat.com>

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: virtio-dev@lists.oasis-open.org
> Cc: virtualization@lists.linux-foundation.org
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/virtio/virtio_pci.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> index a416f9b..101db3f 100644
> --- a/drivers/virtio/virtio_pci.c
> +++ b/drivers/virtio/virtio_pci.c
> @@ -333,10 +333,8 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
>  	for (i = 0; i < nvectors; ++i)
>  		vp_dev->msix_entries[i].entry = i;
>  
> -	/* pci_enable_msix returns positive if we can't get this many. */
> -	err = pci_enable_msix(vp_dev->pci_dev, vp_dev->msix_entries, nvectors);
> -	if (err > 0)
> -		err = -ENOSPC;
> +	err = pci_enable_msix_exact(vp_dev->pci_dev,
> +				    vp_dev->msix_entries, nvectors);
>  	if (err)
>  		goto error;
>  	vp_dev->msix_enabled = 1;
> -- 
> 1.7.7.6
> 
> -- 
> Regards,
> Alexander Gordeev
> agordeev@redhat.com
