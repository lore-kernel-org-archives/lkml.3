Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbaFCILq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 04:11:46 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:44768 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250AbaFCILn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 04:11:43 -0400
Date: Tue, 3 Jun 2014 09:11:36 +0100
From: Lee Jones <lee.jones@linaro.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wsa@the-dreams.de, linus.walleij@linaro.org, grant.likely@linaro.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 3/3] i2c: Make I2C ID tables non-mandatory for DT'ed
 and/or ACPI'ed devices
Message-ID: <20140603081136.GE3060@lee--X1>
References: <1401716463-23457-1-git-send-email-lee.jones@linaro.org>
 <1401716463-23457-4-git-send-email-lee.jones@linaro.org>
 <20140602153417.2065c1a5@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140602153417.2065c1a5@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2014, One Thousand Gnomes wrote:

> On Mon,  2 Jun 2014 14:41:03 +0100
> Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Currently the I2C framework insists on devices supplying an I2C ID
> > table.  Many of the devices which do so unnecessarily adding quite a
> > few wasted lines to kernel code.  This patch allows drivers a means
> > to 'not' supply the aforementioned table and match on either DT
> > and/or ACPI match tables instead.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/i2c/i2c-core.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> > index d0c7180..811b78f 100644
> > --- a/drivers/i2c/i2c-core.c
> > +++ b/drivers/i2c/i2c-core.c
> > @@ -271,7 +271,18 @@ static int i2c_device_probe(struct device *dev)
> >  		return 0;
> >  
> >  	driver = to_i2c_driver(dev->driver);
> > -	if (!driver->probe || !driver->id_table)
> > +	if (!driver->probe)
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * An I2C ID table is not madatory, if and only if, a suitable Device
> 
> typo "madatory"..
> 
> > +	 * Tree and/or ACPI match table entry is supplied for the probing
> > +	 * device.
> > +	 *
> > +	 * TODO: Provide 'device type' to 'ACPI node' call and match here.
> > +	 */
> > +	if (!driver->id_table &&
> > +	    !of_match_device(dev->driver->of_match_table, dev))
> >  		return -ENODEV;
> >  
> 
> Looks sensible to me other than that.

Can I add your Ack once the typo is fixed?

> >  	if (!device_can_wakeup(&client->dev))

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
