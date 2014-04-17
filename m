Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbaDQD2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 23:28:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbaDQD2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 23:28:33 -0400
Date: Wed, 16 Apr 2014 20:28:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging:Line6:usbdefs.h parenthesis for Marcos
Message-ID: <20140417032837.GA3380@kroah.com>
References: <1396973486-30547-1-git-send-email-paulmcquad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396973486-30547-1-git-send-email-paulmcquad@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 05:11:26PM +0100, Paul McQuade wrote:
> ERROR: Macros with complex values should be enclosed in parenthesis
> 
> Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
> ---
>  drivers/staging/line6/usbdefs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/line6/usbdefs.h b/drivers/staging/line6/usbdefs.h
> index 2d1cc47..48958b5 100644
> --- a/drivers/staging/line6/usbdefs.h
> +++ b/drivers/staging/line6/usbdefs.h
> @@ -40,7 +40,7 @@
>  #define LINE6_DEVID_TONEPORT_UX2  0x4142
>  #define LINE6_DEVID_VARIAX        0x534d
>  
> -#define LINE6_BIT(x) LINE6_BIT_ ## x = 1 << LINE6_INDEX_ ## x
> +#define LINE6_BIT(x) (LINE6_BIT_ ## x = 1 << LINE6_INDEX_ ## x)

I love this one, it gets people all the time who don't actually test
their changes...

Hint, it breaks the build, which isn't nice at all.  Please ALWAYS test
build your kernel changes, don't break other people's build boxes...

greg k-h
