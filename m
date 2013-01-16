Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab3APDOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 22:14:15 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41305 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860Ab3APDON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 22:14:13 -0500
Date: Wed, 16 Jan 2013 14:14:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the tegra tree with the arm-soc tree
Message-Id: <20130116141411.8fadedee54ed35dc0eddd288@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_Jan_2013_14_14_11_+1100_ZAEgFAuiuoF.zncB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Jan_2013_14_14_11_+1100_ZAEgFAuiuoF.zncB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tegra tree got a conflict in
drivers/clocksource/Makefile between commit ff7ec345f0ec ("timer: vt8500:
Move timer code to drivers/clocksource") from the arm-soc tree and commit
ac0fd9eca3ba ("ARM: tegra: move timer.c to drivers/clocksource/") from
the tegra tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/clocksource/Makefile
index 440449c,b5cc507..0000000
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@@ -17,6 -17,6 +17,7 @@@ obj-$(CONFIG_CLKSRC_DBX500_PRCMU)	+=3D cl
  obj-$(CONFIG_ARMADA_370_XP_TIMER)	+=3D time-armada-370-xp.o
  obj-$(CONFIG_ARCH_BCM2835)	+=3D bcm2835_timer.o
  obj-$(CONFIG_SUNXI_TIMER)	+=3D sunxi_timer.o
 +obj-$(CONFIG_VT8500_TIMER)	+=3D vt8500_timer.o
+ obj-$(CONFIG_ARCH_TEGRA)	+=3D tegra20_timer.o
 =20
  obj-$(CONFIG_CLKSRC_ARM_GENERIC)	+=3D arm_generic.o

--Signature=_Wed__16_Jan_2013_14_14_11_+1100_ZAEgFAuiuoF.zncB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ9hsDAAoJEECxmPOUX5FEEFoQAJQoM4ch3Pg+Um7syXEvcO5U
mcN1AqDauhjsbSwu6cJ7W5624wkhAX2Z4NaEM504OzTZgdA0r9+JEwAVXbGxEmpo
hiqBRUvndupRgIEd1ftEA8wtzyvsuEC9vHutk/ni+G9eSOBCamWnum1UwZCgbPls
1OzhLNaaCKK0NOtH45Jd552mUtrkmLkqRUQWQmvAMJxMZrl4Mxwl+g25ue+SzZVo
xtStBACzsY7PgjTHpa5B2tPnsbYt/gasIXS6Gm+JjFgKid4B1rpo/ncG8eluPC8c
hVcvlbLDTjjg0h0Ec40xl6Dh8MPa39SzJhn3SQH4io2HufgSl4r4YbM4HU1JK2aS
Z98070MmE/I4BBRwLFKi+NBwIZLfOPPg4Haq+7Cpgcy4qtJsM/ojbt+XuZE0P3ap
434/mOoYyN9eyvqJYNN6KCfHLFSISkVtNcFqmcnCjt62tKFWgF9ucMFQWUgc4foJ
PxT6R7uvS2ZAGSDDb/BsAkP9CKl0V56f30wMTqQ+79hMDVokZ4H+UKjKi5IOMF1R
BQ9erwN6YP4/Vu7DqqSihNW/5vG9z+qBpbwy2U0hFz4GXM12DSj1NoTUU5TIhp+S
yDHl8+k30a5NcFS/X153/h068tagmZwWUJgtKPAmnEUXhixsdW84DzWfg1GbE+VY
euvQMv3LA4cSEyzLwp0C
=dTPH
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Jan_2013_14_14_11_+1100_ZAEgFAuiuoF.zncB--
