Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408Ab3CZEzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 00:55:54 -0400
Received: from ozlabs.org ([203.10.76.45]:60032 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756905Ab3CZEzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 00:55:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>,
        Uwe =?utf-8?Q?Kleine-K?= =?utf-8?Q?=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] drivers: virtio: Use PTR_RET function
In-Reply-To: <1364217936-6284-1-git-send-email-gheorghiuandru@gmail.com>
References: <1364217936-6284-1-git-send-email-gheorghiuandru@gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 26 Mar 2013 13:57:09 +1030
Message-ID: <87fvzidenm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandru Gheorghiu <gheorghiuandru@gmail.com> writes:

> Used PTR_RET function instead of IS_ERR and PTR_ERR.
> Patch found using coccinelle.

WTF is PTR_RET?  PTR_RET doesn't return anything.  Why is it called
that?  It doesn't even make sense.

ZERO_OR_PTR_ERR() maybe.

But what problem are we solving?  Insufficient churn in the tree?  Code
being too readable?  This isn't some hard-to-get right corner case, or a
missed optimization.

Andrew, what am I missing here?

Grumpy,
Rusty.

> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
> ---
>  drivers/virtio/virtio_mmio.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index 1ba0d68..d1e664f 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -567,10 +567,7 @@ static int vm_cmdline_set(const char *device,
>  	pdev = platform_device_register_resndata(&vm_cmdline_parent,
>  			"virtio-mmio", vm_cmdline_id++,
>  			resources, ARRAY_SIZE(resources), NULL, 0);
> -	if (IS_ERR(pdev))
> -		return PTR_ERR(pdev);
> -
> -	return 0;
> +	return PTR_RET(pdev);
>  }
>  
>  static int vm_cmdline_get_device(struct device *dev, void *data)
> -- 
> 1.7.9.5
