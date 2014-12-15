Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401AbaLOAFh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 19:05:37 -0500
Received: from gate.crashing.org ([63.228.1.57]:37779 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaLOAFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 19:05:33 -0500
Message-ID: <1418601906.5111.37.camel@kernel.crashing.org>
Subject: Re: [PATCH 13/18] powerpc/uaccess: fix sparse errors
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Date: Mon, 15 Dec 2014 11:05:06 +1100
In-Reply-To: <1418575877-21488-14-git-send-email-mst@redhat.com>
References: <1418575877-21488-1-git-send-email-mst@redhat.com>
	 <1418575877-21488-14-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-14 at 18:52 +0200, Michael S. Tsirkin wrote:
> virtio wants to read bitwise types from userspace using get_user.  At the
> moment this triggers sparse errors, since the value is passed through an
> integer.
> 
> Fix that up using __force.

You mean bitfields ? Argh ... we should just remove them from the
compiler and be done with it :-(

Ben.

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
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


