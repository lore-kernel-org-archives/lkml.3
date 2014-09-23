Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475AbaIWO4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:56:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37269 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbaIWO4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:56:05 -0400
Date: Tue, 23 Sep 2014 16:55:10 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Joe. C" <srv_yingjoe.chen@mediatek.com>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        "Hongzhou. Yang" <srv_hongzhou.yang@mediatek.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        srv_heupstream@mediatek.com,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, dandan.he@mediatek.com
Subject: Re: [PATCH v2 4/4] ARM: dts: mt8135: Add pinctrl node for mt8135.
Message-ID: <20140923145510.GX4992@pengutronix.de>
References: <1411443545-24951-1-git-send-email-srv_hongzhou.yang@mediatek.com>
 <2770365.r419rjIAOU@wuerfel>
 <1411480694.21299.18.camel@mtksdaap41>
 <7840459.vtELiqVIOL@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7840459.vtELiqVIOL@wuerfel>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:34:55 up 13 days,  7:22, 71 users,  load average: 0.04, 0.08,
 0.06
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 04:10:09PM +0200, Arnd Bergmann wrote:
> On Tuesday 23 September 2014 21:58:14 Joe. C wrote:
> > Thanks for review. 
> > The intend for these macros is helpin pinctrl user to write DT node.
> > With these macro, we could write like this for i2c0:
> > 
> > mediatek,pinfunc = <MT8135_PIN_100_SDA0__FUNC_SDA0 
> >                         MT8135_PIN_101_SCL0__FUNC_SCL0>;
> > 
> > We feel this is less error prone and easier to write than this:
> > 
> > mediatek,pinfunc = <MT_PIN_FUNC(100, 1) MT_PIN_FUNC(101, 1)>
> 
> But you don't actually use the same macros in the driver, so in effect
> you just move the definitions from the file they are needed in to another
> file as a macro.
> 
> It is no less error prone to define those macros in mt8135-pinfunc.h
> than in the pinctrl node, just less readable.

IMO these defines make writing and reviewing dts files much easier. Once
the macros are used widely and thus are likely correct you can be sure
that every board has sane and non conflicting pin setups. The pin names
can often be found in the schematics of a board, so you can verify the
pinmux settings without looking in the SoC datasheet.

If all you have in the dts files is MT_PIN_FUNC(pinx, funcy) then it
can be quite hard to verify pins. First you have to get an idea how
the pin numbers match the pins in the datasheet. In the bindings the
pins are numbered, in the datasheet they usually only have names.
Afterwards you have to find out which functions this pin has and how
these match to the function number in the binding. Repeat this for
dozens of pins.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
