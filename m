Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaJFHTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 03:19:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46274 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaJFHTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 03:19:15 -0400
Date: Mon, 6 Oct 2014 09:18:41 +0200
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
Message-ID: <20141006071841.GN4992@pengutronix.de>
References: <1411443545-24951-1-git-send-email-srv_hongzhou.yang@mediatek.com>
 <1411443545-24951-5-git-send-email-srv_hongzhou.yang@mediatek.com>
 <CACRpkda-K7w-bY0uSdnZvzEKEeQg38oExoHPSW61kEv9Wv20mA@mail.gmail.com>
 <20140924124044.GC4992@pengutronix.de>
 <CACRpkdbtN-BDEwpJO2swnOjCe3UJhD5WOXXKBV0hPOe2M2=k7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbtN-BDEwpJO2swnOjCe3UJhD5WOXXKBV0hPOe2M2=k7Q@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:27:23 up 25 days, 23:14, 64 users,  load average: 0.05, 0.05,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 04:02:58PM +0200, Linus Walleij wrote:
> On Wed, Sep 24, 2014 at 2:40 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Wed, Sep 24, 2014 at 01:23:09PM +0200, Linus Walleij wrote:
> 
> >> I haven't got to reviewing the driver, but this looks just wrong.
> >>
> >> Have the magic numbers in the driver.
> >>
> >> Use strings to describe functions, not integers.
> >
> > Interrupts, clocks, gpios, dma channels, nearly everything in the device tree is
> > arbitrarily numbered. Instead of "irq-i2c0" we have <0 36 IRQ_TYPE_LEVEL_HIGH>
> > in the device tree. These numbers can be resolved efficiently in the
> > driver by shifting them to get a bitmask or by adding them as offset to
> > a register base.
> > Why do you want to make pinctrl different?
> 
> Because pin control is about combining groups of pins with
> certain functions.
> 
> > Thanks to the recently
> > introduced defines in the device trees these numbers are not magic at
> > all anymore.
> 
> Yeah that is good but not what I'm after here.
> 
> >> We need to move toward standardized device tree bindings
> >> for this stuff, and that means using strings, not magic
> >> numbers.
> >
> > Agreed for standardized device tree bindings, but not for using strings.
> 
> What is the alternative? Device Tree is very much about strings,
> as is shown by the pin config bindings.

The alternative is to use numbers. The majority of SoCs have a bit field
per pad which is used for muxing the pad to different functions. The
natural way to describe this is a pair of numbers: <pad-number>
<function-number>.  The pad number can normally be directly translated
into a register offset and the function number to a value written to
that register. This is true for most SoCs I know of and makes it very
easy to generate code for and to prove for correctness of both the code
and the device tree.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
