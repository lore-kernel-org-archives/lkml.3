Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab3ETCgY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 22:36:24 -0400
Received: from ozlabs.org ([203.10.76.45]:46433 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186Ab3ETCgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 22:36:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] virtio_pci: better macro exported in uapi
In-Reply-To: <20130519132224.GA23858@redhat.com>
References: <20130519132224.GA23858@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 20 May 2013 11:00:13 +0930
Message-ID: <87ip2ezbdm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:

> Macro VIRTIO_PCI_CONFIG assumes that userspace actually has a structure
> with a field named msix_enabled.  Add VIRTIO_PCI_CONFIG_OFF that gets
> the msix_enabled by value instead, to make it useful for userspace.  We
> still keep VIRTIO_PCI_CONFIG around for now, in case some userspace uses
> it.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied.

Thanks,
Rusty.

> ---
>
> Changes from v1:
> - rename macro to VIRTIO_PCI_CONFIG_OFF so preprocessor
>   can be used to check for its presence, as suggested
>   by Rusty
> - keep old macro around as suggested by David Howells
>
>  include/uapi/linux/virtio_pci.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
> index ea66f3f..e5ec1ca 100644
> --- a/include/uapi/linux/virtio_pci.h
> +++ b/include/uapi/linux/virtio_pci.h
> @@ -80,7 +80,9 @@
>  
>  /* The remaining space is defined by each driver as the per-driver
>   * configuration space */
> -#define VIRTIO_PCI_CONFIG(dev)		((dev)->msix_enabled ? 24 : 20)
> +#define VIRTIO_PCI_CONFIG_OFF(msix_enabled)	((msix_enabled) ? 24 : 20)
> +/* Deprecated: please use VIRTIO_PCI_CONFIG_OFF instead */
> +#define VIRTIO_PCI_CONFIG(dev)	VIRTIO_PCI_CONFIG_OFF((dev)->msix_enabled)
>  
>  /* Virtio ABI version, this must match exactly */
>  #define VIRTIO_PCI_ABI_VERSION		0
> -- 
> MST
