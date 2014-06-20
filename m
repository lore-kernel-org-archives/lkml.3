Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaFTEST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 00:18:19 -0400
Received: from ozlabs.org ([103.22.144.67]:54027 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbaFTESR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 00:18:17 -0400
Date: Fri, 20 Jun 2014 14:18:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <damm+renesas@opensource.se>
Subject: linux-next: build failure after merge of the staging tree
Message-ID: <20140620141807.45761bd0@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/_kSfxEjV.Z2hOCmiuSx.593"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_kSfxEjV.Z2hOCmiuSx.593
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the staging tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/staging/board/board.c: In function 'find_by_address':
drivers/staging/board/board.c:14:3: error: implicit declaration of function=
 'of_can_translate_address' [-Werror=3Dimplicit-function-declaration]
   if (of_can_translate_address(dn)
   ^

Caused by commit 382063d91e15 ("staging: board: Initial board staging
support").

I have disabled that driver for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 20 Jun 2014 14:14:17 +1000
Subject: [PATCH] staging: board: disable

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/board/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/board/Kconfig b/drivers/staging/board/Kconfig
index 09d94b48c9c9..7eda0b8b7aab 100644
--- a/drivers/staging/board/Kconfig
+++ b/drivers/staging/board/Kconfig
@@ -1,6 +1,7 @@
 config STAGING_BOARD
 	boolean "Staging Board Support"
 	depends on OF_ADDRESS
+	depends on BROKEN
 	help
 	  Select to enable per-board staging support code.
=20
--=20
2.0.0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/_kSfxEjV.Z2hOCmiuSx.593
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTo7YHAAoJEMDTa8Ir7ZwVxVIP/A0caCYpGBCt0fup2zoK3UJH
2cIS37W4MOUDlbHvOCcUs9zMBg1muRwimsVi0YFJoc8USUVFERJHX4q94IXwTZX8
BCCSs9BwFX7zaNYm0nuvgK36rG1syTZLiDW/uHGHaxKsmu5uE/dDs+nter4zt2Jr
ZD1Of4Th31/gmK0PtZlPDTou/DAVv305yYd4n+LjCpueQFarEH+MdO2BwAW9Wgpn
5Jj3ZQH/6hRZTluWrLU0vea0v61GvdY9Nn7eDB50YNGQZabjCejdYynSIQ+5yuII
Mcf2gRk3PG9n1A70BSQwhyj9GzL+hwLQCuMK4/0hO/tvBWs9NXW09bqg/6KZW/Lc
eBkY3TBwrlP5409LgCZA6VaubV7gfx72xIoocR/oOnZlRNquIvPro0H5m+y3GTWl
ZnWk7pUr8kSUwApzDnlwQTB7nqTGaL5GElS5mMjYP43Iju/G4aId5kcetatJ19gu
rpzmXQxRsU6bI6HMheHdMKQ+/1D5gpKRC+U00z89W34wCiDznOyBfnNmtcMQ7iOp
waGqx9doCMbzVaQ3RNSxV0yBVjl6Cpvh+x84D8i5f8UAEl6qVV/Uc787F7fwXPQ+
b2nIu4oZ6Z/Msn2OzYo0QoCHbYx4kcaONJ5D8nO1yY+brA1jer2yMwAr9TH4GYde
biMJgFcTNLIp1DdHAdUh
=bvtQ
-----END PGP SIGNATURE-----

--Sig_/_kSfxEjV.Z2hOCmiuSx.593--
