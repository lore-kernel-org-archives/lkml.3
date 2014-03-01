Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaCAE22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 23:28:28 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53913 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaCAE21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 23:28:27 -0500
Date: Sat, 1 Mar 2014 13:28:18 +0900
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lars@metafoo.de, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140301042818.GP29849@sirena.org.uk>
References: <1393578267-18255-1-git-send-email-Li.Xiubo@freescale.com>
 <1393578267-18255-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4SRTEifjNkXp0Rce"
Content-Disposition: inline
In-Reply-To: <1393578267-18255-2-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.126.181.238
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 1/3] ASoC: codec: Simplify ASoC probe code.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4SRTEifjNkXp0Rce
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 28, 2014 at 05:04:25PM +0800, Xiubo Li wrote:

> "Just removing the set_cache_io() call will not work for all=20
> drivers. There are some MFD child devices which use regmap from the paren=
t=20
> device. So dev_get_regmap() will return NULL for those."

This is the sort of thing that I was referring to when talking about
doing the non-boring drivers separately.  As well as the warnings Lars
mentioned there's a bisection issue here:

> -	codec->control_data =3D da7213->regmap;
> -	ret =3D snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
> -	if (ret < 0) {
> -		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
> -		return ret;
> -	}
> -
>  	/* Default to using ALC auto offset calibration mode. */
>  	snd_soc_update_bits(codec, DA7213_ALC_CTRL1,
>  			    DA7213_ALC_CALIB_MODE_MAN, 0);

Unless the core sets up the I/O before calling probe() the above is
going to mean that the snd_soc_update_bits() call fails since the I/O
operations won't have been set up.  There is a defualt call to set a
regmap up but it's only done after the probe.

--4SRTEifjNkXp0Rce
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTEWHfAAoJELSic+t+oim9+wsP/0ao05KQxKGarPYl3/j7k5LK
dwaDgT6Swd7rH4Jgds2Bld4VfMEOrrecOOlHF48I8wzHoCC1GuCdLCmyOeVvUF2H
SNQ9bEZ6gRyPQyq+BekVd/hdHsLoKUMXcXcj++HGga6QR4KOsgi5FkpQ+guTID+Y
p8wS2bkbwcqzsK7QmQFXyp4YoLsJ1z08roBLyuCf2gFXr/QJqwFZq0n9OHIYHOMv
mAJmSTUYImeuHbfQR+rHBsdLAhph9jNK+seCadofGSpUwY3anT2iDRxT5dTyz24m
/h509qWhXtQZDyaF9QU6ADtnHflETvh/rm4pH8EAh1aB5VS++nkmk/muOezemqLT
fGi7a1M76YcuH1FiTbnn2rYZg7x7Tq/kjYzhKqMuWmrYHGzsyh9Wid2n7jkKrGzH
mJOp+eR03SyrMlch5YEH04qIoOLqeON5h7xrlHPNXV9FKk33mkJ1VICF0+DYQ7lw
cnz//K2ZzgxlZHpTx3ID8wqIiZvRzqztMG68cgcBp0SAq/K5fmGOzePb4KyuCW3j
QvmRleOarVSP1YCIgxIzKIucXfUNqNtVGLQuRfBTes59hW+S375gQi+NWupzVzhP
TWkDfoqfEKJAJlyjo2pJf492HflGbPMc47BDfktRPeIVyP7CZqtFOAsRgSyOU4O4
FdmGdO6xEmJCD3g6HiYz
=d6l9
-----END PGP SIGNATURE-----

--4SRTEifjNkXp0Rce--
