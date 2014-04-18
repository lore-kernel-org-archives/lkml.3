Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaDRSwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 14:52:46 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38243 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaDRSwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 14:52:43 -0400
Date: Fri, 18 Apr 2014 19:52:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20140418185225.GA12304@sirena.org.uk>
References: <1397845810-17002-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bdcc8l/1lFRK/qa7"
Content-Disposition: inline
In-Reply-To: <1397845810-17002-1-git-send-email-tim.kryger@linaro.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: Allow set voltage on fixed regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bdcc8l/1lFRK/qa7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 18, 2014 at 11:30:10AM -0700, Tim Kryger wrote:
> If a regulator consumer requests a voltage range that can be satisfied,
> the return value should indicate success even if that regulator has a
> fixed voltage.  Since there is already logic to check if the requested
> voltage range overlaps the allowed range, set REGULATOR_CHANGE_VOLTAGE
> for regulators with constraints that include a positive voltage.

This seems like the wrong place to fix this, it's nothing to do with DT
and we shouldn't require that nonsensical permissions are set.  Instead
we should fix this at the point where we're implementing the permission
check, have the failure case check the current voltage before returning
an error.

--Bdcc8l/1lFRK/qa7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTUXRlAAoJELSic+t+oim9chwP/jXTjcxjfkqkJHxgfjIYdITM
NGF4a1blcn9lERULG1Vbv+RtQ5jvDxkZnkv83JcUu27uhz3hy3HAt4d5mGjSADy4
/ZCjvE50wSOeKaUUdhPNECNniKPh3vTFIH/xnCimlnLMaXXKNbuTSmrA4kEThZ68
CNZIwGsP7AArqe7X8Cca0om9BQ68ckpXfLpueM+5WpR8rzdMqH34GZHZi4Evubrf
8wWe4TC0G5qkopKQxT/jGYQaLeVWzeezvyREq5f1vg+/wtxviXgdrPFXuLdtM8f5
aewliUtUfOpJUwepc95Ne5m4GSWm3eoUf7e33d6PgJ/bShgx93fMmgRNMxkf6B7t
Yo3uqPVextGqdliCDmV3WRSq5JBc1FzKkpoJ68cc99QG5LdNyST+2/FlixsbjIEk
Lq3S3rETaw8wqRCUndenDcMZCayOayjRMLECzttGKww5+Hj/bZ6c2eArZKUM/HSc
zb+PsUhlEYde9kt61sixbWXsKxDRZECHJwFdMucGNcn+M4DW429ua0kwQXpO+Qs/
ZojqlPTJYD1qKyxzwszJ7qlE/Sw0cMlxnkkwRr8ZO0lYxNezUY4LZtwGXRhre9Z5
8Cf71nhoZc2JK7YdyHKpzUwo2c4lmGGVrQkOo0/bMYcPFA3pu1HmLMRvM4lMf7l/
4dmaZXtdBKLGutJbZfH0
=Saf+
-----END PGP SIGNATURE-----

--Bdcc8l/1lFRK/qa7--
