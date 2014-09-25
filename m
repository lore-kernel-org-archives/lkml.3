Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151AbaIYFq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 01:46:26 -0400
Received: from mail-bn1bon0116.outbound.protection.outlook.com ([157.56.111.116]:2186
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750715AbaIYFqX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 01:46:23 -0400
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
Subject: RE: [PATCH 2/3] i2c: add support for Cypress CYUSBS234 USB-I2C
 adapter
Thread-Topic: [PATCH 2/3] i2c: add support for Cypress CYUSBS234 USB-I2C
 adapter
Thread-Index: AQHP1khYMqHozl+H8E6r7ak9SKD26JwNBKQAgAM/eSA=
Date: Thu, 25 Sep 2014 05:46:16 +0000
Message-ID: <6876ca326315426889d3dc596a495b23@BY2PR06MB076.namprd06.prod.outlook.com>
References: <1411378426-18387-1-git-send-email-muth@cypress.com>
 <20140922113026.GF5237@localhost>
In-Reply-To: <20140922113026.GF5237@localhost>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [121.243.89.10]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR06MB456;UriScan:;
x-forefront-prvs: 0345CFD558
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(199003)(51704005)(189002)(13464003)(377454003)(76576001)(80022003)(20776003)(90102001)(74662003)(64706001)(46102003)(79102003)(81542003)(77982003)(86362001)(92566001)(66066001)(110136001)(81342003)(99396003)(107046002)(77096002)(74502003)(33646002)(95666004)(85852003)(99286002)(83072002)(101416001)(74316001)(54356999)(85306004)(31966008)(108616004)(50986999)(76176999)(10300001)(4396001)(19580405001)(120916001)(105586002)(83322001)(97736003)(15975445006)(76482002)(19580395003)(15202345003)(106116001)(21056001)(106356001)(2656002)(87936001)(24736002)(579004);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR06MB456;H:BY2PR06MB076.namprd06.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR06MB234;
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Johan Hovold [mailto:jhovold@gmail.com] On Behalf Of Johan Hovold
> Sent: Monday, September 22, 2014 5:00 PM
> To: Muthu Mani
> Cc: Samuel Ortiz; Lee Jones; Wolfram Sang; linux-i2c@vger.kernel.org; Linus
> Walleij; Alexandre Courbot; linux-gpio@vger.kernel.org;
> gregkh@linuxfoundation.org; linux-usb@vger.kernel.org; linux-
> kernel@vger.kernel.org; Rajaram Regupathy
> Subject: Re: [PATCH 2/3] i2c: add support for Cypress CYUSBS234 USB-I2C
> adapter
> 
> On Mon, Sep 22, 2014 at 03:03:46PM +0530, Muthu Mani wrote:
> > Adds support for USB-I2C interface of Cypress Semiconductor
> > CYUSBS234 USB-Serial Bridge controller.
> >
> > The read/write operation is setup using vendor command through control
> > endpoint and actual data transfer happens through bulk in/out
> > endpoints.
> >
> > Details about the device can be found at:
> > http://www.cypress.com/?rID=84126
> >
> > Signed-off-by: Muthu Mani <muth@cypress.com>
> > Signed-off-by: Rajaram Regupathy <rera@cypress.com>
> > ---
> >  drivers/i2c/busses/Kconfig         |  12 +
> >  drivers/i2c/busses/Makefile        |   1 +
> >  drivers/i2c/busses/i2c-cyusbs23x.c | 534
> > +++++++++++++++++++++++++++++++++++++
> >  3 files changed, 547 insertions(+)
> >  create mode 100644 drivers/i2c/busses/i2c-cyusbs23x.c
> >
> > diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> > index 2ac87fa..1fdc6ec 100644
> > --- a/drivers/i2c/busses/Kconfig
> > +++ b/drivers/i2c/busses/Kconfig
> > @@ -848,6 +848,18 @@ config I2C_RCAR
> >
> >  comment "External I2C/SMBus adapter drivers"
> >
> > +config I2C_CYUSBS23X
> > +        tristate "CYUSBS23x I2C adapter"
> > +        depends on MFD_CYUSBS23X && USB
> > +        help
> > +       Say yes if you would like to access Cypress CYUSBS23x I2C device.
> > +
> > +       This driver enables the I2C interface of CYUSBS23x USB Serial Bridge
> > +       controller.
> > +
> > +       This driver can also be built as a module. If so, the module will be
> > +       called i2c-cyusbs23x.
> > +
> >  config I2C_DIOLAN_U2C
> >       tristate "Diolan U2C-12 USB adapter"
> >       depends on USB
> > diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> > index 49bf07e..cbf28cb 100644
> > --- a/drivers/i2c/busses/Makefile
> > +++ b/drivers/i2c/busses/Makefile
> > @@ -84,6 +84,7 @@ obj-$(CONFIG_I2C_XLR)               += i2c-xlr.o
> >  obj-$(CONFIG_I2C_RCAR)               += i2c-rcar.o
> >
> >  # External I2C/SMBus adapter drivers
> > +obj-$(CONFIG_I2C_CYUSBS23X)  += i2c-cyusbs23x.o
> >  obj-$(CONFIG_I2C_DIOLAN_U2C) += i2c-diolan-u2c.o
> >  obj-$(CONFIG_I2C_PARPORT)    += i2c-parport.o
> >  obj-$(CONFIG_I2C_PARPORT_LIGHT)      += i2c-parport-light.o
> > diff --git a/drivers/i2c/busses/i2c-cyusbs23x.c
> > b/drivers/i2c/busses/i2c-cyusbs23x.c
> > new file mode 100644
> > index 0000000..6fade25
> > --- /dev/null
> > +++ b/drivers/i2c/busses/i2c-cyusbs23x.c
> > @@ -0,0 +1,534 @@
> > +/*
> > + * Cypress USB-Serial Bridge Controller I2C-USB adapter driver
> > + *
> > + * Copyright (c) 2014 Cypress Semiconductor Corporation.
> > + *
> > + * Author:
> > + *   Rajaram Regupathy <rera@cypress.com>
> > + *
> > + * Additional contributors include:
> > + *   Muthu Mani <muth@cypress.com>
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
> > +#include <linux/i2c.h>
> > +
> > +#include <linux/mfd/cyusbs23x.h>
> > +
> > +#define CYUSBS23X_I2C_NAME "cyusbs23x_i2c"
> > +
> > +#pragma pack(1)
> > +struct cyusbs_i2c_config {
> > +     __u32 frequency;       /* Frequency of operation. Only valid values are
> > +                               100KHz and 400KHz */
> 
> u32 -- drop the __ prefix throughout.

Ok, will update it.

> 
> > +__u8 slave_addr;       /* Slave address to be used when in slave mode */
> > +     bool is_msb_first;     /* Whether to transmit MSB first */
> 
> Use an explicitly sized type (e.g. u8) and not bool for this struct.

Ok.

> 
> > +     bool is_master;        /* Whether block is to be configured as a master:
> > +                               1 - The block functions as I2C master;
> > +                               0 - The block functions as I2C slave */
> > +     bool s_ignore;         /* Ignore general call in slave mode */
> > +     bool clock_stretch;    /* Whether to stretch clock in case of no FIFO
> > +                               availability */
> > +     bool is_loopback;      /* Whether to loop back TX data to RX. Valid
> > +                               only for debug purposes */
> > +     __u8 reserved[6];      /* Reserved for future use */
> > +};
> > +#pragma pack()
> 
> Use __packed rather than pragma if at all needed.

