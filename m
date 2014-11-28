Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaK1QDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:03:34 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42291 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaK1QDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:03:32 -0500
Date: Fri, 28 Nov 2014 16:03:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Peter Rosin <peda@lysator.liu.se>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Peter Rosin <peda@axentia.se>
Message-ID: <20141128160320.GY7712@sirena.org.uk>
References: <1417122162-8122-1-git-send-email-peda@lysator.liu.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JOdSqRa1q7Th5Ot+"
Content-Disposition: inline
In-Reply-To: <1417122162-8122-1-git-send-email-peda@lysator.liu.se>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: Augment existing card DAPM routes in
 snd_soc_of_parse_audio_routing
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JOdSqRa1q7Th5Ot+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 27, 2014 at 10:02:42PM +0100, Peter Rosin wrote:

> -	routes =3D devm_kzalloc(card->dev, num_routes * sizeof(*routes),
> +	old_routes =3D card->num_dapm_routes;
> +	routes =3D devm_kzalloc(card->dev,
> +			      (old_routes + num_routes) * sizeof(*routes),
>  			      GFP_KERNEL);
>  	if (!routes) {
>  		dev_err(card->dev,
> @@ -4611,9 +4613,11 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_=
card *card,
>  		return -EINVAL;
>  	}
> =20
> +	memcpy(routes, card->dapm_routes, old_routes * sizeof(*routes));
> +

Aren't we open coding krealloc() here?

--JOdSqRa1q7Th5Ot+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUeJzHAAoJECTWi3JdVIfQHFgH/1PlWfrdpVbEHJdIPRjH2fTn
WuKmEcIDgBxkElmAscLjuoTCWMlFQ079OxO7CNLIwD7mW55+Xf77UiIys7uZDjVd
B68USu76j36m+Z4KmgQuDiWJWoNTlLschM/J3ef0wnGKJ0JGnfjpzN78p9EMcL2G
AlLYnewg3g6uwk4XAsY2+f3tS6zH3kh4ot9jp9sFynKtEBGxTwYpWKpTnmtoXGR6
PRmCprlwGZzUzg3aCiHey8BvNe6prqDgzhdkpk/160cOVXJ3SGvA5P40n4GZRcJ/
DLZwsNEnNDJDemGvRvHiAlGafFRpGEg5Mjc2nBAwxlOx+/tODP1y53E2ugmwCuE=
=5NBC
-----END PGP SIGNATURE-----

--JOdSqRa1q7Th5Ot+--
