Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab3DSG33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 02:29:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53008 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab3DSG30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 02:29:26 -0400
Date: Fri, 19 Apr 2013 16:29:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: linux-next: manual merge of the arm-soc tree with the gen-gpio tree
Message-Id: <20130419162908.69aa0cbccc708ea1ca563a11@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__19_Apr_2013_16_29_08_+1000_CCugxtMk_e=L.RdE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Apr_2013_16_29_08_+1000_CCugxtMk_e=L.RdE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/plat-orion/Makefile between commit 43b426d6fae8 ("arm:
plat-orion: use GPIO driver on CONFIG_GPIOLIB") from the gen-gpio tree
and various commits from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/plat-orion/Makefile
index bbc0d6b,2eca54b..0000000
--- a/arch/arm/plat-orion/Makefile
+++ b/arch/arm/plat-orion/Makefile
@@@ -3,8 -3,6 +3,6 @@@
  #
  ccflags-$(CONFIG_ARCH_MULTIPLATFORM) :=3D -I$(srctree)/$(src)/include
 =20
- obj-y                             +=3D addr-map.o
-=20
 -orion-gpio-$(CONFIG_GENERIC_GPIO) +=3D gpio.o
 +orion-gpio-$(CONFIG_GPIOLIB)      +=3D gpio.o
  obj-$(CONFIG_PLAT_ORION_LEGACY)   +=3D irq.o pcie.o time.o common.o mpp.o
  obj-$(CONFIG_PLAT_ORION_LEGACY)   +=3D $(orion-gpio-y)

--Signature=_Fri__19_Apr_2013_16_29_08_+1000_CCugxtMk_e=L.RdE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRcOQ0AAoJEECxmPOUX5FEX70P/2WSNBoA6Q/Gb4XCxtvhoEVu
m8OPgKU3pn/NtpPXajjMhcPS+L9lMr2Role/4zPtSSmXyH1q5tf9HyTBtizraBdO
Ij3S/JonmJnQBYmHsjestYExMo6XbH+PcGUQTeKV+yCOeELBqjc5TO55vtcfRk95
QUHo76/qCkWGNiQkw4SJPBirZwu90OHmSB5XN6CVmDCvArJrlId6dWV14DkZU3x6
vKpwfW2I2s+qeMawAMqBxHyMQ01etx86da1ZFwMFDmR7DuMUabsOMsQAH4R87d2+
gzambO0hTt0o5YjXzFxncWl5zF3bVFUPt+Hz6zSgsrHRkE2F+NgxatGuSLUvTgmZ
MEMA/cq/F3MAHz99L1togsQ55Ce+/SEiL3/thUndDHxhj98CbdODwifyK3AtI3Zi
Ci4ed7l/sWXbteVnzi0UUH7MHxv/3hTIoPlazikGtjB4ZikiA1LzesgPJeo2gLvU
BxwB70zHxvU27US0nZ/9sw1/LDn3tNuMrB1Rx46W7R1FVUQ89N7tYEgLq4Pl+FGt
B8BdIBHe1Cr/07z/8hgMiJ9t32JpNCoG2veO1qvbVLlTVJIINLIRxljhOTVXqmcF
Jidj8IM0pyGRQdKazo7XWPOtpiqseu+UC9HYPlHjjBSAtRr1CbOus4UjXDUxUxTC
vYUPVDpeQwo3rhvWffAM
=dGug
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Apr_2013_16_29_08_+1000_CCugxtMk_e=L.RdE--
