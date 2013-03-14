Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab3CNEww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 00:52:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33602 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab3CNEwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 00:52:50 -0400
Date: Thu, 14 Mar 2013 15:52:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?IkrDtnJuIEVuZ2VsIg==?= <joern@logfs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        <josh.h.morris@us.ibm.com>, Jens Axboe <axboe@kernel.dk>
Subject: linux-next: manual merge of the bcon tree with Linus' tree
Message-Id: <20130314155241.20d10e12d78f7986e1fec66e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__14_Mar_2013_15_52_41_+1100_a_H=MtoNYqxverT1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__14_Mar_2013_15_52_41_+1100_a_H=MtoNYqxverT1
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi J=C3=B6rn,

Today's linux-next merge of the bcon tree got a conflict in
drivers/block/Kconfig between commit 8722ff8cdbfa ("block: IBM RamSan
70/80 device driver") from Linus' tree and commit a2ff9d05bbb4 ("add
blockconsole version 1.1") from the bcon tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/block/Kconfig
index 5dc0dae,06eb42f..0000000
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@@ -531,14 -544,10 +531,20 @@@ config BLK_DEV_RB
 =20
  	  If unsure, say N.
 =20
 +config BLK_DEV_RSXX
 +	tristate "RamSam PCIe Flash SSD Device Driver"
 +	depends on PCI
 +	help
 +	  Device driver for IBM's high speed PCIe SSD
 +	  storage devices: RamSan-70 and RamSan-80.
 +
 +	  To compile this driver as a module, choose M here: the
 +	  module will be called rsxx.
 +
+ config BLOCKCONSOLE
+ 	bool "Block device console logging support"
+ 	help
+ 	  This enables logging to block devices.
+ 	  See <file:Documentation/block/blockconsole.txt> for details.
+=20
  endif # BLK_DEV

--Signature=_Thu__14_Mar_2013_15_52_41_+1100_a_H=MtoNYqxverT1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRQVeZAAoJEECxmPOUX5FEGhMQAJbnNsPsSs5GSrdmGHQJcN3V
bHLYAG9XVuBd+x/OO4ZRR85GDnmTOZYwXNGPPzCSOSiU5hAAVn5sVl29H3iunaFB
so0QavddHJkBUW8fkeeSkt3RHgxLeOcZIk/sFShYYfUCurFc86D6OkbcA56yoNy0
6uUE8lsTqeo6ujKrSPeuhDF1A7ZHHqmGwcA+gVNU1n0+qAVj4jnJLBz3q+rJYOTS
zHhgAQvAwVtsBOGXQT7Qy77Oh06wTa234NPobSaSC5Fm7F7yj/D2HBHmfueFnhm0
VaYGlgMM5/SqiZiajWpyLw28wlxuE6h9jgJs1Lz3wLnBz8E85OCi0QOmXoMZGwLN
FOKlVioU4Rl0Z1JQRuwuFVSe9Qx6AbQZ1G75Z4+aPVsM3AGdC6Z0QWEC5oS6JmBz
UAeCoMmTJVbfWn21QDCY3ORJiwSpMvgdO7jIhoJNWJ299I3UtM6MGA3AMDArVKWQ
OsWpnr3xH89vaJK2l7tvwNeiK3rWYAbZe4IU8JgN7pooMr1zvtxvrVRXF4P1XgEG
fbMakVv7OAEyqQTLwnAlFekcEmTUWuA8H/4qnYtlZluI0IlR+Z+s9+XQtr31VY31
j4niYHRoOl576KFbXQbvuMP+InK8jd0HwSzZzyvhsy+Ov2zr3pWxZ5YvlhKk83zv
odH8dhBDahCRdiQ2qVJB
=lHCW
-----END PGP SIGNATURE-----

--Signature=_Thu__14_Mar_2013_15_52_41_+1100_a_H=MtoNYqxverT1--
