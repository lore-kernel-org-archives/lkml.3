Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab3ANBEM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 20:04:12 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56541 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab3ANBEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 20:04:10 -0500
Date: Mon, 14 Jan 2013 12:04:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Greg KH <greg@kroah.com>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20130114120400.e04269f927629773b0570ff2@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_Jan_2013_12_04_00_+1100_Jm/LFSP_KDaaFzfR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Jan_2013_12_04_00_+1100_Jm/LFSP_KDaaFzfR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build
(x86_64allmodconfig) failed like this:

sound/soc/codecs/ak4642.c:550:46: error: expected '=3D', ',', ';', 'asm' or=
 '__attribute__' before '__devinitconst'
sound/soc/codecs/ak4642.c:556:1: error: '__mod_of_device_table' aliased to =
undefined symbol 'ak4642_of_match'
sound/soc/codecs/ak4642.c:556:1: error: '__mod_of_device_table' aliased to =
external symbol 'ak4642_of_match'

Caused by commit bbf1453e28e4 ("ASoC: ak4642: add Device Tree support")
interacting with commit 54b956b90360 ("Remove __dev* markings from
init.h") from the driver-core.current tree.

As an aside, should ak4642_of_match be marked "const"?

I have added the following merge fix patch for today (which could be
applied to the sound-asoc tree directly - please):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 14 Jan 2013 11:59:50 +1100
Subject: [PATCH] ASoC: ak4642: remove __devinitconst annotation

CONFIG_HOTPLUG is always true now and the __dev* macros have been removed.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 sound/soc/codecs/ak4642.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/ak4642.c b/sound/soc/codecs/ak4642.c
index c78794d..2d03787 100644
--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -547,7 +547,7 @@ static int ak4642_i2c_remove(struct i2c_client *client)
 	return 0;
 }
=20
-static struct of_device_id ak4642_of_match[] __devinitconst =3D {
+static struct of_device_id ak4642_of_match[] =3D {
 	{ .compatible =3D "asahi-kasei,ak4642",	.data =3D &soc_codec_dev_ak4642},
 	{ .compatible =3D "asahi-kasei,ak4643",	.data =3D &soc_codec_dev_ak4642},
 	{ .compatible =3D "asahi-kasei,ak4648",	.data =3D &soc_codec_dev_ak4648},
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__14_Jan_2013_12_04_00_+1100_Jm/LFSP_KDaaFzfR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ81mAAAoJEECxmPOUX5FEzkwP/REUWx3/0Q06vSWsN4qc09U3
rzXy5bKvi/f+x6lF5XT9T6NhAyFnmgj0fUujwi5y8+aiXXEyU8n2x6upRkmxU/3V
h/mgYXKyWutIvdjrg4sQ8uHryDCcS1M0lTO16E0jHFKGVbcOrqeksSn5XUugB6BP
gKhpehDEfzHS0Xf+5ktZcmyIXlPq4QZkrggBanLTIG+1B87x4wpcFqR1qzWqxrhb
EpBHe4XWLuK+jVg6a2ksVFtgymHHSTA7UVHmiOVgeAgOYtcBxV5p+6HD7AFE1/yO
lWcCaUGcFcB6PEBdBaDzwoboe0vhGn90e/qfNu/FWCx4Mlxt3pio7Ody1NbQUvhU
gz/EaHz3sJTZuO5D0wWnAxOTMHLoO7nCl52Kp4f5JoU4+DGPhszbhKlDRX1IPGhR
SCk1kceqgtKv+XtlCwDod5ihJbmvy5s6RW59wJDtUXIQZ1Ns5UZ4IcZI4MJE26tA
itwnD7XuQaSwRXIDd4bIDWisYO79AN6h63pEpY5duObT0cjIIMv8OcycljwkQ9JO
ggse4r6nO138Brc6TFvsUU5pUuWLcYFCMgOVafX3bpK7UHIRjf4C39rAGGfeHxFm
IVXCDdj1qOsmYKUzBLpo17NhxCWeItpr/2ARm3VOmiO72Utb7QYunCiwcsBCNzcP
kOvIeIjekP/Yilm7Gyha
=KEOz
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Jan_2013_12_04_00_+1100_Jm/LFSP_KDaaFzfR--
