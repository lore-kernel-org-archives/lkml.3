Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761177Ab3JPWqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:46:54 -0400
Received: from ozlabs.org ([203.10.76.45]:41618 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281Ab3JPWqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:46:51 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] virtio tools: use ansi versions of asm and volatile
In-Reply-To: <1381833790-18687-1-git-send-email-artagnon@gmail.com>
References: <1381833790-18687-1-git-send-email-artagnon@gmail.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 16 Oct 2013 10:39:09 +1030
Message-ID: <87haci9ivu.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramkumar Ramachandra <artagnon@gmail.com> writes:
> asm and volatile are provided for backward compatibility; use the ansi
> versions __asm__ and __volatile__.

Really?  I don't see that in the gcc documentation.  In fact, I didn't
know __volatile__ at all:

 If you are writing a header file that should be includable in ISO C
 programs, write `__asm__' instead of `asm'.  *Note Alternate Keywords::.

We're not...

Cheers,
Rusty.

> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  tools/virtio/asm/barrier.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/virtio/asm/barrier.h b/tools/virtio/asm/barrier.h
> index aff61e1..b2fbbfc 100644
> --- a/tools/virtio/asm/barrier.h
> +++ b/tools/virtio/asm/barrier.h
> @@ -1,5 +1,5 @@
>  #if defined(__i386__) || defined(__x86_64__)
> -#define barrier() asm volatile("" ::: "memory")
> +#define barrier() __asm__ __volatile__("" ::: "memory")
>  #define mb() __sync_synchronize()
>  
>  #define smp_mb()	mb()
> -- 
> 1.8.4.477.g5d89aa9
