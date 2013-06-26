Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab3FZOaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:30:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47208 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3FZOaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:30:07 -0400
Date: Wed, 26 Jun 2013 15:30:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Marek Belisko <marek.belisko@gmail.com>
Cc: perex@perex.cz, tiwai@suse.de, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, lgirdwood@gmail.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        zonque@gmail.com, Marek Belisko <marek.belisko@streamunlimited.com>
Message-ID: <20130626143001.GP27646@sirena.org.uk>
References: <1372251928-15706-1-git-send-email-marek.belisko@streamunlimited.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YRPL3RJyuON7wuhd"
Content-Disposition: inline
In-Reply-To: <1372251928-15706-1-git-send-email-marek.belisko@streamunlimited.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: Add PCM1681 codec driver.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YRPL3RJyuON7wuhd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 26, 2013 at 03:05:28PM +0200, Marek Belisko wrote:

> +#define PCM1681_ATT_CONTROL(X)	(X <= 6 ? X : X + 9) /* Attenuation level */

Write a function for this.

> +static bool pcm1681_writeable_reg(struct device *dev, unsigned register reg)
> +{
> +	return pcm1681_accessible_reg(dev, reg) &&
> +		(reg != PCM1681_ZERO_DETECT_STATUS);
> +}

> +static int pcm1681_digital_mute(struct snd_soc_dai *dai, int mute)
> +{
> +	struct snd_soc_codec *codec = dai->codec;
> +	struct pcm1681_private *priv = snd_soc_codec_get_drvdata(codec);
> +	int ret, val = 0;
> +
> +	if (mute)
> +		val = PCM1681_SOFT_MUTE_ALL;
> +

This would be clearer if written as an if .. else - otherwise it looks
like an uninitalised value might be used.

> +static int pcm1681_hw_params(struct snd_pcm_substream *substream,
> +			     struct snd_pcm_hw_params *params,
> +			     struct snd_soc_dai *dai)
> +{
> +	struct snd_soc_codec *codec = dai->codec;
> +	struct pcm1681_private *priv = snd_soc_codec_get_drvdata(codec);
> +	int val = 0;
> +	int pcm_format = params_format(params);
> +
> +	priv->rate = params_rate(params);
> +

Shouldn't there be a call to set the deemphasis here?

> +static int pcm1681_probe(struct snd_soc_codec *codec)
> +{
> +	return 0;
> +}
> +
> +static int pcm1681_remove(struct snd_soc_codec *codec)
> +{
> +	return 0;
> +}

Remove empty functions.

--YRPL3RJyuON7wuhd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRyvrmAAoJELSic+t+oim96YwP/jVY6XawZvyFk61A32r6zG+L
9oyWAQ9xDCPgWUXU7p406PUDQRypT0jxhT3rOBfX/ht+6w2bgtuDiR2Pch0OZp3J
iZq+AmVwPkf8D3rwwViV371dcFG/2dL2YAgVHRLy9pkWjnImsuP7cjh7TgyqJn3A
4jVeYFeECqe2mLAnW0155de7R3oj/sMUnRwXOIAMYLFGFGiqR+ROSXAwhbGIY8Vf
n/XJn/JTxDin5V/CrUbX2m8rPJKyFrZv23R8dTGU/POjK/ATWN+Nx50nNP1WG0p9
uZpm84PXTEYzp9HdhLIy380buek0+vrB9JgjaHVCNVndEYeELqm5pEZJ/II2P1on
SFSmxX5bOkuZ6fgK+EN4Z8s9sLmnNEzeJULNitK7IOAR44Lfy52ZE6QZzJ0FeXuu
k/N4xuObGwr2oL1Uv6efHWlRmbXQh+LoOqIccFyIy3LHPZG1RaUQ6CXS4FyI12P7
ZCM4kzywC8iOIxh5ETov7bH2WONl8BKIGlgrrJISESxisULfGpEZ2JEKBsyjxNDP
IrGxrKEc1BKJdSSLNIjk6UC9fcmWjAVprNu8EvL+62cW02vbANlVkiRWUfj6d9nr
cb5TzVjlyNusxv1vfqxwn4m155XkgXp12hQlZVuF5IPpidyV4T8UE7G6o9+ehNLw
x1uxG4EUSvMnALwNxr1m
=bDv1
-----END PGP SIGNATURE-----

--YRPL3RJyuON7wuhd--
