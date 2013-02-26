Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053Ab3BZJUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 04:20:49 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:56713 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759876Ab3BZJUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 04:20:33 -0500
Date: Tue, 26 Feb 2013 11:20:22 +0200
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Media: remove incorrect __init/__exit markups
Message-ID: <20130226092022.GA14209@itanic.dhcp.inet.fi>
References: <20130226071726.GA11322@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226071726.GA11322@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.25 2013 23:17:27, Dmitry Torokhov wrote:
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
> diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
> index 8ead492..31b955b 100644
> --- a/drivers/media/rc/ir-rx51.c
> +++ b/drivers/media/rc/ir-rx51.c
> @@ -464,14 +464,14 @@ static int lirc_rx51_probe(struct platform_device *dev)
>  	return 0;
>  }
>  
> -static int __exit lirc_rx51_remove(struct platform_device *dev)
> +static int lirc_rx51_remove(struct platform_device *dev)
>  {
>  	return lirc_unregister_driver(lirc_rx51_driver.minor);
>  }
>  
>  struct platform_driver lirc_rx51_platform_driver = {
>  	.probe		= lirc_rx51_probe,
> -	.remove		= __exit_p(lirc_rx51_remove),
> +	.remove		= lirc_rx51_remove,
>  	.suspend	= lirc_rx51_suspend,
>  	.resume		= lirc_rx51_resume,
>  	.driver		= {

For ir-rx51:

Acked-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>

Thanks!

-Timo
