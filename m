Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab3HUJvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:51:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39767 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3HUJvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:51:05 -0400
Date: Wed, 21 Aug 2013 11:50:49 +0200
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
Subject: Re: [PATCH 1/4] pwm: add freescale ftm pwm driver support
Message-ID: <20130821095049.GQ31036@pengutronix.de>
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
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
 <1377054462-6283-2-git-send-email-Li.Xiubo@freescale.com>
 <20130821073659.GN31036@pengutronix.de>
 <1DD289F6464F0949A2FCA5AA6DC23F827D1C51@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1DD289F6464F0949A2FCA5AA6DC23F827D1C51@039-SN2MPN1-013.039d.mgd.msft.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:37:37 up 21 days, 18:41, 44 users,  load average: 0.00, 0.03,
 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 09:24:56AM +0000, Xiubo Li-B47053 wrote:
> TO Sascha,
> 
> > > +
> > > +	fpc = to_fsl_chip(chip);
> > > +
> > > +	if (WARN_ON(!test_bit(PWMF_REQUESTED, &pwm->flags)))
> > > +		return -ESHUTDOWN;
> > > +
> > > +	statename = kasprintf(GFP_KERNEL, "en%d", pwm->hwpwm);
> > > +	pins_state = pinctrl_lookup_state(fpc->pinctrl,
> > > +			statename);
> > > +	/* enable pins to be muxed in and configured */
> > > +	if (!IS_ERR(pins_state)) {
> > > +		ret = pinctrl_select_state(fpc->pinctrl, pins_state);
> > > +		if (ret)
> > > +			dev_warn(&fpc->pdev->dev,
> > > +					"could not set default pins\n");
> > 
> > Why do you need to manipulate the pinctrl to en/disable a channel?
> > 
> 
> This is because in Vybrid VF610 TOWER board, there are 4 leds, and each led's one point(diode's positive pole) is connected to 3.3V,
> and the other point is connected to pwm's one channel. When the 4 pinctrls are configured as enable at the same time, 
> the 4 pinctrls is low valtage, and the 4 leds will be lighted up as default, then when you enable/disable one led will effects others.
> 

I think the inactive state of a PWM is pretty much undefined by the PWM
framework and left to the drivers.

I stumbled upon this aswell. It would be good to think about the
inactive state and how the PWM framework could help us here getting
things right.

There are several things to consider. For a noninverted PWM the inactive
state should probably logic 0. For an inverted PWM it should probably be
logic 1. I guess several PWM devices have an undefined inactive state,
most of the PWM devices probably can control the inactive state by
setting the duty cycle to 100% / 0% without actually disabling the PWM.

Using the pinctrl is one way to control the inactive state and probaby
the only one before initialization. It might be good to wire this up in
the core instead of the individual PWM drivers.

These are just the thoughts which first came to my mind.

Thierry, any more input about this?


> > > +	fpc = dev_get_drvdata(dev);
> > > +
> > > +	ret = kstrtouint(buf, 0, &val);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	mutex_lock(&fpc->lock);
> > > +	if (!!(val) != !!(fpc->cpwm)) {
> > > +		fpc->cpwm = !!val;
> > > +		fsl_updata_config(fpc, NULL);
> > > +	}
> > > +	mutex_unlock(&fpc->lock);
> > > +
> > > +	return count;
> > > +}
> > 
> > What is this cpwm thingy?
> 
> Up-down counting mode:
> CNTIN(a register) defines the starting value of the count and MOD(a register) defines the final value of the
> count. The value of CNTIN is loaded into the FTM counter, and the counter increments
> until the value of MOD is reached, at which point the counter is decremented until it
> returns to the value of CNTIN and the up-down counting restarts.

The current PWM framework only cares about period times and duty cycles.
Why would I want to care about this?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
