Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab3HNP16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 11:27:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46773 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3HNP15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 11:27:57 -0400
Date: Wed, 14 Aug 2013 16:27:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Florian Lobmaier <florian.lobmaier@ams.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, lee.jones@linaro.org
Message-ID: <20130814152750.GS6427@sirena.org.uk>
References: <1376492098-15672-1-git-send-email-florian.lobmaier@ams.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mhFomgJQ1VTZ9Fr0"
Content-Disposition: inline
In-Reply-To: <1376492098-15672-1-git-send-email-florian.lobmaier@ams.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] added support for ams AS3722 PMIC in mfd
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mhFomgJQ1VTZ9Fr0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 14, 2013 at 04:54:55PM +0200, Florian Lobmaier wrote:

> +static struct regmap_irq_chip as3722_irq_chip = {
> +	.name = "as3722",
> +	.irqs = as3722_irqs,
> +	.num_irqs = ARRAY_SIZE(as3722_irqs),
> +	.num_regs = 4,
> +	.status_base = AS3722_INTERRUPTSTATUS1_REG,
> +	.mask_base = AS3722_INTERRUPTMASK1_REG,
> +	.wake_base = 1,
> +};

wake_base looks wrong - that should be either absent or a register name.

> +static void as3722_reg_init(struct as3722 *as3722,
> +		struct as3722_reg_init *reg_data)
> +{
> +	int ret;
> +
> +	while (reg_data->reg != AS3722_REG_INIT_TERMINATE) {
> +		ret = as3722_reg_write(as3722, reg_data->reg, reg_data->val);
> +		if (ret) {
> +			dev_err(as3722->dev,
> +					"reg setup failed: %d\n", ret);
> +			return;
> +		}
> +		reg_data++;
> +	}
> +}

This looks like it might be supposed to be a register patch?

> +int as3722_read_adc(struct as3722 *as3722,
> +		enum as3722_adc_channel channel,
> +		enum as3722_adc_source source,
> +		enum as3722_adc_voltange_range voltage_range)

This should be moved over to IIO - the ADC code in MFDs predates IIO
being available.

> +static irqreturn_t as3722_onkey_press_irq(int irq, void *irq_data)

> +static irqreturn_t as3722_onkey_lpress_irq(int irq, void *irq_data)

These should be handled by an input driver.

> +static irqreturn_t as3722_temp_sd0_shutdown_irq(int irq, void *irq_data)
> +{
> +	struct as3722 *as3722 = irq_data;
> +
> +	dev_dbg(as3722->dev, "AS3722 temp SD0 shutdown triggered\n");
> +	return IRQ_HANDLED;
> +}

You probably want these to complain loudly rather than as dev_dbg(), I'm
not sure what the status of the thermal framework is.

> +	/* enable 32kHz clock output if required */
> +	if (pdata->enable_clk32out_pin)
> +		as3722_set_bits(as3722, AS3722_RTC_CONTROL_REG,
> +				AS3722_CLK32OUT_ENABLE_MASK,
> +				AS3722_CLK32OUT_ENABLE_ON);
> +	else
> +		as3722_set_bits(as3722, AS3722_RTC_CONTROL_REG,
> +				AS3722_CLK32OUT_ENABLE_MASK,
> +				AS3722_CLK32OUT_ENABLE_OFF);

This looks like a job for the clk API.

--mhFomgJQ1VTZ9Fr0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSC6HzAAoJELSic+t+oim9w5IQAIiV+d3kq6H20TO0t41VzGwk
W76sTr7nGRANCFPImSU9k9XVIdS5kq6h6fKPrKXB8vAzYJDRupI6R4EdAH/Szw/j
vvO5lNt4Oy8ZNlupghsQmDCzPXip9VZ+SgQ9lVJwFfDwUL/NOHyAiLTLddjuS/ip
19bJEEnszt6A7CCAS7pT3Sca0ntgR9AHdqXTpSXgiDGYpkKuF8k2HP+5oEMs2KjX
dOP0WgJzGWrAdTmXTbJBVpX27wSBtRkRAV9olovmmxoHOhtqlML49ifs+chMYU60
JryDDDGqN5YMpxORBrRi/xAdVZ3/VzidRZSQg2HGjwHgTr8XTP+ZQzrfmfAEIPGx
H4amLlI6xp2oJnf+CLnYNc8X3LDELTVcs2z0qvBWP18DqMH3uZobY5/Xx9I2zC5l
DqD5eBRc6Kh0A2yra/64TQVNQusuoprpL4k8uMi4HPakII5pKbGthzxRKivxe9jY
mEhVRZMHPIyklRWQElqo2sycAGkJ9JcUFe/9bBRaadlQfdrzroqM9F7NpcC+WKvA
UlQ56+Qc3ytBrLZ5n/0w6nD7/lVp+6v0xLwlNvkgD8tjEHuKgFqSoZ6hB56nWO1H
q7wBCXxtPzqr7rpN2woeYOnR8TFkhyLnzjDkC2ISFcMR0j8g0UCfMvf9kVvva7lF
AsO5S2Jd7KRKM8AkgXIi
=fS9v
-----END PGP SIGNATURE-----

--mhFomgJQ1VTZ9Fr0--
