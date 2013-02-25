Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab3BYRf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 12:35:26 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:45204 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758411Ab3BYRfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 12:35:23 -0500
Date: Mon, 25 Feb 2013 09:35:18 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Media: remove incorrect __exit markups
Message-ID: <20130225173518.GA6059@core.coreip.homeip.net>
References: <20130225032215.GA9352@core.coreip.homeip.net>
 <Pine.LNX.4.64.1302250847540.3030@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1302250847540.3030@axis700.grange>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 08:49:26AM +0100, Guennadi Liakhovetski wrote:
> Hi Dmitry
> 
> On Sun, 24 Feb 2013, Dmitry Torokhov wrote:
> 
> > Even if bus is not hot-pluggable, the devices can be unbound from the
> > driver via sysfs, so we should not be using __exit annotations on
> > remove() methods. The only exception is drivers registered with
> > platform_driver_probe() which specifically disables sysfs bind/unbind
> > attributes.
> > 
> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > ---
> >  drivers/media/i2c/adp1653.c                      | 4 ++--
> >  drivers/media/i2c/smiapp/smiapp-core.c           | 4 ++--
> >  drivers/media/platform/soc_camera/omap1_camera.c | 4 ++--
> >  drivers/media/radio/radio-si4713.c               | 4 ++--
> >  drivers/media/rc/ir-rx51.c                       | 4 ++--
> >  5 files changed, 10 insertions(+), 10 deletions(-)
> 
> [snip]
> 
> > diff --git a/drivers/media/platform/soc_camera/omap1_camera.c b/drivers/media/platform/soc_camera/omap1_camera.c
> > index 39a77f0..5f548ac 100644
> > --- a/drivers/media/platform/soc_camera/omap1_camera.c
> > +++ b/drivers/media/platform/soc_camera/omap1_camera.c
> > @@ -1677,7 +1677,7 @@ exit:
> >  	return err;
> >  }
> >  
> > -static int __exit omap1_cam_remove(struct platform_device *pdev)
> > +static int omap1_cam_remove(struct platform_device *pdev)
> >  {
> >  	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
> >  	struct omap1_cam_dev *pcdev = container_of(soc_host,
> > @@ -1709,7 +1709,7 @@ static struct platform_driver omap1_cam_driver = {
> >  		.name	= DRIVER_NAME,
> >  	},
> >  	.probe		= omap1_cam_probe,
> > -	.remove		= __exit_p(omap1_cam_remove),
> > +	.remove		= omap1_cam_remove,
> >  };
> >  
> >  module_platform_driver(omap1_cam_driver);
> 
> This looks correct, but don't we also have to remove __init from 
> omap1_cam_probe()? Or would that be a separate patch?

Thanks Guennadi, I missed that one, will update the patch.

-- 
Dmitry
