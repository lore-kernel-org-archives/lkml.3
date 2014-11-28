Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaK1Iih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 03:38:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbaK1Iif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 03:38:35 -0500
Date: Fri, 28 Nov 2014 08:46:14 +0008
From: Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v6 33/46] vhost/net: larger header for virtio 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        cornelia.huck@de.ibm.com, rusty@au1.ibm.com, nab@linux-iscsi.org,
        pbonzini@redhat.com, thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Message-Id: <1417163894.5822.10@smtp.corp.redhat.com>
In-Reply-To: <1417118789-18231-34-git-send-email-mst@redhat.com>
References: <1417118789-18231-1-git-send-email-mst@redhat.com>
	<1417118789-18231-34-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, Nov 28, 2014 at 4:10 AM, Michael S. Tsirkin <mst@redhat.com> 
wrote:
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/net.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index cae22f9..1ac58d0 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -1027,7 +1027,8 @@ static int vhost_net_set_features(struct 
> vhost_net *n, u64 features)
>  	size_t vhost_hlen, sock_hlen, hdr_len;
>  	int i;
>  
> -	hdr_len = (features & (1 << VIRTIO_NET_F_MRG_RXBUF)) ?
> +	hdr_len = (features & ((1ULL << VIRTIO_NET_F_MRG_RXBUF) |
> +			       (1ULL << VIRTIO_F_VERSION_1))) ?
>  			sizeof(struct virtio_net_hdr_mrg_rxbuf) :
>  			sizeof(struct virtio_net_hdr);
>  	if (features & (1 << VHOST_NET_F_VIRTIO_NET_HDR)) {
> -- 
> MST
> 

Reviewed-by: Jason Wang <jasowang@redhat.com>

