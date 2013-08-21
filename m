Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab3HUIBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:01:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47133 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab3HUIBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:01:44 -0400
Date: Wed, 21 Aug 2013 18:01:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>,
        Christoph Jaeger <christophjaeger@linux.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: linux-next: manual merge of the akpm-current tree with the modules
 tree
Message-Id: <20130821180137.c3b4d9240ce859e9e8f8ede9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Aug_2013_18_01_37_+1000_ReMJgBQfHkV6Uz.a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Aug_2013_18_01_37_+1000_ReMJgBQfHkV6Uz.a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
kernel/params.c between commit 79ac6834c255 ("module: fix sprintf format
specifier in param_get_byte()") from the modules tree and commit
55bba1b7fcce ("kernel: replace strict_strto*() with kstrto*()") from the
akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/params.c
index e5f8f17,1f228a3..0000000
--- a/kernel/params.c
+++ b/kernel/params.c
@@@ -253,13 -252,13 +253,13 @@@ int parse_args(const char *doing
  	EXPORT_SYMBOL(param_ops_##name)
 =20
 =20
- STANDARD_PARAM_DEF(byte, unsigned char, "%hhu", unsigned long, strict_str=
toul);
- STANDARD_PARAM_DEF(short, short, "%hi", long, strict_strtol);
- STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, strict_s=
trtoul);
- STANDARD_PARAM_DEF(int, int, "%i", long, strict_strtol);
- STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, strict_strtou=
l);
- STANDARD_PARAM_DEF(long, long, "%li", long, strict_strtol);
- STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, strict_str=
toul);
 -STANDARD_PARAM_DEF(byte, unsigned char, "%c", unsigned long, kstrtoul);
++STANDARD_PARAM_DEF(byte, unsigned char, "%hhu", unsigned long, kstrtoul);
+ STANDARD_PARAM_DEF(short, short, "%hi", long, kstrtol);
+ STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, kstrtoul=
);
+ STANDARD_PARAM_DEF(int, int, "%i", long, kstrtol);
+ STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, kstrtoul);
+ STANDARD_PARAM_DEF(long, long, "%li", long, kstrtol);
+ STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, kstrtoul);
 =20
  int param_set_charp(const char *val, const struct kernel_param *kp)
  {

--Signature=_Wed__21_Aug_2013_18_01_37_+1000_ReMJgBQfHkV6Uz.a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSFHPhAAoJEECxmPOUX5FE/tYQAKOnT1Qsp/flyhDzL+n+UMcQ
OuTFugz8Wy+F1RiDP7JPRy/Bs783ut0RC+YM6p0UIYEs8JA4OX+IrBB9KvlMWEvK
ovZ4sTwjqg18x0MXOmWkWPbK9yVZlJ6H+02SsHriM19nESHFzpTnPJiHO8U8fW+8
8XCEkZ3zhhWJjhp1x7GDIlgZdbuh+BC9b7g8JkJwMyFnBKtTgd0rKRFQBnGv4+uT
4yHZEjlckNLHMYh/8Acsb1909PDqlxoFRvY1swy8ANs0JKwIfYbDH7eoIJ+7ZJ++
TDSohG6w/j+QK2aVb6coGi9wfvOagJdkG9p8SwP62rFsrFbBEpPvPuFa3XFQ5v/2
ndI+liZ0sIBsWHQidvoP8UGFvn/68RqloRIZTyRiRMR61km6476C2i/Jj3ep1htv
Q4Ij7vJQeBwlkRhd37bHB2XeHQU2WQ2gF25s8oa9kReoDGqhWYLIV6nHq/hKOqA5
a5BTvve/HBsbfQy5eGY8G/tI7r273+kLEV9EnzbR2CTjLzVwji0SdXG/VVY9O1sh
H0uMlYWTFxNgOQb1hvI1KNco7bk/fI/I4t8Y5myoNGNjyVoHctZP1vPl9YuMVa5k
+j9V2UIxxTZeeSnWG1cKKUHY/3Eb4tzfoBH7FPVu231oXBoMwKpu7+HqEM3RXZmv
KpJAM+VpgeyT/vDIXiud
=RB9h
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Aug_2013_18_01_37_+1000_ReMJgBQfHkV6Uz.a--
