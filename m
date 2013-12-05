Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab3LECsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:48:42 -0500
Received: from ozlabs.org ([203.10.76.45]:45531 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127Ab3LECsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:48:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio_balloon: update_balloon_size(): update correct field
In-Reply-To: <20131204171856.3f3453e6@redhat.com>
References: <20131204171856.3f3453e6@redhat.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 05 Dec 2013 13:04:36 +1030
Message-ID: <87ob4wowjn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luiz Capitulino <lcapitulino@redhat.com> writes:
> According to the virtio spec, the device configuration field
> that should be updated after an inflation or deflation
> operation is the 'actual' field, not the 'num_pages' one.
>
> Commit 855e0c5288177bcb193f6f6316952d2490478e1c swapped them
> in update_balloon_size(). Fix it.
>
> Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>

Damn, exactly right.  Good catch.

Applied,
Rusty.

>  drivers/virtio/virtio_balloon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index c444654..5c4a95b 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -285,7 +285,7 @@ static void update_balloon_size(struct virtio_balloon *vb)
>  {
>  	__le32 actual = cpu_to_le32(vb->num_pages);
>  
> -	virtio_cwrite(vb->vdev, struct virtio_balloon_config, num_pages,
> +	virtio_cwrite(vb->vdev, struct virtio_balloon_config, actual,
>  		      &actual);
>  }
>  
> -- 
> 1.8.1.4
