Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbbAFRhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:37:34 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38886 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865AbbAFRhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:37:31 -0500
Date: Tue, 6 Jan 2015 17:37:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Zidan Wang <b50113@freescale.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de, lars@metafoo.de,
        ckeepax@opensource.wolfsonmicro.com, Li.Xiubo@freescale.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150106173711.GH2634@sirena.org.uk>
References: <1419997154-860-1-git-send-email-b50113@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pTYhUwqpXRR/mkN7"
Content-Disposition: inline
In-Reply-To: <1419997154-860-1-git-send-email-b50113@freescale.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel][PATCH 1/4] ASoC: wm8960: Let wm8960 codec driver
 manage its own MCLK
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pTYhUwqpXRR/mkN7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 31, 2014 at 11:39:11AM +0800, Zidan Wang wrote:

> +		if (!IS_ERR(wm8960->mclk)) {
> +			if (codec->dapm.bias_level =3D=3D SND_SOC_BIAS_ON)
> +				clk_disable_unprepare(wm8960->mclk);
> +			else {

Both sides of the if statement should have braces if one does, though in
this case nesting a second switch statement would probably be clearer.

> @@ -661,6 +678,7 @@ static int wm8960_set_bias_level_out3(struct snd_soc_=
codec *codec,
> =20
>  		/* Disable VMID and VREF, let them discharge */
>  		snd_soc_write(codec, WM8960_POWER1, 0);
> +
>  		msleep(600);
>  		break;
>  	}

Random while space change here and in a couple of other places.

> +	wm8960->mclk =3D devm_clk_get(&i2c->dev, "codec_mclk");
> +	if (IS_ERR(wm8960->mclk)) {
> +		if (PTR_ERR(wm8960->mclk) =3D=3D -EPROBE_DEFER)
> +			return -EPROBE_DEFER;
> +	}
> +

Why name this "codec_mclk" - the device calls it just MCLK?

--pTYhUwqpXRR/mkN7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUrB1GAAoJECTWi3JdVIfQGtMH/0dylKfX2NmAWZpMtbYDJWNk
mjKWmeHrIKO4qN8o/aYpi4lNPVO/r2/U11WNaHhbzkKu9wlqiefha5MwKr9TBAY4
NxPa9mUUTkwRKXIPZppS/hloaiKQkXPIooBuHoteEfZOX4e5ohZewFPIiOYMi2kw
htKOaO00JmbF1ZSN1+IQZ2ds5rZcwsiy4eIUyiw+NsBGr00NRXSvCWB2ly2BXKzv
S1o11koos9QkMdjR3bCJMF3R1Rw24fz9+dK7krAb40JAHmwr/3ixM7zETBjFZYuM
dasojOHqVnKIjZHZ2YRsEjQG9LEEZ4mGDPjK3d04/ZojRP6Umy775KPIdn73640=
=DvHA
-----END PGP SIGNATURE-----

--pTYhUwqpXRR/mkN7--
