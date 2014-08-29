Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaH2K7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 06:59:22 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:42541 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaH2K7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 06:59:20 -0400
Date: Fri, 29 Aug 2014 11:59:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andreas Werner <andreas.werner@men.de>
Cc: Bryan Wu <cooloney@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux@roeck-us.net,
        lm-sensors@lm-sensors.org, wim@iguana.be,
        linux-watchdog@vger.kernel.org,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Subject: Re: [PATCH v6 3/4] drivers/leds/leds-menf21bmc: introduce MEN
 14F021P00 BMC LED driver
Message-ID: <20140829105913.GI24579@lee--X1>
References: <cover.1409161615.git.andreas.werner@men.de>
 <e91e4f47cda55c03fa1d0a54c0891341d73adfa6.1409161615.git.andreas.werner@men.de>
 <CAK5ve-+zjZBw_HXWm9kGE5Vbv=R2SO4P2dB_0opzLHTAV-BQ0Q@mail.gmail.com>
 <20140829065915.GZ24579@lee--X1>
 <20140829113815.GA30736@awelinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140829113815.GA30736@awelinux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2014, Andreas Werner wrote:

> On Fri, Aug 29, 2014 at 07:59:15AM +0100, Lee Jones wrote:
> > On Thu, 28 Aug 2014, Bryan Wu wrote:
> > 
> > > On Wed, Aug 27, 2014 at 10:52 AM, Andreas Werner <andreas.werner@men.de> wrote:
> > > > Added driver to support the 14F021P00 BMC LEDs.
> > > > The BMC is a Board Management Controller including four LEDs which
> > > > can be switched on and off.
> > > >
> > > 
> > > Please go ahead with my Ack
> > > Acked-by: Bryan Wu <cooloney@gmail.com>
> > > 
> > > Lee, will you merge this through your tree? I think we do that in one
> > > shot is better.
> > 
> > Yes, that's fine.  Pull-request to follow.
> > 
> 
> Thanks to all for review.
> 
> Who of you does the Watchdog part? Is it the part of Wim to Ack the patch
> if everythings is right or Guenther?

Wim looks like the guy:

WATCHDOG DEVICE DRIVERS
M:      Wim Van Sebroeck <wim@iguana.be>
L:      linux-watchdog@vger.kernel.org
W:      http://www.linux-watchdog.org/
T:      git git://www.linux-watchdog.org/linux-watchdog.git
S:      Maintained
F:      Documentation/watchdog/
F:      drivers/watchdog/
F:      include/linux/watchdog.h
F:      include/uapi/linux/watchdog.h

> I ask because if everything is ok all the patches can go in completly that would
> be nice.

That is the plan.

