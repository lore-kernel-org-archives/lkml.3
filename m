Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab3GPDSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 23:18:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37745 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab3GPDSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 23:18:45 -0400
Date: Tue, 16 Jul 2013 13:18:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20130716131828.7c0b539f4ce5a515cc2553ef@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__16_Jul_2013_13_18_28_+1000_B8TiivWmCRNlluYr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Jul_2013_13_18_28_+1000_B8TiivWmCRNlluYr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/soc/tegra/tegra_alc5632.c:16:28: fatal error: asm/mach-types.h: No su=
ch file or directory
 #include <asm/mach-types.h>
                            ^

Caused by commit df7e4082f47d ("ASoC: tegra: Enable COMPILE_TEST
builds").  If you are going to do that, please test via (at least) an
x86_64 allmodconf build.  Including asm/mach-types.h is an architecture
dependency.

sound/soc/omap/omap-pcm.c: In function 'omap_pcm_preallocate_dma_buffer':
sound/soc/omap/omap-pcm.c:171:2: error: implicit declaration of function 'd=
ma_alloc_writecombine' [-Werror=3Dimplicit-function-declaration]
  buf->area =3D dma_alloc_writecombine(pcm->card->dev, size,
  ^
sound/soc/omap/omap-pcm.c:171:12: warning: assignment makes pointer from in=
teger without a cast [enabled by default]
  buf->area =3D dma_alloc_writecombine(pcm->card->dev, size,
            ^
sound/soc/omap/omap-pcm.c: In function 'omap_pcm_free_dma_buffers':
sound/soc/omap/omap-pcm.c:195:3: error: implicit declaration of function 'd=
ma_free_writecombine' [-Werror=3Dimplicit-function-declaration]
   dma_free_writecombine(pcm->card->dev, buf->bytes,
   ^

Caused by commit 6109b2fca632 ("ASoC: omap: Enable COMPILE_TEST build for
DT platforms").  In this case, a missing include.

I have used the version of the sound-asoc tree from next-20130715 for
today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__16_Jul_2013_13_18_28_+1000_B8TiivWmCRNlluYr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR5LuPAAoJEECxmPOUX5FE2KkP/2Sd27n6PD2IolaxLXV1gc4w
Q4pGGHI8Rt3ft76F7qIZmt9kZh7pgEq+cEvKeU8Bzed0LkRgAL1V1nc89QtapfU5
LKC+fkjrefN5Hn0ZCCnvVzSCNGVeZ/KRKbscFYidw7XgZDsiWLiDo92HHaEVW49n
VuXTn62nYwhapjTWOGoAWm3AOMNrbCZrJ9x99OdKnszheWuV+6PKnd0T8LGqZGrR
qYe74dwoZan/MjAtYlOiV6EI4iISyqOeEE5mBWp7w3Asq0JdVAFbqOeJ4TrGDKH6
kjXF0gnQQt8dr7au9qcZRnJIKlcyJZtTqKdp/U7MJPuHj2ZzkokPjeKEtU+4CGKC
G+1/uDN4VR67S5XvZC15Lx7s9qXmq88eH5AiPVz8TmbnD90uWkFKYeaFsPAnylzR
hSeptErjx9ZMVTi9Jlvmti2u81//fCFZ3JT5Q7eby9c3+hsrUmDF0RlawNLBG6pa
tgWUAaDqOo5/XfNguyMKOPxnrDdhetsDcE51XqsHxoonBl8/+hGmj+gWPbRhCLKo
GyOUMd1k5iYAg863dKOR3IGw8VkTkEAbumQ1DN80XLlhRw/krQAwqo2HQQ8e7uFi
4VqQBYDTHwEJWNsRy5JnaQrmWBOOwE5u0D1nAXEdDIAXAGDaKk5U5QwEmvjUhsQl
fbjZ3giATMhtKSjvjLDC
=G0H3
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Jul_2013_13_18_28_+1000_B8TiivWmCRNlluYr--
