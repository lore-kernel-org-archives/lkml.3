Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaEBRZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 13:25:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55389 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaEBRZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 13:25:28 -0400
Date: Fri, 2 May 2014 10:24:52 -0700
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Xia Kaixu <kaixu.xia@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Liam Girdwood <lgirdwood@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org
Message-ID: <20140502172452.GT3245@sirena.org.uk>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
 <1398770316-19715-14-git-send-email-kaixu.xia@linaro.org>
 <20140501191125.GB3245@sirena.org.uk>
 <7071653.m3UbztQEJc@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OengS9RFvveIvu9C"
Content-Disposition: inline
In-Reply-To: <7071653.m3UbztQEJc@wuerfel>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.49.225.226
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 13/15] ASoC: SND_S3C_DMA_LEGACY needs S3C24XX_DMA
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OengS9RFvveIvu9C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2014 at 12:35:21AM +0200, Arnd Bergmann wrote:
> On Thursday 01 May 2014 12:11:25 Mark Brown wrote:

> > Why is the fix for this not to ensure that s3c24xx always enables the
> > DMA controller - how likely is it that it would be sane to build a
> > kernel without DMA after all?

> S3C24XX_DMA is only needed for ASoC and for s3cmci. The latter
> uses 'depends on S3C24XX_DMA'. arch/arm/configs/tct_hammer_defconfig
> is an example of a configuration that does not include DMA because
> it uses neither of the two drivers.

I'm having a hard time caring about that, the arch code can always do an
"if whatever".  If that board is what I think it actually does have
audio on it, either the defconfig was never updated or the driver wasn't
merged into mainline.

> How about the patch below?

I guess (modulo the issues below).  Killing the wrapper and making the
existing selection of DMA support actually select DMA support does avoid
the redundancy.

> diff --git a/sound/soc/samsung/ac97.c b/sound/soc/samsung/ac97.c
> index 76b072b..28fe097 100644
> --- a/sound/soc/samsung/ac97.c
> +++ b/sound/soc/samsung/ac97.c
> @@ -253,10 +253,7 @@ static int s3c_ac97_trigger(struct snd_pcm_substream=
 *substream, int cmd,
> =20
>  	writel(ac_glbctrl, s3c_ac97.regs + S3C_AC97_GLBCTRL);
> =20
> -	if (!dma_data->ops)
> -		dma_data->ops =3D samsung_dma_get_ops();
> -
> -	dma_data->ops->started(dma_data->channel);
> +	s3c2410_dma_ctrl(dma_data->channel, S3C2410_DMAOP_STARTED);
> =20
>  	return 0;
>  }

This code is broken in general - at least s3c64xx has AC'97.  That's
broken anyway though.

--OengS9RFvveIvu9C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTY9ThAAoJELSic+t+oim9pqMP/2O2y/GBdIp74O5SYmgEQK5A
g/p2DCmZ7eiiKEYe7NkCqUcVpYR27kX6Agz5w3pj3XcwMFkW4CM8KAiVvcGNVsXN
42p+fkvI4BGwitFStKH6IgUZG5du9l7VbCEgS9oerfDjBPYi382JKQH2hHgLBAiF
0hm8UeW/GU/b67BYmke9UZQyiAsAfB556wgalv83DIyvdtz8WXYAUcS3cWqm41+b
lLxBmQNnX+bItyv72HK5b4YblUmr6apL79FlMgwnzDQGyH9FlFlIHayD+eeyt86D
yJKZlo/R6Atb3mkEB8GoLLO/a0x1C3R+ElFabNIDXUsG25aOWJOP2d8oVYG5sjsf
1A6Suf4e5tskM3yHaELGrp7JVJPe+NcqQi2ujLjq6LWTBswi592jkIRvEOaGFIoU
IJl1DG9Ly71uPtwPWvL8EeJVwgnmch+ErZxZyAqlVTcGFSMrL5TzVqdv5Ta/rs5e
kgbcgLVWmHi3GwJFXmWtwRJPdwDEY6TUfOcvP+N1ZqM2Ms7uzvG8PCAUKQ5zC8m1
iYdh20MLcft4sbzheVt1/0GO/Q/SYKIdB78HmsyNuxo+bunl9XoQjf4Z7dPQyPz/
xEeiZrLiMR/nh8lBAOXhRQGoM1/hNzDHaK3aV9Tf9a/O43ryVWlP/qxArIhpx4SQ
HV54XgRXTY5qRh3dK68F
=axzQ
-----END PGP SIGNATURE-----

--OengS9RFvveIvu9C--
