Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab3KTPbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:31:32 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60006 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab3KTPb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:31:28 -0500
Date: Wed, 20 Nov 2013 15:31:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20131120153103.GG2674@sirena.org.uk>
References: <1384956732-19526-1-git-send-email-k.kozlowski@samsung.com>
 <1384956732-19526-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mOr7kNv8EL30+EI+"
Content-Disposition: inline
In-Reply-To: <1384956732-19526-2-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Drive defensively.  Buy a tank.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/5] mfd: max14577: Add max14577 MFD driver core
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mOr7kNv8EL30+EI+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 20, 2013 at 03:12:08PM +0100, Krzysztof Kozlowski wrote:

> +static irqreturn_t max14577_irq_thread(int irq, void *data)
> +{
> +	struct max14577 *max14577 =3D data;
> +	u8 irq_reg[MAX14577_IRQ_REGS_NUM] =3D {0};
> +	u8 tmp_irq_reg[MAX14577_IRQ_REGS_NUM] =3D {};
> +	int i, cur_irq;
> +
> +	max14577_bulk_read(max14577->regmap, MAX14577_REG_INT1,
> +			&tmp_irq_reg[MAX14577_IRQ_INT1],
> +			MAX14577_IRQ_REGS_NUM);

All this interrupt handling looks like a straight copy of the regmap
code?

> +int max14577_irq_resume(struct max14577 *max14577)
> +{
> +	int ret =3D 0;
> +
> +	if (max14577->irq && max14577->irq_domain)
> +		ret =3D max14577_irq_thread(0, max14577);

Are you sure that this is not going to race nastily if the interrupt
goes off during resume?

> +
> +	return ret >=3D 0 ? 0 : ret;

This check isn't a triumph of legibility. =20

> +	if (IS_ERR_OR_NULL(pdata)) {
> +		dev_err(&i2c->dev, "No platform data found: %ld\n",
> +				PTR_ERR(pdata));
> +		return -EINVAL;
> +	}

Why IS_ERR_OR_NULL().

> +#else
> +#define max14577_suspend	NULL
> +#define max14577_resume		NULL
> +#endif /* CONFIG_PM */

You don't need these since you use SIMPLE_DEV_PM_OPS().

> +#else
> +#define max14577_dt_match	NULL
> +#endif

Similarly here.

--mOr7kNv8EL30+EI+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSjNW0AAoJELSic+t+oim9UHcP/juvH6z5rgAZCBSYcZT0Pjb8
dpSowLbq2TELYc5s0KH3JkuGaNfZE5Qlo5B0s/4UxtlLUtTwbm9TmFvh/H90BV7R
kMEOWSmhoHZwKukZtpxuaD9ygyW17ard/+d19e3qNuT2JwdAbXvqvwgEI0w2Jgmz
SC30QYzguzGNwGDixUq6hbarHPb/G7sxSn06zYWDGlRl2CJLdno5Sz4+8hrGMfuO
Vi9CzhdeI2vhRW6f6O9sB9TTkyKEWumWnc2oKoOUUpi5yEVGnXRu5+4xwK6UJ/hC
4VyRPekg81pVap8+TiFmJMlvEAI45NH3DQWMsDvl0g63/JORNq66esJKXuichv1L
YK7h1RvL42tSdw8uTKChF7XEpFUM8nobPblnRiR8Ke3HsPSfRVBdBJfwCDtQZQvv
+9CMinYecsOOlgq3K5C90Xfn30C5HXfVKpHi8EhHjjI/tD5o78asd5+pYmx1Cfa5
HYLBC0Z1eTzlKosXCX7D7DMvG5mY2DUTB6bHUAjOEnf4lF6MSsctV4iFeN/plAFz
kVUr0+q1CsY/QjThHazRMkbBsPPoQMhGFize2UO6mdgyvscNVur4jfoKxh5Ng3Em
InL+RxoSyEjBk++ntB3pWQDnTDQ0Pp15/jNu3pjuxqH4QzKdcre80n+yjYXV+pZN
/MiqXqSmN2fLoSnRLlH6
=E4WA
-----END PGP SIGNATURE-----

--mOr7kNv8EL30+EI+--