> > > > Signed-off-by: Andreas Werner <andreas.werner@men.de>
> > > > ---
> > > >  drivers/leds/Kconfig          |   9 +++
> > > >  drivers/leds/Makefile         |   1 +
> > > >  drivers/leds/leds-menf21bmc.c | 131 ++++++++++++++++++++++++++++++++++++++++++
> > > >  3 files changed, 141 insertions(+)
> > > >  create mode 100644 drivers/leds/leds-menf21bmc.c
> > > >
> > > > diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> > > > index 27cf0cd..ec03457 100644
> > > > --- a/drivers/leds/Kconfig
> > > > +++ b/drivers/leds/Kconfig
> > > > @@ -458,6 +458,15 @@ config LEDS_OT200
> > > >           This option enables support for the LEDs on the Bachmann OT200.
> > > >           Say Y to enable LEDs on the Bachmann OT200.
> > > >
> > > > +config LEDS_MENF21BMC
> > > > +       tristate "LED support for the MEN 14F021P00 BMC"
> > > > +       depends on LEDS_CLASS && MFD_MENF21BMC
> > > > +       help
> > > > +         Say Y here to include support for the MEN 14F021P00 BMC LEDs.
> > > > +
> > > > +         This driver can also be built as a module. If so the module
> > > > +         will be called leds-menf21bmc.
> > > > +
> > > >  comment "LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)"
> > > >
> > > >  config LEDS_BLINKM
> > > > diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> > > > index 3c03666..cadc433 100644
> > > > --- a/drivers/leds/Makefile
> > > > +++ b/drivers/leds/Makefile
> > > > @@ -53,6 +53,7 @@ obj-$(CONFIG_LEDS_MAX8997)            += leds-max8997.o
> > > >  obj-$(CONFIG_LEDS_LM355x)              += leds-lm355x.o
> > > >  obj-$(CONFIG_LEDS_BLINKM)              += leds-blinkm.o
> > > >  obj-$(CONFIG_LEDS_VERSATILE)           += leds-versatile.o
> > > > +obj-$(CONFIG_LEDS_MENF21BMC)           += leds-menf21bmc.o
> > > >
> > > >  # LED SPI Drivers
> > > >  obj-$(CONFIG_LEDS_DAC124S085)          += leds-dac124s085.o
> > > > diff --git a/drivers/leds/leds-menf21bmc.c b/drivers/leds/leds-menf21bmc.c
> > > > new file mode 100644
> > > > index 0000000..89dd577
> > > > --- /dev/null
> > > > +++ b/drivers/leds/leds-menf21bmc.c
> > > > @@ -0,0 +1,131 @@
> > > > +/*
> > > > + *  MEN 14F021P00 Board Management Controller (BMC) LEDs Driver.
> > > > + *
> > > > + *  This is the core LED driver of the MEN 14F021P00 BMC.
> > > > + *  There are four LEDs available which can be switched on and off.
> > > > + *  STATUS LED, HOT SWAP LED, USER LED 1, USER LED 2
> > > > + *
> > > > + *  Copyright (C) 2014 MEN Mikro Elektronik Nuernberg GmbH
> > > > + *
> > > > + *  This program is free software; you can redistribute  it and/or modify it
> > > > + *  under  the terms of  the GNU General  Public License as published by the
> > > > + *  Free Software Foundation;  either version 2 of the  License, or (at your
> > > > + *  option) any later version.
> > > > + */
> > > > +
> > > > +#include <linux/module.h>
> > > > +#include <linux/kernel.h>
> > > > +#include <linux/platform_device.h>
> > > > +#include <linux/leds.h>
> > > > +#include <linux/i2c.h>
> > > > +
> > > > +#define BMC_CMD_LED_GET_SET    0xA0
> > > > +#define BMC_BIT_LED_STATUS     BIT(0)
> > > > +#define BMC_BIT_LED_HOTSWAP    BIT(1)
> > > > +#define BMC_BIT_LED_USER1      BIT(2)
> > > > +#define BMC_BIT_LED_USER2      BIT(3)
> > > > +
> > > > +struct menf21bmc_led {
> > > > +       struct led_classdev cdev;
> > > > +       u8 led_bit;
> > > > +       const char *name;
> > > > +       struct i2c_client *i2c_client;
> > > > +};
> > > > +
> > > > +static struct menf21bmc_led leds[] = {
> > > > +       {
> > > > +               .name = "menf21bmc:led_status",
> > > > +               .led_bit = BMC_BIT_LED_STATUS,
> > > > +       },
> > > > +       {
> > > > +               .name = "menf21bmc:led_hotswap",
> > > > +               .led_bit = BMC_BIT_LED_HOTSWAP,
> > > > +       },
> > > > +       {
> > > > +               .name = "menf21bmc:led_user1",
> > > > +               .led_bit = BMC_BIT_LED_USER1,
> > > > +       },
> > > > +       {
> > > > +               .name = "menf21bmc:led_user2",
> > > > +               .led_bit = BMC_BIT_LED_USER2,
> > > > +       }
> > > > +};
> > > > +
> > > > +static DEFINE_MUTEX(led_lock);
> > > > +
> > > > +static void
> > > > +menf21bmc_led_set(struct led_classdev *led_cdev, enum led_brightness value)
> > > > +{
> > > > +       int led_val;
> > > > +       struct menf21bmc_led *led = container_of(led_cdev,
> > > > +                                       struct menf21bmc_led, cdev);
> > > > +
> > > > +       mutex_lock(&led_lock);
> > > > +       led_val = i2c_smbus_read_byte_data(led->i2c_client,
> > > > +                                          BMC_CMD_LED_GET_SET);
> > > > +       if (led_val < 0)
> > > > +               goto err_out;
> > > > +
> > > > +       if (value == LED_OFF)
> > > > +               led_val &= ~led->led_bit;
> > > > +       else
> > > > +               led_val |= led->led_bit;
> > > > +
> > > > +       i2c_smbus_write_byte_data(led->i2c_client,
> > > > +                                 BMC_CMD_LED_GET_SET, led_val);
> > > > +err_out:
> > > > +       mutex_unlock(&led_lock);
> > > > +}
> > > > +
> > > > +static int menf21bmc_led_probe(struct platform_device *pdev)
> > > > +{
> > > > +       int i;
> > > > +       int ret;
> > > > +       struct i2c_client *i2c_client = to_i2c_client(pdev->dev.parent);
> > > > +
> > > > +       for (i = 0; i < ARRAY_SIZE(leds); i++) {
> > > > +               leds[i].cdev.name = leds[i].name;
> > > > +               leds[i].cdev.brightness_set = menf21bmc_led_set;
> > > > +               leds[i].i2c_client = i2c_client;
> > > > +               ret = led_classdev_register(&pdev->dev, &leds[i].cdev);
> > > > +               if (ret < 0)
> > > > +                       goto err_free_leds;
> > > > +       }
> > > > +       dev_info(&pdev->dev, "MEN 140F21P00 BMC LED device enabled\n");
> > > > +
> > > > +       return 0;
> > > > +
> > > > +err_free_leds:
> > > > +       dev_err(&pdev->dev, "failed to register LED device\n");
> > > > +
> > > > +       for (i = i - 1; i >= 0; i--)
> > > > +               led_classdev_unregister(&leds[i].cdev);
> > > > +
> > > > +       return ret;
> > > > +}
> > > > +
> > > > +static int menf21bmc_led_remove(struct platform_device *pdev)
> > > > +{
> > > > +       int i;
> > > > +
> > > > +       for (i = 0; i < ARRAY_SIZE(leds); i++)
> > > > +               led_classdev_unregister(&leds[i].cdev);
> > > > +
> > > > +       return 0;
> > > > +}
> > > > +
> > > > +static struct platform_driver menf21bmc_led = {
> > > > +       .probe          = menf21bmc_led_probe,
> > > > +       .remove         = menf21bmc_led_remove,
> > > > +       .driver         = {
> > > > +               .name           = "menf21bmc_led",
> > > > +               .owner          = THIS_MODULE,
> > > > +       },
> > > > +};
> > > > +
> > > > +module_platform_driver(menf21bmc_led);
> > > > +
> > > > +MODULE_AUTHOR("Andreas Werner <andreas.werner@men.de>");
> > > > +MODULE_DESCRIPTION("MEN 14F021P00 BMC led driver");
> > > > +MODULE_LICENSE("GPL v2");
> > > > +MODULE_ALIAS("platform:menf21bmc_led");
> > > >
> > 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
