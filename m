Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935123Ab3BTLL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:11:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:43041 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935073Ab3BTLLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:11:24 -0500
X-IronPort-AV: E=Sophos;i="4.84,701,1355068800"; 
   d="scan'208";a="6736123"
Message-ID: <5124A182.5080806@cn.fujitsu.com>
Date: Wed, 20 Feb 2013 18:12:18 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Paolo Bonzini <pbonzini@redhat.com>, Asias He <asias@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 11/16] virtio_rng: use simplified virtqueue accessors.
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au> <1361260594-601-12-git-send-email-rusty@rustcorp.com.au>
In-Reply-To: <1361260594-601-12-git-send-email-rusty@rustcorp.com.au>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 18:12:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 18:12:55,
	Serialize complete at 2013/02/20 18:12:55
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
>  drivers/char/hw_random/virtio-rng.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> index 10fd71c..842e2d5 100644
> --- a/drivers/char/hw_random/virtio-rng.c
> +++ b/drivers/char/hw_random/virtio-rng.c
> @@ -47,7 +47,7 @@ static void register_buffer(u8 *buf, size_t size)
>  	sg_init_one(&sg, buf, size);
>  
>  	/* There should always be room for one buffer. */
> -	if (virtqueue_add_buf(vq, &sg, 0, 1, buf, GFP_KERNEL) < 0)
> +	if (virtqueue_add_inbuf(vq, &sg, 1, buf, GFP_KERNEL) < 0)
>  		BUG();
>  
>  	virtqueue_kick(vq);
> 

