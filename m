Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab3DSG7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 02:59:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34362 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab3DSG7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 02:59:49 -0400
Date: Fri, 19 Apr 2013 16:59:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Simon Horman <horms@verge.net.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Bastian Hecht <hechtb@gmail.com>
Subject: linux-next: manual merge of the renesas tree with the arm-soc tree
Message-Id: <20130419165931.740d243c82497664e6bd95b1@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__19_Apr_2013_16_59_31_+1000_YFeUdkA_AdOyYuOR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Apr_2013_16_59_31_+1000_YFeUdkA_AdOyYuOR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Simon,

Today's linux-next merge of the renesas tree got a conflict in
arch/arm/mach-shmobile/setup-r8a7740.c between commit 0583fe478a7d ("ARM:
convert arm/arm64 arch timer to use CLKSRC_OF init") from the arm-soc
tree and commit 74d6523995cc ("ARM: shmobile: r8a7740: Prepare for
reference DT setup") from the renesas tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/setup-r8a7740.c
index 326a4ab,00c5a70..0000000
--- a/arch/arm/mach-shmobile/setup-r8a7740.c
+++ b/arch/arm/mach-shmobile/setup-r8a7740.c
@@@ -1027,9 -1016,10 +1016,9 @@@ static const char *r8a7740_boards_compa
 =20
  DT_MACHINE_START(R8A7740_DT, "Generic R8A7740 (Flattened Device Tree)")
  	.map_io		=3D r8a7740_map_io,
- 	.init_early	=3D r8a7740_add_early_devices_dt,
- 	.init_irq	=3D r8a7740_init_irq,
- 	.init_machine	=3D r8a7740_add_standard_devices_dt,
+ 	.init_early	=3D r8a7740_init_delay,
+ 	.init_irq	=3D r8a7740_init_irq_of,
+ 	.init_machine	=3D r8a7740_generic_init,
 -	.init_time	=3D shmobile_timer_init,
  	.dt_compat	=3D r8a7740_boards_compat_dt,
  MACHINE_END
 =20

--Signature=_Fri__19_Apr_2013_16_59_31_+1000_YFeUdkA_AdOyYuOR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRcOtTAAoJEECxmPOUX5FEtFUP/jyojXRCgZFAS5lSSA9ltr5f
9Jltfu2bQmsLehIsUQb1QuXWnUzTe0Nrp5oe2BTLTH4Tt9R2Mq1JR79/fyEqvtBU
W/2JiHrRtoKGGo5QHAp656umQ+b9PIctVs3PNncmrYJubDuQpNek4+k3hqISeQ6/
ktmvJN5bSvzJ1w1z3Y0tNg/j4GHIix5mVeoAKbIyzQco9r3k7ON5NrUJnr/5QYnL
F4MNAI5+3dUxHR+zxn8sX8HRbX0HOTOC7m2BMdhCOGSxjk74bLI/S81TFXn5r1ue
B2ZKkiFY8F1R+kJy9v+meqlkZEwF/tO0uuSm+nMgFysLQv7MtCaicN6/dA24+oHT
MlLP1vOFQwBwoGezeuloFIzpQ+uCkGNfkcG/yfmELgiCVbywjcAGCJqzTMNfhbi4
O58S7CEfMritrvGJ0mc8BPz6eaZiUN/m2vBmRdPrksYFLfn9RoiQ/L1mbLJeiKih
tl/9KjVu011jg2wdvTLkPMW3Up6gGCYSzJFzg9bVzuEsTmgk3eEQjgatMEqEgkhE
FqV4WAiyh/rg7k9fxYXKrOqv3pyjZW0pMIBdE7n6aucxU3koHvhdAx+7kmLu5uSQ
k8bYPvzagtVuuXZaROTaiiDEgAvaacZnttJCs97e5mobcmTQsBVYinJ3lvoHHvnl
vhZgHYmdy42L6s96BEwv
=yxli
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Apr_2013_16_59_31_+1000_YFeUdkA_AdOyYuOR--
