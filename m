Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaBLLzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:55:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbaBLLzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:55:18 -0500
Date: Wed, 12 Feb 2014 13:59:01 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sridhar Samudrala <sri@us.ibm.com>
Subject: Re: [PATCH net] virtio-net: alloc big buffers also when guest can
 receive UFO
Message-ID: <20140212115901.GC23006@redhat.com>
References: <1392183808-16789-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392183808-16789-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 01:43:28PM +0800, Jason Wang wrote:
> We should alloc big buffers also when guest can receive UFO
> pakcets. Otherwise the big packets will be truncated when mergeable rx
> buffer is disabled.

Not truncated, they will be dropped.

> Fixes 5c5167515d80f78f6bb538492c423adcae31ad65
> (virtio-net: Allow UFO feature to be set and advertised.)
>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Sridhar Samudrala <sri@us.ibm.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

for patch but please fix commit message.


> ---
>  drivers/net/virtio_net.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index d75f8ed..5632a99 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1711,7 +1711,8 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	/* If we can receive ANY GSO packets, we must allocate large ones. */
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
>  	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6) ||
> -	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_ECN))
> +	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_ECN) ||
> +	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_UFO))
>  		vi->big_packets = true;
>  
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
> -- 
> 1.8.3.2
