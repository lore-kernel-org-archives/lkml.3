Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184AbaIXMlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:41:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60491 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaIXMlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:41:13 -0400
Date: Wed, 24 Sep 2014 14:40:44 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Hongzhou.Yang" <srv_hongzhou.yang@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, srv_heupstream@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        dandan.he@mediatek.com
Subject: Re: [PATCH v2 4/4] ARM: dts: mt8135: Add pinctrl node for mt8135.
Message-ID: <20140924124044.GC4992@pengutronix.de>
References: <1411443545-24951-1-git-send-email-srv_hongzhou.yang@mediatek.com>
 <1411443545-24951-5-git-send-email-srv_hongzhou.yang@mediatek.com>
 <CACRpkda-K7w-bY0uSdnZvzEKEeQg38oExoHPSW61kEv9Wv20mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkda-K7w-bY0uSdnZvzEKEeQg38oExoHPSW61kEv9Wv20mA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:12:01 up 14 days,  4:59, 77 users,  load average: 0.08, 0.06,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Sep 24, 2014 at 01:23:09PM +0200, Linus Walleij wrote:
> On Tue, Sep 23, 2014 at 5:39 AM, Hongzhou.Yang
> <srv_hongzhou.yang@mediatek.com> wrote:
> 
> > From: Hongzhou Yang <hongzhou.yang@mediatek.com>
> >
> > Add pinctrl node to mt8135.dtsi.
> >
> > Signed-off-by: Hongzhou Yang <hongzhou.yang@mediatek.com>
> (...)
> > +#define MT8135_PIN_0_MSDC0_DAT7__FUNC_GPIO0 (MT_PIN_NO(0) | 0)
> > +#define MT8135_PIN_0_MSDC0_DAT7__FUNC_MSDC0_DAT7 (MT_PIN_NO(0) | 1)
> > +#define MT8135_PIN_0_MSDC0_DAT7__FUNC_EINT49 (MT_PIN_NO(0) | 2)
> > +#define MT8135_PIN_0_MSDC0_DAT7__FUNC_I2SOUT_DAT (MT_PIN_NO(0) | 3)
> 
> I haven't got to reviewing the driver, but this looks just wrong.
> 
> Have the magic numbers in the driver.
> 
> Use strings to describe functions, not integers.

Interrupts, clocks, gpios, dma channels, nearly everything in the device tree is
arbitrarily numbered. Instead of "irq-i2c0" we have <0 36 IRQ_TYPE_LEVEL_HIGH>
in the device tree. These numbers can be resolved efficiently in the
driver by shifting them to get a bitmask or by adding them as offset to
a register base.
Why do you want to make pinctrl different? Thanks to the recently
introduced defines in the device trees these numbers are not magic at
all anymore.

> 
> We need to move toward standardized device tree bindings
> for this stuff, and that means using strings, not magic
> numbers.

Agreed for standardized device tree bindings, but not for using strings.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
