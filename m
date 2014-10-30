Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933874AbaJ3Qv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:51:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57459 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788AbaJ3Qv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:51:58 -0400
Date: Thu, 30 Oct 2014 16:51:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20141030165133.GB18557@sirena.org.uk>
References: <1414570560-10320-2-git-send-email-mike.looijmans@topic.nl>
 <1414668415-597-1-git-send-email-mike.looijmans@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KygVa1W36dbi1blP"
Content-Disposition: inline
In-Reply-To: <1414668415-597-1-git-send-email-mike.looijmans@topic.nl>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] Add ltc3562 voltage regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KygVa1W36dbi1blP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 12:26:55PM +0100, Mike Looijmans wrote:
> The ltc3562 is an I2C controlled regulator supporting 4 independent
> outputs.
>=20
> v2: Prefix "lltc" to devicetree properties. Use the same property names
>     as the ltc3589 driver. Remove default-voltage property. Use
>     devm_register_regulator.

As covered in SubmittingPatches things like this should be after ---.

> +Required properties:
> +- compatible: "ltc3562"

This needs a vendor in the compatible string.

> +Required child node:
> +- regulators: Contains four regulator child nodes R400B, R600B, R400A, R=
600A,
> +  specifying the initialization data as documented in
> +  Documentation/devicetree/bindings/regulator/regulator.txt.

All regulator child nodes should be optional.

> +			R600A_reg: R600A {
> +				regulator-name =3D "R600A";

Remove these regulator-names, this is for the name of the supplies on
the board not the regulator itself.

> +static int ltc3562_write(struct i2c_client *i2c, u8 reg_a, u8 reg_b);
> +static int ltc3562_dummy_write(struct i2c_client *i2c);

This appears to be reimplementing regmap (including a cache).  Please
use that instead.  Pretty much the entire driver could then be replaced
with the regmap helpers, none of the operations look like they'd be
needed, and you'd get the regmap diagnostic infrastructure.

> +	np =3D of_node_get(i2c->dev.of_node);
> +	np_regulators =3D of_get_child_by_name(np, "regulators");

> +		np_child =3D of_get_child_by_name(np_regulators,
> +			ltc3562_regulators[i].name);
> +		if (np_child =3D=3D NULL) {

Use the core support for looking up constraints please - set
regulators_node and so on.

> +static struct i2c_driver ltc3562_i2c_driver =3D {
> +	.driver =3D {
> +		.name =3D "LTC3562",
> +		.owner =3D THIS_MODULE,
> +	},
> +	.probe    =3D ltc3562_i2c_probe,
> +	.id_table =3D ltc3562_i2c_id,
> +};

You need to supply an of_match_table too.

--KygVa1W36dbi1blP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUUmyUAAoJECTWi3JdVIfQtLYH/34eWTy0i3i0/qvcBqu9snMs
momVMq8YnSbSFP8xS9ZHBVdUKOptptWqBOoXg7ZMDf+0dEcOnd7gVu7j26mIqNNt
ZBMv79m9tgGgvqgw3nJyyomyQpOaKFaL9TUCKMqjFbzZ/qBLqOgzR+lxYKKAUISU
slvxSjZam6K/V704/UMk8dNb5vvTLkVxJNzgHe5S0TSq4DEfiuLLSa01QK+53edp
+o/y//gObXo25kSK9nlrbIhiO+Hcp515iWS/6zS0cMaNgm0l7enkRtpRbcVfhvf2
W2hrwQJjmh1rFOvNIBQVMsaL1iLVq7h96RgbP/je463OL4dymO5iMciCuHkWCwk=
=FNPh
-----END PGP SIGNATURE-----

--KygVa1W36dbi1blP--
