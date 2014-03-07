Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbaCGIPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 03:15:00 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:40369 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaCGIO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 03:14:59 -0500
Date: Fri, 7 Mar 2014 11:14:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: gregkh@linuxfoundation.org, d@teklibre.com, paul.gortmaker@windriver.com,
        sara.bird.iar@gmail.com, standby24x7@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: frontier: fix memory leak in
 usb_alphatrack_probe()
Message-ID: <20140307081441.GD4774@mwanda>
References: <2118769.zIlmIgrC0S@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2118769.zIlmIgrC0S@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 05:02:25PM +0900, Daeseok Youn wrote:
> 
> oldi_buffer and write_buffer need to free when usb_alphatrack_delete()
> is called.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  drivers/staging/frontier/alphatrack.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
> index edd5cef..4d630da 100644
> --- a/drivers/staging/frontier/alphatrack.c
> +++ b/drivers/staging/frontier/alphatrack.c
> @@ -208,6 +208,8 @@ static void usb_alphatrack_delete(struct usb_alphatrack *dev)
>  	kfree(dev->ring_buffer);
>  	kfree(dev->interrupt_in_buffer);
>  	kfree(dev->interrupt_out_buffer);
> +	kfree(dev->oldi_buffer);
> +	kfree(dev->write_buffer);
>  	kfree(dev);		/* fixme oldi_buffer */
                                   ^^^^^^^^^^^^^^^^^
Remove this comment now?

regards,
dan carpenter

