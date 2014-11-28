Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbaK1IdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 03:33:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaK1IdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 03:33:13 -0500
Date: Fri, 28 Nov 2014 08:40:57 +0008
From: Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v6 28/46] vhost: make features 64 bit
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, thuth@linux.vnet.ibm.com,
        kvm@vger.kernel.org, rusty@au1.ibm.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, dahi@linux.vnet.ibm.com,
        pbonzini@redhat.com, David Miller <davem@davemloft.net>
Message-Id: <1417163577.5822.7@smtp.corp.redhat.com>
In-Reply-To: <1417118789-18231-29-git-send-email-mst@redhat.com>
References: <1417118789-18231-1-git-send-email-mst@redhat.com>
	<1417118789-18231-29-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, Nov 28, 2014 at 4:10 AM, Michael S. Tsirkin <mst@redhat.com> 
wrote:
> We need to use bit 32 for virtio 1.0
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/vhost.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 3eda654..c624b09 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -106,7 +106,7 @@ struct vhost_virtqueue {
>  	/* Protected by virtqueue mutex. */
>  	struct vhost_memory *memory;
>  	void *private_data;
> -	unsigned acked_features;
> +	u64 acked_features;
>  	/* Log write descriptors */
>  	void __user *log_base;
>  	struct vhost_log *log;
> @@ -174,6 +174,6 @@ enum {
>  
>  static inline int vhost_has_feature(struct vhost_virtqueue *vq, int 
> bit)
>  {
> -	return vq->acked_features & (1 << bit);
> +	return vq->acked_features & (1ULL << bit);
>  }
>  #endif
> -- 
> MST

Reviewed-by: Jason Wang <jasowang@redhat.com>

