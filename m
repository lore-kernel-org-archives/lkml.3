Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbaJJOWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 10:22:46 -0400
Received: from mail-bn1bon0115.outbound.protection.outlook.com ([157.56.111.115]:15440
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754157AbaJJOWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 10:22:43 -0400
From: Muthu Mani <muth@cypress.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Wolfram Sang <wsa@the-dreams.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajaram Regupathy <rera@cypress.com>,
        "Johan Hovold" <johan@kernel.org>
Subject: RE: [PATCH v3 1/3] mfd: add support for Cypress CYUSBS234 USB Serial
 Bridge controller
Thread-Topic: [PATCH v3 1/3] mfd: add support for Cypress CYUSBS234 USB Serial
 Bridge controller
Thread-Index: AQHP4XPOwrQHMHpEyE2iwliXNR2I8JwnZbCAgAH3D4A=
Date: Fri, 10 Oct 2014 14:22:35 +0000
Message-ID: <db79d07038e44d428f8ca6d82508d4ad@BN1PR06MB069.namprd06.prod.outlook.com>
References: <1412606587-3323-1-git-send-email-muth@cypress.com>
 <20141009074029.GL20647@lee--X1>
In-Reply-To: <20141009074029.GL20647@lee--X1>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [121.243.89.10]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR06MB451;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-forefront-prvs: 03607C04F0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(51164003)(24454002)(52604005)(51704005)(189002)(199003)(377454003)(33646002)(64706001)(99396003)(76576001)(4396001)(2656002)(106116001)(77096002)(85852003)(87936001)(122556002)(97736003)(46102003)(110136001)(21056001)(108616004)(66066001)(15202345003)(20776003)(40100002)(80022003)(105586002)(85306004)(86362001)(107046002)(120916001)(101416001)(95666004)(99286002)(15975445006)(106356001)(92566001)(19580395003)(19580405001)(50986999)(76482002)(74316001)(31966008)(54356999)(76176999)(2004002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR06MB451;H:BN1PR06MB069.namprd06.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR06MB435;
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9AEMpmX006259

> -----Original Message-----
> From: Lee Jones [mailto:lee.jones@linaro.org]
> Sent: Thursday, October 09, 2014 1:10 PM
> To: Muthu Mani
> Cc: Samuel Ortiz; Wolfram Sang; Linus Walleij; Alexandre Courbot;
> gregkh@linuxfoundation.org; linux-i2c@vger.kernel.org; linux-
> gpio@vger.kernel.org; linux-usb@vger.kernel.org; linux-
> kernel@vger.kernel.org; Rajaram Regupathy; Johan Hovold
> Subject: Re: [PATCH v3 1/3] mfd: add support for Cypress CYUSBS234 USB
> Serial Bridge controller
> 
> On Mon, 06 Oct 2014, Muthu Mani wrote:
> 
> > Adds support for USB-I2C/GPIO interfaces of Cypress Semiconductor
> > CYUSBS234 USB-Serial Bridge controller.
> >
> > Details about the device can be found at:
> > http://www.cypress.com/?rID=84126
> >
> > Signed-off-by: Muthu Mani <muth@cypress.com>
> > Signed-off-by: Rajaram Regupathy <rera@cypress.com>
> > ---
> > Changes since v2:
> > * Used auto mfd id to support multiple devices
> > * Cleaned up the code
> >
> > Changes since v1:
> > * Identified different serial interface and loaded correct cell driver
> > * Formed a mfd id to support multiple devices
> > * Removed unused platform device
> >
> >  drivers/mfd/Kconfig           |  12 +++
> >  drivers/mfd/Makefile          |   1 +
> >  drivers/mfd/cyusbs23x.c       | 167
> ++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/mfd/cyusbs23x.h |  62 ++++++++++++++++
> >  4 files changed, 242 insertions(+)
> >  create mode 100644 drivers/mfd/cyusbs23x.c
> >  create mode 100644 include/linux/mfd/cyusbs23x.h
> >
> > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > index de5abf2..a31e9e3 100644
> > --- a/drivers/mfd/Kconfig
> > +++ b/drivers/mfd/Kconfig
> > @@ -116,6 +116,18 @@ config MFD_ASIC3
> >         This driver supports the ASIC3 multifunction chip found on many
> >         PDAs (mainly iPAQ and HTC based ones)
> >
> > +config MFD_CYUSBS23X
> > +        tristate "Cypress CYUSBS23x USB Serial Bridge controller"
> 
> White space issue here.

Thanks for reviewing!
Sure, will fix other files as well.

> 
> > +     select MFD_CORE
> > +     depends on USB
> > +     default n
> > +     help
> > +       Say yes here if you want support for Cypress Semiconductor
> > +       CYUSBS23x USB-Serial Bridge controller.
> > +
> > +       This driver can also be built as a module. If so, the module will be
> > +       called cyusbs23x.
> > +
> >  config PMIC_DA903X
> >       bool "Dialog Semiconductor DA9030/DA9034 PMIC Support"
> >       depends on I2C=y
> > diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> > index f001487..fc5bcd1 100644
> > --- a/drivers/mfd/Makefile
> > +++ b/drivers/mfd/Makefile
> > @@ -151,6 +151,7 @@ si476x-core-y := si476x-cmd.o si476x-prop.o si476x-
> i2c.o
> >  obj-$(CONFIG_MFD_SI476X_CORE)        += si476x-core.o
> >
> >  obj-$(CONFIG_MFD_CS5535)     += cs5535-mfd.o
> > +obj-$(CONFIG_MFD_CYUSBS23X)     += cyusbs23x.o
> >  obj-$(CONFIG_MFD_OMAP_USB_HOST)      += omap-usb-host.o omap-
> usb-tll.o
> >  obj-$(CONFIG_MFD_PM8921_CORE)        += pm8921-core.o ssbi.o
> >  obj-$(CONFIG_TPS65911_COMPARATOR)    += tps65911-comparator.o
> > diff --git a/drivers/mfd/cyusbs23x.c b/drivers/mfd/cyusbs23x.c
> > new file mode 100644
> > index 0000000..c70ea40
> > --- /dev/null
> > +++ b/drivers/mfd/cyusbs23x.c
> > @@ -0,0 +1,167 @@
> > +/*
> > + * Cypress USB-Serial Bridge Controller USB adapter driver
> > + *
> > + * Copyright (c) 2014 Cypress Semiconductor Corporation.
> > + *
> > + * Author:
> > + *   Muthu Mani <muth@cypress.com>
> > + *
> > + * Additional contributors include:
> > + *   Rajaram Regupathy <rera@cypress.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms of the GNU General Public License version 2 as
> published by
> > + * the Free Software Foundation.
> > + */
> > +
> > +/*
> > + * This is core MFD driver for Cypress Semiconductor CYUSBS234 USB-
> Serial
> > + * Bridge controller. CYUSBS234 offers a single channel serial interface
> > + * (I2C/SPI/UART). It can be configured to enable either of I2C, SPI, UART
> > + * interfaces. The GPIOs are also available to access.
> > + * Details about the device can be found at:
> > + *    http://www.cypress.com/?rID=84126
> > + *
> > + * Separate cell drivers are available for I2C and GPIO. SPI and UART are
> not
> > + * supported yet. All GPIOs are exposed for get operation. However, only
> > + * unused GPIOs can be set.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/errno.h>
> > +#include <linux/module.h>
> > +#include <linux/slab.h>
> > +#include <linux/types.h>
> > +#include <linux/mutex.h>
> > +
> 
> This '\n' is superfluous, please remove it.
> 
> > +#include <linux/mfd/core.h>
> > +#include <linux/mfd/cyusbs23x.h>
> > +
> > +#include <linux/usb.h>
> > +
> > +static const struct usb_device_id cyusbs23x_usb_table[] = {
> > +     { USB_DEVICE(0x04b4, 0x0004) },   /* Cypress Semiconductor */
> > +     { }                               /* Terminating entry */
> 
> This comment is not required, please remove it.
> 
> > +};
> > +
> > +MODULE_DEVICE_TABLE(usb, cyusbs23x_usb_table);
> > +
> > +static const struct mfd_cell cyusbs23x_i2c_devs[] = {
> > +     {
> > +             .name = "cyusbs23x-i2c",
> > +     },
> > +     {
> > +             .name = "cyusbs23x-gpio",
> > +     },
> > +};
> > +
> > +static int update_ep_details(struct usb_interface *interface,
> > +                             struct cyusbs23x *cyusbs)
> > +{
> > +     struct usb_host_interface *iface_desc;
> > +     struct usb_endpoint_descriptor *ep;
> > +     int i;
> > +
> > +     iface_desc = interface->cur_altsetting;
> > +
> > +     for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
> > +
> > +             ep = &iface_desc->endpoint[i].desc;
> > +
> > +             if (!cyusbs->bulk_in_ep_num && usb_endpoint_is_bulk_in(ep))
> > +                     cyusbs->bulk_in_ep_num = ep->bEndpointAddress;
> > +             if (!cyusbs->bulk_out_ep_num &&
> usb_endpoint_is_bulk_out(ep))
> > +                     cyusbs->bulk_out_ep_num = ep->bEndpointAddress;
> > +             if (!cyusbs->intr_in_ep_num && usb_endpoint_is_int_in(ep))
> > +                     cyusbs->intr_in_ep_num = ep->bEndpointAddress;
> > +     }
> 
> All of the USB specific code in this driver will require a USB Ack.
> 
> > +     dev_dbg(&interface->dev, "%s intr_in=%d, bulk_in=%d,
> bulk_out=%d\n",
> > +             __func__, cyusbs->intr_in_ep_num ,
> > +             cyusbs->bulk_in_ep_num, cyusbs->bulk_out_ep_num);
> > +
> > +     if (!cyusbs->bulk_in_ep_num || !cyusbs->bulk_out_ep_num ||
> > +             !cyusbs->intr_in_ep_num)
> > +             return -ENODEV;
> > +
> > +     return 0;
> > +}
> > +
> > +static int cyusbs23x_probe(struct usb_interface *interface,
> > +                        const struct usb_device_id *id)
> > +{
> > +     struct cyusbs23x *cyusbs;
> > +     const struct mfd_cell *cyusbs23x_devs;
> > +     int ret, ndevs = 0;
> > +     u8 sub_class;
> > +
> > +     cyusbs = kzalloc(sizeof(*cyusbs), GFP_KERNEL);
> 
> Any reason for not using managed resources (devm_*)?

Ok, will use managed resources.

> 
> > +     if (cyusbs == NULL)
> 
> if (!cyusbs)
> 
> > +             return -ENOMEM;
> > +
> > +     cyusbs->usb_dev = usb_get_dev(interface_to_usbdev(interface));
> 
> Can you do this last?  Then you can remove the 'error' error path.

mfd_add_devices would utlimately invoke the cell drivers' probe before returning and cell drivers use usb_dev in their probe.
So, leaving it as such.

> 
> > +     cyusbs->usb_intf = interface;
> > +     cyusbs->intf_num = interface->cur_altsetting-
> >desc.bInterfaceNumber;
> 
> If you're already saving 'interface' there is no need to save this
> also, just extract it from 'cyusbs->usb_intf' when you need it.
> 
> > +     ret = update_ep_details(interface, cyusbs);
> > +     if (ret < 0) {
> 
> Can ret be > 0?  If not, just do 'if (ret)'
> 
> > +             dev_err(&interface->dev, "invalid interface\n");
> 
> If you put the error message in update_ep_details() can you print out
> a more specific error message and remove this line.
> 
> > +             goto error;
> > +     }
> > +
> > +     usb_set_intfdata(interface, cyusbs);
> > +
> > +     /* Serial interfaces (I2C, SPI, UART) differ in interface subclass */
> > +     sub_class = interface->cur_altsetting->desc.bInterfaceSubClass;
> > +     switch (sub_class) {
> 
> This is a waste of a variable and adds nothing to the code.  Just
> switch() for 'interface->cur_altsetting->desc.bInterfaceSubClass'.
> 
> > +     case CY_USBS_SCB_I2C:
> > +             dev_info(&interface->dev, "I2C interface found\n");
> 
> Was it even lost?
> 
> Would "using I2C interface" be better?
> 
> > +             cyusbs23x_devs = cyusbs23x_i2c_devs;
> > +             ndevs = ARRAY_SIZE(cyusbs23x_i2c_devs);
> > +             break;
> 
> I assume there will be other interfaces supported at a later date?  If
> not, this switch() is pretty over-the-top.
> 
> > +     default:
> > +             dev_err(&interface->dev, "unsupported subclass\n");
> > +             ret = -ENODEV;
> > +             goto error;
> > +     }
> > +
> > +     ret = mfd_add_devices(&interface->dev, PLATFORM_DEVID_AUTO,
> > +                             cyusbs23x_devs, ndevs, NULL, 0, NULL);
> > +     if (ret != 0) {
> 
> if (ret)
> 
> > +             dev_err(&interface->dev, "Failed to add mfd devices to core\n");
> 
> "Failed to register devices"
> 
> > +             goto error;
> > +     }
> > +
> > +     return 0;
> > +
> > +error:
> > +     usb_put_dev(cyusbs->usb_dev);
> > +     kfree(cyusbs);
> > +
> > +     return ret;
> > +}
> > +
> > +static void cyusbs23x_disconnect(struct usb_interface *interface)
> > +{
> > +     struct cyusbs23x *cyusbs = usb_get_intfdata(interface);
> > +
> > +     mfd_remove_devices(&interface->dev);
> > +     usb_put_dev(cyusbs->usb_dev);
> > +     kfree(cyusbs);
> 
> If you use managed resources, you can remove this line.
> 
> > +     dev_dbg(&interface->dev, "disconnected\n");
> 
> Please remove this line.
> 
> > +}
> > +
> > +static struct usb_driver cyusbs23x_usb_driver = {
> > +     .name           = "cyusbs23x",
> > +     .probe          = cyusbs23x_probe,
> > +     .disconnect     = cyusbs23x_disconnect,
> > +     .id_table       = cyusbs23x_usb_table,
> > +};
> > +
> > +module_usb_driver(cyusbs23x_usb_driver);
> > +
> > +MODULE_AUTHOR("Rajaram Regupathy <rera@cypress.com>");
> > +MODULE_AUTHOR("Muthu Mani <muth@cypress.com>");
> > +MODULE_DESCRIPTION("Cypress CYUSBS23x mfd core driver");
> 
> s/mfd/MFD/

