Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaHSUYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 16:24:44 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:51890 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaHSUYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 16:24:42 -0400
Date: Tue, 19 Aug 2014 13:24:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Murphy, Dan" <dmurphy@ti.com>
Cc: "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v6] input: drv260x: Add TI drv260x haptics driver
Message-ID: <20140819202438.GD3626@core.coreip.homeip.net>
References: <1408117670-19750-1-git-send-email-dmurphy@ti.com>
 <20140819192401.GA32080@core.coreip.homeip.net>
 <00FC9A978A94B7418C33AFAE8A35ED49DEC1EF@DFLE09.ent.ti.com>
 <20140819200748.GB3626@core.coreip.homeip.net>
 <00FC9A978A94B7418C33AFAE8A35ED49DEC3E6@DFLE09.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00FC9A978A94B7418C33AFAE8A35ED49DEC3E6@DFLE09.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 08:13:32PM +0000, Murphy, Dan wrote:
> On 08/19/2014 03:07 PM, Dmitry Torokhov wrote:
> > On Tue, Aug 19, 2014 at 07:35:06PM +0000, Murphy, Dan wrote:
> >> Dmitry
> >>
> >> On 08/19/2014 02:24 PM, Dmitry Torokhov wrote:
> >>> Hi Dan,
> >>>
> >>> On Fri, Aug 15, 2014 at 10:47:50AM -0500, Dan Murphy wrote:
> >>>> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> >>>> index 2ff4425..99f6762 100644
> >>>> --- a/drivers/input/misc/Kconfig
> >>>> +++ b/drivers/input/misc/Kconfig
> >>>> @@ -676,4 +676,13 @@ config INPUT_SOC_BUTTON_ARRAY
> >>>>  	  To compile this driver as a module, choose M here: the
> >>>>  	  module will be called soc_button_array.
> >>>>  
> >>>> +config INPUT_DRV260X_HAPTICS
> >>>> +	tristate "TI DRV260X haptics support"
> >>>> +	depends on INPUT && I2C
> >>>
> >>> This also needs "select REGMAP_I2C"
> >>>
> >>
> >> This one is OK
> >>
> >>>> +	help
> >>>> +	  Say Y to enable support for the TI DRV260X haptics driver.
> >>>> +
> >>>> +	  To compile this driver as a module, choose M here: the
> >>>> +	  module will be called drv260x-haptics.
> >>>> +
> >>>
> >>> [...]
> >>>
> >>>> +#ifndef _LINUX_DRV260X_PDATA_H
> >>>> +#define _LINUX_DRV260X_PDATA_H
> >>>> +
> >>>> +struct drv260x_platform_data {
> >>>> +	int enable_gpio;
> >>>
> >>> I do not see this used anywhere.
> >>
> >> But this is actually used here
> >>
> >> haptics->enable_gpio = devm_gpiod_get(&client->dev, "enable");
> >>
> >> for the non-dt case
> > 
> > "haptics" is not instance of drv260x_platform_data but drv260x_data which
> > defines:
> > 
> > struct drv260x_data {
> > 	...
> > 	struct gpio_desc *enable_gpio;
> > 	...
> > 
> > That one I kept.
> > 
> 
> Yes that is correct but the enable_gpio for non-dt enabled devices this enable_gpio
> needs to come from the platform data structure.  Without the enable gpio in the platform data
> structure there is no way for non-dt enabled devices to set the gpio value.

What else uses the platform data structure? You are accessing gpio by name, not
by number, in the driver so I am not sure how non-dt case will use u32 defined
in platform data.

> 
> The haptics instance just stores the gpio descriptor returned from this call.

Right.

> 
> The devm_gpiod looks at the platform data is CONFIG_OF is not set.

Umm, how? You do not pass it anywhere...

Thanks.

-- 
Dmitry
