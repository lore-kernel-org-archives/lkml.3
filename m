Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab3BFFWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 00:22:06 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:43580 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3BFFWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 00:22:01 -0500
Date: Wed, 6 Feb 2013 16:21:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Jingoo Han <jg1.han@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: linux-next: manual merge of the driver-core tree with the spi tree
Message-Id: <20130206162151.73f40e71f5103e33c19c4c49@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__6_Feb_2013_16_21_51_+1100_hbzL/UC5UNOtpNzK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Feb_2013_16_21_51_+1100_hbzL/UC5UNOtpNzK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in drivers/=
spi/spi-s3c64xx.c between commit 4eb770067f3a ("spi/s3c64xx: Use devm_clk_g=
et() and devm_request_irq()") from the  tree and commit b0ee5605234a ("spi:=
 Convert to devm_ioremap_resource()") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/spi/spi-s3c64xx.c
index 7cfbe9d,3d4a7c4..0000000
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@@ -1241,11 -1276,10 +1241,10 @@@ static int s3c64xx_spi_probe(struct pla
  	/* the spi->mode bits understood by this driver: */
  	master->mode_bits =3D SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
 =20
- 	sdd->regs =3D devm_request_and_ioremap(&pdev->dev, mem_res);
- 	if (sdd->regs =3D=3D NULL) {
- 		dev_err(&pdev->dev, "Unable to remap IO\n");
- 		ret =3D -ENXIO;
+ 	sdd->regs =3D devm_ioremap_resource(&pdev->dev, mem_res);
+ 	if (IS_ERR(sdd->regs)) {
+ 		ret =3D PTR_ERR(sdd->regs);
 -		goto err1;
 +		goto err0;
  	}
 =20
  	if (!sci->cfg_gpio && pdev->dev.of_node) {

--Signature=_Wed__6_Feb_2013_16_21_51_+1100_hbzL/UC5UNOtpNzK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJREehvAAoJEECxmPOUX5FEj/AP/AwawM/47FpaCWqW6F6DWsXz
fBoRvyV9BXUy1OXagZCxvHSjyqXogFvW46k55ZuRc/awB+01mUpxTOZaGK1tpDCh
nkwphXSSw+x/1TY9bXb7B0MRSiF6gOYjcbIN1DnKnzIxe92G0ZJE4upJj/qr1UDH
gZNTgNvLMr8bSGaIC33UEY9XU3mrrl/42DgUDWVQt6WpMqCTDWiD5m5w4/z+OObU
6rityi30mOauLKhih4RCZJp1Ko2HNla8Zc4OWklOQjEL+7dKKLIVwUDtubd8AJrO
ohm1FyAFaU2V/OWt7k1olHPsBnbD5Tbk5kqhDOzZUVg79q7jQ6pr/G2ukk6Bmx13
PQSdJJUhPmX7e7eNJTv0hcIwOjyOAFtZUWue+cLGoyvV8+fewuAWzlVs+xVA6czJ
AL4mYNEec3LxzN8vyXeQHdV3W0QdGlZjKMRHvUmFWA+KTsRebk6bGVCXg7QnOnJZ
FNPh0fkG1kcj5ubtOobwemCy35AuUhAOUk6xf3VUvrWQfL7NmDcpVnRf+U03d81J
MBSaEBy9XExrfiE5sjlzn/P4br5zvRok43b1mfDbHW5IBrKjEYTmklklxsZQsMh/
ysm3w30+kvmZupAZvIDTeK3CuxbsiL1f/fOMG8uD1FZofQKS4VRel3vr+o0DkN0x
hBSCSGDv8FWAZr+CVRa7
=7lH8
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Feb_2013_16_21_51_+1100_hbzL/UC5UNOtpNzK--
