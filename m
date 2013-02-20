Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935167Ab3BTLLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:11:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53076 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934918Ab3BTLL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:11:26 -0500
X-IronPort-AV: E=Sophos;i="4.84,701,1355068800"; 
   d="scan'208";a="6736127"
Message-ID: <5124A231.4020001@cn.fujitsu.com>
Date: Wed, 20 Feb 2013 18:15:13 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Paolo Bonzini <pbonzini@redhat.com>, Asias He <asias@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 15/16] virtio_balloon: use simplified virtqueue accessors.
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au> <1361260594-601-16-git-send-email-rusty@rustcorp.com.au>
In-Reply-To: <1361260594-601-16-git-send-email-rusty@rustcorp.com.au>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 18:15:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 18:15:46,
	Serialize complete at 2013/02/20 18:15:46
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 03:56 PM, Rusty Russell wrote:
> We never add buffers with input and output parts, so use the new accessors.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Reviewed-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>

> ---
>  drivers/virtio/virtio_balloon.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 8dab163..bd3ae32 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -108,7 +108,7 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
>  	sg_init_one(&sg, vb->pfns, sizeof(vb->pfns[0]) * vb->num_pfns);
>  
>  	/* We should always be able to add one buffer to an empty queue. */
> -	if (virtqueue_add_buf(vq, &sg, 1, 0, vb, GFP_KERNEL) < 0)
> +	if (virtqueue_add_outbuf(vq, &sg, 1, vb, GFP_KERNEL) < 0)
>  		BUG();
>  	virtqueue_kick(vq);
>  
> @@ -256,7 +256,7 @@ static void stats_handle_request(struct virtio_balloon *vb)
>  	if (!virtqueue_get_buf(vq, &len))
>  		return;
>  	sg_init_one(&sg, vb->stats, sizeof(vb->stats));
> -	if (virtqueue_add_buf(vq, &sg, 1, 0, vb, GFP_KERNEL) < 0)
> +	if (virtqueue_add_outbuf(vq, &sg, 1, vb, GFP_KERNEL) < 0)
>  		BUG();
>  	virtqueue_kick(vq);
>  }
> @@ -341,7 +341,7 @@ static int init_vqs(struct virtio_balloon *vb)
>  		 * use it to signal us later.
>  		 */
>  		sg_init_one(&sg, vb->stats, sizeof vb->stats);
> -		if (virtqueue_add_buf(vb->stats_vq, &sg, 1, 0, vb, GFP_KERNEL)
> +		if (virtqueue_add_outbuf(vb->stats_vq, &sg, 1, vb, GFP_KERNEL)
>  		    < 0)
>  			BUG();
>  		virtqueue_kick(vb->stats_vq);
> 

