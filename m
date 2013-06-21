Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423103Ab3FUOwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:52:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61791 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161419Ab3FUOwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:52:34 -0400
Date: Fri, 21 Jun 2013 16:52:28 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@kernel.org>
cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/2] regulators: max8973: initial DT support
In-Reply-To: <20130621144423.GX27646@sirena.org.uk>
Message-ID: <Pine.LNX.4.64.1306211651120.27277@axis700.grange>
References: <Pine.LNX.4.64.1306210825040.27277@axis700.grange>
 <Pine.LNX.4.64.1306210827090.27277@axis700.grange> <20130621144423.GX27646@sirena.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:jSc9utd5YQoP+l5i+MFiUbz6/0HpFbaONIGddIZSJvj
 Y6FUXNIPtLtSVtENP/3oSI34YTR3OS9ACxgACkqdt9s+i/NRYy
 zfcZEQ0WHejl/vRQGqa23x0CaqEW6ozQTRpKsT+rx4hNvh1H/x
 fRRmne5Kk1sJcuddbbH+oK8ozwl+f3as1xIuFX1EyHPS9YruIg
 vsIkkeoomW2u3YBIxkr1WCXCUJAD+G7+lWaMGvmqQ6pKDm7Fb1
 vodil44TdogNy/NKXF1ruS98tNxhtMR/fDfksDeGGZMgnfxr7Y
 407Wgrc22p5hGpCnkILKu13KmKbsqq1dlguL5VgzH4I2cP6Fbw
 kR3N8e6xLPWWNKdYkbfTgCnGaUDAUk+TB04mvf6BkdZPTPsCzD
 lTt1RZCbLEd7A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark

Thanks for the review

On Fri, 21 Jun 2013, Mark Brown wrote:

> On Fri, Jun 21, 2013 at 08:30:26AM +0200, Guennadi Liakhovetski wrote:
> 
> > +Required properties:
> > +
> > +- compatible:	must be "maxium,max8973"
> > +- reg:		the i2c slave address of the regulator. It should be 0x1b.
> > +- regulators:	a subnode with a single regulator descriptor in it called "dcdc"
> 
> Why make this a subnode - if there's only one regulator on the device
> then it may as well just put all the regulator properties there?

Right, I wasn't sure about this, I thought it was kind of a common 
practice even for just one regulator. Will embed, sure.

> 
> > +	if (!regulators) {
> > +		dev_err(dev, "regulator node not found\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	ret = of_regulator_match(dev, regulators,
> > +				 &max8973_regulator_match, 1);
> > +	of_node_put(regulators);
> > +	if (ret < 0) {
> > +		dev_err(dev, "Error parsing regulator init data: %d\n", ret);
> > +		return ret;
> > +	}
> > +	if (!ret) {
> > +		dev_err(dev, "No regulator configuration found\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	return 0;
> 
> This would simplify the code here, the driver can just call
> of_get_regulator_init_data() directly with the node.

Ok, I'll look at it.

> > -	if (!pdata->enable_ext_control) {
> > +	if (!pdata || !pdata->enable_ext_control) {
> >  		max->desc.enable_reg = MAX8973_VOUT;
> >  		max->desc.enable_mask = MAX8973_VOUT_ENABLE;
> >  		max->ops.enable = regulator_enable_regmap;
> 
> A common approach here is just to embed the platform data in the
> driver data then copy actual platform data in there or parse the device
> tree bindings (when added) into the structure.  This means that most of
> the driver can just assume there's platform data which makes life a bit
> simpler.

But we can do this later, when we add DT support for those parameters, 
right?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
