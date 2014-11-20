Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbaKTJUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:20:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56908 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726AbaKTJUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:20:11 -0500
Date: Thu, 20 Nov 2014 10:19:43 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: Flora Fu <flora.fu@mediatek.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srv_heupstream@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>
Subject: Re: [PATCH 2/7] mfd: MT6397: Add regmap for MT8135 and MT6397 SoC
Message-ID: <20141120091943.GJ30369@pengutronix.de>
References: <1416210027-5562-1-git-send-email-flora.fu@mediatek.com>
 <1416210027-5562-3-git-send-email-flora.fu@mediatek.com>
 <20141118114645.GX24004@x1>
 <20141118134618.GF30369@pengutronix.de>
 <20141119170454.GJ1875@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119170454.GJ1875@x1>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:14:51 up 35 days, 20:28, 73 users,  load average: 0.08, 0.14,
 0.11
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 05:04:54PM +0000, Lee Jones wrote:
> On Tue, 18 Nov 2014, Sascha Hauer wrote:
> 
> > On Tue, Nov 18, 2014 at 11:46:45AM +0000, Lee Jones wrote:
> > > On Mon, 17 Nov 2014, Flora Fu wrote:
> > > 
> > > > Add PMIC wrapper of MT8135 to access MFD MT6397.
> > > > This is regmap of MT6397 MFD.
> > > > 
> > > > Signed-off-by: Flora Fu <flora.fu@mediatek.com>
> > > > ---
> > > >  drivers/mfd/Kconfig            |   8 +
> > > >  drivers/mfd/Makefile           |   1 +
> > > >  drivers/mfd/mt8135-pmic-wrap.c | 847 +++++++++++++++++++++++++++++++++++++++++
> > > 
> > > All of the PMIC functionality needs removing from MFD and placed
> > > somewhere else.  I suggest either drivers/power or drivers/regulator.
> > 
> > This is no PMIC functionality. The MT8135 has a unit which is is used to
> > access the PMIC (which is not only a PMIC, but also Touchscreen
> > interface and other stuff). This unit is called pmic-wrapper in the
> > docs. See the introductory mail for a nice picture.
> 
> I saw the picture, it's very nice.  Whatever this is, it's not an
> MFD.  It's a device which is located on an MFD.  There is far too much
> functional (the operative word here) code contained in this patch.

The MT6397 is a classical MFD device. It has a PMIC, an audio amp and a
RTC. It is very tightly coupled to the SoC via SPI, but the SPI itself
is not directly visible on the SoC. It's accessible indirectly via the
PMIC-wrapper. Indeed the PMIC-wrapper is not MFD. Another dumping ground
that comes to my mind is drivers/soc/. We could move over there.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
