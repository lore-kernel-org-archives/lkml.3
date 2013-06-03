Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab3FCFlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 01:41:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40613 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3FCFlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 01:41:09 -0400
Date: Mon, 3 Jun 2013 15:41:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the imx-mxs tree with the arm-soc tree
Message-Id: <20130603154101.f35d9198796f9735f0c886ad@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Jun_2013_15_41_01_+1000_/0tUGAD9i2039sQL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Jun_2013_15_41_01_+1000_/0tUGAD9i2039sQL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

Today's linux-next merge of the imx-mxs tree got a conflict in
arch/arm/mach-mxs/mach-mxs.c between commit 6aaab172c99b ("ARM: mxs:
remove the .map_io declaration") from the arm-soc tree and commit
fe7149dfa886 ("ARM: mxs: Remove init_irq declaration in machine
description") from the imx-mxs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-mxs/mach-mxs.c
index d67ecc1,66fe810..0000000
--- a/arch/arm/mach-mxs/mach-mxs.c
+++ b/arch/arm/mach-mxs/mach-mxs.c
@@@ -434,7 -433,7 +433,6 @@@ static const char *mxs_dt_compat[] __in
  };
 =20
  DT_MACHINE_START(MXS, "Freescale MXS (Device Tree)")
- 	.init_irq	=3D irqchip_init,
 -	.map_io		=3D debug_ll_io_init,
  	.handle_irq	=3D icoll_handle_irq,
  	.init_time	=3D mxs_timer_init,
  	.init_machine	=3D mxs_machine_init,

--Signature=_Mon__3_Jun_2013_15_41_01_+1000_/0tUGAD9i2039sQL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRrCxtAAoJEECxmPOUX5FEjJMQAILj0cQjXN9FeYbMVfcwNNDu
grRaJj1OPyuPa9EhA3+gKE+fTK29gV3lQK5N3RND5Q6Pm968fuze8Dbx+TQvpT8A
8yfMUDKedAlYr+902pkAtjbqLieIkEmKDe9AJTxqRSx5vkKJdBZf8AIAWWI0039T
X2c5Io4sEssAf7TiUxx0ou/LvUdScGMOCFJj/a4//c3xZtskMirxBIA8y2aMI6Qz
KyTGisrvWf3lvvcSsDZ0xWnqRHdOd4Ig8riXA5yAAKgy4EBAvc13kDcmxONo88v+
uIT1+FBimZ+n6FC0KvIp3JiSEDVuLsz5arFMJmcpNmVRFv2BfqDhVRLIk3bNHCuM
4tEw/7cJ5tM2m50WLhfqMwUomxs+PPQ9aLGRPZl2dzJ/vKG2bqoN5uVpm7dDXIqv
G24lMuhuGK20k9BZj9mszWXXZ/Tj5hEnr85vlrAUSZA8+QKJMdDkfx2ddSsfYj3l
RgUCnzsTlI9xjwFjO2Bk248ikNtRx47Vk0zUdFtP+PFSJi4Mz+hNgjRu9CnBCJoa
oh9XJEFU5dS3e+lLHYhFf8ueWTkeLDuosclxwjqcM8OPjBY5tVMO7Y5Xexzbuchv
2RouHgkJPRZmOArZlM89SLa8vC9wBDtRGcxoYA1A33qwc0bn7cuSmHwwnx5Dtyvl
G0oxdRUuMKPbaiZc7pYh
=R6nF
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Jun_2013_15_41_01_+1000_/0tUGAD9i2039sQL--
