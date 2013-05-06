Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab3EFHzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 03:55:12 -0400
Received: from ozlabs.org ([203.10.76.45]:42278 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab3EFHyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 03:54:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: mst@redhat.com
Subject: Re: Add missing module license tag to vring helpers.
In-Reply-To: <20130503204009.GA29376@redhat.com>
References: <20130503204009.GA29376@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 06 May 2013 17:06:23 +0930
Message-ID: <87bo8opnk8.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:
> [  624.286653] vringh: module license 'unspecified' taints kernel.
>
> Signed-off-by: Dave Jones <davej@redhat.com>

Thanks!  This is exactly right.

But note that the default license tag for otherwise-unlabelled modules
would be "GPLv2".  "GPL" means v2 or later (which is what I want, but
it's not the kernel default).

Applied,
Rusty.

> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index bff0775..5174eba 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -3,6 +3,7 @@
>   *
>   * Since these may be in userspace, we use (inline) accessors.
>   */
> +#include <linux/module.h>
>  #include <linux/vringh.h>
>  #include <linux/virtio_ring.h>
>  #include <linux/kernel.h>
> @@ -1005,3 +1006,5 @@ int vringh_need_notify_kern(struct vringh *vrh)
>  	return __vringh_need_notify(vrh, getu16_kern);
>  }
>  EXPORT_SYMBOL(vringh_need_notify_kern);
> +
> +MODULE_LICENSE("GPL");
