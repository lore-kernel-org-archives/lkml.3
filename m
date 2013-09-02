Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348Ab3IBFtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 01:49:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757214Ab3IBFtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 01:49:18 -0400
Date: Mon, 2 Sep 2013 08:51:18 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/6] vhost_net: make vhost_zerocopy_signal_used()
 returns void
Message-ID: <20130902055118.GB19838@redhat.com>
References: <1377836962-49780-1-git-send-email-jasowang@redhat.com>
 <1377836962-49780-2-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377836962-49780-2-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tweak subj s/returns/return/

On Fri, Aug 30, 2013 at 12:29:17PM +0800, Jason Wang wrote:
> None of its caller use its return value, so let it return void.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/net.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 969a859..280ee66 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -276,8 +276,8 @@ static void copy_iovec_hdr(const struct iovec *from, struct iovec *to,
>   * of used idx. Once lower device DMA done contiguously, we will signal KVM
>   * guest used idx.
>   */
> -static int vhost_zerocopy_signal_used(struct vhost_net *net,
> -				      struct vhost_virtqueue *vq)
> +static void vhost_zerocopy_signal_used(struct vhost_net *net,
> +				       struct vhost_virtqueue *vq)
>  {
>  	struct vhost_net_virtqueue *nvq =
>  		container_of(vq, struct vhost_net_virtqueue, vq);
> @@ -297,7 +297,6 @@ static int vhost_zerocopy_signal_used(struct vhost_net *net,
>  	}
>  	if (j)
>  		nvq->done_idx = i;
> -	return j;
>  }
>  
>  static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
> -- 
> 1.7.1
