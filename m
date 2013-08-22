Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab3HVG0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 02:26:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59350 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab3HVG0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 02:26:44 -0400
Date: Thu, 22 Aug 2013 08:26:10 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Xiubo Li-B47053 <B47053@freescale.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Subject: Re: [PATCH 4/4] Documentation: Add device tree bindings for
 Freescale FTM PWM
Message-ID: <20130822062610.GR31036@pengutronix.de>
Mail-Followup-To: Xiubo Li-B47053 <B47053@freescale.com>,
	Tomasz Figa <tomasz.figa@gmail.com>,
	Guo Shawn-R65073 <r65073@freescale.com>,
	"thierry.reding@gmail.com" <thierry.reding@gmail.com>,
	"grant.likely@linaro.org" <grant.likely@linaro.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	"rob@landley.net" <rob@landley.net>,
	"ian.campbell@citrix.com" <ian.campbell@citrix.com>,
	"swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>,
	"pawel.moll@arm.com" <pawel.moll@arm.com>,
	"rob.herring@calxeda.com" <rob.herring@calxeda.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linus.walleij@linaro.org" <linus.walleij@linaro.org>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
 <1377054462-6283-5-git-send-email-Li.Xiubo@freescale.com>
 <1473340.OXSHEp7d4P@flatron>
 <1DD289F6464F0949A2FCA5AA6DC23F827D2244@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1DD289F6464F0949A2FCA5AA6DC23F827D2244@039-SN2MPN1-013.039d.mgd.msft.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:22:10 up 22 days, 15:26, 41 users,  load average: 0.00, 0.02,
 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 02:55:42AM +0000, Xiubo Li-B47053 wrote:
> Hi Tomasz,
> 
> Thanks for your comments.
> 
> 
> > Could you explain meaning of this property more precisely? I'm interested
> > especially how is this related to the PWM IP block and boards.
> > 
> 
> Yes.
> There are 8 channels most. While the pinctrls of 4th and 5th channels could be
> used by uart's Rx and Tx, then these 2 channels won't be used for pwm output,
> so there will be 6 channels available by the pwm.
> Thus, the pwm chip will register only 6 pwms(6 channels) most("fsl,pwm-channel-orders
> = {0 1 2 3 6 7}").And also the "fsl,pwm-channel-number" will be 6.

If the chip has eight PWMs I would register all of them. If some of them
are not routed out by the pinmux then just nothing happens if you use
them. In a sane devicetree they won't be referenced anyway when they are
not routed out of the SoC.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
