Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab3HLXg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 19:36:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42615 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab3HLXgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 19:36:55 -0400
Date: Tue, 13 Aug 2013 00:36:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Jaroslav Kysela <perex@perex.cz>, Kukjin Kim <kgene.kim@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sangbeom Kim <sbkim73@samsung.com>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>
Message-ID: <20130812233641.GL6427@sirena.org.uk>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
 <1376243970-6489-11-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aVF5wPVC5Z7LhB4n"
Content-Disposition: inline
In-Reply-To: <1376243970-6489-11-git-send-email-tomasz.figa@gmail.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/18] spi: s3c64xx: Do not require legacy DMA API in
 case of S3C64XX
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aVF5wPVC5Z7LhB4n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 11, 2013 at 07:59:22PM +0200, Tomasz Figa wrote:
> With support for amba-pl08x driver, on S3C64xx the generic DMA engine
> API can be used instead of the private s3c-dma interface.

I'm still getting issues for SPI with this:

[   50.952845] s3c64xx-spi s3c6410-spi.0: Failed to get RX DMA channel
[   50.953520] spi_master spi0: failed to prepare transfer hardware

when I test (with -next with this series applied on top), this is from
the first transfer that tries to DMA - there's actually no RX data.  No
errors are reported by the DMA controller itself.  I'm also getting
crashes setting up the audio DMA while derferencecing the channel.

This is without DT - are there any hookups missing because of that?

--aVF5wPVC5Z7LhB4n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCXGGAAoJELSic+t+oim9XdEP/jjU2+VNZYOHerrBv1kvn4ru
4Y/cKtRQSgnvuhubIWr0eEiHa5gOYz7I27efZlbas90no+x7PkrQ9lHrJyzSXRGm
w3rSHitDX3D+m18jam6Rl2Ok4Kaz1NkRhaiR4HXFj7hmsIzqjNBegEpHxTcAOJIp
d5hslTMzUB+3uwAoVuIuS2lSyGKeTnT0WXeaB+qjmvamYDx8fU3YNDVX1Lf/3qBg
0aIreTf5HqhyA7XYpaDotUQh4IcbkLJzUKCNyPQtph9H0e6+gvPpmjSPQqWd3VoO
2Cfw9XXuIpDonW9PTflCPIxuOTbh7eEFtuYR0ZGcvhDWrax5dm82txJKy/6JQE/9
pwsSyYZQWIcZ+UU2knj/wAfG4/wJQfOe81D6nANID3loWfpl6jEE9ooLF0Y8FcVw
8+OrcD3RDLo3Xo/1HsHG6sxTYMlthh4HkA9EVjHp+lks8xm+VjSbj+oifoh6XfOI
sdUW4c/Qt/etsB/p/VceNcb/cHpmGBaM9S5uMSkSj1jBEGIFdF1yxxk4GGzvDCX7
PFfPFqfEHiBbmanBRTP/tbOwYknVhpCRvwprjUEW9oaakL+AoGXAG7uG2pKZT5/i
dCuU4F9Gul4EbiG2HPYXPlOlCdSdWatPlG4YdpfX16J8UBduo07dgnqKhURPxwCg
AbKwZ+IOADF6htqXUWtp
=Vh+Z
-----END PGP SIGNATURE-----

--aVF5wPVC5Z7LhB4n--
