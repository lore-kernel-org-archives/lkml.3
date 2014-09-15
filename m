Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaIOHFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 03:05:01 -0400
Received: from ozlabs.org ([103.22.144.67]:48018 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbaIOHFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 03:05:00 -0400
Date: Mon, 15 Sep 2014 17:04:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: linux-next: build failure after merge of the nfs tree
Message-ID: <20140915170453.0e8d4e85@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/IbQG_eWMVj=qp7ZVnuefNoH"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/IbQG_eWMVj=qp7ZVnuefNoH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Trond,

After merging the nfs tree, today's linux-next build (powerpc
allyesconfig) failed like this:

fs/nfs/blocklayout/extent_tree.c: In function 'ext_tree_prepare_commit':
fs/nfs/blocklayout/extent_tree.c:540:3: error: implicit declaration of func=
tion '__vmalloc' [-Werror=3Dimplicit-function-declaration]
   start_p =3D __vmalloc(buffer_size, GFP_NOFS, PAGE_KERNEL);
   ^
fs/nfs/blocklayout/extent_tree.c:540:11: warning: assignment makes pointer =
from integer without a cast
   start_p =3D __vmalloc(buffer_size, GFP_NOFS, PAGE_KERNEL);
           ^

Caused by commit 34dc93c2fc04 ("pnfs/blocklayout: allocate separate
pages for the layoutcommit payload").

I added the following fix patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 15 Sep 2014 17:01:32 +1000
Subject: [PATCH] pnfs/blocklayout: include vmalloc.h for __vmalloc

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/nfs/blocklayout/extent_tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/blocklayout/extent_tree.c b/fs/nfs/blocklayout/extent_t=
ree.c
index 93193616205a..31d0b5e53dfd 100644
--- a/fs/nfs/blocklayout/extent_tree.c
+++ b/fs/nfs/blocklayout/extent_tree.c
@@ -2,6 +2,8 @@
  * Copyright (c) 2014 Christoph Hellwig.
  */
=20
+#include <linux/vmalloc.h>
+
 #include "blocklayout.h"
=20
 #define NFSDBG_FACILITY		NFSDBG_PNFS_LD
--=20
2.1.0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/IbQG_eWMVj=qp7ZVnuefNoH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUFo+aAAoJEMDTa8Ir7ZwVNuwP/3CeGubkoEz5GDCSeM3WVcPi
DzPJ+K3uKahjiUx/CK05UCivIWIi728IA7lyDZb72IvO7LyiwHCSE38RIpkub4Uf
KKi+rL7loEFLSXN6OPtWmYg+zwZ857khoiF0sGedjVPrE9pv8eGH5IfFwc5jwWZR
n18F5Tf3ozFgksuPZnxw4U7hnc5DRLoz5aOqwigHTU+MAotXTNJA+SDumRG+TOBW
7m/fAZxa+nCdUDP2GPxUy7Mp3NAWtFVaOIyaqpzvENqf7OXSZIu7gZLDUQGP9pvJ
hNYjHX6H1LlH7ziBHZ2O0jI9gsP9BTzLIIPmyJhMXlrP+x+HQpUkP/+Wi8/ZdLpy
/FCAmlOWLfcPKf+dzEtWRmb8yPC+H12Ddk0hmAc5UvN6JtYzaFgzsD0gT9ajRL1G
SW2lax/49xtZg2B4003bTLW7qovCNB/dQy4jrHY+iCRjAPLtlponCRBAAxQDwUKi
u/rfurSGau4gvjCNTaHhtgCAiPIQzMWUrg/tZAIV4mWHGc0L5zdCa0YCrljkqHrE
Y7ma0cZ3fnKZwMMo9sL53+Aas4h6G8WZzsZkWSFCrAFBPhJkkVjVRyd98k1I1ntB
EzSMAgHQC2Hby8qXzB2twoBNc1oHIr1qJcHudbd4cGlXFceGpP2kAzbYolUtMXtE
ChkVNrIiuXKtejL6tSf8
=KyuS
-----END PGP SIGNATURE-----

--Sig_/IbQG_eWMVj=qp7ZVnuefNoH--
