Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaIYFrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 01:47:17 -0400
Received: from mail-by2on0111.outbound.protection.outlook.com ([207.46.100.111]:38582
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750774AbaIYFrP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 01:47:15 -0400
From: Muthu Mani <muth@cypress.com>
To: Johan Hovold <johan@kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajaram Regupathy <rera@cypress.com>
Subject: RE: [PATCH 3/3] gpio: add support for Cypress CYUSBS234 USB-GPIO
 adapter
Thread-Topic: [PATCH 3/3] gpio: add support for Cypress CYUSBS234 USB-GPIO
 adapter
Thread-Index: AQHP1kho61TVlGdoYUKymU/GbIk8bpwNCGuAgAM+DYA=
Date: Thu, 25 Sep 2014 05:47:11 +0000
Message-ID: <7e6ba8fdbdb643c885369e37e2bcd25a@BY2PR06MB076.namprd06.prod.outlook.com>
References: <1411378458-18424-1-git-send-email-muth@cypress.com>
 <20140922114357.GG5237@localhost>
In-Reply-To: <20140922114357.GG5237@localhost>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [121.243.89.10]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR06MB453;
x-forefront-prvs: 0345CFD558
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(51704005)(13464003)(24454002)(377454003)(199003)(85306004)(81342003)(86362001)(79102003)(105586002)(83072002)(106116001)(106356001)(2656002)(74502003)(108616004)(80022003)(87936001)(76176999)(10300001)(99396003)(54356999)(99286002)(50986999)(15975445006)(95666004)(15202345003)(66066001)(107046002)(120916001)(85852003)(19580405001)(19580395003)(83322001)(33646002)(101416001)(31966008)(76482002)(90102001)(110136001)(20776003)(74316001)(81542003)(92566001)(97736003)(77982003)(4396001)(64706001)(46102003)(21056001)(77096002)(74662003)(76576001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR06MB453;H:BY2PR06MB076.namprd06.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Johan Hovold [mailto:jhovold@gmail.com] On Behalf Of Johan Hovold
> Sent: Monday, September 22, 2014 5:14 PM
> To: Muthu Mani
> Cc: Samuel Ortiz; Lee Jones; Wolfram Sang; linux-i2c@vger.kernel.org; Linus
> Walleij; Alexandre Courbot; linux-gpio@vger.kernel.org;
> gregkh@linuxfoundation.org; linux-usb@vger.kernel.org; linux-
> kernel@vger.kernel.org; Rajaram Regupathy
> Subject: Re: [PATCH 3/3] gpio: add support for Cypress CYUSBS234 USB-GPIO
> adapter
> 
> On Mon, Sep 22, 2014 at 03:04:18PM +0530, Muthu Mani wrote:
> > Adds support for USB-GPIO interface of Cypress Semiconductor
> > CYUSBS234 USB-Serial Bridge controller.
> >
> > The GPIO get/set can be done through vendor command on control
> > endpoint.
> >
> > Details about the device can be found at:
> > http://www.cypress.com/?rID=84126
> >
> > Signed-off-by: Muthu Mani <muth@cypress.com>
> > Signed-off-by: Rajaram Regupathy <rera@cypress.com>
> > ---
> >  drivers/gpio/Kconfig          |  13 +++
> >  drivers/gpio/Makefile         |   1 +
> >  drivers/gpio/gpio-cyusbs23x.c | 190
> > ++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 204 insertions(+)
> >  create mode 100644 drivers/gpio/gpio-cyusbs23x.c
> >
> > diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig index
> > 9de1515..932e07c 100644
> > --- a/drivers/gpio/Kconfig
> > +++ b/drivers/gpio/Kconfig
> > @@ -886,6 +886,19 @@ config GPIO_BCM_KONA
> >
> >  comment "USB GPIO expanders:"
> >
> > +config GPIO_CYUSBS23X
> > +     tristate "CYUSBS23x GPIO support"
> > +     depends on MFD_CYUSBS23X && USB
> > +     help
> > +       Say yes here to access the GPIO signals of Cypress
> > +       Semiconductor CYUSBS23x USB Serial Bridge Controller.
> > +
> > +       This driver enables the GPIO interface of CYUSBS23x USB Serial
> > +       Bridge controller.
> > +
> > +       This driver can also be built as a module. If so, the module will be
> > +       called gpio-cyusbs23x.
> > +
> >  config GPIO_VIPERBOARD
> >       tristate "Viperboard GPIO a & b support"
> >       depends on MFD_VIPERBOARD && USB diff --git
> > a/drivers/gpio/Makefile b/drivers/gpio/Makefile index 5d024e3..3ad89f1
> > 100644
> > --- a/drivers/gpio/Makefile
> > +++ b/drivers/gpio/Makefile
> > @@ -23,6 +23,7 @@ obj-$(CONFIG_GPIO_BT8XX)    += gpio-bt8xx.o
> >  obj-$(CONFIG_GPIO_CLPS711X)  += gpio-clps711x.o
> >  obj-$(CONFIG_GPIO_CS5535)    += gpio-cs5535.o
> >  obj-$(CONFIG_GPIO_CRYSTAL_COVE)      += gpio-crystalcove.o
> > +obj-$(CONFIG_GPIO_CYUSBS23X) += gpio-cyusbs23x.o
> >  obj-$(CONFIG_GPIO_DA9052)    += gpio-da9052.o
> >  obj-$(CONFIG_GPIO_DA9055)    += gpio-da9055.o
> >  obj-$(CONFIG_GPIO_DAVINCI)   += gpio-davinci.o
> > diff --git a/drivers/gpio/gpio-cyusbs23x.c
> > b/drivers/gpio/gpio-cyusbs23x.c new file mode 100644 index
> > 0000000..8aa3ab6
> > --- /dev/null
> > +++ b/drivers/gpio/gpio-cyusbs23x.c
> > @@ -0,0 +1,190 @@
> > +/*
> > + * Cypress USB-Serial Bridge Controller GPIO driver
> > + *
> > + * Copyright (c) 2014 Cypress Semiconductor Corporation.
> > + *
> > + * Author:
> > + *   Muthu Mani <muth@cypress.com>
> > + *
> > + * Additional contributors include:
> > + *   Rajaram Regupathy <rera@cypress.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > +modify it
> > + * under the terms of the GNU General Public License version 2 as
> > +published by
> > + * the Free Software Foundation.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/errno.h>
> > +#include <linux/module.h>
> > +#include <linux/slab.h>
> > +#include <linux/types.h>
> > +#include <linux/mutex.h>
> > +#include <linux/platform_device.h>
> > +
> > +#include <linux/usb.h>
> > +#include <linux/gpio.h>
> > +
> > +#include <linux/mfd/cyusbs23x.h>
> > +
> > +#define CY_GPIO_GET_LEN              (2)
> > +
> > +struct cyusbs_gpio {
> > +     struct gpio_chip gpio;
> > +     struct cyusbs23x *cyusbs;
> > +};
> > +
> > +static int cy_gpio_get(struct gpio_chip *chip,
> > +                     unsigned offset) {
> > +     int ret;
> > +     char buf[CY_GPIO_GET_LEN];
> 
> Buffers used for USB (DMA) transfers cannot be allocated on the stack.
> Use kmalloc and friends.

Ok, will update it.

> 
> > +     __u16 wIndex, wValue;
> 
> u16 throughout.

Ok.

> 
> > +     struct cyusbs_gpio *gpio =
> > +                             container_of(chip, struct cyusbs_gpio, gpio);
> > +     struct cyusbs23x *cyusbs = gpio->cyusbs;
> > +
> > +     dev_dbg(&cyusbs->usb_intf->dev, "%s: %d\n", __func__,
> > +             offset);
> > +     wValue = offset;
> > +     wIndex = 0;
> > +
> > +     mutex_lock(&cyusbs->lock);
> > +     ret = usb_control_msg(cyusbs->usb_dev,
> > +                     usb_rcvctrlpipe(cyusbs->usb_dev, 0),
> > +                     CY_GPIO_GET_VALUE_CMD,
> > +                     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
> > +                     wValue, wIndex, buf, CY_GPIO_GET_LEN, 2000);
> > +     mutex_unlock(&cyusbs->lock);
> > +
> > +     dev_dbg(&cyusbs->usb_intf->dev, "%s: %d %02x %02x\n", __func__,
> > +             ret, buf[0], buf[1]);
> > +
> > +     if (ret == CY_GPIO_GET_LEN) {
> > +             if (buf[0] == 0)
> > +                     ret = buf[1];
> > +             else
> > +                     ret = -EINVAL;
> > +     } else {
> > +             ret = -EREMOTEIO;
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +static void cy_gpio_set(struct gpio_chip *chip,
> > +                     unsigned offset, int value) {
> > +     int ret;
> > +     __u16 wIndex, wValue;
> > +     struct cyusbs_gpio *gpio =
> > +                     container_of(chip, struct cyusbs_gpio, gpio);
> > +     struct cyusbs23x *cyusbs = gpio->cyusbs;
> > +
> > +     dev_dbg(&cyusbs->usb_intf->dev, "%s: %d\n", __func__,
> > +             offset);
> > +     wValue = offset;
> > +     wIndex = value;
> > +
> > +     mutex_lock(&cyusbs->lock);
> > +     ret = usb_control_msg(cyusbs->usb_dev,
> > +                     usb_sndctrlpipe(cyusbs->usb_dev, 0),
> > +                     CY_GPIO_SET_VALUE_CMD,
> > +                     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
> > +                     wValue, wIndex, NULL, 0, 2000);
> > +     mutex_unlock(&cyusbs->lock);
> > +
> > +     if (ret < 0)
> > +             dev_err(&cyusbs->usb_intf->dev, "error setting
> > +gpio:%d\n", ret); }
> > +
> > +static int cy_gpio_direction_input(struct gpio_chip *chip,
> > +                                     unsigned offset) {
> > +     return 0;
> 
> Aren't the GPIOs output-only?

No.

> 
> > +}
> > +
> > +static int cy_gpio_direction_output(struct gpio_chip *chip,
> > +                                     unsigned offset, int value) {
> > +     return 0;
> > +}
> > +
> > +static int cyusbs23x_gpio_probe(struct platform_device *pdev) {
> > +     struct cyusbs23x *cyusbs;
> > +     struct cyusbs_gpio *cy_gpio;
> > +     int ret = 0;
> > +
> > +     dev_dbg(&pdev->dev, "%s\n", __func__);
> > +
> > +     cyusbs = dev_get_drvdata(pdev->dev.parent);
> > +
> > +     cy_gpio = devm_kzalloc(&pdev->dev, sizeof(*cy_gpio), GFP_KERNEL);
> > +     if (cy_gpio == NULL)
> > +             return -ENOMEM;
> > +
> > +     cy_gpio->cyusbs = cyusbs;
> > +     /* registering gpio */
> > +     cy_gpio->gpio.label = "cyusbs23x gpio";
> > +     cy_gpio->gpio.dev = &pdev->dev;
> > +     cy_gpio->gpio.owner = THIS_MODULE;
> > +     cy_gpio->gpio.base = -1;
> > +     cy_gpio->gpio.ngpio = 12; /* total GPIOs */
> 
> I think you need to read out the gpio config from the device eeprom and
> implement a request() callback where you verify that a requested gpio is
> actually available (mode dependent, and there are never more than 10 gpios
> availble).

In this initial driver, all GPIOs are made available to user space.
Additional functionalities will be added in the next version of the driver.

> 
> > +     cy_gpio->gpio.can_sleep = true;
> > +     cy_gpio->gpio.set = cy_gpio_set;
> > +     cy_gpio->gpio.get = cy_gpio_get;
> > +     cy_gpio->gpio.direction_input = cy_gpio_direction_input;
> > +     cy_gpio->gpio.direction_output = cy_gpio_direction_output;
> > +     ret = gpiochip_add(&cy_gpio->gpio);
> > +     if (ret < 0) {
> > +             dev_err(cy_gpio->gpio.dev, "could not add gpio");
> > +             goto error;
> > +     }
> > +
> > +     platform_set_drvdata(pdev, cy_gpio);
> > +
> > +     dev_dbg(&pdev->dev, "added GPIO\n");
> > +     return ret;
> > +
> > +error:
> > +     dev_dbg(&pdev->dev, "error occured %d\n", ret);
> > +     return ret;
> > +}
> > +
> > +static int cyusbs23x_gpio_remove(struct platform_device *pdev) {
> > +     struct cyusbs_gpio *cy_gpio = platform_get_drvdata(pdev);
> > +
> > +     dev_dbg(&pdev->dev, "%s\n", __func__);
> > +
> > +     gpiochip_remove(&cy_gpio->gpio);
> > +
> > +     return 0;
> > +}
> > +
> > +static struct platform_driver cyusbs23x_gpio_driver = {
> > +     .driver.name    = "cyusbs23x-gpio",
> > +     .driver.owner   = THIS_MODULE,
> > +     .probe          = cyusbs23x_gpio_probe,
> > +     .remove         = cyusbs23x_gpio_remove,
> > +};
> > +
> > +static int __init cyusbs23x_gpio_init(void) {
> > +     return platform_driver_register(&cyusbs23x_gpio_driver);
> > +}
> > +subsys_initcall(cyusbs23x_gpio_init);
> > +
> > +static void __exit cyusbs23x_gpio_exit(void) {
> > +     platform_driver_unregister(&cyusbs23x_gpio_driver);
> > +}
> > +module_exit(cyusbs23x_gpio_exit);
> 
> module_platform_driver

Ok.

> 
> > +
> > +MODULE_AUTHOR("Rajaram Regupathy <rera@cypress.com>");
> > +MODULE_AUTHOR("Muthu Mani <muth@cypress.com>");
> > +MODULE_DESCRIPTION("gpio-cyusbs23x driver v0.1");
> > +MODULE_LICENSE("GPL");
> 
> Description and license comments from i2c patch apply here as well.

Ok, will update it.

> 
> > +MODULE_ALIAS("platform:cyusbs23x-gpio");
> > +
> 
> Stray new line.

Ok, will remove it.
I will send the v2 patch soon.

> 
> Johan
