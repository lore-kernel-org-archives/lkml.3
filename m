Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaEIHc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:32:59 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48266 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751055AbaEIHc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:32:57 -0400
Date: Fri, 9 May 2014 10:32:52 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: m.chehab@samsung.com, linux-dev@sensoray.com, hans.verkuil@cisco.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] s2255drv: fix memory leak s2255_probe()
Message-ID: <20140509073252.GI8753@valkosipuli.retiisi.org.uk>
References: <20140508225718.GA24276@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508225718.GA24276@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daeseok,

Thanks for the update! :-)

On Fri, May 09, 2014 at 07:57:18AM +0900, Daeseok Youn wrote:
> smatch says:
>  drivers/media/usb/s2255/s2255drv.c:2246 s2255_probe() warn:
> possible memory leak of 'dev'
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
> V2: use the same pattern for error handling.
> 
>  drivers/media/usb/s2255/s2255drv.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
> index 1d4ba2b..3193474 100644
> --- a/drivers/media/usb/s2255/s2255drv.c
> +++ b/drivers/media/usb/s2255/s2255drv.c
> @@ -2243,7 +2243,7 @@ static int s2255_probe(struct usb_interface *interface,
>  	dev->cmdbuf = kzalloc(S2255_CMDBUF_SIZE, GFP_KERNEL);
>  	if (dev->cmdbuf == NULL) {
>  		s2255_dev_err(&interface->dev, "out of memory\n");
> -		return -ENOMEM;
> +		goto errorFWDATA1;
>  	}
>  
>  	atomic_set(&dev->num_channels, 0);

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
