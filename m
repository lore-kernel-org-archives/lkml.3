Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab3GGOUX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 10:20:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab3GGOUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 10:20:19 -0400
Date: Sun, 7 Jul 2013 17:21:20 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: kvm@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio: include asm/barrier explicitly
Message-ID: <20130707142120.GA2465@redhat.com>
References: <20130707142019.GA2447@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130707142019.GA2447@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 07, 2013 at 05:20:19PM +0300, Michael S. Tsirkin wrote:
> virtio_ring.h uses mb() and friends, make
> it pull in asm/barrier.h itself, not rely
> on other headers to do it.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

In particular this fixes warnings during test build:
[linux]$ make -C tools/virtio/ 
make: Entering directory `/home/mst/scm/linux/tools/virtio'
cc -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign
-fno-strict-overflow -fno-strict-aliasing -fno-common -MMD
-U_FORTIFY_SOURCE   -c -o virtio_test.o virtio_test.c
In file included from ./linux/virtio_ring.h:1:0,
                 from ../../usr/include/linux/vhost.h:17,
                 from virtio_test.c:14:
./linux/../../../include/linux/virtio_ring.h: In function ‘virtio_mb’:
./linux/../../../include/linux/virtio_ring.h:50:2: warning: implicit
declaration of function ‘mb’ [-Wimplicit-function-declaration]


> ---
>  include/linux/virtio_ring.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
> index ca3ad41..b300787 100644
> --- a/include/linux/virtio_ring.h
> +++ b/include/linux/virtio_ring.h
> @@ -1,6 +1,7 @@
>  #ifndef _LINUX_VIRTIO_RING_H
>  #define _LINUX_VIRTIO_RING_H
>  
> +#include <asm/barrier.h>
>  #include <linux/irqreturn.h>
>  #include <uapi/linux/virtio_ring.h>
>  
> -- 
> MST
