Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaLPQsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:48:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbaLPQsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:48:04 -0500
Date: Tue, 16 Dec 2014 18:47:46 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 13/18] powerpc/uaccess: fix sparse errors
Message-ID: <20141216164746.GB21876@redhat.com>
References: <1418575877-21488-1-git-send-email-mst@redhat.com>
 <1418575877-21488-14-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418575877-21488-14-git-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 06:52:51PM +0200, Michael S. Tsirkin wrote:
> virtio wants to read bitwise types from userspace using get_user.  At the
> moment this triggers sparse errors, since the value is passed through an
> integer.
> 
> Fix that up using __force.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Ping.
Do powerpc maintainers consider fixing sparse errors
applicable for 3.19?
If yes, can you pls merge this patch?

> ---
>  arch/powerpc/include/asm/uaccess.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
> index 9485b43..a0c071d 100644
> --- a/arch/powerpc/include/asm/uaccess.h
> +++ b/arch/powerpc/include/asm/uaccess.h
> @@ -284,7 +284,7 @@ do {								\
>  	if (!is_kernel_addr((unsigned long)__gu_addr))		\
>  		might_fault();					\
>  	__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
> -	(x) = (__typeof__(*(ptr)))__gu_val;			\
> +	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
>  	__gu_err;						\
>  })
>  #endif /* __powerpc64__ */
> @@ -297,7 +297,7 @@ do {								\
>  	might_fault();							\
>  	if (access_ok(VERIFY_READ, __gu_addr, (size)))			\
>  		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
> -	(x) = (__typeof__(*(ptr)))__gu_val;				\
> +	(x) = (__force __typeof__(*(ptr)))__gu_val;				\
>  	__gu_err;							\
>  })
>  
> @@ -308,7 +308,7 @@ do {								\
>  	const __typeof__(*(ptr)) __user *__gu_addr = (ptr);	\
>  	__chk_user_ptr(ptr);					\
>  	__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
> -	(x) = (__typeof__(*(ptr)))__gu_val;			\
> +	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
>  	__gu_err;						\
>  })
>  
> -- 
> MST
> 
