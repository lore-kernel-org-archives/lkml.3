Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbbASH3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 02:29:10 -0500
Received: from ozlabs.org ([103.22.144.67]:55354 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbbASH3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 02:29:03 -0500
Date: Mon, 19 Jan 2015 18:28:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20150119182853.35f278b5@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/0Q/EYCdme_LQbLdQyjLeaFw"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0Q/EYCdme_LQbLdQyjLeaFw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:


mm/filemap_xip.c:304:2: error: unknown field 'remap_pages' specified in ini=
tializer
  .remap_pages =3D generic_file_remap_pages,
  ^
mm/filemap_xip.c:304:17: error: 'generic_file_remap_pages' undeclared here =
(not in a function)
  .remap_pages =3D generic_file_remap_pages,
                 ^

Caused by commit 76f0255272b6 ("mm: drop vm_ops->remap_pages and
generic_file_remap_pages() stub").  Looks like one was missed - grep is
your friend.

I have added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 19 Jan 2015 18:16:15 +1100
Subject: [PATCH] mm: drop vm_ops->remap_pages and generic_file_remap_pages(=
) stub fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/filemap_xip.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index 0d105aeff82f..70c09da1a419 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -301,7 +301,6 @@ out:
 static const struct vm_operations_struct xip_file_vm_ops =3D {
 	.fault	=3D xip_file_fault,
 	.page_mkwrite	=3D filemap_page_mkwrite,
-	.remap_pages =3D generic_file_remap_pages,
 };
=20
 int xip_file_mmap(struct file * file, struct vm_area_struct * vma)
--=20
2.1.4

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/0Q/EYCdme_LQbLdQyjLeaFw
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUvLI7AAoJEMDTa8Ir7ZwVuckP/iEmt4hhBamuUjMNmZk2qNvl
OpAmCfxM1JxF5IPc/fbcpn/O/IXxEE/C0ku1UPwiokVwLlKTGcCi4Bff0usK985x
9jXEFGwbUwb6bbZvTuMs5v82H8L5ONxpRjQpBSqX34ltVQoDWbV9jEeZJXl2O0qf
8MSKbl+oEMFnwYDHG5rNOj7BitI9JP647mgHZOgTUJihY3DwF2tZhhqp+o75IiOZ
MAWKHzoJFOuQLdp+BW9wuGP3PGMQWZHe/ud+EQwa+pHUXduU8O+aW9FB0CCxoSdh
PVUceYAO6XenYHPTzhjgiGbdcO3YRU0UVrUbD3Es1AG85QMMzEaBJTRlcDzmFxvV
uuhsPe7NrPdg339MV2JnchHWTcutPwjD5ePkznZyQ6Q2aPn/E9jmLuBQ/HSjGZ35
fH4HLxWncWkynNJhAy7JwS+6rWFHMIWjPRgvnppja4dUgTekHoaCa85H0h2oYzGT
0qoR4K0IZmI7Ped9q0EpFS5WvXW1tzNKapTuO3RMjyclDL2/PZ7qvBBUuY4vY3JE
qjCR+TnXb2b0bsAXlR/2MYmyJLWuLJZChDphR0X/q0Uc1WttUQpuKSkvujjxbiX8
Eys7CmqiIN4sm83YlIYqgbsRjh+5gPZOVp0pYcn2bh0pAnxABgA+zIhqJFi8aosq
9D8v9UbtVccu50HPQkWm
=cHpH
-----END PGP SIGNATURE-----

--Sig_/0Q/EYCdme_LQbLdQyjLeaFw--
