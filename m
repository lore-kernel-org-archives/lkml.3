Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbaCCH5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 02:57:09 -0500
Received: from ozlabs.org ([203.10.76.45]:58210 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbaCCH5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 02:57:06 -0500
Date: Mon, 3 Mar 2014 18:56:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>,
        Rob Herring <robh@kernel.org>
Subject: linux-next: manual merge of the akpm-current tree with the arm-soc
 tree
Message-Id: <20140303185657.64cf0ef850f86ec92ffd240d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Mar_2014_18_56_57_+1100__BRQSrsTEW_n/2/X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Mar_2014_18_56_57_+1100__BRQSrsTEW_n/2/X
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
arch/arm/mach-picoxcell/Kconfig between commit ddb902cc3459 ("ARM:
centralize common multi-platform kconfig options") from the arm-soc tree
and commit b096b0b50c4b ("Kconfig: rename HAS_IOPORT to HAS_IOPORT_MAP")
from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-picoxcell/Kconfig
index eca9eb1c5931,c03cd6ffb429..000000000000
--- a/arch/arm/mach-picoxcell/Kconfig
+++ b/arch/arm/mach-picoxcell/Kconfig
@@@ -1,7 -1,12 +1,7 @@@
  config ARCH_PICOXCELL
  	bool "Picochip PicoXcell" if ARCH_MULTI_V6
  	select ARCH_REQUIRE_GPIOLIB
 -	select ARM_PATCH_PHYS_VIRT
  	select ARM_VIC
 -	select CPU_V6K
  	select DW_APB_TIMER_OF
 -	select GENERIC_CLOCKEVENTS
  	select HAVE_TCM
- 	select NO_IOPORT
+ 	select NO_IOPORT_MAP
 -	select SPARSE_IRQ
 -	select USE_OF

--Signature=_Mon__3_Mar_2014_18_56_57_+1100__BRQSrsTEW_n/2/X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTFDXOAAoJEMDTa8Ir7ZwVWkAP/Ry/Wikj2976AnfQXaIspxtz
biwWOHQR85rc9FuSETujkWM9aHa/uNRA70WhzYmUZiYDe07j24a6vCKkY6yWRVhf
ABg4Rj8t9P5iZfApDsh+TRaukHjq5TFz4w/TGK4mEItlX0FfAFF+qtlth0bO0sAD
v9nlHiwaQf00GfEki5dOUIWLRtApMfbeeZxaNepV05L7MC5TmW3cQGO2i53M3g14
X4GTHGYpFSS6sKgDB6p3DG439O2Acwte9Z7XYfK6qB5QH8loT/PqTqRqt9ao8UAg
uWytGRT3sfBkAMfrWStHI9IA4Thwhx5sMBZ09QDW8PM7rO0quyapJjy9lqH1/CvM
wOiEpadjH1OPZiur17e/CzttbczDM7T680y44biN6kg++GH1JzBFYaQlZfeQnw1M
trRvX48Yy3snxrqyo3F2hgRtI3JfAAd1TruHiVrG24rEatfPYLiV9BpbUNT9zeYs
0JegsVkKzLSZXbpoi25/kwXCDQ6hoE35oZ3BV6Id2J1T75ByQzddU4xKrKZ3eFs6
tFXC42aVU91qgU/WVjBXyAUzc3DRXrV7EM8H5+vxyylVX4NSKM9Qktn7WhUi+lr6
cgdntXi5syzw/f354toToMq/m4fPAslUf+CcN+QEXraMeNAVOWSZQI8ZgwgGQlld
i1qx4QAeNNUUlQ50bSjh
=FDW0
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Mar_2014_18_56_57_+1100__BRQSrsTEW_n/2/X--
