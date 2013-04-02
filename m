Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760898Ab3DBG54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 02:57:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34039 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760302Ab3DBG5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 02:57:54 -0400
Date: Tue, 2 Apr 2013 17:57:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the imx-mxs tree with the arm-soc tree
Message-Id: <20130402175752.b6ff90247b873b67111d31ad@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Apr_2013_17_57_52_+1100_cOk8FCxomU/zM2h="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Apr_2013_17_57_52_+1100_cOk8FCxomU/zM2h=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

Today's linux-next merge of the imx-mxs tree got a conflict in
drivers/clocksource/Makefile between commit 275786b71d42 ("ARM: sirf: use
clocksource_of infrastructure") from the arm-soc tree and commit
c74512bf83f3 ("ARM: mxs: move timer driver into drivers/clocksource")
from the imx-mxs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/clocksource/Makefile
index 5e2176f,89c5adc..0000000
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@@ -16,8 -16,7 +16,9 @@@ obj-$(CONFIG_CLKSRC_NOMADIK_MTU)	+=3D nom
  obj-$(CONFIG_CLKSRC_DBX500_PRCMU)	+=3D clksrc-dbx500-prcmu.o
  obj-$(CONFIG_ARMADA_370_XP_TIMER)	+=3D time-armada-370-xp.o
  obj-$(CONFIG_ARCH_BCM2835)	+=3D bcm2835_timer.o
 +obj-$(CONFIG_ARCH_MARCO)	+=3D timer-marco.o
 +obj-$(CONFIG_ARCH_PRIMA2)	+=3D timer-prima2.o
+ obj-$(CONFIG_ARCH_MXS)		+=3D mxs_timer.o
  obj-$(CONFIG_SUNXI_TIMER)	+=3D sunxi_timer.o
  obj-$(CONFIG_ARCH_TEGRA)	+=3D tegra20_timer.o
  obj-$(CONFIG_VT8500_TIMER)	+=3D vt8500_timer.o

--Signature=_Tue__2_Apr_2013_17_57_52_+1100_cOk8FCxomU/zM2h=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBCAAGBQJRWoFwAAoJEECxmPOUX5FEImQP92FNqsDj1RCZq5HdzRyF0whX
TBk2qyYGQScMtx8+/0gYamH67mzH4G48Ve5PCdC0KIVcPZUOKYR4zsfON8c4SXm4
N4fhp/volL69Tq6DlhI5pWplSwEYIbodmXkJ9eLvEXop+s99Dr6xsqz/v2gAVPxB
neOPE1XFaP2ETwFPjj1DtiIp1Rig1o+vyuY0dRnijHxeGfiUQtZwpuxJh5BGs//R
qF2epoo4KGuPARCYHMK13p8YPUtYFUksLyTJVP0eIDytbfDXTz1gwX6iB5iJb/6T
ia3nyioAv/kCdQIckm5ufnd7a5QQj2xCPw4WobbeOJgJF1YZLh/u+Vv4ZUCDDbTu
vxIqPvqdnSySFpxElSu49a/7e1HKoTsxvpIp2mMkD5DIgp23aCWbrapVAaErd68h
Vm2N13uIkslaE3/3CH2SutM7xVsr1Vw20UL5tydKtjJXs/HENWPpv37wdELQJibH
ntuRo7BhyWaqhMGpczpz099eUdPi+1ZvENAJ2kasAxgaIfcODH1+iw0+ha5j2Jl7
7cZBdH3L69jKCb0C0uFV2orQmcv56tBAM46kmTNBa6rSpOxcld7pQNoG/ScgWK7d
b0mQdiH3mzds6ELkzlpxG9zJpMMfv/lpUfXdJP5VWF/qHuiMtMDb8vGdAcTruJEv
SwQFVEwNYHpVjBF6gX0=
=MJ+W
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Apr_2013_17_57_52_+1100_cOk8FCxomU/zM2h=--