Ok.

> 
> > +
> > +struct cyusbs_i2c {
> > +     struct i2c_adapter i2c_adapter;
> > +     struct cyusbs_i2c_config i2c_config;
> 
> Buffers used for USB (DMA) transfers needs to be allocated separately from
> the containing struct.

Ok.

> 
> > +
> > +     bool is_stop_bit;
> > +     bool is_nak_bit;
> > +};
> > +
> > +#define CY_I2C_MODE_WRITE     1
> > +#define CY_I2C_MODE_READ      0
> > +
> > +static int cy_i2c_get_status(struct device *d, char *buf, __u16
> > +mode); static int cy_i2c_reset(struct device *d, __u16 mode);
> > +
> > +static ssize_t show_i2c_read_status(struct device *d,
> > +                                 struct device_attribute *attr, char
> > +*buf) {
> > +     dev_dbg(d, "%s\n", __func__);
> > +
> > +     return cy_i2c_get_status(d, buf, CY_I2C_MODE_READ); } static
> > +DEVICE_ATTR(i2c_read_status, 0444, show_i2c_read_status, NULL);
> 
> What are these attributes used for? Can't they be handled through the i2c-
> framework if at all needed?

These attributes are used to query I2C transfer status specific to CYUSBS234 (which is USB-I2C adapter device, not a regular I2C device). So, these can't be keep through i2c-framework.

