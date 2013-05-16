Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab3EPPrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:47:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37350 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab3EPPre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:47:34 -0400
Date: Thu, 16 May 2013 19:46:27 +0400
From: Mark Brown <broonie@kernel.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130516154627.GN24524@sirena.org.uk>
References: <A874F61F95741C4A9BA573A70FE3998F82E5CF3D@DQHE06.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ll0BBk1HBk/f94B0"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E5CF3D@DQHE06.ent.ti.com>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 176.12.107.141
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: lp872x: support the device tree feature
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ll0BBk1HBk/f94B0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 10, 2013 at 07:17:48AM +0000, Kim, Milo wrote:

> Patch v2.
>   Move the opmode code of the device tree from 'of_regulator' to the lp872x
>   because its mode depends on the device.
>   Supported modes in LP8720/5 are 'fast' and 'normal'.

> Patch v1.
>   Initial patch

Please keep these changelogs after the --- so they don't get included in
the final changelog by git am.

> +Optional properties:
> +- general-config: the value of LP872X_GENERAL_CFG register (u8)
> +- update-config: define it when LP872X_GENERAL_CFG register should be updated

A bit more information on this one wouldn't hurt but the information
will be in the datasheet I guess.

> +- dvs-gpio: GPIO number for DVS control

If this is the AP side GPIO then it ought to be a standard GPIO
specifier rather than a GPIO number.  If this is the pin on the PMIC
then it probably ought to be spelled out a bit more clearly.

> +- dvs-vsel: DVS selector. 0 = SEL_V1, 1 = SEL_V2.
> +- dvs-state: initial DVS pin state. 0 = DVS_LOG, 1 = DVS_HIGH.

Any custom properties are supposed to be namespaced, for example
"ti,general-config".

> +Child node
> +- regulator-id: the value of enum lp872x_regulator_id. (u8)

These would need to be listed as part of the binding, though it'd be
much more friendly to use plain text names and of_regulator_match() to
look them up.  That makes the binding much more legible.

--Ll0BBk1HBk/f94B0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRlP9FAAoJELSic+t+oim95xUP/Av452DPuPI+8x4UM0nPEwZi
Mzc5lTFYG5yolbRFyZ5N8yol/VsbXpF+YgRU4kRSSqhU7kU+G6sof8xCYqnvzPme
XzozglaFwfRxDSqzDMNPUFaukpass2gyx0TFtuiNYrEKBn7v92mzTKLjyF9Sx+H5
bWkqOL9reqyy1KWcidk3L3116MfWfSNONxsv1miz5UZk5dheZ7F7lfmH3m5tlADe
MsHYqoTKyC2Ub6DwSZG8adrvRx5berxwiLR4HXPUImGEmoi0ystlcmkGuqpXUODA
7AiGSdC/LbLuNhi00KbhzZAm6MfjkQlvXb7hYa53wyyNtsGFi9TwDwDYTtLBcavf
kjKZUidyLxD2NOzwQXMgXhoKHejHLsn6svjecPYtEBtoiXJmotlgx5O335QqZPVX
WdjwbpQO4TV9tKx81eVVYVfLD9xnMRAerQr5zDfnzDpXCWpPknEYm94ZWZ3oAlBs
12wqlCiYe1ZQVe9kAMsz0P33zMPUqAlhR3WgMeZRkp3ZFR0hsehtZUUXmWg8z7d8
5HZ3ij25tHxm/979z0Lhmy25Ab1AklyGmL1Kh0caCvzH0NRQULmHSf5BuZHgbsWA
icM5XB3h37gMf0A7hqO1E6DvHWXcRQQHl1z9wWh1uIJj1P1oW+mUUWLd7PWsCO3V
m5sjdD5D+elLmthUVDIl
=BLm4
-----END PGP SIGNATURE-----

--Ll0BBk1HBk/f94B0--
