Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbaIAQhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 12:37:25 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45047 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442AbaIAQhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 12:37:23 -0400
Date: Mon, 1 Sep 2014 17:36:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Jackson <Andrew.Jackson@arm.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140901163642.GG29327@sirena.org.uk>
References: <cover.1409490122.git.moinejf@free.fr>
 <080616c48997c53a14910f05a0fcf3f995412315.1409490122.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W0QGcccuECrPGiFB"
Content-Disposition: inline
In-Reply-To: <080616c48997c53a14910f05a0fcf3f995412315.1409490122.git.moinejf@free.fr>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 1/2] ASoC:codecs: Add a generic HDMI audio CODEC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W0QGcccuECrPGiFB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 31, 2014 at 12:45:39PM +0200, Jean-Francois Moine wrote:

>  Documentation/devicetree/bindings/sound/hdmi2.txt |  32 ++++
>  include/sound/hdmi2.h                             |  24 +++
>  sound/soc/codecs/Kconfig                          |   3 +
>  sound/soc/codecs/Makefile                         |   2 +
>  sound/soc/codecs/hdmi2.c                          | 204 ++++++++++++++++=
++++++
>  5 files changed, 265 insertions(+)

This is clearly not a good name and it's not clear what the difference
between this and the existing HDMI stub CODEC is intended to be. =20

> +Required properties:
> +
> +  - audio-ports: must contain one or two HDMI transmitter dependant
> +	values identifying the audio sources.
> +	The source type is given by the corresponding entry in
> +	the audio-port-names property.
> +
> +  - audio-port-names: must contain entries matching the entries in
> +	the audio-ports property.
> +	Each value may be "i2s" or "spdif", giving the type of
> +	the associated audio port.

It seems hard to see this binding as really generic - I'd expect to see
other devices which are just able to have fixed audio ports for example.

> +static int hdmi2_probe(struct snd_soc_codec *codec)
> +{
> +	struct i2c_client *i2c_client =3D to_i2c_client(codec->dev);
> +	struct hdmi2_codec *audio =3D i2c_get_clientdata(i2c_client);
> +	struct device_node *np =3D codec->dev->of_node;
> +	int i, j, ret;
> +	const char *p;
> +
> +	if (!audio)
> +		return -ENODEV;
> +	snd_soc_codec_set_drvdata(codec, audio);

The code also seems pretty device specific.  I think it's probably
better to leave the binding device specific for now and concentrate on
sharing inside the kernel, making any generic binding additions be about
how the devices interface rather than what's going on inside a specific
device.

--W0QGcccuECrPGiFB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBKCWAAoJELSic+t+oim9z/8QAJByMjItnkLZo3fJgOJH47/2
T5l5IRlzNs+k9arhmv+T3M1tBFHVi1MNUFG6YeNj2RoHNkYtYCjnAcDBLJ7gdRUq
sqB7u0IhBhaFQ2lHF3l6h3ccATsb8uOP2E+mAjB+lBwiyhrZM2AIAWihNIWAAPzP
j3858M8lvSGrUSJdXrSRjmOszO2HhexDzyUAw0X53y9Rl0XAQDwLh5TIVkDFmzOC
ZYFXdnMTJwJJF+AB4acMhYdICXGFiO5ZawBBcYtwfKAn94OXsRXV7ZUY8Ih5kdkw
16bSZkXeCkb3DnhGKFUQgjgmiCeQ0L+eLkmeTi9VsT+y8oWk+Wgut+HNGAHEGwHm
5JNww5H+qGQ5eAPH9Pe5DnvV/c+DkVImvOydLG2xv53UHSD9CIqr1icgJRU/1sUg
nYw9mfYTeM8PeMdy2bIKe8/FK++/lyiLfcTf3hjoTCL8n1Qg2I+G82xyHa2L8sNY
39wAQeEgqyzijDfa+pcO3Bv0kp5LscpmNCS13k9k734e0at4eKpEgD/JyB4htSho
4kHfnj/pxlXl7nc197Z5ovi7959UQjuaK3ZRfAiMfxKuz1l6XghPADgEDLGvNqJL
KV+EZ+3AEHFFOBQnt83bvsehGvl6wrmR+wE5g4Do/faO61N4+BVfAzsBo6NXiMwx
lJJuWfvN2Eh5mTt0Fytj
=E7dD
-----END PGP SIGNATURE-----

--W0QGcccuECrPGiFB--
