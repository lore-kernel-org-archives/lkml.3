Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbaBTEYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 23:24:52 -0500
Received: from ozlabs.org ([203.10.76.45]:45311 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbaBTEYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 23:24:51 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] virtio: Use pci_enable_msix_range() instead of pci_enable_msix()
In-Reply-To: <1392804931-30671-9-git-send-email-agordeev@redhat.com>
References: <1392804931-30671-9-git-send-email-agordeev@redhat.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 20 Feb 2014 12:14:11 +1030
Message-ID: <87eh2yblsk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Gordeev <agordeev@redhat.com> writes:
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

I've put this in my pending queue, but in case someone else wants to
take it:

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.