Is there a typo?

> 
> > +MODULE_LICENSE("GPL v2");
> > diff --git a/include/linux/mfd/cyusbs23x.h
> b/include/linux/mfd/cyusbs23x.h
> > new file mode 100644
> > index 0000000..1580d98
> > --- /dev/null
> > +++ b/include/linux/mfd/cyusbs23x.h
> > @@ -0,0 +1,62 @@
> > +/*
> > + * Cypress USB-Serial Bridge Controller definitions
> > + *
> > + * Copyright (c) 2014 Cypress Semiconductor Corporation.
> > + *
> > + * Author:
> > + *   Muthu Mani <muth@cypress.com>
> > + *
> > + * Additional contributors include:
> > + *   Rajaram Regupathy <rera@cypress.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms of the GNU General Public License version 2 as
> published by
> > + * the Free Software Foundation.
> > + */
> > +
> > +#ifndef __MFD_CYUSBS23X_H__
> > +#define __MFD_CYUSBS23X_H__
> > +
> > +#include <linux/types.h>
> > +#include <linux/usb.h>
> > +
> > +/* Structure to hold all device specific stuff */
> > +struct cyusbs23x {
> > +     struct usb_device *usb_dev;
> > +     struct usb_interface *usb_intf;
> > +
> > +     u8 intf_num;
> > +     u8 bulk_in_ep_num;
> > +     u8 bulk_out_ep_num;
> > +     u8 intr_in_ep_num;
> > +};
> > +
> > +enum cy_usbs_vendor_cmds {
> > +     CY_I2C_GET_CONFIG_CMD  = 0xC4,
> > +     CY_I2C_SET_CONFIG_CMD  = 0xC5,
> > +     CY_I2C_WRITE_CMD       = 0xC6,
> > +     CY_I2C_READ_CMD        = 0xC7,
> > +     CY_I2C_GET_STATUS_CMD  = 0xC8,
> > +     CY_I2C_RESET_CMD       = 0xC9,
> > +     CY_GPIO_GET_CONFIG_CMD = 0xD8,
> > +     CY_GPIO_SET_CONFIG_CMD = 0xD9,
> > +     CY_GPIO_GET_VALUE_CMD  = 0xDA,
> > +     CY_GPIO_SET_VALUE_CMD  = 0xDB,
> > +};
> > +
> > +/* Serial interfaces (I2C, SPI, UART) differ in interface subclass */
> > +enum cy_scb_modes {
> > +     CY_USBS_SCB_DISABLED = 0,
> > +     CY_USBS_SCB_UART = 1,
> > +     CY_USBS_SCB_SPI = 2,
> > +     CY_USBS_SCB_I2C = 3
> 
> No need to number these.
> 
> > +};
> > +
> > +/* SCB index shift */
> > +#define CY_SCB_INDEX_SHIFT      15
> > +
> > +#define CY_USBS_CTRL_XFER_TIMEOUT    2000
> > +#define CY_USBS_BULK_XFER_TIMEOUT    5000
> > +#define CY_USBS_INTR_XFER_TIMEOUT    5000
> > +
> > +#endif /* __MFD_CYUSBS23X_H__ */
> 
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org â”‚ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
> This message and any attachments may contain Cypress (or its subsidiaries)
> confidential information. If it has been received in error, please advise the
> sender and immediately delete this message.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
