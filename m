Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaHRG5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 02:57:37 -0400
Received: from mail1.g1.pair.com ([66.39.3.162]:24069 "EHLO mail1.g1.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbaHRG5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 02:57:35 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Aug 2014 02:57:35 EDT
Message-ID: <53F1A263.3030000@kosagi.com>
Date: Mon, 18 Aug 2014 14:51:15 +0800
From: Sean Cross <xobs@kosagi.com>
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
References: <20140818083055.7cedc567@canb.auug.org.au>
In-Reply-To: <20140818083055.7cedc567@canb.auug.org.au>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="UWcA2x7OoOob6L110NhwJC1Q6iPTe9WU9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UWcA2x7OoOob6L110NhwJC1Q6iPTe9WU9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/18/14 06:30, Stephen Rothwell wrote:
> Hi all,
>
> After merging the sound-asoc tree, today's linux-next build (powerpc al=
lyesconfig)
> failed like this:
>
> sound/soc/fsl/imx-pcm-fiq.c:31:21: fatal error: asm/fiq.h: No such file=
 or directory
>  #include <asm/fiq.h>
>                      ^
>
> Caused by commit 7e7292dba215 ("ASoC: fsl: add imx-es8328 machine
> driver").  Presumably it will only build on arm?
>
> I reverted that commit for today.
The following patch should fix the problem:

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index c0ace69..13199b5 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -237,8 +237,6 @@ config SND_SOC_IMX_ES8328
     select SND_SOC_IMX_PCM_DMA
     select SND_SOC_IMX_AUDMUX
     select SND_SOC_FSL_SSI
-    select SND_SOC_FSL_UTILS
-    select SND_SOC_IMX_PCM_FIQ
     help
       Say Y if you want to add support for the ES8328 audio codec connec=
ted
       via SSI/I2S over either SPI or I2C.

That gives it almost the exact same kernel config as the SGTL5000.

Is this the sort of thing you can apply on your end, or would you like
me to resubmit a v12 with just this file?  I'm afraid I don't have a PPC
toolchain to test with.


Sean


--UWcA2x7OoOob6L110NhwJC1Q6iPTe9WU9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iQIcBAEBAgAGBQJT8aJtAAoJEKuwFcVr1hraIi4P/1gfbYC2+ti2OfMNvPQZ+pon
FTC0qTDWSaOSh9lo9Guh68tr3PuBXlugE6tMs0ihHPuGneBpm27z4BnWw37Co840
cPLymJvCssUQFniH2B9PyyVBuDMsJ5s9N6vPZpusUWrq2hjJJZt2hNaKCxb/MRfl
fGlxcigfV7lUoI+WN5Cwl+cucHTO8+V5S5/E/bx3yNpR6FD3ouBjr/Ejx34bfOlf
Gic1q0pTamvUy15ZbFSjVIJ9Eeg4CPNbkF0E4IcfPl9Rz2ti6MzrAIkyiZWTDiuT
xPPvKD42eBvUcyS+Q3Qalx2+s2QX2+YYIaMFyf2Pp7hPonLZ89MSz+ZVvn+v1If4
17fpWhOhAIUiTHrrXffSIWxS7dhWcAcUK00QNhta1pqy3ICTKaivvVjhF/xXMAZK
EJCyvvTPAunph6LRDUGSvvNlJbVuHP6p8l2ZWjBz1Vw+2vnfGnWoG0xiC5nMnoTj
DZiNT23yWBI3SQN1T19+RStxyy6HUDJZ4WHDy/UzCFz+YVq0osIc23kN8xXA0xI9
Jq5ykuFpWkpD+7mVubQ0h8FM3BgA4KE2yTojd5FCh5QIDswdJWpx45A+hr4v3NKW
Jpe/qykIMkUsluoG0S8v/VAwDDmII9FUSVotgaIjAZW3brr83lovsA5dGVu5pATA
/SD64C4Vi8Z7XC5jYym+
=8aEr
-----END PGP SIGNATURE-----

--UWcA2x7OoOob6L110NhwJC1Q6iPTe9WU9--
