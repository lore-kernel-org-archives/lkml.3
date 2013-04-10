Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965091Ab3DJHdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 03:33:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49195 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934290Ab3DJHdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 03:33:10 -0400
Date: Wed, 10 Apr 2013 17:33:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dirk Behme <dirk.behme@de.bosch.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: linux-next: manual merge of the imx-mxs tree with the arm-soc tree
Message-Id: <20130410173301.a9fb60beb9ca0865c93930f0@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Apr_2013_17_33_01_+1000_js_TbwuzCIGaxp8P"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Apr_2013_17_33_01_+1000_js_TbwuzCIGaxp8P
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

Today's linux-next merge of the imx-mxs tree got a conflict in
arch/arm/mach-imx/clk-imx6q.c between commit e8094b2c1712 ("ARM i.MX6:
Fix ldb_di clock selection") from the arm-soc tree and commit
8034cf45ac38 ("ARM i.MX6q: Add audio/video PLL post dividers for i.MX6q
rev 1.1") from the imx-mxs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-imx/clk-imx6q.c
index d38e54f,65319d5..0000000
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@@ -115,8 -187,8 +187,8 @@@ static const char *gpu2d_core_sels[]	=3D=20
  static const char *gpu3d_core_sels[]	=3D { "mmdc_ch0_axi", "pll3_usb_otg"=
, "pll2_pfd1_594m", "pll2_pfd2_396m", };
  static const char *gpu3d_shader_sels[] =3D { "mmdc_ch0_axi", "pll3_usb_ot=
g", "pll2_pfd1_594m", "pll2_pfd9_720m", };
  static const char *ipu_sels[]		=3D { "mmdc_ch0_axi", "pll2_pfd2_396m", "p=
ll3_120m", "pll3_pfd1_540m", };
- static const char *ldb_di_sels[]	=3D { "pll5_video", "pll2_pfd0_352m", "p=
ll2_pfd2_396m", "mmdc_ch1_axi", "pll3_usb_otg", };
- static const char *ipu_di_pre_sels[]	=3D { "mmdc_ch0_axi", "pll3_usb_otg"=
, "pll5_video", "pll2_pfd0_352m", "pll2_pfd2_396m", "pll3_pfd1_540m", };
 -static const char *ldb_di_sels[]	=3D { "pll5_video_div", "pll2_pfd0_352m"=
, "pll2_pfd2_396m", "mmdc_ch1_axi", "pll3_pfd1_540m", };
++static const char *ldb_di_sels[]	=3D { "pll5_video_div", "pll2_pfd0_352m"=
, "pll2_pfd2_396m", "mmdc_ch1_axi", "pll3_usb_otg", };
+ static const char *ipu_di_pre_sels[]	=3D { "mmdc_ch0_axi", "pll3_usb_otg"=
, "pll5_video_div", "pll2_pfd0_352m", "pll2_pfd2_396m", "pll3_pfd1_540m", };
  static const char *ipu1_di0_sels[]	=3D { "ipu1_di0_pre", "dummy", "dummy"=
, "ldb_di0", "ldb_di1", };
  static const char *ipu1_di1_sels[]	=3D { "ipu1_di1_pre", "dummy", "dummy"=
, "ldb_di0", "ldb_di1", };
  static const char *ipu2_di0_sels[]	=3D { "ipu2_di0_pre", "dummy", "dummy"=
, "ldb_di0", "ldb_di1", };

--Signature=_Wed__10_Apr_2013_17_33_01_+1000_js_TbwuzCIGaxp8P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRZRWtAAoJEECxmPOUX5FEcpoP/2vMHEE3iS7ohkr/YPfJh834
uwRwwMtMUGz8O9ER2c9h8xgfF4Msb7Ng837ZWj9nKzWp4LtTZmceFKamS0VpIiJP
AeP/C/AOL2yxvKe15YIMfBl46US2CYOKpwyeirhq/iSI/x5Iyd83g2gGG+i6AIJP
rAUX525X82ehbIAmIk5iKeq5RPCDzaIODb2OHNEgKrKs15ftft4uCeqstlm7LTOv
WNMVIpkGqR8mwioJ/vAf3xLzVfao1Idg2/eW3K30IKvshpJUZPmeC1cbewTlfw/T
JCrLQp+fFI7VAYCANUEYwi7b4VzKzRhLw+r4hUiOypTzoiSKhpwX8OeEExZX1jb+
PUDgF1x8CAdXSgMl0aSHGf0MlmmZ9Z+VJo45K1JBbTQfyr5jDfn/RdiAc5U5jYBU
pH6CWtYCiE20VDq8dKH0uuzWmSBZUT6Yb1HdENYMmcyb3PIjXxZTsf0EQqpWnx+d
FaQh6bY2/K+r1yoy/aM0sEy85HXrOlG9BDAgWwoNv3owS2KDujxktWJPxQ8mgLYg
aiNGC7X2dN0Nr7st1KEINDF/QD+wMPLIxL9EuG+DMUHyKeDNvL25s5fIdqrshe/u
ZWVZqOYN9FtGWWlwvwtwOgzxxSv72meea/fo4J3UwkGh1cr6TusxQCUFS+0fZ9ay
1deY4A+HqO9jTha2mPf0
=ZlFD
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Apr_2013_17_33_01_+1000_js_TbwuzCIGaxp8P--
