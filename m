Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaLCJcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:32:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbaLCJcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:32:00 -0500
Date: Wed, 3 Dec 2014 11:31:49 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] virtio-net: don't do header check for dodgy gso
 packets
Message-ID: <20141203093149.GA9487@redhat.com>
References: <1417588844-11095-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417588844-11095-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 02:40:44PM +0800, Jason Wang wrote:
> There's no need to do header check for virito-net since:

s/virito/virtio/

> 
> - Host set dodgy for all gso packets from guest and check the header.

s/set/sets/

> - Host should prepare for all kinds of evil packets from guest, since

s/prepare/be prepared/

>   malicious guest can send any kinds of packet.
> 
> So this patch sets NETIF_F_GSO_ROBUST for virtio-net to skip the check.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

with the comment fixes:

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/virtio_net.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index b0bc8ea..4cd242b 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1760,6 +1760,8 @@ static int virtnet_probe(struct virtio_device *vdev)
>  		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_ECN))
>  			dev->hw_features |= NETIF_F_TSO_ECN;
>  
> +		dev->features |= NETIF_F_GSO_ROBUST;
> +
>  		if (gso)
>  			dev->features |= dev->hw_features & NETIF_F_ALL_TSO;
>  		/* (!csum && gso) case will be fixed by register_netdev() */
> -- 
> 1.9.1
> 
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
