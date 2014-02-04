Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbaBDLFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 06:05:44 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35109 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaBDLFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 06:05:37 -0500
Date: Tue, 4 Feb 2014 11:05:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20140204110531.GR22609@sirena.org.uk>
References: <1391493268-3242-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QV2rA8kv1o2PNnkS"
Content-Disposition: inline
In-Reply-To: <1391493268-3242-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Make regulator object reflect
 configured voltage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QV2rA8kv1o2PNnkS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 03, 2014 at 09:54:28PM -0800, Bjorn Andersson wrote:

> +	/*
> +	 * Make the regulator reflect the configured voltage selected in
> +	 * machine_constraints_voltage()
> +	 */
> +	if (rdev->constraints->apply_uV &&
> +	    rdev->constraints->min_uV == rdev->constraints->max_uV) {
> +		regulator->min_uV = rdev->constraints->min_uV;
> +		regulator->max_uV = rdev->constraints->min_uV;
> +	}
> +

Why not do this at the time we apply the voltage?  That would seem to be
more robust, doing it in a separate place means that we might update one
bit of code and not the other or might change the execution path so that
one gets run and the other doesn't.

--QV2rA8kv1o2PNnkS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8Ml4AAoJELSic+t+oim9nvoP/3B3vUcaTDuUqU9bTfF4Wc20
GbQ5rLTXHksFiw7DFTaSaSR95E8WCp/tLLY4jNFY6p4BKGOhd3t7927VD0d4D4Y7
EG8qqspQpI+pYoMzZ69p5hgDZhaaY/jjA+Rq7EZAmfuY48bPrDwqNayb/lYLUIJo
+eDrpE+gWYYfPRNMiDUynxieH6MpiL9rSfZv3kh15lEuDFmxJ+iVVYQ02VvPJVcx
qQ3eQit1lxnZYvz9jqlNS0AdbjZnfO4+ytcS3YkrdJYIk2kYgKEO2lXuTnZw+T6u
mOYQCNoeEj583PsaDpdB8s9KKvU/TSDIq+MJ+WPCUuXDOb5DMmF9Olzxt7DrJxS6
vTBn38GjfLmEXMK3di7i/nCx74u05niil9DwD7GWiR3sAcsA7puTYNgd9LBfmIYJ
CJ9DmtRY5e+p9HMo2RvEVICfC+KHZzMnMMyLcvCIoDORdZy11ptEK2JWEMqSq9iY
i2d0JT5YbLNMhQp0r8Hq5bY/rugQvgkK/oqt8Qn8Vtomx/F/ieM+4oboGel4jhL2
wZSqXqSWBLIDsBhm1N/iKIhFQG98M++h6UaLN5I8SoZ+iICaK/x96409kV2j56SX
coD4L5n6ZWgjzZjmlpoy8t5W3g4IZsosoExyYAN7KAJENPNXSZXvsmR47MFxtiA4
fooTXH/e868Gt3NCrzYK
=hnSf
-----END PGP SIGNATURE-----

--QV2rA8kv1o2PNnkS--
