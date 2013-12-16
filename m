Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093Ab3LPFra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 00:47:30 -0500
Received: from ozlabs.org ([203.10.76.45]:50652 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab3LPFr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 00:47:28 -0500
Date: Mon, 16 Dec 2013 16:47:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20131216164721.79bfe996919a8ec3576867c7@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Dec_2013_16_47_21_+1100_aiI0P5wogZ+ZnUD1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Dec_2013_16_47_21_+1100_aiI0P5wogZ+ZnUD1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/regulator/s2mps11.c: In function 's2mps11_pmic_probe':
drivers/regulator/s2mps11.c:441:23: error: 'struct sec_pmic_dev' has no mem=
ber named 'regmap'
  config.regmap =3D iodev->regmap;
                       ^

Caused by commit 3e1e4a5f3a32 ("mfd/rtc: s5m: fix register updating by
adding regmap for RTC") from Linus' tree.  Grep is your friend ...

I have added the following fix patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 16 Dec 2013 16:43:02 +1100
Subject: [PATCH] mfd/rtc: fix for previous RTC fix

This updates drivers/regulator/s2mps11.c for the changes in commit
3e1e4a5f3a32 ("mfd/rtc: s5m: fix register updating by adding regmap
for RTC").

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/regulator/s2mps11.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 333677d68d0e..9e61922d8230 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -438,7 +438,7 @@ common_reg:
 	platform_set_drvdata(pdev, s2mps11);
=20
 	config.dev =3D &pdev->dev;
-	config.regmap =3D iodev->regmap;
+	config.regmap =3D iodev->regmap_pmic;
 	config.driver_data =3D s2mps11;
 	for (i =3D 0; i < S2MPS11_REGULATOR_MAX; i++) {
 		if (!reg_np) {
--=20
1.8.5.1

--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

--Signature=_Mon__16_Dec_2013_16_47_21_+1100_aiI0P5wogZ+ZnUD1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSrpPtAAoJEMDTa8Ir7ZwVmIAP/AisjjzE/kUQbLHxZgTpb32s
kmXaLVlX7/m8kHMuuOZG8eur47KVBLuXFfn2qeiPmhFCoRN4zSrLorlTnFnr0ksJ
+95mkvRrw44WLAHwEIpnOwK+vEomlwSm7HvFPlK53CBJw5pPtQa48RpH0kdcBiti
S1WVmJAYuTcOa6iVmb1VPbtIacyweW0CasOwoSFSBLZCqbzwEfqKi7Ezl3uV98d6
0XTJv6rQylBhXy8BpNzmq+BJSEKtjZjVPl1vPzKPMGTV4ihU2usSWPOTB98GKdhO
nsgB0fKd3OePtzAXa6DUFZ/MmcZGMpWuvUDMro3TM5jZWBvzoQGSq0BojAzRM3dT
hgNr9S5METc35eT7N3o8YY0ftuvsde+BADH+Nv9fvXRwQbnMqfig7jAj41p0x62y
MFqwbc4fOUfM1Yq4cvwj48MPPDrm8weuGhhOi54hDJCzNxDFBClUy9NkKLiBbKy6
VofJPtd+3EfHZPaaEsNjZtrpup/qXfJTJJf3exAI4VJS0FL1hlsfSWuFcAC/CqMs
x90pOu2ONO2xlcia8Ao/QtyF/LKtfb3h5GUmLd2jyZXUm4aZiVbtumy6tXtsSlM5
vtjEU9F9R/3sXYJVEfbqMv9aFuvYKCCYwjYMj9dIMPs/osmNGFOWqovQki1WH29l
d0Qa/slWJD29bF9Vqviz
=R7Lc
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Dec_2013_16_47_21_+1100_aiI0P5wogZ+ZnUD1--
