Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbbAZO21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:28:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:25494 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113AbbAZO2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:28:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,469,1418112000"; 
   d="scan'208";a="676023845"
From: "Tan, Raymond" <raymond.tan@intel.com>
To: Mike Turquette <mturquette@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Alvin" <alvin.chen@intel.com>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        "Tan, Raymond" <raymond.tan@intel.com>
Subject: RE: [PATCH v3 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000
 I2C-GPIO MFD Driver
Thread-Topic: [PATCH v3 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark
 X1000 I2C-GPIO MFD Driver
Thread-Index: AQHQFScZb+ZefmlWzUame3dicNkxRpyKcpeAgBB8lsCALg3ZAIAJvrtQ
Date: Mon, 26 Jan 2015 14:28:10 +0000
Message-ID: <F0CA9E243F4F424B836EAC30E41BF4CF5C7D86E5@PGSMSX104.gar.corp.intel.com>
References: <1418290710-5871-1-git-send-email-raymond.tan@intel.com>
 <1418290710-5871-2-git-send-email-raymond.tan@intel.com>
 <20141211222627.20398.48669@quantum>
 <F0CA9E243F4F424B836EAC30E41BF4CF5C7BCDCA@PGSMSX104.gar.corp.intel.com>
 <20150120173002.22722.46885@quantum>
In-Reply-To: <20150120173002.22722.46885@quantum>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0QESXYr017939

Hi Mike,

Thanks for the acknowledgement. The clk will be consumed by the desginware i2c controller. 

Warm Regards, 

Â Raymond Tan
Software Engineer
Malaysia IT Flex Services
INET: 8-253-0075
Flex Website: http://flexservices.intel.com 

> -----Original Message-----
> From: Mike Turquette [mailto:mturquette@linaro.org]
> Sent: Wednesday, January 21, 2015 1:30 AM
> To: Tan, Raymond; Lee Jones; Samuel Ortiz
> Cc: linux-kernel@vger.kernel.org; Chen, Alvin; Shevchenko, Andriy; Tan,
> Raymond
> Subject: RE: [PATCH v3 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark
> X1000 I2C-GPIO MFD Driver
> 
> Quoting Tan, Raymond (2014-12-21 18:33:42)
> > Hi Mike,
> >
> > Thanks for your reply. I've answered the questions as below.
> >
> > Warm Regards,
> >
> > Raymond Tan
> >
> > > -----Original Message-----
> > > From: Mike Turquette [mailto:mturquette@linaro.org]
> > > Sent: Friday, December 12, 2014 6:26 AM
> > > To: Tan, Raymond; Lee Jones; Samuel Ortiz
> > > Cc: linux-kernel@vger.kernel.org; Chen, Alvin; Shevchenko, Andriy;
> > > Tan, Raymond
> > > Subject: Re: [PATCH v3 1/1] mfd: intel_quark_i2c_gpio: Add Intel
> > > Quark
> > > X1000 I2C-GPIO MFD Driver
> > >
> > > Quoting Raymond Tan (2014-12-11 01:38:30)
> > > > In Quark X1000, there's a single PCI device that provides both an
> > > > I2C controller and a GPIO controller. This MFD driver will split
> > > > the 2 devices for their respective drivers.
> > > >
> > > > This patch is based on Josef Ahmad's initial work for Quark enabling.
> > > >
> > > > Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > Signed-off-by: Weike Chen <alvin.chen@intel.com>
> > > > Signed-off-by: Raymond Tan <raymond.tan@intel.com>
> > > > ---
> > > >  drivers/mfd/Kconfig                |   12 ++
> > > >  drivers/mfd/Makefile               |    1 +
> > > >  drivers/mfd/intel_quark_i2c_gpio.c |  279
> > > > ++++++++++++++++++++++++++++++++++++
> > > >  3 files changed, 292 insertions(+)  create mode 100644
> > > > drivers/mfd/intel_quark_i2c_gpio.c
> > >
> > > <snip>
> > >
> > > > +static int intel_quark_register_i2c_clk(struct intel_quark_mfd
> > > > +*quark_mfd) {
> > > > +       struct pci_dev *pdev = quark_mfd->pdev;
> > > > +       struct clk_lookup *i2c_clk_lookup;
> > > > +       struct clk *i2c_clk;
> > > > +       int retval;
> > > > +
> > > > +       i2c_clk_lookup = devm_kcalloc(
> > > > +               &pdev->dev, INTEL_QUARK_I2C_NCLK,
> > > > +               sizeof(*i2c_clk_lookup), GFP_KERNEL);
> > > > +
> > > > +       if (!i2c_clk_lookup)
> > > > +               return -ENOMEM;
> > > > +
> > > > +       i2c_clk_lookup[0].dev_id = INTEL_QUARK_I2C_CONTROLLER_CLK;
> > > > +
> > > > +       i2c_clk = clk_register_fixed_rate(
> > > > +               &pdev->dev, INTEL_QUARK_I2C_CONTROLLER_CLK, NULL,
> > > > +               CLK_IS_ROOT, INTEL_QUARK_I2C_CLK_HZ);
> > > > +
> > > > +       quark_mfd->i2c_clk_lookup = i2c_clk_lookup;
> > > > +       quark_mfd->i2c_clk = i2c_clk;
> > > > +
> > > > +       retval = clk_register_clkdevs(i2c_clk, i2c_clk_lookup,
> > > > +                                     INTEL_QUARK_I2C_NCLK);
> > >
> > > Lee asked about this in V2, so I'll follow up here in V3. It is OK
> > > for a driver to use the clock provider api to register clocks with
> > > the clk framework if that device truly is the provider of that clock
> > > signal. A good example can be found
> > > here:
> > >
> > > drivers/media/platform/omap3isp/isp.c
> > >
> > > The OMAP3 ISP receives a clock signal as a input. Within the image
> > > signal processor IP block it also has some basic clock controls of
> > > it's own which it feeds to downstream IP blocks. As such it is both
> > > a clock consumer and a provider and this is a common pattern amongst
> SoC designs.
> >
> > Thanks for the reference, however the mfd driver is purely a clk provider in
> this case.
> >
> > >
> > > So my question for this driver is if i2c_clk is provided by whatever
> > > the hell this mfd device is supposed to be, or if it's just a convenient place
> to call the code?
> >
> > As you've noticed, this is a fixed clock which only consumed by the I2C
> controller.
> > Following the structure of the designware i2c controller device
> > driver, a clk is needed for it, and on this platform, it is a fixed clk.
> > I'm putting the clk functions in this mfd driver is due to the fact
> > that, this mfd driver is splitting the function of the PCI device to 2
> controllers downstream.
> >
> > >
> > > Another concern is that fact that this is a fixed clock. For
> > > architectures that use device tree to desribe board topology (ARM,
> > > MIPS,
> > > PPC) it is common to simply put the fixed-rate clocks there and not
> > > directly into the drive code. This prevents having to hack a lot of
> > > conditionals into your driver when rev 2.0 of your hardware comes
> > > out with a faster fixed rate clock, but you still need to support
> > > 1.0 hardware users at the slower rate. I don't know if x86 has a
> > > similar way of describing board topology but it might something to look
> into.
> >
> > I checked the kernel source for x86 arch, sadly there's no similar
> > implementation of fixed clk being developed/written on the architectures
> code.
> > That being said, for this platform, we do have a separate platform
> > board file for those onboard peripherals, do you think that it's
> > better I put the clk function under the board file instead? My
> > reasoning behind is if I were to introduce clk in general to x86 in
> > this way, it's effect will be on x86 unless I introduce further checking during
> compilation / runtime.
> 
> Thanks for the explanation. One final question, who consumes this clock?
> 
> The clk bits of the driver look good to me so please add my:
> 
> Acked-by: Michael Turquette <mturquette@linaro.org>
> 
> Thanks,
> Mike
> 
> >
> > >
> > > Regards,
> > > Mike
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
