Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaIXKOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:14:00 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:35004 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbaIXKN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:13:58 -0400
Date: Wed, 24 Sep 2014 11:13:52 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, johan@kernel.org
Subject: Re: [PATCH v2 2/2] mfd: viperboard: remove redundant OOM message and
 NULL pointer check
Message-ID: <20140924101352.GE19999@lee--X1>
References: <1411414759-7056-1-git-send-email-octavian.purdila@intel.com>
 <1411414759-7056-3-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411414759-7056-3-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014, Octavian Purdila wrote:

> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> ---
>  drivers/mfd/viperboard.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)

Looks fine, but won't apply without patch 1.

> diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
> index 5f62f4e..d27c131 100644
> --- a/drivers/mfd/viperboard.c
> +++ b/drivers/mfd/viperboard.c
> @@ -59,10 +59,8 @@ static int vprbrd_probe(struct usb_interface *interface,
>  
>  	/* allocate memory for our device state and initialize it */
>  	vb = kzalloc(sizeof(*vb), GFP_KERNEL);
> -	if (vb == NULL) {
> -		dev_err(&interface->dev, "Out of memory\n");
> +	if (vb == NULL)
>  		return -ENOMEM;
> -	}
>  
>  	vb->buf = kzalloc(sizeof(struct vprbrd_i2c_write_msg), GFP_KERNEL);
>  	if (vb->buf == NULL) {
> @@ -109,11 +107,9 @@ static int vprbrd_probe(struct usb_interface *interface,
>  	return 0;
>  
>  error:
> -	if (vb) {
> -		usb_put_dev(vb->usb_dev);
> -		kfree(vb->buf);
> -		kfree(vb);
> -	}
> +	usb_put_dev(vb->usb_dev);
> +	kfree(vb->buf);
> +	kfree(vb);
>  
>  	return ret;
>  }

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
