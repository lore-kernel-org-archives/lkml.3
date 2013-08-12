Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab3HLGHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 02:07:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55862 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3HLGHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 02:07:34 -0400
Date: Mon, 12 Aug 2013 16:07:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20130812160733.b14fa70ef8ab575a3e42cd1b@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__12_Aug_2013_16_07_33_+1000_GeXUIKGfLCFwJD/D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Aug_2013_16_07_33_+1000_GeXUIKGfLCFwJD/D
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build
(x86_64 allmodconfig) failed like this:

mm/memcontrol.c: In function '__mem_cgroup_iter_next':
mm/memcontrol.c:982:4: error: 'prev_cgroup' undeclared (first use in this f=
unction)
    prev_cgroup =3D next_cgroup;
    ^
mm/memcontrol.c:982:18: error: 'next_cgroup' undeclared (first use in this =
function)
    prev_cgroup =3D next_cgroup;
                  ^

I applied this patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 12 Aug 2013 16:04:36 +1000
Subject: [PATCH] memcontrol: further merge fix patch

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 624d69e..a367145 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -979,7 +979,7 @@ skip_node:
=20
 		switch (mem_cgroup_filter(mem, root, cond)) {
 		case SKIP:
-			prev_cgroup =3D next_cgroup;
+			prev_css =3D next_css;
 			goto skip_node;
 		case SKIP_TREE:
 			if (mem =3D=3D root)
@@ -998,7 +998,7 @@ skip_node:
 			if (css_tryget(&mem->css))
 				return mem;
 			else {
-				prev_cgroup =3D next_cgroup;
+				prev_css =3D next_css;
 				goto skip_node;
 			}
 			break;
--=20
1.8.4.rc0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__12_Aug_2013_16_07_33_+1000_GeXUIKGfLCFwJD/D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSCHulAAoJEECxmPOUX5FEzT0P/jdzPYB4GsNpExn6QOFMJVXf
X/tfpQbUDPc4PZmcB+u1aYye8VRdmEh61ofeaFdNedfi3GD5B5h4caT6Vg8jmeth
PTvFvIqnrqwc1mUVR556DCvhmdoLkB67qjqoR75lsIpcsFsg61kuqn2OqCJwsfCt
zIrxRQybX37GDS2I6h0p8/KVSCOjsKR2oNFVhrwXjknGrex6s7cZno2HEOzrPjTd
t7hmrUGRQOZj1q0+TKFGOiT3Lfzt9L0c2NYaCqSA7BeZ4EeeJwp7O2VK+hAqVBuZ
v6jOqi6liPL/INmJ1OggkLeVfICMwdo/43SGB3+cS1mF5wzsibeN7HMn87GDtXrV
LJsQanxT8+DcFouKjdp7lhjBi6CmAoXn3uCq3lz0jssM2CRhFafBY6c0LR4ii+LI
+TItUMh0zqMynaFQB4RPdqC7Ccbt5XnMOU/gBRkBONASa9igzNwBhTj/aETtC9LQ
OmqvEXxNflUkludbSjDpwnY4hsXaGPxeyS0Kblm6R2rriLlP8nAOB6vraUmbXgHf
piuynxIV8qlGi0+i9hYx2epZ2j3oCAFIaQGeNaDaXweNs2wvcHffEwwm1bBhBKhL
9NbXhWqcSsg/lXj5plUzSY05PMTA8sgWyt2nycGkD2qNQKyLwq2W1KdcGyGM3V9f
uZXEJHF5jN1DmOPHP+F6
=Yj+w
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Aug_2013_16_07_33_+1000_GeXUIKGfLCFwJD/D--
