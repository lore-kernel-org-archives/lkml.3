Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3J1Ii0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:38:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46983 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3J1IiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:38:24 -0400
Date: Mon, 28 Oct 2013 19:38:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, Rob Herring <rob.herring@calxeda.com>
Subject: linux-next: build failure after merge of the dt-rh tree
Message-Id: <20131028193814.6d9416904eb8fac2f441c8af@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Oct_2013_19_38_14_+1100_75ecpV9NO7gk+cMv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Oct_2013_19_38_14_+1100_75ecpV9NO7gk+cMv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rob,

After merging the dt-rh tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/platforms/powernv/rng.c: In function 'rng_init_per_cpu':
arch/powerpc/platforms/powernv/rng.c:64:2: error: implicit declaration of f=
unction 'of_get_ibm_chip_id' [-Werror=3Dimplicit-function-declaration]
  chip_id =3D of_get_ibm_chip_id(dn);
  ^
arch/powerpc/platforms/powernv/rng.c: In function 'rng_create':
arch/powerpc/platforms/powernv/rng.c:85:2: error: implicit declaration of f=
unction 'of_iomap' [-Werror=3Dimplicit-function-declaration]
  rng->regs =3D of_iomap(dn, 0);
  ^
arch/powerpc/platforms/powernv/rng.c:85:12: error: assignment makes pointer=
 from integer without a cast [-Werror]
  rng->regs =3D of_iomap(dn, 0);
            ^

Caused by commit a4da0d50b2a0 ("powerpc: Implement
arch_get_random_long/int() for powernv") from the powerpc tree
interacting with commit b5b4bb3f6a11 ("of: only include prom.h on sparc")
from the dt-rh tree.

I added this merge fix patch (which will need to be sent to Linus when
these two trees get merged, or could be applied now to the powerpc tree):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 28 Oct 2013 19:34:41 +1100
Subject: [PATCH] powerpc: add include of prom.h to fix powernv/rng.c build

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/platforms/powernv/rng.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/platforms/powernv/rng.c b/arch/powerpc/platforms/=
powernv/rng.c
index 02db7d73cf8b..483b06640efb 100644
--- a/arch/powerpc/platforms/powernv/rng.c
+++ b/arch/powerpc/platforms/powernv/rng.c
@@ -11,10 +11,12 @@
=20
 #include <linux/kernel.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/slab.h>
 #include <asm/archrandom.h>
 #include <asm/io.h>
+#include <asm/prom.h>
 #include <asm/machdep.h>
=20
=20
--=20
1.8.4.rc3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__28_Oct_2013_19_38_14_+1100_75ecpV9NO7gk+cMv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSbiJ6AAoJEMDTa8Ir7ZwVpUsP/Ruhp0QFi0oNsc3o2OcrKrYb
GN/xWgAnaoyh4CChDMF2EEOcJ1ijsyVZfB2jVHJOfd/SxMEPbaQY1eE7vbNnlc8n
iTfaqUQ6kLqz6fgsg3vHQI3sDDte1IkCIcI03wjVnaJKUv8CP+f1v/KDpyAxstFy
vGYXuoEnnSUL8E8vSQuxIsAQ64YsW4gYo9t/N3SOeNS+PTiQzP0Y6GFddVMVWFJR
X7fi/0WLKNL5FoJIzhzmV9sme7MLMrp70qmFYpZS1Yyu2XQuXelj/q1DbsJm7WD4
vfPtS8ma37gWGODL0Czpy969V//1IYC5Hm6z1H5ubuLTk8p4QoOXxHgJmEFvbHhN
9EfbNZva7kn6AwiXKGf8vggTZhOoqD78vJIHGyw4bbB656RkR4I5m1KztTc08pRs
s+TpPAxObxvmvNwbcKDtCr+M2mPImtpUbmi9ROnds+/t1UTVtJ6D0jM/Xt8L2Yjr
cW93YyrCXzgsoJIK894aXcaMLoIPNKRbZn5o9ZqjnSkOHDBuH10DhhTiCDbTgL8f
SQqkQVKoqrtHRdP13iUwojwiYiF/uFvEzVphagOxEPHsoAk9kAAcTJK7mbwopKGN
1wV8E0bE1c95pxB/LeoISvGqF0/oAwcdFclN8vCyk5DOYnSg8bJRJHa9eoAUTIhj
Yd964SCk/aff2jMavBhU
=WFLG
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Oct_2013_19_38_14_+1100_75ecpV9NO7gk+cMv--
