Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbaEVKaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 06:30:52 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36204 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbaEVKav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 06:30:51 -0400
Date: Thu, 22 May 2014 11:30:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, tiwai@suse.de, perex@perex.cz,
        dianders@chromium.org, jerry.wong@maximintegrated.com
Message-ID: <20140522103039.GD12304@sirena.org.uk>
References: <1400750228-13750-1-git-send-email-tushar.behera@linaro.org>
 <1400750228-13750-2-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3QshgT4nm5mNXvH/"
Content-Disposition: inline
In-Reply-To: <1400750228-13750-2-git-send-email-tushar.behera@linaro.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: max98090: Add master clock handling
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3QshgT4nm5mNXvH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2014 at 02:47:07PM +0530, Tushar Behera wrote:

> +	max98090->mclk =3D devm_clk_get(codec->dev, "mclk");
> +	if (!IS_ERR(max98090->mclk))
> +		clk_prepare_enable(max98090->mclk);
> +

Ths doesn't handle deferred probe, we need to at least return an error
if we get -EPROBE_DEFER. =20

It'd also be better to move the enabling to set_bias_level() if possible
(I don't know if the clock is needed for register access) though less
essential.

--3QshgT4nm5mNXvH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfdHMAAoJELSic+t+oim9gUIQAJNKPSihIGnAwBUsNQLw2+42
yqhHnH53X0OeeR6/CPA0OyDkqmQXEL0p5z2z8nURIzmqH4dxh/gRv6nJJQU398s2
Sb26E3dSSuzXRd6KVf+BXiWn65LSbnM61ZbucDvkYGRPo8PlpD7DYqThwTP8jlV/
hgc7c6WbQiQ7gwU6FrCAF/P4AECPKav57uYQage7aL8OEjXAocRiOrmw0rgKnHby
e9GqvgIvUdTMszXPGsCkb/22+/VwC2YPk0uvoIfYn0L5tFxnBiGLLVZABD4J6F/d
98TgkxpQ87HqCZdYFdzxOfgqmH0u1Nwh/N0WyeQa2iWPnDsjjwAu96JDVmw0Gw2I
Ndk3zeCaI8RFp90lCNqACSmpAcCbvja5taZWs5hojnycj7QHmm2sPvdTAQhnz9nA
PQyYtU/fyxT4Zm2fQGSU2HTnE3yH3KfhqiqBb5bBh8eX+WQQG8+BJNphd/8Ne8sV
nc9cgR285sbfXOqPCUqWhqVhIfBIRN5wbc8Kh7/6+O188nhFeh/4pYWWx+buUfVk
1fv//JFHnbKpj9BWZL+AladMgZlX/Yx/N1uF5Imap/W3WdqO6XZbuIChfHraeMCK
wK+RRiBxCrDn8+Om6HwUxC+uY1cOJ/Du5Um8qYZSC+cs9gLS99KrXAELK6zP+QH5
fxXwLHx+oDtaK+NeC0hn
=+iuv
-----END PGP SIGNATURE-----

--3QshgT4nm5mNXvH/--
