Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbaK1IcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 03:32:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbaK1IcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 03:32:13 -0500
Date: Fri, 28 Nov 2014 08:39:57 +0008
From: Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v6 26/46] virtio_net: bigger header when VERSION_1 is
 set
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, thuth@linux.vnet.ibm.com, rusty@au1.ibm.com,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        dahi@linux.vnet.ibm.com, pbonzini@redhat.com,
        David Miller <davem@davemloft.net>
Message-Id: <1417163517.5822.6@smtp.corp.redhat.com>
In-Reply-To: <1417118789-18231-27-git-send-email-mst@redhat.com>
References: <1417118789-18231-1-git-send-email-mst@redhat.com>
	<1417118789-18231-27-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, Nov 28, 2014 at 4:10 AM, Michael S. Tsirkin <mst@redhat.com> 
wrote:
> With VERSION_1 virtio_net uses same header size
> whether mergeable buffers are enabled or not.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> ---
>  drivers/net/virtio_net.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 098f443..a0e64cf 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1805,7 +1805,8 @@ static int virtnet_probe(struct virtio_device 
> *vdev)
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

Reviewed-by: Jason Wang <jasowang@redhat.com>

