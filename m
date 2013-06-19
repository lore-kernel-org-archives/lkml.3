Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934898Ab3FSRlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:41:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50589 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab3FSRlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:41:11 -0400
Date: Wed, 19 Jun 2013 18:40:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        alsa-devel@alsa-project.org, Kukjin Kim <kgene.kim@samsung.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Padmavathi Venna <padma.v@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alban Bedel <alban.bedel@avionic-design.de>
Message-ID: <20130619174047.GB1403@sirena.org.uk>
References: <1371416058-22047-1-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uGRt5eEWyOm7cD/8"
Content-Disposition: inline
In-Reply-To: <1371416058-22047-1-git-send-email-tomasz.figa@gmail.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH 00/11] ARM: s3c64xx: Let amba-pl08x driver handle DMA
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uGRt5eEWyOm7cD/8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 16, 2013 at 10:54:07PM +0200, Tomasz Figa wrote:
> One of the biggest roadblocks on the way of S3C64xx to DeviceTree support
> is its DMA driver, which is completely platform-specific and provides
> private API (s3c-dma), not even saying that its design is completely
> against multiplatform-awareness.

I tried to test this on my s3c64xx based system but it gave me a kernel
that didn't boot far enough to give console output (there's some early
init stuff that uses SPI...).  That said, I needed:

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 210a893..0f49707 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -313,7 +313,7 @@ static int pl08x_request_mux(struct pl08x_dma_chan *plc=
han)
 	int ret;
=20
 	if (plchan->mux_use++ =3D=3D 0 && pd->get_signal) {
-		ret =3D pd->get_signal(plchan->cd);
+		ret =3D (pd->get_signal)(plchan->cd);
 		if (ret < 0) {
 			plchan->mux_use =3D 0;
 			return ret;

to get it to build which makes me suspect the compiler a bit as well...
the system has audio, SPI and MMC enabled.

I was applying this to -next, are there any other dependencies I need or
anything?

--uGRt5eEWyOm7cD/8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwe0bAAoJELSic+t+oim98MwP/29FMHj4LijyYDE64SKiyk4K
dnPnJEb9L0089HSrEIXeBi9an7SuKNl83tWhE1pX1hDKm4Ey/EXJ1xCfRLvoiG6Y
Mo71VnAxiAE9kvU1pTW/X7Alm1W6uzmtMLcPUdMgKSCDl0WbrXlQmOcmfBnO6siO
ED4NU8VuKX67HvMZ4Z4Dm1KdmgH0xoXf+Yqrg5LlNbXblVha97sH/qNc/cI71zIE
4IpfgL1zmtfUMVDhkUUY3RovK9kszQpm6i0m3XPG0ePvam3pPA8Vv8XuSWI4aAxt
w9UMlbja9bzEuxi7ArZ2jPQ8T9TOLm+SV3NozOpxr8QVDxenFT5GbfAV4V5PxmgV
2/EZCFwv5n6IvVN1xckXYw/OTOx7BF6le8uEcvvybJQYijWx2hOZ6TRNNtezO+ZF
JjuPS5hjpFKy09VItKvOpi2gLaSYL11V59MN20rl9gwGMlp9Z4BGFdJSU7ynK6hi
2FEZvep5rAiVxbcIjD92dpa0wc22Q+pOBx+Dw5nAMyzRSu1NwaRtmqPHVn4HapK+
fVPZyim1eFmc5tFQR1v2v5Q37iZEwbXeQ9UiSXSozq1m1b81QPItIo0xIgQREVeP
CbY7W+3QfGPrtW435BGd1P8Ja1+EZ3DardHOi/1Nhy8YlzVrCRFNjQ3tJVeKPak6
QbGKJj4Mv5ntZdSipxoD
=aV7e
-----END PGP SIGNATURE-----

--uGRt5eEWyOm7cD/8--
