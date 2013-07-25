Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab3GYBhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 21:37:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44225 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab3GYBhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 21:37:21 -0400
Date: Thu, 25 Jul 2013 11:37:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hauke Mehrtens <hauke@hauke-m.de>, David Miller <davem@davemloft.net>
Subject: linux-next: manual merge of the wireless-next tree with Linus' tree
Message-Id: <20130725113709.210d2157219410a4ff119510@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__25_Jul_2013_11_37_09_+1000_yk=H6WhbomfUl.Vl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Jul_2013_11_37_09_+1000_yk=H6WhbomfUl.Vl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
drivers/net/ethernet/broadcom/Kconfig between commit 31bd29776b85
("bgmac: add dependency to phylib") from Linus' tree and commit
72bb2f267887 ("bgmac: make bgmac depend on bcm47xx") from the
wireless-next tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/ethernet/broadcom/Kconfig
index 52c9603,7b839bf..0000000
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@@ -130,8 -130,7 +130,8 @@@ config BNX2X_SRIO
 =20
  config BGMAC
  	tristate "BCMA bus GBit core support"
- 	depends on BCMA_HOST_SOC && HAS_DMA
+ 	depends on BCMA_HOST_SOC && HAS_DMA && BCM47XX
 +	select PHYLIB
  	---help---
  	  This driver supports GBit MAC and BCM4706 GBit MAC cores on BCMA bus.
  	  They can be found on BCM47xx SoCs and provide gigabit ethernet.

--Signature=_Thu__25_Jul_2013_11_37_09_+1000_yk=H6WhbomfUl.Vl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR8IFJAAoJEECxmPOUX5FE/xcP/2GnWYTcYgyVHqjNwr6t1AoE
NrKHLTMYFivfnCGZJ6JXq1PsZ9msthQo0nKpnCSDleIjQlWr6wF9CkE1u5qMpw8M
PhoSTm4JEILfCInTfrdP34O0LXyMGsDWZC0yZU2U0To3pcmzTgL7zMYedajQBvQL
TG4O4gufGqLA7O4jQvJ7utROyp1BFiih08kjmfqRk6JXItMXueZsjBsDq9r3IcS/
avNLyqidLOVRpbfPU9y0MYHFuhxmfZ7phOA7DWrr2NXY32FHycexy7a7tkcq9dHw
xi/1YwKzl0AF+HoFa1JLtqSJQq7w//ojHPAbDkCRIjqSmMDkBzJNgwpfCqVFinA6
dOF9al3LumxB3dXByfA4/Q4HRLJ4mKT/rgKXO7sCmph//Y1ZWdCpJ/WRlm/+0V99
mlnfdYRKjEBwPT0qnyiTFjfZm+HacV2BcFGJJTg+NsuXewkPLZg3Edfmk79iU1u1
z6hmfQDUrsljUvMeCIcIbjTQZisQXO07faU+ACSDHQ/4Hv/lj3eEF+54tapRN9J+
Xo6CIJunCgNnXO5zqAUXYbHclCDSg8PQTexzgn4HSdSIL8oc8jRHVhNGqlSVeM0m
k9mezQQfYBxNLNg/Ik5PRv5lB1LQjZbpxCOBCmacQY7S7MjMcK2CBBoIAcnExo0M
qNN126T3ie411ku8o3gk
=jgH4
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Jul_2013_11_37_09_+1000_yk=H6WhbomfUl.Vl--
