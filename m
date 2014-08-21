Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbaHUNZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:25:31 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:59151 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbaHUNZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:25:29 -0400
Date: Thu, 21 Aug 2014 14:25:22 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andreas Werner <andreas.werner@men.de>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, wim@iguana.be,
        linux-watchdog@vger.kernel.org, cooloney@gmail.com, rpurdie@rpsys.net,
        linux-leds@vger.kernel.org, jdelvare@suse.de, linux@roeck-us.net,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH v4 1/4] drivers/mfd/menf21bmc: introduce MEN 14F021P00
 BMC MFD Core driver
Message-ID: <20140821132522.GI4266@lee--X1>
References: <cover.1407918792.git.andreas.werner@men.de>
 <ddd9430eafd8f633a586f9a3cc02ade69ed35817.1407918792.git.andreas.werner@men.de>
 <20140821113046.GZ4266@lee--X1>
 <20140821135707.GA16867@awelinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140821135707.GA16867@awelinux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2014, Andreas Werner wrote:
> On Thu, Aug 21, 2014 at 12:30:46PM +0100, Lee Jones wrote:
> > On Wed, 13 Aug 2014, Andreas Werner wrote:
> > > The MEN 14F021P00 Board Management Controller provides an
> > > I2C interface to the host to access the feature implemented in the BMC.
> > > The BMC is a PIC Microntroller assembled on CPCI Card from MEN Mikroelektronik
> > > and on a few Box/Display Computer.
> > > 
> > > Added MFD Core driver, supporting the I2C communication to the device.
> > > 
> > > The MFD driver currently supports the following features:
> > >  	- Watchdog
> > >  	- LEDs
> > > 	- Hwmon (voltage monitoring)
> > > 
> > > Signed-off-by: Andreas Werner <andreas.werner@men.de>
> > > ---
> > >  drivers/mfd/Kconfig     |  12 +++++
> > >  drivers/mfd/Makefile    |   1 +
> > >  drivers/mfd/menf21bmc.c | 132 ++++++++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 145 insertions(+)
> > >  create mode 100644 drivers/mfd/menf21bmc.c
> > > 
> > > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > > index b8d9ca0..bf155b9 100644
> > > --- a/drivers/mfd/Kconfig
> > > +++ b/drivers/mfd/Kconfig
> > > @@ -453,6 +453,18 @@ config MFD_MAX8998
> > >  	  additional drivers must be enabled in order to use the functionality
> > >  	  of the device.
> > >  
> > > +config MFD_MENF21BMC
> > > +	tristate "MEN 14F021P00 Board Management Controller Support"
> > > +	depends on I2C=y
> > 
> > Why must I2C be built-in?
> 
> Sorry my mistake, I2C must not be built in.
> 
> > 
> > > +	select MFD_CORE
> > > +	help
> > > +	  Say yes here to add support for the MEN 14F021P00 BMC
> > > +	  which is a Board Management Controller connected to the I2C bus.
> > > +	  The device supports multiple sub-devices like LED, HWMON  and WDT.
> > > +	  This driver provides common support for accessing the devices;
> > > +	  additional drivers must be enabled in order to use the
> > > +	  functionality of the BMC device.
> > > +
> > 
> > Apart from that the patch looks good to me.
> > 
> > I'm assuming this can go in via the MFD tree by itself?
> 
> Yes why not.
> Do you want to have a single patch for the MFD or
> is it better to wait for the other Subsystem maintainer that I 
> can resend a patch v5?

When you resent, apply my Ack and I'll pick it up when the other
Maintainers are happy.

> > 
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> > 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
