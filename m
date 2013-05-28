Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab3E1ESP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 00:18:15 -0400
Received: from ozlabs.org ([203.10.76.45]:56354 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932550Ab3E1ESL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 00:18:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH rusty/virtio-pci-new-layout] virtio: new layout minor header fixups
In-Reply-To: <20130527155943.GA18246@redhat.com>
References: <20130527155943.GA18246@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 28 May 2013 10:59:08 +0930
Message-ID: <87txlnopsr.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> Fix issues observed with the new layout code, seen
> when implementing device in qemu:
> 	- use of uXX in uapi header
> 	- incorrect readonly tag on one field
> 	- unconditional warning breaks builds with -Werr
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Hmm, this means if we ever *do* remove those defines, qemu will break.

But perhaps that's OK, because we'll probably remove legacy support at
the same time as we break the header.

Applied, thanks!
Rusty.

> This patch is on top of rusty/virtio-pci-new-layout.
>
>  include/uapi/linux/virtio_pci.h | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
> index 3e61d55..cda688f 100644
> --- a/include/uapi/linux/virtio_pci.h
> +++ b/include/uapi/linux/virtio_pci.h
> @@ -86,8 +86,10 @@
>  #define VIRTIO_PCI_LEGACY_VRING_ALIGN		4096
>  
>  #ifndef VIRTIO_PCI_NO_LEGACY
> +#ifndef VIRTIO_PCI_LEGACY_COMPAT_NAMES
>  /* Don't break compile of old userspace code.  These will go away. */
>  #warning "Please support virtio_pci non-legacy mode!"
> +#endif
>  #define VIRTIO_PCI_HOST_FEATURES VIRTIO_PCI_LEGACY_HOST_FEATURES
>  #define VIRTIO_PCI_GUEST_FEATURES VIRTIO_PCI_LEGACY_GUEST_FEATURES
>  #define VIRTIO_PCI_QUEUE_PFN VIRTIO_PCI_LEGACY_QUEUE_PFN
> @@ -125,10 +127,10 @@
>  
>  /* This is the PCI capability header: */
>  struct virtio_pci_cap {
> -	u8 cap_vndr;	/* Generic PCI field: PCI_CAP_ID_VNDR */
> -	u8 cap_next;	/* Generic PCI field: next ptr. */
> -	u8 cfg_type;	/* One of the VIRTIO_PCI_CAP_*_CFG. */
> -	u8 bar;		/* Where to find it. */
> +	__u8 cap_vndr;	/* Generic PCI field: PCI_CAP_ID_VNDR */
> +	__u8 cap_next;	/* Generic PCI field: next ptr. */
> +	__u8 cfg_type;	/* One of the VIRTIO_PCI_CAP_*_CFG. */
> +	__u8 bar;		/* Where to find it. */
>  	__le32 offset;	/* Offset within bar. */
>  	__le32 length;	/* Length. */
>  };
> @@ -144,7 +146,7 @@ struct virtio_pci_common_cfg {
>  	__le32 device_feature_select;	/* read-write */
>  	__le32 device_feature;		/* read-only */
>  	__le32 guest_feature_select;	/* read-write */
> -	__le32 guest_feature;		/* read-only */
> +	__le32 guest_feature;		/* read-write */
>  	__le16 msix_config;		/* read-write */
>  	__le16 num_queues;		/* read-only */
>  	__u8 device_status;		/* read-write */
> -- 
> MST
