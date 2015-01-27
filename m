Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbbA0Q1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:27:11 -0500
Received: from bastet.se.axis.com ([195.60.68.11]:50124 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbbA0Q1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:27:07 -0500
Date: Tue, 27 Jan 2015 17:27:05 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH v2 06/40] cris/uaccess: fix sparse errors
Message-ID: <20150127162705.GB26817@axis.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
 <1420558883-10131-7-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-7-git-send-email-mst@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 04:43:50PM +0100, Michael S. Tsirkin wrote:
> virtio wants to read bitwise types from userspace using get_user.  At the
> moment this triggers sparse errors, since the value is passed through an
> integer.
> 
> Fix that up using __force.

Looks sane, I'll take this in the CRIS tree since you
have a cleanup patch which depends on it.

Thanks!

/Jesper

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/cris/include/asm/uaccess.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/cris/include/asm/uaccess.h b/arch/cris/include/asm/uaccess.h
> index 9145408..9cf5a23 100644
> --- a/arch/cris/include/asm/uaccess.h
> +++ b/arch/cris/include/asm/uaccess.h
> @@ -153,7 +153,7 @@ struct __large_struct { unsigned long buf[100]; };
>  ({								\
>  	long __gu_err, __gu_val;				\
>  	__get_user_size(__gu_val,(ptr),(size),__gu_err);	\
> -	(x) = (__typeof__(*(ptr)))__gu_val;			\
> +	(x) = (__force __typeof__(*(ptr)))__gu_val;		\
>  	__gu_err;						\
>  })
>  
> @@ -163,7 +163,7 @@ struct __large_struct { unsigned long buf[100]; };
>  	const __typeof__(*(ptr)) *__gu_addr = (ptr);			\
>  	if (access_ok(VERIFY_READ,__gu_addr,size))			\
>  		__get_user_size(__gu_val,__gu_addr,(size),__gu_err);	\
> -	(x) = (__typeof__(*(ptr)))__gu_val;				\
> +	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
>  	__gu_err;							\
>  })
>  
> -- 
> MST

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
