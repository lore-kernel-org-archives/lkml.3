Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaEZFGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 01:06:06 -0400
Received: from ozlabs.org ([103.22.144.67]:58466 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbaEZFGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 01:06:05 -0400
Date: Mon, 26 May 2014 15:05:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiubo Li <Li.Xiubo@freescale.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: linux-next: build failure after merge of the devicetree tree
Message-ID: <20140526150557.219ea08f@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/paX6015SxamKmsbRbJUDQ/W"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/paX6015SxamKmsbRbJUDQ/W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Grant,

After merging the devicetree tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/of/base.c: In function 'of_update_property':
drivers/of/base.c:1906:10: error: 'found' undeclared (first use in this fun=
ction)
   return found ? 0 : -ENODEV;
          ^

Caused by a bad automatic merge resolution between commits 582da6527da3
("of: make of_update_property() usable earlier in the boot process")
(merged into Linus' tree between v3.15-rc4 and rc5) and 947fdaad0627
("of: fix race between search and remove in of_update_property()") from
the devicetree tree.

I have added the following merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 26 May 2014 14:50:40 +1000
Subject: [PATCH] of: fix bad merge of drivers/of/base.c

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/of/base.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 395ee2b3146d..03e7fc6c93e8 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1901,10 +1901,6 @@ int of_update_property(struct device_node *np, struc=
t property *newprop)
 	if (!of_kset)
 		return 0;
=20
-	/* At early boot, bail out and defer setup to of_init() */
-	if (!of_kset)
-		return found ? 0 : -ENODEV;
-
 	/* Update the sysfs attribute */
 	if (oldprop)
 		sysfs_remove_bin_file(&np->kobj, &oldprop->attr);
--=20
2.0.0.rc4

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/paX6015SxamKmsbRbJUDQ/W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTgsu6AAoJEMDTa8Ir7ZwVLL0P/3C7n/9wsz3DwR1vJKuDSqPh
CN3HuVOc6srQhpfjoAYvsNXu2+qmRLjngD3qMA2ZIPVr7afjm0TqzQI36hGo7UUO
lN+sM96My5+8eHNVwAqpZqbHMrOw3JPRzFBRFk2It+i3GyxXoU6VeEXuCm1TzUem
+mzcD/WtfPjJvMt1dinrAc6pg3rT5OZWbzxNCltmM3Vyv45DNoPff+USQ33cDPnF
hQ4dO4spQHCiwecjQJdd8qZk6U0Tkw5MIykufHFCNJTRu9tdOFZ4CmP7HLuFEEKS
YevIACsUktKMmZmWBfyby6pwIdBKSbXAibvE7rs/+p1fuB8z8kyXR3HT/nZoIY6H
KyKVjM/lWjBiiZlEsHFa1TAv2rxj2KAi72IJFr3TbtrlrEgeVg8ibvuQE7U+qNY+
0qxfwE6SnYRxvXQ/dyEtqZB9DQYIkmtmMwZDk+qJgRbhDJvfJE5coCYDcyABUhHR
UD4VsIwmW6vf2tmTr57kpYzCpH22uuzkG93Jk6re29RZ4FtIuKxIVKzj4iL07Gjz
VLcn2QvHIKtaKQtxhILMBhW3iQnpO40VNT5P2zp42437u83+Cj9th91QRs8M+1fs
EoGRIOdPe5G9TqBGKZIHCbQtUoHH4H3Q0PJQL7xAXqtxF7r7dRg5tWkr1UMShLsg
pkiQ8nLVUSBgg0Ly5c2e
=xWYU
-----END PGP SIGNATURE-----

--Sig_/paX6015SxamKmsbRbJUDQ/W--
