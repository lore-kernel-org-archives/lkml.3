Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbaBYBpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 20:45:49 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51216 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaBYBps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 20:45:48 -0500
Date: Tue, 25 Feb 2014 10:05:23 +0900
From: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        nikesh <Nikesh.Oswal@wolfsonmicro.com>
Message-ID: <20140225010523.GJ25940@sirena.org.uk>
References: <1393250058-18430-1-git-send-email-Nikesh.Oswal@wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BxIhUKWW31lNoI9D"
Content-Disposition: inline
In-Reply-To: <1393250058-18430-1-git-send-email-Nikesh.Oswal@wolfsonmicro.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASOC: dapm: add param_fixup callback
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BxIhUKWW31lNoI9D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 24, 2014 at 01:54:18PM +0000, NikeshOswal wrote:
> From: nikesh <Nikesh.Oswal@wolfsonmicro.com>

You need to fix both your git and e-mail setups, you should be using
"Nikesh Oswal" or similar as your real name and more importantly your
mail setup is sending mail as "NikeshOswal" with no even a domain part
which means you can't be replied to.  It is very important that you are
able to get review comments at the address you post from.

> dai-link params for codec-codec links were fixed.
> The fixed link between codec and another chip which
> may be another codec, baseband, bluetooth codec etc

Please use the full width for your changelog.

> Change-Id: Iad6ee3951bc4e8b8bc519c62642a2b4bcd949c18

Don't include noise like this in upstream submissions.

> -	const struct snd_soc_pcm_stream *params;
> +	struct snd_soc_pcm_stream *params;
> +	/* optional params re-writing for dai links */
> +	int (*params_fixup)(struct snd_soc_dapm_widget *w, int event);

This isn't a great interface, it relies on the driver peering inside the
core data structures and it means that we have to drop the consts from
users.  Systems not using this feature ought to be able to declare their
parameters as static const but this breaks that ability.  Similarly
users that are fully dynamic need to allocate some static data to work
with this interface.

If you look at the existing interface you'll also see that it takes an
array of parameters rather than just a single parameter.  The idea was
to extend the interface to provide a control to userspace allowing
selection of one of the configurations from a list for use with cases
like modems which can switch between 8kHz and 16kHz modes.

--BxIhUKWW31lNoI9D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTC+xPAAoJELSic+t+oim9EN0QAIH9wnKFhpH1CZfAZFSQs/5G
+sETiAQBGduB7EyJb1ZpQqjTjhnLDSfor28Uhuyd6WyQBwIPTiMKREyNFg7W7JiI
CsgTi7w/KeU1nBL9ckEMxDXqdZ3vibV9TlwI6eSB0PSKVUnBDJYjWL2km6SujNKZ
RKCpI2HT8jPkQdRY5Zgk6j+i2/ziQPjERISyjQE6s+Hs2VHmQfHKsHhwrhWD+h5z
IdavPM2Ugi8ves+IqvnYSzkDV5q4WfyvN3toVCl931EXrIe0bbXHE5ucR+sKO5xo
llLyGm2/aBityXi9Biof/qz98lS98Yc0Tjfg11g5Iqq3uhnZFUj0mUc4SOXkq0bU
ZPWrw0T0xIPj6bShSFyfSW5EPXo8Xo5iaujBSqPv3700/KjURfhF+xtiA18wGhB/
+7CMj/BWAw8JTgxgyCCfq1El4b6RaT9wHodIuO7X4YxVwNcdeVe6//lYLK6fJx4S
1X4MSeLWloMFSeDHIu27r3aUDBAfvwcZ9dS9/YNq3od70QvTQtp7PPUt8seh6TaJ
eGJNsrpGkJ5eHS/FqHOMcDxTp/kyD+1E06sNILMRifBr0z/rx7c2Ve4pXeBj3VBj
3duzrrDfiEgz1GRt62+w2Siip66fRlejbRMQbyUAUX69BPUnDlFHZEtW0ZmR9JNn
i2/jOqCn6vmSANBQ4FKS
=UjEx
-----END PGP SIGNATURE-----

--BxIhUKWW31lNoI9D--
