Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab3GXKTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 06:19:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46899 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3GXKTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 06:19:11 -0400
Date: Wed, 24 Jul 2013 12:18:59 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Robin Gong <b38343@freescale.com>
Cc: broonie@kernel.org, shawn.guo@linaro.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, lgirdwood@gmail.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] regulator: pfuze100: add pfuze100 regulator driver
Message-ID: <20130724101859.GF4332@pengutronix.de>
References: <1374398247-11384-1-git-send-email-b38343@freescale.com>
 <20130724083041.GC4332@pengutronix.de>
 <20130724100717.GA7786@Robin-OptiPlex-780>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130724100717.GA7786@Robin-OptiPlex-780>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:14:29 up 40 days, 22:24, 26 users,  load average: 0.02, 0.06,
 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 06:07:18PM +0800, Robin Gong wrote:
> On Wed, Jul 24, 2013 at 10:30:41AM +0200, Steffen Trumtrar wrote:
> > Hi!
> > 
> > I tested your patch and had to change two things to actually make it
> > work. See below...
> > 
> > On Sun, Jul 21, 2013 at 05:17:27PM +0800, Robin Gong wrote:
> > > Add pfuze100 regulator driver.
> > > 
> > > Signed-off-by: Robin Gong <b38343@freescale.com>
> > 
> > (...)
> > 
> > > ---
> > 
> > > diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
> > > new file mode 100644
> > > index 0000000..fd259ef
> > > --- /dev/null
> > > +++ b/drivers/regulator/pfuze100-regulator.c
> > > @@ -0,0 +1,462 @@
> > 
> > (...)
> > 
> > > +static struct regulator_ops pfuze100_ldo_regulator_ops = {
> > > +	.enable = regulator_enable_regmap,
> > > +	.disable = regulator_disable_regmap,
> > > +	.is_enabled = regulator_is_enabled_regmap,
> > > +	.list_voltage = regulator_list_voltage_linear,
> > > +	.set_voltage_sel = regulator_set_voltage_sel_regmap,
> > > +	.get_voltage_sel = regulator_get_voltage_sel_regmap,
> > > +};
> > > +
> > > +static struct regulator_ops pfuze100_fixed_regulator_ops = {
> > > +	.list_voltage = regulator_list_voltage_linear,
> > > +};
> > 
> > 
> > This needs:
> > 
> > diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
> > index 07d5a54..d0d67b4 100644
> > --- a/drivers/regulator/pfuze100-regulator.c
> > +++ b/drivers/regulator/pfuze100-regulator.c
> > @@ -133,6 +133,7 @@ static struct regulator_ops pfuze100_ldo_regulator_ops = {
> > 
> >  static struct regulator_ops pfuze100_fixed_regulator_ops = {
> > 	.list_voltage = regulator_list_voltage_linear,
> > +	.set_voltage_sel = regulator_set_voltage_sel_regmap,
> >  };
> > 
> >  static struct regulator_ops pfuze100_sw_regulator_ops = {
> > 
> > 
> > Otherwise the fixed_regulator VDDR isn't registered and the driver then unloads
> > completely. This is at least the case for v3.10. I haven't had the chance to test
> > it on v3.11-rcX. If the _regulator_do_set_voltage logic changes, then scratch this.
> > 
> Thanks firstly for you test with the patch. I have test it on v3.10 just now,
> and can't reproduce what you saw that VDDR regulator can't be registered
> successfully. I don't think fixed regulator need <set_voltage_sel>.

Okay. I rechecked and I was doing it wrong. I had the min/max voltage propreties
in the DT and missed the "regulator-boot-on;" property. Works fine now.

Thanks,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
