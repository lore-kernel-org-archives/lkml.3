Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaIJJ2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 05:28:40 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:59606 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbaIJJ2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 05:28:37 -0400
Date: Wed, 10 Sep 2014 10:28:32 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] Input: atmel_mxt_ts: Add of node type to the i2c table
Message-ID: <20140910092832.GM30307@lee--X1>
References: <1410249158-18192-1-git-send-email-sjoerd.simons@collabora.co.uk>
 <540ED495.20609@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <540ED495.20609@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Sep 2014, Javier Martinez Canillas wrote:

> [adding Lee Jones to cc list since I'm referring on a series he posted]
> 
> Hello Sjoerd,
> 
> On 09/09/2014 09:52 AM, Sjoerd Simons wrote:
> > For i2c devices in OF the modalias exposed to userspace is i2c:<node
> > type>, for the Maxtouch driver this is i2c:maxtouch.
> > 
> > Add maxtouch to the i2c id table such that userspace can correctly
> > load the module for the device and drop the OF table as it's not
> > needed for i2c devices.
> > 
> > Signed-off-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
> > ---
> >  drivers/input/touchscreen/atmel_mxt_ts.c | 8 +-------
> >  1 file changed, 1 insertion(+), 7 deletions(-)
> > 
> > diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> > index db178ed..57ff26d 100644
> > --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> > +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> > @@ -2267,16 +2267,11 @@ static int mxt_resume(struct device *dev)
> >  
> >  static SIMPLE_DEV_PM_OPS(mxt_pm_ops, mxt_suspend, mxt_resume);
> >  
> > -static const struct of_device_id mxt_of_match[] = {
> > -	{ .compatible = "atmel,maxtouch", },
> > -	{},
> > -};
> > -MODULE_DEVICE_TABLE(of, mxt_of_match);
> > -
> >  static const struct i2c_device_id mxt_id[] = {
> >  	{ "qt602240_ts", 0 },
> >  	{ "atmel_mxt_ts", 0 },
> >  	{ "atmel_mxt_tp", 0 },
> > +	{ "maxtouch", 0 },
> >  	{ "mXT224", 0 },
> >  	{ }
> >  };
> > @@ -2286,7 +2281,6 @@ static struct i2c_driver mxt_driver = {
> >  	.driver = {
> >  		.name	= "atmel_mxt_ts",
> >  		.owner	= THIS_MODULE,
> > -		.of_match_table = of_match_ptr(mxt_of_match),
> >  		.pm	= &mxt_pm_ops,
> >  	},
> >  	.probe		= mxt_probe,
> > 
> 
> I see that Lee is working to allow the I2C subsystem to not need an I2C ID
> table to match [0]. I'll let Lee to comment what the future plans are and if
> his series are going to solve your issue since I'm not that familiar with the
> I2C core.

It's wrong to expect DT to probe these devices without a compatible
string.  It does so at the moment, but this is a bi-product and not
the correct method.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