> 
> Use DEVICE_ATTR_RO and friends rather tham DEVICE_ATTR directly.

Ok.

> 
> And is it ascii data you're returning? You don't seem to null-terminate it.

Yes.

> 
> > +
> > +static ssize_t show_i2c_write_status(struct device *d,
> > +                                  struct device_attribute *attr, char
> > +*buf) {
> > +     dev_dbg(d, "%s\n", __func__);
> > +
> > +     return cy_i2c_get_status(d, buf, CY_I2C_MODE_WRITE); } static
> > +DEVICE_ATTR(i2c_write_status, 0444, show_i2c_write_status, NULL);
> > +
> > +static ssize_t cy_i2c_read_reset(struct device *d,
> > +                              struct device_attribute *attr,
> > +                              const char *buf, size_t count) {
> > +     int ret;
> > +
> > +     if (((count != 1) && (count != 2 || buf[1] != '\n')) || (buf[0] != '1'))
> > +             return -EINVAL;
> > +
> > +     dev_dbg(d, "%s\n", __func__);
> > +     ret = cy_i2c_reset(d, CY_I2C_MODE_READ);
> > +
> > +     if (!ret)
> > +             ret = count;
> > +
> > +     return ret;
> > +}
> > +static DEVICE_ATTR(i2c_read_reset, 0200, NULL, cy_i2c_read_reset);
> 
> Shouldn't this be handled from within the driver?

These attributes are used to soft reset I2C read/write module.
Main objective is to keep the driver simple and leverage control to userspace.

