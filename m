Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbaK1Ibh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 03:31:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaK1Ibf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 03:31:35 -0500
Date: Fri, 28 Nov 2014 08:39:19 +0008
From: Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v6 25/46] virtio_net: stricter short buffer length
 checks
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, thuth@linux.vnet.ibm.com, rusty@au1.ibm.com,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        dahi@linux.vnet.ibm.com, pbonzini@redhat.com,
        David Miller <davem@davemloft.net>
Message-Id: <1417163479.5822.5@smtp.corp.redhat.com>
In-Reply-To: <1417118789-18231-26-git-send-email-mst@redhat.com>
References: <1417118789-18231-1-git-send-email-mst@redhat.com>
	<1417118789-18231-26-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, Nov 28, 2014 at 4:09 AM, Michael S. Tsirkin <mst@redhat.com> 
wrote:
> Our buffer length check is not strict enough for mergeable
> buffers: buffer can still be shorter that header + address
> by 2 bytes.
> 
> Fix that up.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> ---
>  drivers/net/virtio_net.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 516f2cb..098f443 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -437,7 +437,7 @@ static void receive_buf(struct virtnet_info *vi, 
> struct receive_queue *rq,
>  	struct sk_buff *skb;
>  	struct virtio_net_hdr_mrg_rxbuf *hdr;
>  
> -	if (unlikely(len < sizeof(struct virtio_net_hdr) + ETH_HLEN)) {
> +	if (unlikely(len < vi->hdr_len + ETH_HLEN)) {
>  		pr_debug("%s: short packet %i\n", dev->name, len);
>  		dev->stats.rx_length_errors++;
>  		if (vi->mergeable_rx_bufs) {
> -- 
> MST

Reviewed-by: Jason Wang <jasowang@redhat.com>

