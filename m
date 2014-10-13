Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbaJMOnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 10:43:08 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51129 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaJMOnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 10:43:07 -0400
Date: Mon, 13 Oct 2014 16:42:35 +0200
From: Mark Brown <broonie@kernel.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Krzysztof =?utf-8?Q?Koz=C5=82owski?= <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Message-ID: <20141013144235.GJ27755@sirena.org.uk>
References: <1412776028-15655-1-git-send-email-mpa@pengutronix.de>
 <1412776028-15655-3-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zjgHyPOYItD3o7TG"
Content-Disposition: inline
In-Reply-To: <1412776028-15655-3-git-send-email-mpa@pengutronix.de>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/4] regulator: Set ena_gpio_initialized in regulator
 drivers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zjgHyPOYItD3o7TG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 08, 2014 at 03:47:06PM +0200, Markus Pargmann wrote:

> --- a/drivers/regulator/max8952.c
> +++ b/drivers/regulator/max8952.c
> @@ -225,6 +225,8 @@ static int max8952_pmic_probe(struct i2c_client *clie=
nt,
>  	config.of_node =3D client->dev.of_node;
> =20
>  	config.ena_gpio =3D pdata->gpio_en;
> +	if (!pdata)
> +		config.ena_gpio_initialized =3D true;

This looks wrong, we're checking for pdata being non-NULL immediately
after dereferencing pdata.

--zjgHyPOYItD3o7TG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO+TaAAoJECTWi3JdVIfQZl4IAIO3KH7yGj5s78Zl7GGoewDu
2ANG0MOPz8d6kVplisrOWN5OlaerZB34ripD/j7jT2LiwyL2S+o2Vw8kYgmHX3DA
XjOxN5tu6hjRf7ff24pBWBUOoB+iTv3KizLOq0LEsWLuaNwTMjqAp7Dt2Si+gCcE
GB8rbYbxDHCFoKzQTDIpqn0u1d/4BCMzKC+/E5RlLtbV3knAlFILtk/OYUHsrorl
kfXNc9qUAzcdX2eWt9YVvHIqNaejvyXg5pbflA0KrLP9LnNdWFIyI3Mpfo1hJRwM
CrEdNJ5aeBvy2eAiAkyxpAVyDlNApfSngv3blhSMRNt/8ZbmEQzA1BlBgmYcV40=
=5Kr7
-----END PGP SIGNATURE-----

--zjgHyPOYItD3o7TG--
