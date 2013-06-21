Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161561Ab3FUOo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:44:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53592 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161419Ab3FUOo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:44:26 -0400
Date: Fri, 21 Jun 2013 15:44:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Message-ID: <20130621144423.GX27646@sirena.org.uk>
References: <Pine.LNX.4.64.1306210825040.27277@axis700.grange>
 <Pine.LNX.4.64.1306210827090.27277@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s8wpp40TDz0KNMmP"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1306210827090.27277@axis700.grange>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulators: max8973: initial DT support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s8wpp40TDz0KNMmP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 21, 2013 at 08:30:26AM +0200, Guennadi Liakhovetski wrote:

> +Required properties:
> +
> +- compatible:	must be "maxium,max8973"
> +- reg:		the i2c slave address of the regulator. It should be 0x1b.
> +- regulators:	a subnode with a single regulator descriptor in it called "dcdc"

Why make this a subnode - if there's only one regulator on the device
then it may as well just put all the regulator properties there?

> +	if (!regulators) {
> +		dev_err(dev, "regulator node not found\n");
> +		return -ENODEV;
> +	}
> +
> +	ret = of_regulator_match(dev, regulators,
> +				 &max8973_regulator_match, 1);
> +	of_node_put(regulators);
> +	if (ret < 0) {
> +		dev_err(dev, "Error parsing regulator init data: %d\n", ret);
> +		return ret;
> +	}
> +	if (!ret) {
> +		dev_err(dev, "No regulator configuration found\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;

This would simplify the code here, the driver can just call
of_get_regulator_init_data() directly with the node.

> -	if (!pdata->enable_ext_control) {
> +	if (!pdata || !pdata->enable_ext_control) {
>  		max->desc.enable_reg = MAX8973_VOUT;
>  		max->desc.enable_mask = MAX8973_VOUT_ENABLE;
>  		max->ops.enable = regulator_enable_regmap;

A common approach here is just to embed the platform data in the
driver data then copy actual platform data in there or parse the device
tree bindings (when added) into the structure.  This means that most of
the driver can just assume there's platform data which makes life a bit
simpler.

--s8wpp40TDz0KNMmP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRxGbEAAoJELSic+t+oim9y1YP/20vru+A9RC/W5aGXzNLmwbN
SbGPlvMz49PEhMYLV0qopkh/LHl3R6IZa9AH+Ut6yEezBDiEvX7gXbdtA3w1AppX
sORbw1DiSUE1veUtYxehVFS+YWhuJHguqZQG4Wn+8X5J2N/gArT3EsVMu/rs+Iap
vIs+WJ8Y2pNMOoLmck4SNiQ/bqhWEJ1mK3I50TTSxYxhcxg4ZF1+EVHprQCQwkON
Q8cTfA7mcG+gNmdDQq5qugAKP3gzKv9LJWli/vjbVhKtMvQ/RBbCOWBbi1D6dzn0
Amt7P9G7M8+SE4dNAa8sB4EIReuLIbcfgFU6bFH/8S0P+NrWBoU8yYfB9KY9QgNS
whqoSP/Wgb/evmH9k5IOAYqTtHYAQEcvEKiCm/XtcPGPYbMsR9tmnfPkIo6KDuay
5ZURnlMMpUtXScSeeQ1DuNf7U+YNqLH2FChWe0lvgJJ8Bnk78d/m/ZWkopsAI5/B
H9w+M8j8T1tWGdER1cP4TvoNKbU/sRKqsP+rrY58fJgTofP+cs2vd3c8f+fN1sse
lShjsxOmUQ6nGuvlfvHhI2/c6uGrT6aCOVPBfxGJ4qkyqmnw6zxYsJvyK7eQ0x0O
o52y9G90/rpUUIIv5GAbzm7fzB7Xj3jmuWEgVRCWqqQp7kNZyDsT9G/Qmmlpg54G
Mx+ACHGsTgPirBu5Or9C
=5pfA
-----END PGP SIGNATURE-----

--s8wpp40TDz0KNMmP--
