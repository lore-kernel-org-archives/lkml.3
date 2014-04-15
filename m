Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbaDOJdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:33:13 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33018 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751037AbaDOJdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:33:10 -0400
Date: Tue, 15 Apr 2014 12:33:06 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: m.chehab@samsung.com, linux-dev@sensoray.com, hans.verkuil@cisco.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] s2255drv: fix memory leak s2255_probe()
Message-ID: <20140415093305.GE8753@valkosipuli.retiisi.org.uk>
References: <1408657.25U3i1DfG3@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408657.25U3i1DfG3@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daeseok,

On Tue, Apr 15, 2014 at 01:49:34PM +0900, Daeseok Youn wrote:
> 
> smatch says:
>  drivers/media/usb/s2255/s2255drv.c:2246 s2255_probe() warn:
> possible memory leak of 'dev'
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  drivers/media/usb/s2255/s2255drv.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
> index 1d4ba2b..8aca3ef 100644
> --- a/drivers/media/usb/s2255/s2255drv.c
> +++ b/drivers/media/usb/s2255/s2255drv.c
> @@ -2243,6 +2243,7 @@ static int s2255_probe(struct usb_interface *interface,
>  	dev->cmdbuf = kzalloc(S2255_CMDBUF_SIZE, GFP_KERNEL);
>  	if (dev->cmdbuf == NULL) {
>  		s2255_dev_err(&interface->dev, "out of memory\n");
> +		kfree(dev);
>  		return -ENOMEM;
>  	}
>  

The rest of the function already uses goto and labels for error handling. I
think it'd take adding one more. dev is correctly released in other error
cases.

What do you think?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
