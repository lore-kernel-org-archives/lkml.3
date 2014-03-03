Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaCCFin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 00:38:43 -0500
Received: from ozlabs.org ([203.10.76.45]:35148 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbaCCFim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 00:38:42 -0500
Date: Mon, 3 Mar 2014 16:38:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: linux-next: manual merge of the watchdog tree with the arm-soc tree
Message-Id: <20140303163835.303fbfd4fa64507e0e3db33c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Mar_2014_16_38_35_+1100_b8nv56JosaBmfQ.6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Mar_2014_16_38_35_+1100_b8nv56JosaBmfQ.6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wim,

Today's linux-next merge of the watchdog tree got a conflict in
drivers/watchdog/Kconfig between commit 59416745bb8c ("watchdog: orion:
Enable the build on ARCH_MVEBU") from the arm-soc tree and commit
db5dd336cb23 ("watchdog: orion: prepare new Dove DT Kconfig variable")
from the watchdog tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/watchdog/Kconfig
index f1ff408c4b17,90f950d039c4..000000000000
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@@ -292,7 -301,7 +301,7 @@@ config DAVINCI_WATCHDO
 =20
  config ORION_WATCHDOG
  	tristate "Orion watchdog"
- 	depends on ARCH_ORION5X || ARCH_KIRKWOOD || ARCH_DOVE || ARCH_MVEBU
 -	depends on ARCH_ORION5X || ARCH_KIRKWOOD || ARCH_DOVE || MACH_DOVE
++	depends on ARCH_ORION5X || ARCH_KIRKWOOD || ARCH_DOVE || ARCH_MVEBU || M=
ACH_DOVE
  	select WATCHDOG_CORE
  	help
  	  Say Y here if to include support for the watchdog timer

--Signature=_Mon__3_Mar_2014_16_38_35_+1100_b8nv56JosaBmfQ.6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTFBVfAAoJEMDTa8Ir7ZwV/rQP/RJwuId5TTzCG/cstZo5l4t4
Oz+3MCxrOTL2TPewUbOuZuMc0Zx7TsN+u18KUMdZmaSDYnd2DKucc3wyWDmnY1XT
8e80gpeYxgzo9M8gFVd4iiQuzcmYVusnzbiKgGsKUFoG2a+Rd3c8Bs5n6LBz6K7V
DzbFkfzBrAVRLXmTzx2YRpm0A/Aj4EAoBs5JaLFOBRW8tqqNUYm8ebWQgbI7VXxM
d2A+kKvywvfxC/wFbR92dhMRgP6WAPl2Dy6902qznIVdqXdEW9DW+hyNHJeKp1FE
ZdxD92ypMmuU/kzaiGUNmlh/z3tcrIF+21GDmxqgdA4ptDERJlsGsyAhCVDNVcB8
8Pig0T7GTD+4MTeeY6RDckx9bujpssTrAV7U2l4KiXY8JKkDiykEMSPqLjJI3lS5
OImBsccVcUD2Os1tTYizcqqtFFi0jxYhDKea+hYDR7NzVvodUT1nu33Q4XnxSOAV
8x5RPPPGkqwRXs0D8TukE3jlFldSCljC0djuRl1GoSYd3SxR4ZIWzwNiNW+piH0W
hFVg9HKU0QwG95kHJVZVpm2wOrGYrYvoylkmPmDe4xjYaDMAi7jjLTT19ZCJcs8G
a91hIGSIiqWmFp1VHPsatMxGs6fmDu6Asc1gtIodThdFe8RY/BpDxqZb8BlzlRbf
dq8mnwjDhCtTf93pjsvZ
=oFiW
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Mar_2014_16_38_35_+1100_b8nv56JosaBmfQ.6--
