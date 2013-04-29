Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab3D2Iec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 04:34:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:32794 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab3D2Iea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 04:34:30 -0400
Date: Mon, 29 Apr 2013 18:34:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        HoSung Jung <rain6557@gmail.com>
Subject: linux-next: manual merge of the akpm tree with the vfs tree
Message-Id: <20130429183428.d420f496ba32b0aef7856fb6@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Apr_2013_18_34_28_+1000_ni4YyHDOi2fQwU3d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Apr_2013_18_34_28_+1000_ni4YyHDOi2fQwU3d
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in ipc/msgutil.c
between commit b3ecda5869da ("proc: Split the namespace stuff out into
linux/proc_ns.h") from the vfs tree and commit "ipc/msgutil.c: use
linux/uaccess.h" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc ipc/msgutil.c
index a53f38f,d43439e..0000000
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@@ -16,8 -16,8 +16,8 @@@
  #include <linux/msg.h>
  #include <linux/ipc_namespace.h>
  #include <linux/utsname.h>
 -#include <linux/proc_fs.h>
 +#include <linux/proc_ns.h>
- #include <asm/uaccess.h>
+ #include <linux/uaccess.h>
 =20
  #include "util.h"
 =20

--Signature=_Mon__29_Apr_2013_18_34_28_+1000_ni4YyHDOi2fQwU3d
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRfjCUAAoJEECxmPOUX5FEm7IQAKPDdf5FH1OrlM/APTrBwzjB
GtZ9/ut7PuZl1e0jpEevSiyNLlgtafZQwaBtAc59LYtYNmG+0NllfBxbcgAOePUx
yGwh9lJ4HkDHDOcI/5w63F1qrI8XLYmXKu9bctOflnWdEZCdOJQAP7yabzE6CoBJ
Yw1d72j4Z81D3rGZUVByFsLvYgvIXYLeshfhXF7pgy0K5FrASo0vi6rBIjLtUd1v
QWQIGadpX2nKKK4mzUsrmdkozs2RgG51Mu9yicwkAalcZSneG0hXzfryvTdM0+Ff
GNH4BycSvnp74aui31rehsRUupyhsec49eN5J1u9CNOcn/CTRv+au6E1QLZ/wAkW
lqPDQRBEn8yIRsuvZBgrIzuPbCUxJBMmI2IkTp7KJBX4Kf/XRd8cE4Sb1t6Cmszm
4ePKIuEkPOZdKY7jm3er05gv6rdTgkOcSKme4VutvDv65moqG1WSUpr3E8fIGZgK
sBmbegJ5zOt3f9ufSuO2ipT5qPp7oxTYjdwHTLZFTm5Tzi6kTQhABAN/5A3ylo6B
XIC/SZ9n4Dr2zji+MzJQMacq5iZW8IebLRwLrm7hURQNuHP5gJF14It3v/dV9Lc5
ac0rYP3ur+mxHUoMR9jBiy/T5l998Bxy/NZci4KJu317r6SHHeQByh/nKc7HeRRM
eYwgmYPCDZ1bWvwl9bEB
=ChlZ
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Apr_2013_18_34_28_+1000_ni4YyHDOi2fQwU3d--
