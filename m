Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaJ0Qiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:38:51 -0400
Received: from mail.kernel.org ([198.145.19.201]:47693 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbaJ0Qit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:38:49 -0400
Date: Mon, 27 Oct 2014 17:38:43 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org
Subject: Re: [PATCH v4] Add LTC2941/LTC2943 Battery Gauge Driver
Message-ID: <20141027163842.GB20765@earth.universe>
References: <1412748300-3915-1-git-send-email-mike.looijmans@topic.nl>
 <1414067918-6688-1-git-send-email-mike.looijmans@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Content-Disposition: inline
In-Reply-To: <1414067918-6688-1-git-send-email-mike.looijmans@topic.nl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 23, 2014 at 02:38:38PM +0200, Mike Looijmans wrote:
> Both the LTC2941 and LTC2943 measure battery capacity.
> The LTC2943 is compatible with the LTC2941, it adds voltage and
> temperature monitoring, and uses a slightly different conversion
> formula for the charge counter.
>=20
> To avoid confusion with e.g. the LTC2945, the driver is called
> LTC2941 instead of LTC294X.
>=20
> v2: Fix units of measurement: uV, uA and centidegrees.
> v3: Correctly set configuration register. Allow negative values
>     for the sense resistor.
> v4: Run checkpatch.pl and fix all errors and warnings.
>=20
> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
> ---
> [...]
>
> +	np =3D of_node_get(client->dev.of_node);
> +
> +	/* r_sense can be negative, when sense+ is connected to the battery
> +	 * instead of the sense-. This results in reversed measurements. */
> +	ret =3D of_property_read_u32(np, "resistor-sense", &r_sense);
> +	if (ret < 0) {
> +		dev_err(&client->dev,
> +			"Could not find resistor-sense in devicetree\n");
> +		goto fail_name;
> +	}
> +	info->r_sense =3D r_sense;
> +
> +	ret =3D of_property_read_u32(np, "prescaler-exponent", &prescaler_exp);
> +	if (ret < 0) {
> +		dev_err(&client->dev,
> +			"PrescalerExponent not in devicetree, assume max\n");
> +		prescaler_exp =3D LTC2941_MAX_PRESCALER_EXP;
> +	}

The device tree properties are not documented. Please document them
in a separate patch and Cc devicetree binding maintainers.

Apart from that the properties should be vendor prefixed (e.g.
"lltc,resistor-sense").

-- Sebastian

--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIbBAEBCgAGBQJUTnUSAAoJENju1/PIO/qaIFEP+OKLYgb13e0vfUGnQnqE2JRF
tJ+1acnS/6eEiLrR6i7YAXLyFKjLAa3QInstcn37sqV8fP3N8ox6S062VmcZQZzn
yzzbj4djYUVKs+b98VXKdOXm5yw7ewXvi7J/igcWLAJ/6IHgxX48g8Qk3wXYqTkN
NbXy1Re/E42jNvMAhAFJZOmVA+Jb5fb0Pl/DUJpyhtQYNTS7e4VoFBEExpGNNh+s
IlgirjKdjP/BHf9OpTkRSV3jWgj1QMMrQTq7CpAmmX+bzULwi6KbiZdG7SvmS5oR
BoqFeRpgHwzhYjKpNHwyJMFEiGuLEYDEAL74fDSifrs3qosvT3ZUiYK7Vv+yT5y6
/aAQhxPIHjK8zNEvD90x/wmVyo805XSA2iOAqjpzhtM0lmBpmNiB+w0w2U1V1vcZ
DnFqeRUIdL88uAbVdOFc0EAP74XmQH5uafYOtKFO1PuIN35Tyn/bWm0g91dDJ+qp
hoqi2ecVcYEKc15FTXPmyAsYV47RMYb0Pll8wjnX+Fk0iEO2A7SFW+OyGlcjrEVc
1Eke/BeF8dGN52kdpSHtlddlTFszFbPOwFAOhlFlNhLOw6UErOMVEjC73HJFfHyo
okAd38kk8b5Kwsr8MEKNMHGU7nueezq0i6Z5MA8FgHvTJ5NJhHSDcN4wnEdR+jZT
SC7awXMq0v0zkAGzHEU=
=5B8d
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--
