Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbaBTFM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 00:12:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaBTFM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 00:12:56 -0500
Date: Thu, 20 Feb 2014 07:17:54 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] virtio: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Message-ID: <20140220051754.GB28241@redhat.com>
References: <1392804931-30671-9-git-send-email-agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392804931-30671-9-git-send-email-agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 11:15:29AM +0100, Alexander Gordeev wrote:
> As result deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range() and pci_enable_msix_range()
> interfaces.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: virtio-dev@lists.oasis-open.org
> Cc: virtualization@lists.linux-foundation.org
> Cc: linux-pci@vger.kernel.org

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/virtio/virtio_pci.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> index a416f9b..dea042c 100644
> --- a/drivers/virtio/virtio_pci.c
> +++ b/drivers/virtio/virtio_pci.c
> @@ -333,11 +333,9 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
>  	for (i = 0; i < nvectors; ++i)
>  		vp_dev->msix_entries[i].entry = i;
>  
> -	/* pci_enable_msix returns positive if we can't get this many. */
> -	err = pci_enable_msix(vp_dev->pci_dev, vp_dev->msix_entries, nvectors);
> -	if (err > 0)
> -		err = -ENOSPC;
> -	if (err)
> +	err = pci_enable_msix_range(vp_dev->pci_dev,
> +				    vp_dev->msix_entries, nvectors, nvectors);
> +	if (err < 0)
>  		goto error;
>  	vp_dev->msix_enabled = 1;
>  
> -- 
> 1.7.7.6
