Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaK1Ikm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 03:40:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbaK1Ikk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 03:40:40 -0500
Date: Fri, 28 Nov 2014 08:48:24 +0008
From: Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v6 34/46] virtio_net: disable mac write for virtio 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, thuth@linux.vnet.ibm.com, rusty@au1.ibm.com,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        dahi@linux.vnet.ibm.com, pbonzini@redhat.com,
        David Miller <davem@davemloft.net>
Message-Id: <1417164024.5822.11@smtp.corp.redhat.com>
In-Reply-To: <1417118789-18231-35-git-send-email-mst@redhat.com>
References: <1417118789-18231-1-git-send-email-mst@redhat.com>
	<1417118789-18231-35-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, Nov 28, 2014 at 4:10 AM, Michael S. Tsirkin <mst@redhat.com> 
wrote:
> The spec states that mac in config space is only driver-writable in 
> the
> legacy case.  Fence writing it in virtnet_set_mac_address() in the
> virtio 1.0 case.
> 
> Suggested-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/net/virtio_net.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index c6a72d3..9ab3c50 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1030,7 +1030,8 @@ static int virtnet_set_mac_address(struct 
> net_device *dev, void *p)
>  				 "Failed to set mac address by vq command.\n");
>  			return -EINVAL;
>  		}
> -	} else if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC)) {
> +	} else if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC) &&
> +		   !virtio_has_feature(vdev, VIRTIO_F_VERSION_1)) {
>  		unsigned int i;
>  
>  		/* Naturally, this has an atomicity problem. */
> -- 
> MST

Does this mean there's no way to setting mac addres
if ctrl mac addr is disabled in virtio-1?

If yes, we'd better keep this compatibility somehow. 

