Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab3H0GPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 02:15:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60505 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3H0GPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 02:15:20 -0400
Date: Tue, 27 Aug 2013 16:15:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sourav Poddar <sourav.poddar@ti.com>
Subject: linux-next: build failure after merge of the spi tree
Message-Id: <20130827161511.47ee5028fa50811a2adf586d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Aug_2013_16_15_11_+1000_V3ADD0VYBAtYAx9h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Aug_2013_16_15_11_+1000_V3ADD0VYBAtYAx9h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

After merging the spi tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

In file included from drivers/spi/spi-ti-qspi.c:19:0:
include/linux/module.h:87:32: error: '__mod_of_device_table' aliased to und=
efined symbol 'dra7xxx_qspi_match'
 extern const struct gtype##_id __mod_##gtype##_table  \
                                ^
include/linux/module.h:145:3: note: in expansion of macro 'MODULE_GENERIC_T=
ABLE'
   MODULE_GENERIC_TABLE(type##_device,name)
   ^
drivers/spi/spi-ti-qspi.c:458:1: note: in expansion of macro 'MODULE_DEVICE=
_TABLE'
 MODULE_DEVICE_TABLE(of, dra7xxx_qspi_match);
 ^

Caused by commit 505a14954e2d ("spi/qspi: Add qspi flash controller").

Clearly not build tested as a module. :-(

I have used the spi tree from next-20130822 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__27_Aug_2013_16_15_11_+1000_V3ADD0VYBAtYAx9h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHEPzAAoJEECxmPOUX5FELAEQAJ9zwiPutAgsjcEl8FnrMFAu
4BdVB1QI1yzTMfjkGYjWlr2ZpaQLTOtLCr5PGbGu3G/ZzAkAQK62k2sW8QzqbZmu
KsSFeapqtsxwGNJGSxl+oDNs0bZink9U8EtGhOdLSbr6BPMHeZUikEyEtdryACZ7
hhAstIzjgfdJW+MuG5nGMlr5kIM68ENGMltcb0Tut7uJ9zlzchjfAvgbZeid4seb
GpMrasl0ddmvqkxy2OrZJri9//Tg3uJOsugc04ky26Wts3vseuXzH8aBY+sv/4B1
+m0pJt8jSWYhP0NYNtg7CA/IOKzvyKxk6AR8y+Ha4vP+l+hLiBcEVS1kimYMrrP/
PuVT7buE4ZzAslI+aMf/eTjAaCzp8oKhxImbzlOBWTnJOAhIGvFtIXcxkiQDhUV6
mS++R+MmJLoy9/IoUGyZVA2WW/IOP9cWHmca/8ON4TIgGehHTaQwAxysSJY3zx0k
+Hj7AlCiGZQYn07U4UbHribw61Ewhz8In5NcYDPG2G+8Vt73gWHUw0eGDPGCL/C/
V5sS0BpGbjkBq1vXKL+P9RfQyEK/jxhQa2ljthj5vsqeKsWy+HJqMSTtlMM6AUkp
mxdWsU5pjl4YwbuEzLXWgIIGm86R8aKezPTD8LbdnVCxPzZq4jjA6IDOEFr07pHV
TOA7uTyXuU92jlA3iJLh
=75bk
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Aug_2013_16_15_11_+1000_V3ADD0VYBAtYAx9h--
