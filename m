Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaIQHZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 03:25:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36624 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaIQHZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 03:25:19 -0400
Date: Wed, 17 Sep 2014 09:24:37 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Robin Gong <b38343@freescale.com>
Cc: Shawn Guo <shawn.guo@freescale.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        kernel@pengutronix.de, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, grant.likely@linaro.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] ARM: dts: imx6: add pm_power_off support for
 i.mx6 chips
Message-ID: <20140917072437.GP4992@pengutronix.de>
References: <1410511739-31122-1-git-send-email-b38343@freescale.com>
 <1410511739-31122-2-git-send-email-b38343@freescale.com>
 <20140917021044.GD4796@dragon>
 <20140917034514.GF27452@Robin-OptiPlex-780>
 <20140917060649.GJ4992@pengutronix.de>
 <20140917071736.GA5545@Robin-OptiPlex-780>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917071736.GA5545@Robin-OptiPlex-780>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:11:53 up 6 days, 23:59, 58 users,  load average: 0.02, 0.08, 0.12
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 03:17:38PM +0800, Robin Gong wrote:
> On Wed, Sep 17, 2014 at 08:06:49AM +0200, Sascha Hauer wrote:
> > On Wed, Sep 17, 2014 at 11:45:15AM +0800, Robin Gong wrote:
> > > On Wed, Sep 17, 2014 at 10:10:45AM +0800, Shawn Guo wrote:
> > > > On Fri, Sep 12, 2014 at 04:48:57PM +0800, Robin Gong wrote:
> > > > > All chips of i.mx6 can be powered off by programming SNVS.
> > > > > For example :
> > > > > On i.mx6q-sabresd board, PMIC_ON_REQ connect with external
> > > > > pmic ON/OFF pin, that will cause the whole PMIC powered off
> > > > > except VSNVS. And system can restart once PMIC_ON_REQ goes
> > > > > high by push POWRER key.
> > > > 
> > > > What's the behavior for those boards on which PMIC_ON_REQ isn't
> > > > connected to anywhere?
> > > >
> > > System can't be powered off if not connect PMIC_ON_REQ. Although all of our
> > > reference design for i.mx6 chips are connecting  PMIC_ON_REQ with external
> > > PMIC, we need consider others may not use external PMIC. I'll add the info
> > > into commit log or Kconfig.
> > 
> > You should add the information to the dtsi file in form of a
> > status = "disabled" property so that boards that actually have the
> > feature can enable it.
> > 
> > Sascha
> Hi Sacha, but that's  SOC level feature and it's harmless even if others don't
> want to use this pin to control external PMIC.

Harmless? If a pm_power_off hook is registered I expect it to work, but
it doesn't work when my board does not have the connection between the
PMIC and the SoC. Even worse, if my board has some custom power of
method you overwrite my method in the snvs poweroff driver with a method
that does not work on my board.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
