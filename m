Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaLPQra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:47:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbaLPQr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:47:29 -0500
Date: Tue, 16 Dec 2014 18:47:17 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: Re: [PATCH 01/18] x86/uaccess: fix sparse errors
Message-ID: <20141216164717.GA21876@redhat.com>
References: <1418575877-21488-1-git-send-email-mst@redhat.com>
 <1418575877-21488-2-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418575877-21488-2-git-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 06:51:57PM +0200, Michael S. Tsirkin wrote:
> virtio wants to read bitwise types from userspace using get_user.  At the
> moment this triggers sparse errors, since the value is passed through an
> integer.
> 
> Fix that up using __force.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---

Ping.
Do x86 maintainers consider fixing sparse errors
applicable for 3.19?
If yes, can you pls merge this patch?


>  arch/x86/include/asm/uaccess.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
> index 0d592e0..8ce1af8 100644
> --- a/arch/x86/include/asm/uaccess.h
> +++ b/arch/x86/include/asm/uaccess.h
> @@ -179,7 +179,7 @@ __typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
>  	asm volatile("call __get_user_%P3"				\
>  		     : "=a" (__ret_gu), "=r" (__val_gu)			\
>  		     : "0" (ptr), "i" (sizeof(*(ptr))));		\
> -	(x) = (__typeof__(*(ptr))) __val_gu;				\
> +	(x) = (__force __typeof__(*(ptr))) __val_gu;				\
>  	__ret_gu;							\
>  })
>  
> -- 
> MST
> 
