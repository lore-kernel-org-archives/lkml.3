Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161125AbaDQDQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 23:16:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757106AbaDQDQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 23:16:10 -0400
Date: Wed, 16 Apr 2014 20:16:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mathieu Maret <mathieu.maret@gmail.com>
Cc: devel@driverdev.osuosl.org, serban.constantinescu@arm.com,
        linux-kernel@vger.kernel.org, arve@android.com, joe@perches.com,
        prtvar.b@gmail.com
Subject: Re: [PATCH RESEND 2/2] staging: binder: Code simplification
Message-ID: <20140417031614.GB20339@kroah.com>
References: <1397556186-5465-1-git-send-email-mathieu.maret@gmail.com>
 <1397556186-5465-2-git-send-email-mathieu.maret@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397556186-5465-2-git-send-email-mathieu.maret@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 12:03:06PM +0200, Mathieu Maret wrote:
> Remove duplicate code
> 
> Signed-off-by: Mathieu Maret <mathieu.maret@gmail.com>
> ---
>  drivers/staging/android/binder.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index 3dca577..c29c3c7 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -2686,11 +2686,8 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  	case BINDER_VERSION:{
>  		struct binder_version __user *ver = ubuf;
>  
> -		if (size != sizeof(struct binder_version)) {
> -			ret = -EINVAL;
> -			goto err;
> -		}
> -		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION,
> +		if (size != sizeof(struct binder_version) ||
> +		    put_user(BINDER_CURRENT_PROTOCOL_VERSION,
>  			     &ver->protocol_version)) {
>  			ret = -EINVAL;
>  			goto err;

I agree with Dan, the original code was easier to read.

thanks,

greg k-h
