Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934534Ab3FSJLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:11:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:44330 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934517Ab3FSJLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:11:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,895,1363158000"; 
   d="scan'208";a="319325555"
Date: Wed, 19 Jun 2013 11:11:27 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Kevin Strasser <kevin.strasser@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Michael Brunner <mibru@gmx.de>, Chris Healy <chealy@imsco-us.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wim Van Sebroeck <wim@iguana.be>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 1/4] mfd: Kontron PLD mfd driver
Message-ID: <20130619091127.GW7161@zurbaran>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
 <1371589469-32700-1-git-send-email-kevin.strasser@linux.intel.com>
 <1371589469-32700-2-git-send-email-kevin.strasser@linux.intel.com>
 <CACRpkdap753rf82jqDx4CGRcsNRUYwsrsfpJe4=331NQom6SuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdap753rf82jqDx4CGRcsNRUYwsrsfpJe4=331NQom6SuA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Jun 19, 2013 at 10:40:04AM +0200, Linus Walleij wrote:
> On Tue, Jun 18, 2013 at 11:04 PM, Kevin Strasser
> <kevin.strasser@linux.intel.com> wrote:
> > Add core MFD driver for the on-board PLD found on some Kontron embedded
> > modules. The PLD device may provide functions like watchdog, GPIO, UART
> > and I2C bus.
> >
> > The following modules are supported:
> >         * COMe-bIP#
> >         * COMe-bPC2 (ETXexpress-PC)
> >         * COMe-bSC# (ETXexpress-SC T#)
> >         * COMe-cCT6
> >         * COMe-cDC2 (microETXexpress-DC)
> >         * COMe-cPC2 (microETXexpress-PC)
> >         * COMe-mCT10
> >         * ETX-OH
> >
> > Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>
> > Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
> > Acked-by: Guenter Roeck <linux@roeck-us.net>
> > Acked-by: Darren Hart <dvhart@linux.intel.com>
> 
> (...)
> > +/**
> > + * kempld_read8 - read 8 bit register
> > + * @pld: kempld_device_data structure describing the PLD
> > + * @index: register index on the chip
> > + *
> > + * kempld_get_mutex must be called prior to calling this function.
> > + */
> > +u8 kempld_read8(struct kempld_device_data *pld, u8 index)
> > +{
> > +       iowrite8(index, pld->io_index);
> > +       return ioread8(pld->io_data);
> > +}
> > +EXPORT_SYMBOL_GPL(kempld_read8);
> > +
> > +/**
> > + * kempld_write8 - write 8 bit register
> > + * @pld: kempld_device_data structure describing the PLD
> > + * @index: register index on the chip
> > + * @data: new register value
> > + *
> > + * kempld_get_mutex must be called prior to calling this function.
> > + */
> > +void kempld_write8(struct kempld_device_data *pld, u8 index, u8 data)
> > +{
> > +       iowrite8(index, pld->io_index);
> > +       iowrite8(data, pld->io_data);
> > +}
> > +EXPORT_SYMBOL_GPL(kempld_write8);
> > +
> > +/**
> > + * kempld_read16 - read 16 bit register
> > + * @pld: kempld_device_data structure describing the PLD
> > + * @index: register index on the chip
> > + *
> > + * kempld_get_mutex must be called prior to calling this function.
> > + */
> > +u16 kempld_read16(struct kempld_device_data *pld, u8 index)
> > +{
> > +       return kempld_read8(pld, index) | kempld_read8(pld, index + 1) << 8;
> > +}
> > +EXPORT_SYMBOL_GPL(kempld_read16);
> > +
> > +/**
> > + * kempld_write16 - write 16 bit register
> > + * @pld: kempld_device_data structure describing the PLD
> > + * @index: register index on the chip
> > + * @data: new register value
> > + *
> > + * kempld_get_mutex must be called prior to calling this function.
> > + */
> > +void kempld_write16(struct kempld_device_data *pld, u8 index, u16 data)
> > +{
> > +       kempld_write8(pld, index, (u8)data);
> > +       kempld_write8(pld, index + 1, (u8)(data >> 8));
> > +}
> > +EXPORT_SYMBOL_GPL(kempld_write16);
> > +
> > +/**
> > + * kempld_read32 - read 32 bit register
> > + * @pld: kempld_device_data structure describing the PLD
> > + * @index: register index on the chip
> > + *
> > + * kempld_get_mutex must be called prior to calling this function.
> > + */
> > +u32 kempld_read32(struct kempld_device_data *pld, u8 index)
> > +{
> > +       return kempld_read16(pld, index) | kempld_read16(pld, index + 2) << 16;
> > +}
> > +EXPORT_SYMBOL_GPL(kempld_read32);
> > +
> > +/**
> > + * kempld_write32 - write 32 bit register
> > + * @pld: kempld_device_data structure describing the PLD
> > + * @index: register index on the chip
> > + * @data: new register value
> > + *
> > + * kempld_get_mutex must be called prior to calling this function.
> > + */
> > +void kempld_write32(struct kempld_device_data *pld, u8 index, u32 data)
> > +{
> > +       kempld_write16(pld, index, (u16)data);
> > +       kempld_write16(pld, index + 2, (u16)(data >> 16));
> > +}
> > +EXPORT_SYMBOL_GPL(kempld_write32);
> (...)
> > +extern u8 kempld_read8(struct kempld_device_data *pld, u8 index);
> > +extern void kempld_write8(struct kempld_device_data *pld, u8 index, u8 data);
> > +extern u16 kempld_read16(struct kempld_device_data *pld, u8 index);
> > +extern void kempld_write16(struct kempld_device_data *pld, u8 index, u16 data);
> > +extern u32 kempld_read32(struct kempld_device_data *pld, u8 index);
> > +extern void kempld_write32(struct kempld_device_data *pld, u8 index, u32 data);
> 
> Not really my business, but I think if I was to implement this
> inter-module API I would use regmap for this read/write marshalling
> right here.
I thought about this one and was under the impression that the regmap
API would not let us implement this kind of stuff. I don't see how the
reg_read and reg_write hooks would allow us to implement that, but I may
be missing something here. Maybe Mark can provide some more input.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
