Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbaH0EGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 00:06:40 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39965 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaH0EGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 00:06:38 -0400
Date: Wed, 27 Aug 2014 13:06:29 +0900
From: Gyungoh Yoo <gyungoh@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        grant.likely@linaro.org, sameo@linux.intel.com,
        jack.yoo@skyworksinc.com, jason@lakedaemon.net,
        heiko.stuebner@bqreaders.com, florian.vaussard@epfl.ch,
        thierry.reding@gmail.com, andrew@lunn.ch, silvio.fricke@gmail.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Adding Skyworks SKY81452 MFD driver
Message-ID: <20140827040629.GA3401@jack-ThinkPad-T520>
References: <1407488899-31065-1-git-send-email-jack.yoo@skyworksinc.com>
 <20140821094502.GV4266@lee--X1>
 <20140825070608.GA6230@jack-ThinkPad-T520>
 <20140826082258.GC9574@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140826082258.GC9574@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 09:22:58AM +0100, Lee Jones wrote:
> On Mon, 25 Aug 2014, Gyungoh Yoo wrote:
> > On Thu, Aug 21, 2014 at 10:45:02AM +0100, Lee Jones wrote:
> > > When you send patch-sets, you should send them connected to one
> > > another AKA threaded.  That way, when we're reviewing we can look at
> > > the other patches in the set for reference.  See the man page for `git
> > > send-email` for details.
> > > 
> > > <commit log>
> > > 
> > > > Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> > > > ---
> 
> [...]
> 
> > > > +static int sky81452_register_devices(struct device *dev,
> > > > +		const struct sky81452_platform_data *pdata)
> > > > +{
> > > > +	struct mfd_cell cells[] = {
> > > > +		{
> > > > +			.name = "sky81452-bl",
> > > > +			.platform_data = pdata->bl_pdata,
> > > > +			.pdata_size = sizeof(*pdata->bl_pdata),
> > > 
> > > Have you tested this with DT?
> > > 
> > > You're not passing the compatible string and not using
> > > of_platform_populate() so I'm struggling to see how it would work
> > > properly.
> > 
> > sky81452-bl and regulator-sky81452 is parsing the information
> > in regulator node of its parent node. So I thought these 2 drivers
> > don't need compatible attribute. That is what it didn't have
> > compatible string.
> > Is is mandatory that all drivers should have compatible attribute?
> 
> How do they obtain their DT nodes?

The backlight driver which is one of the child driver is obtain its DT node like this

np = of_get_child_by_name(dev->parent->of_node, "backlight");

> 
> [...]
> 
> > > > +	return mfd_add_devices(dev, -1, cells, ARRAY_SIZE(cells),
> > > > +			NULL, 0, NULL);
> > > 
> > > This doesn't really need to be in a function of its own.  Please put
> > > it in .probe().  Also check for the return value and present the user
> > > with an error message if it fails.
> > 
> > I think this need to be, in case of !CONFIG_OF.
> > Can you please explain more in details?
> 
> Then how to you obtain the shared register map you created?

regmap is stored in driver data in MFD.

i2c_set_clientdata(client, regmap);

The child drivers obain the regmap from the parent.

struct regmap *regmap = dev_get_drvdata(dev->parent);

> 
> [...]
> 
> -- 
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
