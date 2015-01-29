Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586AbbA2O1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:27:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33722 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbbA2O1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:27:47 -0500
Date: Thu, 29 Jan 2015 15:27:40 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        YH Chen =?utf-8?B?KOmZs+aYseixqik=?= <yh.chen@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Henry Chen <henryc.chen@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Yingjoe Chen =?utf-8?B?KOmZs+iLsea0sik=?= 
	<Yingjoe.Chen@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        James Liao <jamesjj.liao@mediatek.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v2] MediaTek PMIC support
Message-ID: <20150129142740.GH12209@pengutronix.de>
References: <1422022202-7526-1-git-send-email-s.hauer@pengutronix.de>
 <20150126114735.GA3178@pengutronix.de>
 <CABuKBe+x9o5OiysnMq-gvOBx3nKoaheL2efZGA6YQ7ZT5aqijw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABuKBe+x9o5OiysnMq-gvOBx3nKoaheL2efZGA6YQ7ZT5aqijw@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:49:16 up 106 days,  1:03, 146 users,  load average: 0.01, 0.07,
 0.11
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2015 at 01:39:42PM +0100, Matthias Brugger wrote:
> Hi Sascha,
> 
> 2015-01-26 12:47 GMT+01:00 Sascha Hauer <s.hauer@pengutronix.de>:
> > Olof, Arnd,
> >
> > OK to put the driver into drivers/soc/mediatek? Can you take these
> > patches?
> 
> How does this patches fit together with the one James clock framework patches?
> Both use the same compatible "mediatek,mt8135-infracfg" and
> "mediatek,mt8135-pericfg".
> 
> I had a look on other implementations and they attach the reset
> controller to the clk driver, if they share the same hw block.
> Might we run into problems if we implement the clocks in the mfd, as
> we need the clocks early in boot (e.g. for the timer)?

>From my experience the clocks are needed by the timer before any driver
initializes.

> 
> In mt6589 pericfg apart from the clocks and reset controller provides
> registers for AXI bus control and USB wakeup and USB clock selection.
> The infracfg block provides top AXI bus fabric control signals and
> remap registers for the modem.
> Mike, Stephen, what do you think. Can we implement the clk in a mfd
> driver? Or do you prefer to implement the whole block in the clk
> driver?

Currently the clk support uses regular CLK_OF_DECLARE which handles the
clock part of pericfg/infracfg and then later a regular driver for
pericfg/infracfg comes and handles the rest of the functionality. Since
both use separate registers in the device register space it should work
fine.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
