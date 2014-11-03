Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaKCFor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 00:44:47 -0500
Received: from mailgw01.mediatek.com ([218.249.47.110]:34931 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750826AbaKCFon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 00:44:43 -0500
X-Listener-Flag: 11101
Message-ID: <1414993470.10276.19.camel@mhfsdcap03>
Subject: Re: [PATCH 3/3] I2C: mediatek: Add driver for MediaTek I2C
 controller
From: xudong chen <xudong.chen@mediatek.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Mark Rutland <mark.rutland@arm.com>, <arm@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Grant Likely" <grant.likely@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, "Arnd Bergmann" <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>, "Eddie Huang" <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        YH Chen <yh.chen@mediatek.com>
Date: Mon, 3 Nov 2014 13:44:30 +0800
In-Reply-To: <CABuKBeJ2NxcVn=yapcvNs1xLU+eye4JWESBwdcWoeqO=-vMBKw@mail.gmail.com>
References: <1414561058-23803-1-git-send-email-xudong.chen@mediatek.com>
	 <1414561058-23803-4-git-send-email-xudong.chen@mediatek.com>
	 <CABuKBe+RXboBEZD7Bu_kSbVwiapJJcAuuw_wo=xw67osJWJ20w@mail.gmail.com>
	 <1414737101.32208.18.camel@mhfsdcap03>
	 <CABuKBeK1O2q37RMVE0Yjp2=QgkzXZfh=vxXiZrw-JMiYMxb-QQ@mail.gmail.com>
	 <1414766288.5833.46.camel@mtksdaap41>
	 <CABuKBeJ2NxcVn=yapcvNs1xLU+eye4JWESBwdcWoeqO=-vMBKw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 17:10 +0100, Matthias Brugger wrote:
> 2014-10-31 15:38 GMT+01:00 Yingjoe Chen <yingjoe.chen@mediatek.com>:
> > On Fri, 2014-10-31 at 11:48 +0100, Matthias Brugger wrote:
> >> 2014-10-31 7:31 GMT+01:00 xudong chen <xudong.chen@mediatek.com>:
> >> > On Thu, 2014-10-30 at 14:16 +0100, Matthias Brugger wrote:
> >> >> 2014-10-29 6:37 GMT+01:00 Xudong Chen <xudong.chen@mediatek.com>:
> >> >> > The mediatek SoCs have I2C controller that handle I2C transfer.
> >> >> > This patch include common I2C bus driver.
> >> >> > This driver is compatible with I2C controller on mt65xx/mt81xx.
> >> >> >
> >> >> > Signed-off-by: Xudong Chen <xudong.chen@mediatek.com>
> >> >> > Change-Id: Icc17e326b9df46a226d536956e103f17b0382b6e
> >> >> > ---
> >> >> >  drivers/i2c/busses/Kconfig      |   9 +
> >> >> >  drivers/i2c/busses/Makefile     |   1 +
> >> >> >  drivers/i2c/busses/i2c-mt65xx.c | 728 ++++++++++++++++++++++++++++++++++++++++
> >> >> >  3 files changed, 738 insertions(+)
> >> >> >  create mode 100644 drivers/i2c/busses/i2c-mt65xx.c
> >> >> >
> >> >> > diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> >> >> > index 917c358..0d7d0a4 100644
> >> >> > --- a/drivers/i2c/busses/Kconfig
> >> >> > +++ b/drivers/i2c/busses/Kconfig
> >> >> > @@ -564,6 +564,15 @@ config I2C_MPC
> >> >> >           This driver can also be built as a module.  If so, the module
> >> >> >           will be called i2c-mpc.
> >> >> >
> >> >> > +config I2C_MT65XX
> >> >> > +       tristate "MediaTek I2C adapter"
> >> >> > +       depends on ARCH_MEDIATEK
> >> >> > +       help
> >> >> > +         This selects the MediaTek(R) Integrated Inter Circuit bus driver
> >> >> > +         for MT65xx and MT81xx.
> >> >> > +         If you want to use MediaTek(R) I2C interface, say Y or M here.
> >> >> > +         If unsure, say N.
> >> >> > +
> >> >> >  config I2C_MV64XXX
> >> >> >         tristate "Marvell mv64xxx I2C Controller"
> >> >> >         depends on MV64X60 || PLAT_ORION || ARCH_SUNXI
> >> >> > diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> >> >> > index 78d56c5..7a9f0f3 100644
> >> >> > --- a/drivers/i2c/busses/Makefile
> >> >> > +++ b/drivers/i2c/busses/Makefile
> >> >> > @@ -54,6 +54,7 @@ obj-$(CONFIG_I2C_IMX)         += i2c-imx.o
> >> >> >  obj-$(CONFIG_I2C_IOP3XX)       += i2c-iop3xx.o
> >> >> >  obj-$(CONFIG_I2C_KEMPLD)       += i2c-kempld.o
> >> >> >  obj-$(CONFIG_I2C_MPC)          += i2c-mpc.o
> >> >> > +obj-$(CONFIG_I2C_MT65XX)       += i2c-mt65xx.o
> >> >> > +
> >> >> > +static int mt_i2c_do_transfer(struct mt_i2c *i2c)
> >> >> > +{
> >> >> > +       u16 addr_reg;
> >> >> > +       u16 control_reg;
> >> >> > +       int tmo = i2c->adap.timeout;
> >> >> > +
> >> >> > +       i2c->trans_stop = false;
> >> >> > +       i2c->irq_stat = 0;
> >> >> > +
> >> >> > +       /* If use i2c pin from PMIC mt6397 side, need set PATH_DIR first */
> >> >> > +       if (i2c->have_pmic)
> >> >> > +               i2c_writew(I2C_CONTROL_WRAPPER, i2c, OFFSET_PATH_DIR);
> >> >>
> >> >> So this is some sort of multiplexer bit, right?
> >> >> I think in this case we need to build a multi function device (mfd)
> >> >> where the pmic driver will set this bit.
> >> >>
> >> > Hi,
> >> >
> >> > This feature means the chip can use I2C pins from PMIC(mt6397).
> >> > In this case,
> >> > 1. We actually control the register on mt8135 and the DMA/Control Logic
> >> > is on mt8135, only use pins from mt6397. If set register OFFSET_PATH_DIR
> >> > bit0 to 1, the I2C data will go/from PMIC pins.
> >>
> >> Sorry but I'm a bit puzzled. mt6397 is the PMIC, right?
> >> So from the mt6589 datasheet it says:
> >> "PATH_DIR Decides transmission direction
> >> If set, the I2C data will go/from PMIC; otherwise, the I2C data will
> >> go/from main die."
> >>
> >> From my understanding the I2C bus will be multiplexed depending on
> >> this bit. The bit decides if it the data will be send to the PMIC or
> >> to some other I2C peripheral.
> >>
> >> So we need a mfd and the PMIC device driver sets/unsets the PATH_DIR register.
> >
> > Yes, mt6397 is the PMIC work with mt8135 or mt8127.
> >
> > I think the datasheet is a little misleading here. AFAIK, on 8135 even
> > if your clear the bit for I2C4, there are no corresponding pins for this
> > i2c port on 8135. So it is not really multiplexed. Base on my
> > understanding this is more like "Set this bit if this a PMIC I2C port".
> 
> I had a look at mt6589. The SoC has seven i2c controller. Looking at
> the source code all controller with an ID bigger then 3 can be set to
> pmic wrapper state.

I have checked the mt8135 and mt6589 GPIO datasheet, there are pins on
mt8135 or mt6589 for i2c4~i2c6, we also can use i2c4~i2c6 modules on
mt8135 or mt6589 after set pinmux. Sorry about the misunderstand before.
I will add i2c4~i2c6 nodes to the mt8135.dtsi in next patch.

> So I would say that the PATH_DIR bit is not always bound to i2c4. We
> should implement a driver which will work on all possible
> configurations. We don't know if apart from mt6589 and mt8135 some
> other SoC in the future will use this i2c controller.
> 
Because the mt6397 HW limitation, it's i2c module cannot be used when
apart from mt6589 or mt8135.
Take mt6589 for example:
If we want to use mt6397 i2c pins, it must work together with mt6589,
also we need to set the i2c control register on mt6589(DIR_PATH and the
other registers) and then the HW will auto handle the communication
between mt6397 and mt6589 internal(do not need any SW control), so data
can go/from mt6397 pins. In this case the i2c pins on mt6397 will work
just like the i2c pins is from mt6589.

> Maybe you can check with the HW guys how this is implemented to shed
> some light on the issue.
> 



