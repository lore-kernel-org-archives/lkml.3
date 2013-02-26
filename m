Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580Ab3BZIZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 03:25:41 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48246 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758511Ab3BZIZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 03:25:40 -0500
Date: Tue, 26 Feb 2013 10:25:34 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Media: remove incorrect __init/__exit markups
Message-ID: <20130226082534.GD24184@valkosipuli.retiisi.org.uk>
References: <20130226071726.GA11322@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226071726.GA11322@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Mon, Feb 25, 2013 at 11:17:27PM -0800, Dmitry Torokhov wrote:
> Even if bus is not hot-pluggable, the devices can be unbound from the
> driver via sysfs, so we should not be using __exit annotations on
> remove() methods. The only exception is drivers registered with
> platform_driver_probe() which specifically disables sysfs bind/unbind
> attributes.
> 
> Similarly probe() methods should not be marked __init unless
> platform_driver_probe() is used.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
> 
> v1->v2: removed __init markup on omap1_cam_probe() that was pointed out
> 	by Guennadi Liakhovetski.
> 
>  drivers/media/i2c/adp1653.c                      | 4 ++--
>  drivers/media/i2c/smiapp/smiapp-core.c           | 4 ++--
>  drivers/media/platform/soc_camera/omap1_camera.c | 6 +++---
>  drivers/media/radio/radio-si4713.c               | 4 ++--
>  drivers/media/rc/ir-rx51.c                       | 4 ++--
>  5 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
> index df16380..ef75abe 100644
> --- a/drivers/media/i2c/adp1653.c
> +++ b/drivers/media/i2c/adp1653.c
> @@ -447,7 +447,7 @@ free_and_quit:
>  	return ret;
>  }
>  
> -static int __exit adp1653_remove(struct i2c_client *client)
> +static int adp1653_remove(struct i2c_client *client)
>  {
>  	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
>  	struct adp1653_flash *flash = to_adp1653_flash(subdev);
> @@ -476,7 +476,7 @@ static struct i2c_driver adp1653_i2c_driver = {
>  		.pm	= &adp1653_pm_ops,
>  	},
>  	.probe		= adp1653_probe,
> -	.remove		= __exit_p(adp1653_remove),
> +	.remove		= adp1653_remove,
>  	.id_table	= adp1653_id_table,
>  };
>  
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> index 83c7ed7..cae4f46 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -2833,7 +2833,7 @@ static int smiapp_probe(struct i2c_client *client,
>  				 sensor->src->pads, 0);
>  }
>  
> -static int __exit smiapp_remove(struct i2c_client *client)
> +static int smiapp_remove(struct i2c_client *client)
>  {
>  	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
>  	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> @@ -2881,7 +2881,7 @@ static struct i2c_driver smiapp_i2c_driver = {
>  		.pm = &smiapp_pm_ops,
>  	},
>  	.probe	= smiapp_probe,
> -	.remove	= __exit_p(smiapp_remove),
> +	.remove	= smiapp_remove,
>  	.id_table = smiapp_id_table,
>  };
>  

For adp1653 and smiapp:

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
