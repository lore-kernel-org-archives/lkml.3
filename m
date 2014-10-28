Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaJ1Axr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:53:47 -0400
Received: from ozlabs.org ([103.22.144.67]:33513 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbaJ1Awn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:52:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: cornelia.huck@de.ibm.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC 4/4] virtio_net: bigger header when VERSION_1 is set
In-Reply-To: <1414099656-28090-4-git-send-email-mst@redhat.com>
References: <1414099656-28090-1-git-send-email-mst@redhat.com> <1414099656-28090-2-git-send-email-mst@redhat.com> <1414099656-28090-3-git-send-email-mst@redhat.com> <1414099656-28090-4-git-send-email-mst@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 28 Oct 2014 10:58:39 +1030
Message-ID: <87wq7l9gw8.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> With VERSION_1 virtio_net uses same header size
> whether mergeable buffers are enabled or not.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

These two are great too, thanks:

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.

> ---
>  drivers/net/virtio_net.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 9c6d50f..a2fe340 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1764,7 +1764,8 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
>  		vi->mergeable_rx_bufs = true;
>  
> -	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
> +	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF) ||
> +	    virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
>  		vi->hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
>  	else
>  		vi->hdr_len = sizeof(struct virtio_net_hdr);
> -- 
> MST
