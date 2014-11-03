Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaKCILd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:11:33 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48861 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaKCILc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:11:32 -0500
Date: Mon, 3 Nov 2014 09:11:05 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Xudong Chen <xudong.chen@mediatek.com>,
        Mark Rutland <mark.rutland@arm.com>, arm@kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-i2c@vger.kernel.org, Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        YH Chen <yh.chen@mediatek.com>
Subject: Re: [PATCH 3/3] I2C: mediatek: Add driver for MediaTek I2C controller
Message-ID: <20141103081105.GD14482@pengutronix.de>
References: <1414561058-23803-1-git-send-email-xudong.chen@mediatek.com>
 <1414561058-23803-4-git-send-email-xudong.chen@mediatek.com>
 <CABuKBe+RXboBEZD7Bu_kSbVwiapJJcAuuw_wo=xw67osJWJ20w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABuKBe+RXboBEZD7Bu_kSbVwiapJJcAuuw_wo=xw67osJWJ20w@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:59:28 up 18 days, 19:13, 48 users,  load average: 0.12, 0.18,
 0.19
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 02:16:04PM +0100, Matthias Brugger wrote:
> 2014-10-29 6:37 GMT+01:00 Xudong Chen <xudong.chen@mediatek.com>:
> > +static int mt_i2c_do_transfer(struct mt_i2c *i2c)
> > +{
> > +       u16 addr_reg;
> > +       u16 control_reg;
> > +       int tmo = i2c->adap.timeout;
> > +
> > +       i2c->trans_stop = false;
> > +       i2c->irq_stat = 0;
> > +
> > +       /* If use i2c pin from PMIC mt6397 side, need set PATH_DIR first */
> > +       if (i2c->have_pmic)
> > +               i2c_writew(I2C_CONTROL_WRAPPER, i2c, OFFSET_PATH_DIR);
> 
> So this is some sort of multiplexer bit, right?
> I think in this case we need to build a multi function device (mfd)
> where the pmic driver will set this bit.

This bit is in the i2c controller register space, so it shouldn't be
controlled by some other driver. I think the configuration of this
register is already in the correct place. What I could think of is that
the PMIC could implement a pinctrl driver and the i2c controller driver
gets the pins from the PMIC. Anyway, the controlling of this bit would
still be in the i2c driver.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
