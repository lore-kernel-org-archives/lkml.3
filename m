Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbaDPX6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 19:58:31 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33871 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbaDPX63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 19:58:29 -0400
Date: Thu, 17 Apr 2014 02:58:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Yves Deweerdt <yves.deweerdt.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Bojan Prtvar <prtvar.b@gmail.com>, mathieu.maret@gmail.com
Subject: Re: [PATCH] staging: android: binder.c: avoid sparse checker
 warning: cast removes address space of expression
Message-ID: <20140416235810.GU26890@mwanda>
References: <534EEB29.9020900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534EEB29.9020900@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 10:42:17PM +0200, Yves Deweerdt wrote:
> 
> __user should be kept when casting to struct binder_version *
> 
> 

Mathieu sent this one earlier.
http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2014-April/048614.html

His is perfect, except that he missed the space in the ": {", but it's
still ok.

regards,
dan carpenter

> Signed-off-by: Yves Deweerdt <yves.deweerdt.linux@gmail.com>
> ---
>  drivers/staging/android/binder.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index cfe4bc8..0f74e43 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -2683,16 +2683,21 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		binder_free_thread(proc, thread);
>  		thread = NULL;
>  		break;
> -	case BINDER_VERSION:
> +	case BINDER_VERSION: {
> +		struct binder_version __user *bv =
> +			(struct binder_version __user *)ubuf;
> +
>  		if (size != sizeof(struct binder_version)) {
>  			ret = -EINVAL;
>  			goto err;
>  		}
> -		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION, &((struct binder_version *)ubuf)->protocol_version)) {
> +		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION,
> +				&(bv->protocol_version))) {
>  			ret = -EINVAL;
>  			goto err;
>  		}
>  		break;
> +	}
>  	default:
>  		ret = -EINVAL;
>  		goto err;
> -- 
> 1.8.3.2
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
