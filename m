Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934953Ab3BTLMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:12:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:43041 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935079Ab3BTLLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:11:25 -0500
X-IronPort-AV: E=Sophos;i="4.84,701,1355068800"; 
   d="scan'208";a="6736125"
Message-ID: <5124A198.8020102@cn.fujitsu.com>
Date: Wed, 20 Feb 2013 18:12:40 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Paolo Bonzini <pbonzini@redhat.com>, Asias He <asias@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 12/16] virtio_console: use simplified virtqueue accessors.
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au> <1361260594-601-13-git-send-email-rusty@rustcorp.com.au>
In-Reply-To: <1361260594-601-13-git-send-email-rusty@rustcorp.com.au>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 18:13:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 18:13:23,
	Serialize complete at 2013/02/20 18:13:23
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
>  drivers/char/virtio_console.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> index e905d5f..6d59f16 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -502,7 +502,7 @@ static int add_inbuf(struct virtqueue *vq, struct port_buffer *buf)
>  
>  	sg_init_one(sg, buf->buf, buf->size);
>  
> -	ret = virtqueue_add_buf(vq, sg, 0, 1, buf, GFP_ATOMIC);
> +	ret = virtqueue_add_inbuf(vq, sg, 1, buf, GFP_ATOMIC);
>  	virtqueue_kick(vq);
>  	if (!ret)
>  		ret = vq->num_free;
> @@ -569,7 +569,7 @@ static ssize_t __send_control_msg(struct ports_device *portdev, u32 port_id,
>  	vq = portdev->c_ovq;
>  
>  	sg_init_one(sg, &cpkt, sizeof(cpkt));
> -	if (virtqueue_add_buf(vq, sg, 1, 0, &cpkt, GFP_ATOMIC) == 0) {
> +	if (virtqueue_add_outbuf(vq, sg, 1, &cpkt, GFP_ATOMIC) == 0) {
>  		virtqueue_kick(vq);
>  		while (!virtqueue_get_buf(vq, &len))
>  			cpu_relax();
> @@ -618,7 +618,7 @@ static ssize_t __send_to_port(struct port *port, struct scatterlist *sg,
>  
>  	reclaim_consumed_buffers(port);
>  
> -	err = virtqueue_add_buf(out_vq, sg, nents, 0, data, GFP_ATOMIC);
> +	err = virtqueue_add_outbuf(out_vq, sg, nents, data, GFP_ATOMIC);
>  
>  	/* Tell Host to go! */
>  	virtqueue_kick(out_vq);
> 

