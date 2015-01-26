Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbbAZLLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:11:30 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:37572 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbbAZLL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:11:27 -0500
Date: Mon, 26 Jan 2015 11:11:19 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Yingjoe Chen =?utf-8?B?KOmZs+iLsea0sik=?= 
	<Yingjoe.Chen@mediatek.com>,
        Henry Chen <henryc.chen@mediatek.com>,
        YH Chen =?utf-8?B?KOmZs+aYseixqik=?= <yh.chen@mediatek.com>,
        Flora Fu <flora.fu@mediatek.com>
Subject: Re: [PATCH 7/7] mfd: Add support for the MediaTek MT6397 PMIC
Message-ID: <20150126111119.GE11745@x1>
References: <1422022202-7526-1-git-send-email-s.hauer@pengutronix.de>
 <1422022202-7526-8-git-send-email-s.hauer@pengutronix.de>
 <20150123161440.GA11745@x1>
 <20150126105222.GM12209@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150126105222.GM12209@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015, Sascha Hauer wrote:
> On Fri, Jan 23, 2015 at 04:14:40PM +0000, Lee Jones wrote:
> > On Fri, 23 Jan 2015, Sascha Hauer wrote:
> > 
> > > From: Flora Fu <flora.fu@mediatek.com>
> > > 
> > > This adds support for the MediaTek MT6397 PMIC. This is a
> > > multifunction device with the following sub modules:
> > > 
> > > - Regulator
> > > - RTC
> > > - Audio codec
> > > - GPIO
> > > - Clock
> > > 
> > > It is interfaced to the host controller using SPI interface by a proprietary
> > > hardware called PMIC wrapper or pwrap. MT6397 MFD is a child device of the
> > > pwrap.
> > > 
> > > Signed-off-by: Flora Fu, MediaTek
> > > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > > Cc: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  Documentation/devicetree/bindings/mfd/mt6397.txt |  70 +++++

[...]

> > > +	struct mt6397_chip *mt6397 = irq_get_chip_data(data->irq);
> > > +	int shift = mt6397_irq_shift(data->hwirq);
> > > +	int reg = mt6397_irq_reg(data->hwirq);
> > > +	int reg_ofs = MT6397_INT_CON0 + reg * 2;
> > > +
> > > +	mt6397->irq_masks_cur[reg] &= ~(1 << shift);
> > 
> > s/(1 << shift)/BIT(shift)/
> 
> Is it mentioned somewhere that these BIT macros shall be used? There are
> quadrillions of examples for both styles in the kernel and personally I
> think 1 << x is more readable.

I haven't seen a hard and fast 'rule' per say.  I think it's left up
to the Maintainer of any given subsystem. ;)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
