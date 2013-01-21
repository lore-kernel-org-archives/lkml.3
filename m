Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab3AUEuO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 23:50:14 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49432 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab3AUEuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 23:50:13 -0500
Date: Mon, 21 Jan 2013 15:50:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the samsung tree with the gpio-lw tree
Message-Id: <20130121155004.45a5fc0b25b26ece0e954834@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_Jan_2013_15_50_04_+1100_hXB9YX111xwwCpSK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Jan_2013_15_50_04_+1100_hXB9YX111xwwCpSK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
drivers/gpio/gpio-samsung.c between commit 6948ce588bd7 ("gpio: samsung:
skip gpio lib registration for EXYNOS5440") from the gpio-lw tree and
commit bda7f6d4e198 ("gpio: samsung: skip gpiolib registration if pinctrl
support is enabled for exynos5250") from the samsung tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpio/gpio-samsung.c
index 76be7ee,0d46db6..0000000
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@@ -3025,7 -3025,7 +3024,8 @@@ static __init int samsung_gpiolib_init(
  	static const struct of_device_id exynos_pinctrl_ids[] =3D {
  		{ .compatible =3D "samsung,pinctrl-exynos4210", },
  		{ .compatible =3D "samsung,pinctrl-exynos4x12", },
+ 		{ .compatible =3D "samsung,pinctrl-exynos5250", },
 +		{ .compatible =3D "samsung,pinctrl-exynos5440", },
  	};
  	for_each_matching_node(pctrl_np, exynos_pinctrl_ids)
  		if (pctrl_np && of_device_is_available(pctrl_np))

--Signature=_Mon__21_Jan_2013_15_50_04_+1100_hXB9YX111xwwCpSK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/Mj8AAoJEECxmPOUX5FEytgP/iyxPW4n4Vc+MXuivWqbUty9
bRlF/PVZT3jTIG1/MjAC+eovncl3AoQAz5ilq7rbU+2/cFVfkYUCT5mZ6IEI0Ef3
7IRf1rz9c8cZySTOVw0TcSSxSfF7diRMFzjUngYBkbgyq78hIM7qSHfaBTRTiI8H
z/PZuJZ5aYFAMK8gm66J5zstL6831iprPRK6U0WChRTfG1j0rnatzFpOABbEjK/2
N7OYUnntk0sWjVm5+0YUgcD/hCoeB4adojJ9eHtk1d2j5eQZ0YKG0cWTGgi3+Pdm
aQDEdZrrTtP/Kq02VNK+RhpRopG05owg8UrbxKi2BIIfZc3S8ZiLW7YW7ms3zDQQ
SS8zb1yVfqb8ffrvgLQOUnrCgUOQt4gVCPGgrIaxwbRQXrvcvZlwF0uVuWMWCCPS
MjSC14mgUc7mGQLDWvUSMAnpFV5XIYfjiTQIDvjHhVUzYE7lcRLUN9rn5P7ca8gS
U7coBdgzxqvA+hETyI2Io37vozdJMeS13Z963vK64u9HC3w8sDRy7Frp7wDGvQs3
j1fpyvGe2qQ0YH6iZwF9kHgQoy/6+UJ4MG+bC8iSThDlSUALl9GZzEbcEPYZ4j/R
sEeo0OgYGkKzby3voaCgNDMDjEzLKOR329kW36kL2fvwFsZs5UD9rFRmbrHUoRmE
yGFsipvvtsGgxr5skiKj
=WBVj
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Jan_2013_15_50_04_+1100_hXB9YX111xwwCpSK--
