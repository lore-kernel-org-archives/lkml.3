Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbbAZL0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:26:37 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56901 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbbAZL0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:26:35 -0500
Date: Mon, 26 Jan 2015 12:26:29 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Lee Jones <lee.jones@linaro.org>
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
Message-ID: <20150126112629.GP12209@pengutronix.de>
References: <1422022202-7526-1-git-send-email-s.hauer@pengutronix.de>
 <1422022202-7526-8-git-send-email-s.hauer@pengutronix.de>
 <20150123161440.GA11745@x1>
 <20150126105222.GM12209@pengutronix.de>
 <20150126111119.GE11745@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126111119.GE11745@x1>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:22:02 up 102 days, 22:35, 144 users,  load average: 0.06, 0.31,
 0.27
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 11:11:19AM +0000, Lee Jones wrote:
> On Mon, 26 Jan 2015, Sascha Hauer wrote:
> > On Fri, Jan 23, 2015 at 04:14:40PM +0000, Lee Jones wrote:
> > > On Fri, 23 Jan 2015, Sascha Hauer wrote:
> > > > +	struct mt6397_chip *mt6397 = irq_get_chip_data(data->irq);
> > > > +	int shift = mt6397_irq_shift(data->hwirq);
> > > > +	int reg = mt6397_irq_reg(data->hwirq);
> > > > +	int reg_ofs = MT6397_INT_CON0 + reg * 2;
> > > > +
> > > > +	mt6397->irq_masks_cur[reg] &= ~(1 << shift);
> > > 
> > > s/(1 << shift)/BIT(shift)/
> > 
> > Is it mentioned somewhere that these BIT macros shall be used? There are
> > quadrillions of examples for both styles in the kernel and personally I
> > think 1 << x is more readable.
> 
> I haven't seen a hard and fast 'rule' per say.  I think it's left up
> to the Maintainer of any given subsystem. ;)

Ok, I know your opinion already, I hope Samuel has the same ;).
I'll change it to BIT().

Maybe I'll even change my personal opinion since I noticed that 1 << x
doesn't work for 64bit registers. Here 1UL << x must be used, but this
could easily be forgotten.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
