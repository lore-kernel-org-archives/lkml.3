Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3LDGBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 01:01:41 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:28500 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897Ab3LDGBi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 01:01:38 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551biz1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de097hz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2184h21a6h2216h22d0h2336hbe9i1155h)
From: Li Xiubo <Li.Xiubo@freescale.com>
To: Mark Rutland <mark.rutland@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>
CC: Mike Turquette <mturquette@linaro.org>,
        Shawn Guo <Shawn.Guo@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "t.figa@samsung.com" <t.figa@samsung.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Huan Wang <Huan.Wang@freescale.com>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: RE: [PATCHv6 1/4] pwm: Add Freescale FTM PWM driver support
Thread-Topic: [PATCHv6 1/4] pwm: Add Freescale FTM PWM driver support
Thread-Index: AQHO304NjulFCIkIhEyiDysSHbIEFZo7QgeAgAAUJ4CABYdDAIACsfQQ
Date: Wed, 4 Dec 2013 06:01:29 +0000
Message-ID: <1DD289F6464F0949A2FCA5AA6DC23F828E66C5@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1384220218-12716-1-git-send-email-Li.Xiubo@freescale.com>
 <1384220218-12716-2-git-send-email-Li.Xiubo@freescale.com>
 <20131128212510.GC14689@mithrandir> <20131128223719.GG14689@mithrandir>
 <20131202110243.GD12952@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131202110243.GD12952@e106331-lin.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > +static int fsl_pwm_parse_clk_ps(struct fsl_pwm_chip *fpc)
> > > > +{
> > > > +	int ret;
> > > > +	struct of_phandle_args clkspec;
> > > > +	struct device_node *np = fpc->chip.dev->of_node;
> > > > +
> > > > +	fpc->sys_clk = devm_clk_get(fpc->chip.dev, "ftm0");
> > > > +	if (IS_ERR(fpc->sys_clk)) {
> > > > +		ret = PTR_ERR(fpc->sys_clk);
> > > > +		dev_err(fpc->chip.dev,
> > > > +				"failed to get \"ftm0\" clock %d\n", ret);
> > > > +		return ret;
> > > > +	}
> > > > +
> > > > +	fpc->counter_clk = devm_clk_get(fpc->chip.dev, "ftm0_counter");
> > > > +	if (IS_ERR(fpc->counter_clk)) {
> > > > +		ret = PTR_ERR(fpc->counter_clk);
> > > > +		dev_err(fpc->chip.dev,
> > > > +				"failed to get \"ftm0_counter\" clock %d\n",
> > > > +				ret);
> > > > +		return ret;
> > > > +	}
> > > > +
> > > > +	ret = of_parse_phandle_with_args(np, "clocks", "#clock-cells",
> 1,
> > > > +					&clkspec);
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > > +	fpc->counter_clk_select = clkspec.args[0];
> > >
> > > This isn't at all pretty. But given that once you have access to a
> > > struct clk there's no way to identify it, I don't know of a better
> > > alternative.
> >
> > Hi Mike,
> >
> > I've seen this crop up a number of times now, to varying degrees of
> > gravity. In this particular case, the driver needs to know the type of a
> > clock because it needs to program this hardware differently depending on
> > which clock feeds the counter. Since there is no way to obtain any kind
> > of identifying information from a struct clk, drivers need to rely on
> > hacks like this and manually reach into the device tree to obtain that
> > information.
> 
> Which property of the clock is the consumer concerned with in this case?
> 

The "ftm0_counter" clock.


> From a quick look at the driver it looks like there are actually a
> number of different input lines to the device that share the clock-name
> "ftm0_counter", though they are actually separate and each has a
> different divider. Have I got that right?
> 

Yes mostly, there are three different input lines wired to the counter
clock, but they share only one divider. And between the three lines and
the divider there is one mux inside of the FTM IP block.
The three clock sources are:
"ftm0",
"ftm0-fix",
"ftm0-ext".
		 _____________________________________________________
		|									|
		|   +++++++++++		FTM Module				|
ftm0 -------|-->+         +							|
		|   +         +     +++++++++++++     ++++++++++++++	|
ftm0-fix ---|-->+   MUX   +---->+  divider  +---->+  counter   +	|
		|   +         +     +++++++++++++     ++++++++++++++	|
ftm0-ext ---|-->+         +							|
		|   +++++++++++							|
		|_____________________________________________________|



> If that's the case, having a unique clock-names value for each of those
> lines would be the solution I'd expect. Then you just have to list the
> one(s) that are wired up, and the driver can figure out the appropriate
> line to use either by requesting by name until it finds a match or
> inspecting the clock-names property.
> 

Hi Kumar,
In the list archives for mails of "[RFC][PATCHv5 4/4] Documentation: Add
device tree bindings for Freescale FTM PWM.",we have discussed about this.
Is there any different with your suggestions or ideas? 


> Is there some other property of the parent that we care about here?
> 

As I know, not yet.

--
Best Regards,
 

