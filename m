Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbaDWDsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 23:48:01 -0400
Received: from ozlabs.org ([103.22.144.67]:38179 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbaDWDr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 23:47:59 -0400
Date: Wed, 23 Apr 2014 13:47:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: linux-next: build failure after merge of the wireless-next tree
Message-Id: <20140423134753.4731f16efe32ee9f20925757@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Apr_2014_13_47_53_+1000_Cne3cXYYf.OXrymN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Apr_2014_13_47_53_+1000_Cne3cXYYf.OXrymN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the wireless-next tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/net/wireless/mwifiex/pcie.c: In function 'mwifiex_pcie_fw_dump_work=
':
drivers/net/wireless/mwifiex/pcie.c:2290:3: error: implicit declaration of =
function 'vmalloc' [-Werror=3Dimplicit-function-declaration]
   entry->mem_ptr =3D vmalloc(memory_size + 1);
   ^
drivers/net/wireless/mwifiex/pcie.c:2290:18: warning: assignment makes poin=
ter from integer without a cast [enabled by default]
   entry->mem_ptr =3D vmalloc(memory_size + 1);
                  ^
drivers/net/wireless/mwifiex/pcie.c:2361:4: error: implicit declaration of =
function 'vfree' [-Werror=3Dimplicit-function-declaration]
    vfree(entry->mem_ptr);
    ^

Caused by commit e050c76fcf49 ("mwifiex: add firmware dump feature for
PCIe").

I have applied this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 23 Apr 2014 13:44:59 +1000
Subject: [PATCH] mwifiex: using vmallog requires including vmalloc.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/wireless/mwifiex/pcie.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwi=
fiex/pcie.c
index 51989b31137a..9c1f42754bbe 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -17,6 +17,7 @@
  * this warranty disclaimer.
  */
=20
+#include <linux/vmalloc.h>
 #include <linux/firmware.h>
=20
 #include "decl.h"
--=20
1.9.2

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__23_Apr_2014_13_47_53_+1000_Cne3cXYYf.OXrymN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTVzfuAAoJEMDTa8Ir7ZwVWh4P/RXkrDOqO5RvEwH1F36djonz
0d3i8mQupPI9tFQiFofSTuUk7KVgw72XvMDsIAFjBOnYAnDCDdHezCSRCEjSxqvy
bM088FmHi8yFdIxMlKsBsAufzYBFPJwZIwFOc5DylxVRCReM8dzyrSBziahW/AE6
m5Ex7R1ohMhu57MWRNCN0ouDB7ScX/mz4tKT5KU6pVyAIdNfWEvXFg1K46dscAMK
pMuEgsJDDJE8DhASuUWWiNfZ9XjGaBa9RJVQo3fwk6cayf+myVIRibZc/erqe7Zr
s/oItcKPhJQKyigLpCbME5Kr9bMp1pvymi9i89wUxxH4GMvgorh97OzuLJncyLQh
k6dRGaCpBGHM1vPetjuVH39uwlR5xVWikrf/cS8VZaOUymf92N+xWS22pKq+c9LN
MYm5kscyWE8/cQ+eXO8BPUZmYZUAXoo/aWrxPct9+etcj9H7P4Kvc0e9nLnNmSQN
xP5xk15HAC1LUQVjphPiDn19FMuDkTcmmEK4ySJ/rCuj9yLH4YjZS7CutssY8LIY
4qI1G3GGybVHQ84Dc2ZI7f6sZk5kec9C4r7PCJUt7bIaxu8e/WzA2yCQR8jtGCi+
40r9lgAMtfWQIBermLvL6f8vdTAr/zQ1h5FTt8NraXtBjGCcSg2Ns5/OxTUb9jDu
9h1A2qmzMAFxpcEArRrN
=HQkN
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Apr_2014_13_47_53_+1000_Cne3cXYYf.OXrymN--
