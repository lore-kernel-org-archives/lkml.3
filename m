Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaEDV1D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 17:27:03 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59941 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492AbaEDV1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 17:27:01 -0400
X-Sasl-enc: 2FWGxku1i/O8nyogHOw41e04FGRXgpojZtaZAEcvlrrf 1399238820
Date: Sun, 4 May 2014 17:26:58 -0400
From: Greg KH <greg@kroah.com>
To: =?iso-8859-1?Q?Cl=E9ment?= Calmels <clement.calmels@free.fr>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6655: correct coding style issue
Message-ID: <20140504212658.GA28438@kroah.com>
References: <1399233129-13436-1-git-send-email-clement.calmels@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399233129-13436-1-git-send-email-clement.calmels@free.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2014 at 09:52:09PM +0200, Clément Calmels wrote:
> Remove C99 comment and rewrite lines over 80 characters.
> Warnings and error found by checkpatch.pl script.
> 
> Signed-off-by: Clément Calmels <clement.calmels@free.fr>
> ---
>  drivers/staging/vt6655/tmacro.h | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/vt6655/tmacro.h b/drivers/staging/vt6655/tmacro.h
> index 59c6e72..264c6ed 100644
> --- a/drivers/staging/vt6655/tmacro.h
> +++ b/drivers/staging/vt6655/tmacro.h
> @@ -44,17 +44,22 @@
>  #define LOWORD(d)           ((unsigned short)(d))
>  #endif
>  #if !defined(HIWORD)
> -#define HIWORD(d)           ((unsigned short)((((unsigned long)(d)) >> 16) & 0xFFFF))
> +#define HIWORD(d)							\
> +	((unsigned short)((((unsigned long)(d)) >> 16) & 0xFFFF))
>  #endif
>  
>  #define LODWORD(q)          ((q).u.dwLowDword)
>  #define HIDWORD(q)          ((q).u.dwHighDword)
>  
>  #if !defined(MAKEWORD)
> -#define MAKEWORD(lb, hb)    ((unsigned short)(((unsigned char)(lb)) | (((unsigned short)((unsigned char)(hb))) << 8)))
> +#define MAKEWORD(lb, hb)\
> +	((unsigned short)(((unsigned char)(lb))				\
> +			  | (((unsigned short)((unsigned char)(hb))) << 8)))
>  #endif
>  #if !defined(MAKEDWORD)
> -#define MAKEDWORD(lw, hw)   ((unsigned long)(((unsigned short)(lw)) | (((unsigned long)((unsigned short)(hw))) << 16)))
> +#define MAKEDWORD(lw, hw)\
> +	((unsigned long)(((unsigned short)(lw))				\
> +			 | (((unsigned long)((unsigned short)(hw))) << 16)))
>  #endif
>  
> -#endif // __TMACRO_H__
> +#endif /* __TMACRO_H__ */

Why not just switch to use the built-in macros the kernel provides for
this?

greg k-h