> 
> > +
> > +static ssize_t cy_i2c_write_reset(struct device *d,
> > +                               struct device_attribute *attr,
> > +                               const char *buf, size_t count) {
> > +     int ret;
> > +
> > +     if (((count != 1) && (count != 2 || buf[1] != '\n')) || (buf[0] != '1'))
> > +             return -EINVAL;
> > +
> > +     dev_dbg(d, "%s\n", __func__);
> > +     ret = cy_i2c_reset(d, CY_I2C_MODE_WRITE);
> > +
> > +     if (!ret)
> > +             ret = count;
> > +
> > +     return ret;
> > +}
> > +static DEVICE_ATTR(i2c_write_reset, 0200, NULL, cy_i2c_write_reset);
> > +
> > +static ssize_t show_is_stop_bit(struct device *d,
> > +                             struct device_attribute *attr, char
> > +*buf) {
> > +     struct platform_device *pdev = to_platform_device(d);
> > +     struct cyusbs_i2c *cy_i2c = platform_get_drvdata(pdev);
> > +
> > +     return sprintf(buf, "%d\n", cy_i2c->is_stop_bit); }
> > +
> > +static ssize_t store_is_stop_bit(struct device *d,
> > +                              struct device_attribute *attr,
> > +                              const char *buf, size_t count) {
> > +     struct platform_device *pdev = to_platform_device(d);
> > +     struct cyusbs_i2c *cy_i2c = platform_get_drvdata(pdev);
> > +
> > +     if ((count != 1) && (count != 2 || buf[1] != '\n'))
> > +             return -EINVAL;
> > +
> > +     if (buf[0] == '0')
> > +             cy_i2c->is_stop_bit = 0;
> > +     else if (buf[0] == '1')
> > +             cy_i2c->is_stop_bit = 1;
> > +     else
> > +             return -EINVAL;
> > +
> > +     dev_dbg(d, "is_stop_bit=%d buf=%s\n", cy_i2c->is_stop_bit, buf);
> > +
> > +     return count;
> > +}
> > +static DEVICE_ATTR(is_stop_bit, 0644, show_is_stop_bit,
> > +store_is_stop_bit);
> > +
> > +static ssize_t show_is_nak_bit(struct device *d,
> > +                            struct device_attribute *attr, char *buf)
> > +{
> > +     struct platform_device *pdev = to_platform_device(d);
> > +     struct cyusbs_i2c *cy_i2c = platform_get_drvdata(pdev);
> > +
> > +     return sprintf(buf, "%d\n", cy_i2c->is_nak_bit); }
> > +
> > +static ssize_t store_is_nak_bit(struct device *d,
> > +                             struct device_attribute *attr,
> > +                             const char *buf, size_t count) {
> > +     struct platform_device *pdev = to_platform_device(d);
> > +     struct cyusbs_i2c *cy_i2c = platform_get_drvdata(pdev);
> > +
> > +     if ((count != 1) && (count != 2 || buf[1] != '\n'))
> > +             return -EINVAL;
> > +
> > +     if (buf[0] == '0')
> > +             cy_i2c->is_nak_bit = 0;
> > +     else if (buf[0] == '1')
> > +             cy_i2c->is_nak_bit = 1;
> > +     else
> > +             return -EINVAL;
> > +
> > +     dev_dbg(d, "is_nak_bit=%d buf=%s\n", cy_i2c->is_nak_bit, buf);
> > +
> > +     return count;
> > +}
> > +static DEVICE_ATTR(is_nak_bit, 0644, show_is_nak_bit,
> > +store_is_nak_bit);
> > +
> > +static int cy_i2c_get_status(struct device *d, char *buf, __u16 mode)
> > +{
> > +     int ret;
> > +     __u16 wIndex, wValue, scb_index, tmp;
> > +     struct cyusbs23x *cyusbs = dev_get_drvdata(d->parent);
> > +
> > +     tmp = cyusbs->usb_intf->cur_altsetting->desc.bInterfaceNumber;
> > +     scb_index = tmp & 0x01;
> > +     wValue = ((scb_index << CY_SCB_INDEX_POS) | mode);
> > +     wIndex = 0;
> > +
> 
> Allocate the transfer buffer using kmalloc explicitly here and do a memcpy if
> needed to make sure the buffer is always DMA-able.

Ok.

> 
> > +     mutex_lock(&cyusbs->lock);
> > +     ret = usb_control_msg(cyusbs->usb_dev,
> > +                     usb_rcvctrlpipe(cyusbs->usb_dev, 0),
> > +                     CY_I2C_GET_STATUS_CMD,
> > +                     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
> > +                     wValue, wIndex, buf, 3, 2000);
> > +     mutex_unlock(&cyusbs->lock);
> > +
> > +     dev_dbg(&cyusbs->usb_intf->dev, "%s: %02x %02x %02x\n",
> __func__,
> > +             buf[0], buf[1], buf[2]);
> > +     return ret;
> > +}
> > +
> > +static int cy_i2c_reset(struct device *d, __u16 mode) {
> > +     int ret;
> > +     __u16 wIndex, wValue, scb_index, tmp;
> > +     struct cyusbs23x *cyusbs = dev_get_drvdata(d->parent);
> > +
> > +     tmp = cyusbs->usb_intf->cur_altsetting->desc.bInterfaceNumber;
> > +     scb_index = tmp & 0x01;
> > +     wValue = ((scb_index << CY_SCB_INDEX_POS) | mode);
> > +     wIndex = 0;
> > +
> > +     mutex_lock(&cyusbs->lock);
> > +     ret = usb_control_msg(cyusbs->usb_dev,
> > +                     usb_sndctrlpipe(cyusbs->usb_dev, 0),
> > +                     CY_I2C_RESET_CMD,
> > +                     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
> > +                     wValue, wIndex, NULL, 0, 2000);
> > +     mutex_unlock(&cyusbs->lock);
> > +     dev_dbg(d, "%s: %d\n", __func__, ret);
> > +     return ret;
> > +}
> > +
> > +static int cy_get_i2c_config(struct cyusbs23x *cyusbs,
> > +                             struct cyusbs_i2c *cy_i2c) {
> > +     int ret;
> > +     __u16 scb_index, tmp;
> > +
> > +     dev_dbg(&cyusbs->usb_intf->dev, "%s\n", __func__);
> > +
> > +     tmp = cyusbs->usb_intf->cur_altsetting->desc.bInterfaceNumber;
> > +     scb_index = (tmp & 0x01) << CY_SCB_INDEX_POS;
> > +
> > +     mutex_lock(&cyusbs->lock);
> > +     ret = usb_control_msg(cyusbs->usb_dev,
> > +                     usb_rcvctrlpipe(cyusbs->usb_dev, 0),
> > +                     CY_I2C_GET_CONFIG_CMD,
> > +                     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
> > +                     scb_index, 0, &cy_i2c->i2c_config, 16, 2000);
> 
> Hardcoded length. Use proper attributes and sizeof.

Ok.

> 
> > +     mutex_unlock(&cyusbs->lock);
> > +
> > +     dev_dbg(&cyusbs->usb_intf->dev, "%s: %d, 0x%02x, %d, %d, %d, %d,
> %d\n",
> > +             __func__, cy_i2c->i2c_config.frequency,
> > +             cy_i2c->i2c_config.slave_addr,
> > +             cy_i2c->i2c_config.is_msb_first,
> > +             cy_i2c->i2c_config.is_master,
> > +             cy_i2c->i2c_config.s_ignore,
> > +             cy_i2c->i2c_config.clock_stretch,
> > +             cy_i2c->i2c_config.is_loopback);
> > +     return ret;
> > +}
> > +
> > +static int cy_i2c_set_data_config(struct cyusbs23x *cyusbs,
> > +                               struct cyusbs_i2c *cy_i2c, __u16 slave_addr,
> > +                               __u16 length, __u8 command) {
> > +     int ret;
> > +     __u16 wIndex, wValue;
> > +     __u16 scb_index, tmp;
> > +
> > +     dev_dbg(&cyusbs->usb_intf->dev, "%s\n", __func__);
> > +
> > +     tmp = cyusbs->usb_intf->cur_altsetting->desc.bInterfaceNumber;
> > +     scb_index = (tmp & 0x01) << 7;
> > +     slave_addr = (slave_addr & 0x7F) | scb_index;
> > +     wValue = cy_i2c->is_stop_bit | cy_i2c->is_nak_bit << 1;
> > +     wValue |= (slave_addr << 8);
> > +     wIndex = length;
> > +
> > +     dev_dbg(&cyusbs->usb_intf->dev,
> > +             "%s, cmd=0x%x,val=0x%x,idx=0x%x\n",
> > +             __func__, command, wValue, wIndex);
> > +
> > +     ret = usb_control_msg(cyusbs->usb_dev,
> > +             usb_sndctrlpipe(cyusbs->usb_dev, 0),
> > +             command, USB_TYPE_VENDOR | USB_RECIP_DEVICE |
> USB_DIR_OUT,
> > +             wValue, wIndex, NULL, 0, 2000);
> > +
> > +     return ret;
> > +}
> > +
> > +static int cy_i2c_read(struct cyusbs23x *cyusbs, struct i2c_msg
> > +*msgs) {
> > +     int ret, actual_read_len = 0;
> > +
> > +     dev_dbg(&cyusbs->usb_intf->dev, "%s\n", __func__);
> > +
> > +     ret = usb_bulk_msg(cyusbs->usb_dev,
> > +             usb_rcvbulkpipe(cyusbs->usb_dev, cyusbs->bulk_in_ep_num),
> > +             msgs[0].buf,
> > +             msgs[0].len,
> > +             &actual_read_len, 5000);
> > +
> > +     if (ret)
> > +             dev_dbg(&cyusbs->usb_intf->dev,
> > +                     "read %d/%d returned %d\n",
> > +                     actual_read_len, msgs[0].len, ret);
> > +
> > +     return ret;
> > +}
> > +
> > +static int cy_i2c_write(struct cyusbs23x *cyusbs, struct i2c_msg
> > +*msgs) {
> > +     int ret, actual_write_len = 0;
> > +
> > +     dev_dbg(&cyusbs->usb_intf->dev, "%s\n", __func__);
> > +
> > +     ret = usb_bulk_msg(cyusbs->usb_dev,
> > +             usb_sndbulkpipe(cyusbs->usb_dev, cyusbs->bulk_out_ep_num),
> > +             msgs[0].buf,
> > +             msgs[0].len,
> > +             &actual_write_len, 5000);
> > +
> > +     if (ret)
> > +             dev_dbg(&cyusbs->usb_intf->dev,
> > +                     "write %d/%d returned %d\n",
> > +                     actual_write_len, msgs[0].len, ret);
> > +
> > +     return ret;
> > +}
> > +
> > +static int cy_i2c_xfer(struct i2c_adapter *adapter,
> > +                    struct i2c_msg *msgs, int num) {
> > +     int ret = 0;
> > +     struct cyusbs_i2c *cy_i2c;
> > +     struct cyusbs23x *cyusbs = (struct cyusbs23x
> > +*)adapter->algo_data;
> > +
> > +     dev_dbg(&adapter->dev, "%s\n", __func__);
> > +
> > +     if (num > 1) {
> > +             dev_err(&adapter->dev, "i2c_msg number is > 1\n");
> > +             return -EIO;
> > +     }
> 
> Why not handle multiple messages?

This iteration of the driver is designed to handle only a single message at a time.
It can be expanded to handle multiple messages in future.

> 
> > +
> > +     cy_i2c = container_of(adapter, struct cyusbs_i2c, i2c_adapter);
> > +
> > +     mutex_lock(&cyusbs->lock);
> > +     if (msgs[0].flags & I2C_M_RD) {
> > +             dev_dbg(&adapter->dev,
> > +                     "I2C read requested for addr 0x%02x, data length %d\n",
> > +                     msgs[0].addr, msgs[0].len);
> > +
> > +             ret = cy_i2c_set_data_config(cyusbs, cy_i2c, msgs[0].addr,
> > +                             msgs[0].len, CY_I2C_READ_CMD);
> > +
> > +             if (ret < 0) {
> > +                     dev_err(&adapter->dev,
> > +                             "Set Config (read) failed with %d\n", ret);
> > +                     goto io_error;
> > +             }
> > +
> > +             ret = cy_i2c_read(cyusbs, msgs);
> > +             if (ret) {
> > +                     dev_err(&adapter->dev,
> > +                             "Read failed with error code %d\n", ret);
> > +                     goto io_error;
> > +             }
> > +     } else {
> > +             dev_dbg(&adapter->dev,
> > +                     "I2C write requested for addr 0x%02x, data length %d\n",
> > +                     msgs[0].addr, msgs[0].len);
> > +
> > +             ret = cy_i2c_set_data_config(cyusbs, cy_i2c, msgs[0].addr,
> > +                             msgs[0].len, CY_I2C_WRITE_CMD);
> > +
> > +             if (ret < 0) {
> > +                     dev_err(&adapter->dev,
> > +                     "Set Config (write) failed with %d\n", ret);
> > +                     goto io_error;
> > +             }
> > +
> > +             ret = cy_i2c_write(cyusbs, msgs);
> > +             if (ret) {
> > +                     dev_err(&adapter->dev,
> > +                             "Write failed with error code %d\n", ret);
> > +                     goto io_error;
> > +             }
> > +     }
> > +     mutex_unlock(&cyusbs->lock);
> > +     return ret;
> > +
> > +io_error:
> > +     mutex_unlock(&cyusbs->lock);
> > +     return ret;
> > +}
> > +
> > +static u32 cy_i2c_func(struct i2c_adapter *adapter) {
> > +     dev_dbg(&adapter->dev, "%s\n", __func__);
> > +
> > +     return I2C_FUNC_I2C;
> > +}
> > +
> > +static const struct i2c_algorithm i2c_cyusbs23x_algorithm = {
> > +     .master_xfer    = cy_i2c_xfer,
> > +     .functionality  = cy_i2c_func,
> > +};
> > +
> > +static int cyusbs23x_i2c_probe(struct platform_device *pdev) {
> > +     struct cyusbs23x *cyusbs;
> > +     struct cyusbs_i2c *cy_i2c;
> > +     int ret = 0;
> > +
> > +     dev_dbg(&pdev->dev, "%s\n", __func__);
> > +
> > +     cyusbs = dev_get_drvdata(pdev->dev.parent);
> > +
> > +     cy_i2c = devm_kzalloc(&pdev->dev, sizeof(*cy_i2c), GFP_KERNEL);
> > +     if (cy_i2c == NULL)
> > +             return -ENOMEM;
> > +
> > +     cy_i2c->is_stop_bit = 1;
> > +     cy_i2c->is_nak_bit = 1;
> > +
> > +     cy_i2c->i2c_adapter.owner = THIS_MODULE;
> > +     cy_i2c->i2c_adapter.class = I2C_CLASS_HWMON;
> > +     cy_i2c->i2c_adapter.algo = &i2c_cyusbs23x_algorithm;
> > +     cy_i2c->i2c_adapter.algo_data = cyusbs;
> > +     snprintf(cy_i2c->i2c_adapter.name, sizeof(CYUSBS23X_I2C_NAME),
> > +                     CYUSBS23X_I2C_NAME);
> > +     cy_i2c->i2c_adapter.dev.parent = &pdev->dev;
> > +
> > +     ret = device_create_file(&pdev->dev, &dev_attr_i2c_read_status);
> > +     if (ret) {
> > +             dev_err(&pdev->dev,
> > +                     "error in adding i2c_read_status\n");
> > +             goto error;
> > +     }
> > +     ret = device_create_file(&pdev->dev, &dev_attr_i2c_write_status);
> > +     if (ret) {
> > +             dev_err(&pdev->dev,
> > +                     "error in adding i2c_write_status\n");
> > +             goto error;
> > +     }
> > +
> > +     ret = device_create_file(&pdev->dev, &dev_attr_i2c_read_reset);
> > +     if (ret) {
> > +             dev_err(&pdev->dev,
> > +                     "error in adding i2c_read_reset\n");
> > +             goto error;
> > +     }
> > +     ret = device_create_file(&pdev->dev, &dev_attr_i2c_write_reset);
> > +     if (ret) {
> > +             dev_err(&pdev->dev,
> > +                     "error in adding i2c_write_reset\n");
> > +             goto error;
> > +     }
> > +
> > +     ret = device_create_file(&pdev->dev, &dev_attr_is_nak_bit);
> > +     if (ret) {
> > +             dev_err(&pdev->dev,
> > +                     "error in adding is_nak_bit\n");
> > +             goto error;
> > +     }
> > +     ret = device_create_file(&pdev->dev, &dev_attr_is_stop_bit);
> > +     if (ret) {
> > +             dev_err(&pdev->dev,
> > +                     "error in adding is_stop_bit\n");
> > +             goto error;
> > +     }
> 
> If really needed, these attributes should be attributes of the i2c adapter and
> not the platform device. And use attribute groups rather than
> device_create_file to avoid racing with userspace.

Ok.

> 
> > +
> > +     ret = cy_get_i2c_config(cyusbs, cy_i2c);
> > +     if (ret < 0) {
> > +             dev_err(&pdev->dev, "error to get i2c config\n");
> > +             goto error;
> 
> You never release the attribute files created above in these error paths.

Ok. With using attribute groups, it would be taken care.

> 
> > +     }
> > +
> > +     if (!cy_i2c->i2c_config.is_master) {
> > +             ret = -EIO;
> > +             dev_err(&pdev->dev, "not an I2C master\n");
> 
> What is returned here if the adapter is in for example SPI mode?

Changes were made to prevent the I2C driver not load on SPI mode.

> 
> > +             goto error;
> > +     }
> > +
> > +     ret = i2c_add_adapter(&cy_i2c->i2c_adapter);
> > +     if (ret != 0) {
> > +             dev_err(&pdev->dev, "failed to add i2c adapter\n");
> > +             goto error;
> > +     }
> > +
> > +     platform_set_drvdata(pdev, cy_i2c);
> > +
> > +     dev_dbg(&pdev->dev, "added I2C adapter\n");
> > +     return 0;
> > +
> > +error:
> > +     dev_dbg(&pdev->dev, "error occured %d\n", ret);
> > +     return ret;
> > +}
> > +
> > +static int cyusbs23x_i2c_remove(struct platform_device *pdev) {
> > +     struct cyusbs_i2c *cy_i2c = platform_get_drvdata(pdev);
> > +
> > +     dev_dbg(&pdev->dev, "%s\n", __func__);
> > +
> > +     i2c_del_adapter(&cy_i2c->i2c_adapter);
> > +
> > +     return 0;
> > +}
> > +
> > +static struct platform_driver cyusbs23x_i2c_driver = {
> > +     .driver.name    = "cyusbs23x-i2c",
> > +     .driver.owner   = THIS_MODULE,
> > +     .probe          = cyusbs23x_i2c_probe,
> > +     .remove         = cyusbs23x_i2c_remove,
> > +};
> > +
> > +static int __init cyusbs23x_i2c_init(void) {
> > +     return platform_driver_register(&cyusbs23x_i2c_driver);
> > +}
> > +subsys_initcall(cyusbs23x_i2c_init);
> > +
> > +static void __exit cyusbs23x_i2c_exit(void) {
> > +     platform_driver_unregister(&cyusbs23x_i2c_driver);
> > +}
> > +module_exit(cyusbs23x_i2c_exit);
> 
> Use module_platform_driver

Ok.

> 
> > +
> > +MODULE_AUTHOR("Rajaram Regupathy <rera@cypress.com>");
> > +MODULE_AUTHOR("Muthu Mani <muth@cypress.com>");
> > +MODULE_DESCRIPTION("i2c-cyusbs23x driver v0.1");
> 
> This is not a description.
> 
> Drop the version number as the kernel version is what matters.

Will update the description.

> 
> > +MODULE_LICENSE("GPL");
> 
> GPL v2 only?

Will update license.

> 
> > +MODULE_ALIAS("platform:cyusbs23x-i2c");
> 
> Johan
