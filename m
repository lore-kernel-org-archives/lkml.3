Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaKCWac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 17:30:32 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41174 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaKCWaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 17:30:30 -0500
Date: Mon, 3 Nov 2014 22:30:22 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: gyungoh@gmail.com, sameo@linux.intel.com, jg1.han@samsung.com,
        cooloney@gmail.com, broonie@kernel.org, lgirdwood@gmail.com,
        jack.yoo@skyworksinc.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Subject: Re: [RESUBMIT PATCH v6 1/8] mfd: Add support for Skyworks SKY81452
 driver
Message-ID: <20141103223022.GE13359@x1>
References: <1414393369-31583-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-2-git-send-email-jack.yoo@skyworksinc.com>
 <20141103171451.GG12011@x1>
 <1415050088.20372.72.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415050088.20372.72.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2014, Paul Bolle wrote:

> On Mon, 2014-11-03 at 17:14 +0000, Lee Jones wrote:
> >On Fri, 31 Oct 2014, gyungoh@gmail.com wrote:
> > Code looks fine, but what are its dependencies.  I'm assuming nothing;
> > however, did Mark say that something depends on it?
> 
> That would be REGULATOR_SKY81452. That is currently dangling (since
> v3.18-rc1) as it depends on the non-existent symbol SKY81452.
> 
> > If so, what and what are you going to do about it?
> 
> See 7/8. That patch makes REGULATOR_SKY81452 depend on MFD_SKY81452,
> making it buildable.

Okay, so I can take this patch with no fall-out then.

> > > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > > index 1456ea7..a54244c 100644
> > > --- a/drivers/mfd/Kconfig
> > > +++ b/drivers/mfd/Kconfig
> > > @@ -693,6 +693,18 @@ config MFD_SM501_GPIO
> > >  	 lines on the SM501. The platform data is used to supply the
> > >  	 base number for the first GPIO line to register.
> > >  
> > > +config MFD_SKY81452
> > > +	tristate "Skyworks Solutions SKY81452"
> > > +	select MFD_CORE
> > > +	select REGMAP_I2C
> > > +	depends on I2C
> > > +	help
> > > +	  This is the core driver for the Skyworks SKY81452 backlight and
> > > +	  voltage regulator device.
> > > +
> > > +	  This driver can also be built as a module.  If so, the module
> > > +	  will be called sky81452.
> > > +
> > >  config MFD_SMSC
> > >         bool "SMSC ECE1099 series chips"
> > >         depends on I2C=y
> 
> 
> Paul Bolle
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
