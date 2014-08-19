Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaHSUHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 16:07:54 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33380 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaHSUHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 16:07:52 -0400
Date: Tue, 19 Aug 2014 13:07:48 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Murphy, Dan" <dmurphy@ti.com>
Cc: "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v6] input: drv260x: Add TI drv260x haptics driver
Message-ID: <20140819200748.GB3626@core.coreip.homeip.net>
References: <1408117670-19750-1-git-send-email-dmurphy@ti.com>
 <20140819192401.GA32080@core.coreip.homeip.net>
 <00FC9A978A94B7418C33AFAE8A35ED49DEC1EF@DFLE09.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00FC9A978A94B7418C33AFAE8A35ED49DEC1EF@DFLE09.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 07:35:06PM +0000, Murphy, Dan wrote:
> Dmitry
> 
> On 08/19/2014 02:24 PM, Dmitry Torokhov wrote:
> > Hi Dan,
> > 
> > On Fri, Aug 15, 2014 at 10:47:50AM -0500, Dan Murphy wrote:
> >> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> >> index 2ff4425..99f6762 100644
> >> --- a/drivers/input/misc/Kconfig
> >> +++ b/drivers/input/misc/Kconfig
> >> @@ -676,4 +676,13 @@ config INPUT_SOC_BUTTON_ARRAY
> >>  	  To compile this driver as a module, choose M here: the
> >>  	  module will be called soc_button_array.
> >>  
> >> +config INPUT_DRV260X_HAPTICS
> >> +	tristate "TI DRV260X haptics support"
> >> +	depends on INPUT && I2C
> > 
> > This also needs "select REGMAP_I2C"
> > 
> 
> This one is OK
> 
> >> +	help
> >> +	  Say Y to enable support for the TI DRV260X haptics driver.
> >> +
> >> +	  To compile this driver as a module, choose M here: the
> >> +	  module will be called drv260x-haptics.
> >> +
> > 
> > [...]
> > 
> >> +#ifndef _LINUX_DRV260X_PDATA_H
> >> +#define _LINUX_DRV260X_PDATA_H
> >> +
> >> +struct drv260x_platform_data {
> >> +	int enable_gpio;
> > 
> > I do not see this used anywhere.
> 
> But this is actually used here
> 
> haptics->enable_gpio = devm_gpiod_get(&client->dev, "enable");
> 
> for the non-dt case

"haptics" is not instance of drv260x_platform_data but drv260x_data which
defines:

struct drv260x_data {
	...
	struct gpio_desc *enable_gpio;
	...

That one I kept.

-- 
Dmitry
