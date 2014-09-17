Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbaIQIKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:10:10 -0400
Received: from mail-bl2on0106.outbound.protection.outlook.com ([65.55.169.106]:25249
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751577AbaIQIKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:10:05 -0400
Date: Wed, 17 Sep 2014 16:16:22 +0800
From: Robin Gong <b38343@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Shawn Guo <shawn.guo@freescale.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <kernel@pengutronix.de>, <sre@kernel.org>, <dbaryshkov@gmail.com>,
        <dwmw2@infradead.org>, <grant.likely@linaro.org>,
        <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/3] ARM: dts: imx6: add pm_power_off support for
 i.mx6 chips
Message-ID: <20140917081609.GA6274@Robin-OptiPlex-780>
References: <1410511739-31122-1-git-send-email-b38343@freescale.com>
 <1410511739-31122-2-git-send-email-b38343@freescale.com>
 <20140917021044.GD4796@dragon> <20140917034514.GF27452@Robin-OptiPlex-780>
 <20140917060649.GJ4992@pengutronix.de>
 <20140917071736.GA5545@Robin-OptiPlex-780>
 <20140917072437.GP4992@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140917072437.GP4992@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(51704005)(199003)(24454002)(93886004)(104016003)(33716001)(77982003)(84676001)(74502003)(85306004)(21056001)(87936001)(102836001)(4396001)(74662003)(97756001)(80022003)(15975445006)(79102003)(46102003)(81342003)(46406003)(19580395003)(81542003)(83072002)(99396002)(83322001)(85852003)(68736004)(6806004)(92566001)(50466002)(54356999)(76176999)(15202345003)(50986999)(23726002)(26826002)(64706001)(105606002)(97736003)(20776003)(44976005)(92726001)(106466001)(33656002)(90102001)(47776003)(110136001)(31966008)(76482002)(107046002)(83506001)(95666004)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB343;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB343;
X-Forefront-PRVS: 0337AFFE9A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 09:24:37AM +0200, Sascha Hauer wrote:
> On Wed, Sep 17, 2014 at 03:17:38PM +0800, Robin Gong wrote:
> > On Wed, Sep 17, 2014 at 08:06:49AM +0200, Sascha Hauer wrote:
> > > On Wed, Sep 17, 2014 at 11:45:15AM +0800, Robin Gong wrote:
> > > > On Wed, Sep 17, 2014 at 10:10:45AM +0800, Shawn Guo wrote:
> > > > > On Fri, Sep 12, 2014 at 04:48:57PM +0800, Robin Gong wrote:
> > > > > > All chips of i.mx6 can be powered off by programming SNVS.
> > > > > > For example :
> > > > > > On i.mx6q-sabresd board, PMIC_ON_REQ connect with external
> > > > > > pmic ON/OFF pin, that will cause the whole PMIC powered off
> > > > > > except VSNVS. And system can restart once PMIC_ON_REQ goes
> > > > > > high by push POWRER key.
> > > > > 
> > > > > What's the behavior for those boards on which PMIC_ON_REQ isn't
> > > > > connected to anywhere?
> > > > >
> > > > System can't be powered off if not connect PMIC_ON_REQ. Although all of our
> > > > reference design for i.mx6 chips are connecting  PMIC_ON_REQ with external
> > > > PMIC, we need consider others may not use external PMIC. I'll add the info
> > > > into commit log or Kconfig.
> > > 
> > > You should add the information to the dtsi file in form of a
> > > status = "disabled" property so that boards that actually have the
> > > feature can enable it.
> > > 
> > > Sascha
> > Hi Sacha, but that's  SOC level feature and it's harmless even if others don't
> > want to use this pin to control external PMIC.
> 
> Harmless? If a pm_power_off hook is registered I expect it to work, but
> it doesn't work when my board does not have the connection between the
> PMIC and the SoC. Even worse, if my board has some custom power of
> method you overwrite my method in the snvs poweroff driver with a method
> that does not work on my board.
> 
> Sascha
Sorry, I suppose PMIC_ON_REQ is the only way to control external power ON/OFF.
If they don't use PMIC_ON_REQ, I assume they drop poweroff feature.
Yes, I agree with you that set status as 'disable' in DTS make things clear if
they want to use other pins to control external power. But I'm not sure whether
we need consider this special case to 'disable' the soc level feature and
re-enable on many boards level DTS? Also, I don't understand why they give up
PMIC_ON_REQ and consume another pin to do the same thing....But I'm ok if both
you and Shawn agree with it.
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
