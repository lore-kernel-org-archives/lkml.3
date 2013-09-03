Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab3ICG7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 02:59:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47951 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab3ICG7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 02:59:00 -0400
Date: Tue, 3 Sep 2013 08:58:32 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Xiubo Li-B47053 <B47053@freescale.com>
Cc: Guo Shawn-R65073 <r65073@freescale.com>,
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
        Lu Jingchang-B35083 <B35083@freescale.com>
Subject: Re: [PATCHv2 1/4] pwm: Add Freescale FTM PWM driver support
Message-ID: <20130903065832.GB30088@pengutronix.de>
Mail-Followup-To: Xiubo Li-B47053 <B47053@freescale.com>,
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
	Lu Jingchang-B35083 <B35083@freescale.com>
References: <1377856132-11290-1-git-send-email-Li.Xiubo@freescale.com>
 <1377856132-11290-2-git-send-email-Li.Xiubo@freescale.com>
 <20130830174909.GF30088@pengutronix.de>
 <1DD289F6464F0949A2FCA5AA6DC23F827F785F@039-SN2MPN1-011.039d.mgd.msft.net>
 <20130902085630.GS30088@pengutronix.de>
 <1DD289F6464F0949A2FCA5AA6DC23F827F7C59@039-SN2MPN1-011.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1DD289F6464F0949A2FCA5AA6DC23F827F7C59@039-SN2MPN1-011.039d.mgd.msft.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:22:45 up 9 days, 15:53, 38 users,  load average: 0.03, 0.04, 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 04:17:09AM +0000, Xiubo Li-B47053 wrote:
> > Subject: Re: [PATCHv2 1/4] pwm: Add Freescale FTM PWM driver support
> > 
> > You simply don't need the available field. You don't need to track
> > whether they are available. If a user enables a pwm which is not routed
> > out of the SoC (disabled in the iomux) simply nothing will happen except
> > for a slightly increased power consumption.
> > 
> If the there is not need to explicitly specify the channels are
> available or not, so there is no doubt that the 'available' field will
> be dropt.  Why I added this here is because that the 4th and 5th
> channels' pinctrls are used as UART TX and RX as I have mentioned
> before, so here if you configure these two pinctrls, the UART TX and
> RX will be polluted, there maybe some other cases like this.

If you misconfigure your iomux then usually unexptected things happen.
That is not the problem of the PWM driver, but the problem of the one
writing the devicetree. The kernel will print a message for conflicting
iomux settings. That should be hint enough to fix it.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
