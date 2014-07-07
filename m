Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaGGOvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:51:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51305 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbaGGOvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:51:12 -0400
Date: Mon, 7 Jul 2014 16:48:32 +0200
From: Mark Brown <broonie@kernel.org>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Message-ID: <20140707144832.GL30458@sirena.org.uk>
References: <20140706070800.GA2927@himangi-Dell>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kunpHVz1op/+13PW"
Content-Disposition: inline
In-Reply-To: <20140706070800.GA2927@himangi-Dell>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: sgtl5000: Use devm_ functions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kunpHVz1op/+13PW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 06, 2014 at 12:38:00PM +0530, Himangi Saraogi wrote:

> diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
> index 249fadb..0efd6d6 100644
> --- a/sound/soc/codecs/sgtl5000.c
> +++ b/sound/soc/codecs/sgtl5000.c
> @@ -841,14 +841,15 @@ static int ldo_regulator_register(struct snd_soc_co=
dec *codec,
>  	struct sgtl5000_priv *sgtl5000 =3D snd_soc_codec_get_drvdata(codec);
>  	struct regulator_config config =3D { };
> =20
> -	ldo =3D kzalloc(sizeof(struct ldo_regulator), GFP_KERNEL);
> +	ldo =3D devm_kzalloc(codec->dev, sizeof(struct ldo_regulator),
> +			   GFP_KERNEL);

You're using the managed functions within the ASoC level probe functions
which doesn't work - devm_ is only usable as part of the driver model
binding and unbinding.  All this resource allocation needs to be moved
into the device level probe (which is a better thing anyway) before it
is converted to devm.

--kunpHVz1op/+13PW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTurM9AAoJELSic+t+oim9SpIP/1svFdCcBDiD8L2+o3dllB9C
t1EqkpkNQhcv8krzWH7QfBPAgiHR3ihBQjULPpA/6cIaqOHoTA+LHiVykEhIDgKV
Kqb1tUD+fAIieuT/YdVMObRBMwBVllnup1Ip6zgsRa460wNCUqXbR8rqNgqo+aZ0
OzB2d8/nJLUBfTr/2Y7pWBwzhQ1fzMTtHLH8ixBT2IYQSW91y3abCs1+Lsvx8+es
XAawaBOdooMldPKgqiFgcCARWfAnYPmVihgXJOTHCwQfuQtWaWJ6903UR4HY4JR1
CeE3cvwr/nVuWCsiYk3UtbDeG4O2bKOAYuhlxiuFLvBeehIwzLT5nHl0jcciqj4C
k7e9hnUsYRWOwpW/zcWWU0UGXWUNt1cKf25nl6TP2UnOkHdsWK7LyTpBfS4tfakB
cnt0N7jepk2LLFFRecoj3xRzcccNbllsW6/9QmCLH20iBUdKS9KgbXfcIOZ5K3wY
FFksMn++5D8mwVW0q9XleyNOpdUUTvcPlbqS/Yt9X2PT6s5zDbE+Fn+utQGRAYAI
c1je11Ke1Kd2gP4vs8/cv0xWVciERXVG+fSuAFABmLEZrb02f/fj0bl+bvsuGHoL
El6WRMNVnRICAWOL1uPZ5v8F8S9qMot+VDJj4wVda9SYJfam1XeQiftqyxrlr3sx
nyE+UM/+ThWitikqiRc4
=/G7O
-----END PGP SIGNATURE-----

--kunpHVz1op/+13PW--
