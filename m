Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab3IBI4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:56:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34099 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758596Ab3IBI4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:56:43 -0400
Date: Mon, 2 Sep 2013 10:56:31 +0200
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
Message-ID: <20130902085630.GS30088@pengutronix.de>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1DD289F6464F0949A2FCA5AA6DC23F827F785F@039-SN2MPN1-011.039d.mgd.msft.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:52:57 up 8 days, 18:23, 33 users,  load average: 0.01, 0.02, 0.19
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 03:33:37AM +0000, Xiubo Li-B47053 wrote:
> 
> > > +static void fsl_pwm_free(struct pwm_chip *chip, struct pwm_device
> > > +*pwm) {
> > > +	struct fsl_pwm_chip *fpc;
> > > +	struct fsl_pwm_data *pwm_data;
> > > +
> > > +	fpc = to_fsl_chip(chip);
> > > +
> > > +	pwm_data = pwm_get_chip_data(pwm);
> > > +	if (!pwm_data)
> > > +		return;
> > 
> > THis check seems unnecessary.
> > 
> 
> But if do not check it here, I must check it in the following code.
> 
> > > +
> > > +	if (pwm_data->available != FSL_AVAILABLE)
> > > +		return;
> > > +
> 
> So the ' struct fsl_pwm_data' may be removed in the future.
> 
> > 
> > > +
> > > +
> > > +	pwm_data->period_cycles = period_cycles;
> > > +	pwm_data->duty_cycles = duty_cycles;
> > 
> > These fields are set but never read. Please drop them.
> > 
> > If you drop the 'available' field also the you can drop chip_data
> > completely.
> > 
> 
> I think I may move the 'available' field to the PWM driver data struct.

You simply don't need the available field. You don't need to track
whether they are available. If a user enables a pwm which is not routed
out of the SoC (disabled in the iomux) simply nothing will happen except
for a slightly increased power consumption.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
