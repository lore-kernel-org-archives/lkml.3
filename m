Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab3BVDqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 22:46:53 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:34444 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab3BVDqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 22:46:51 -0500
Date: Fri, 22 Feb 2013 14:46:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <koverstreet@google.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Filipe Brandenburger <filbranden@google.com>
Subject: linux-next: manual merge of the akpm-current tree with the  tree
Message-Id: <20130222144641.1121f174dda171a07a89636b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__22_Feb_2013_14_46_41_+1100_8o7Cg1dZcQ9S=kvl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Feb_2013_14_46_41_+1100_8o7Cg1dZcQ9S=kvl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
fs/btrfs/inode.cfs/btrfs/file.c between commit 55e301fd57a6 ("Btrfs: move
fs/btrfs/ioctl.h to include/uapi/linux/btrfs.h") from the btrfs tree and
commit "aio: don't include aio.h in sched.h" from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/btrfs/file.c
index 8614c5b,39f556f..0000000
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@@ -30,7 -30,7 +30,8 @@@
  #include <linux/statfs.h>
  #include <linux/compat.h>
  #include <linux/slab.h>
 +#include <linux/btrfs.h>
+ #include <linux/aio.h>
  #include "ctree.h"
  #include "disk-io.h"
  #include "transaction.h"
diff --cc fs/btrfs/inode.c
index 40d49da,ed7ea0a..0000000
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@@ -39,8 -39,7 +39,9 @@@
  #include <linux/slab.h>
  #include <linux/ratelimit.h>
  #include <linux/mount.h>
 +#include <linux/btrfs.h>
 +#include <linux/blkdev.h>
+ #include <linux/aio.h>
  #include "compat.h"
  #include "ctree.h"
  #include "disk-io.h"

--Signature=_Fri__22_Feb_2013_14_46_41_+1100_8o7Cg1dZcQ9S=kvl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRJuohAAoJEECxmPOUX5FExvMP/2EV0Rk/wBBegvc+K+aka7aK
KrEdXA9H6WI3PVGK7PJKf2+fskKeof6QfMe5JA8BbGvJ7DVNBtWMwTjxe6vJvsOt
GMv1JyHTIvunOx0PsDeOxQzLWxMbV+nD9NHeSnR6zMc/wMoWM5+2NodCfP0MwJ11
PF/fRBayfir7sAqzfF7yrMd7Dr0/SJGQAqYMEr1PdF7fx7jgBdsbpan9mmr+Z4uU
Nd7T3jqeDm8V0QYbbyu5PzwXR6jmcmOOieBEsIkVMhNaM6bi3S9F1ouCN+rPur4K
QJXmi5nhLQLEee39b6wHRpZlC1dN58numnB4hiHVfYmk8Va5xvx+JKrt6GAGE2mW
YE7ufsVnOGFtkhQ0XbNe2sWN056YJMj2uZj3wAuXekHeG8q8eoKHgukDpPDm9qrb
MbxcrNoQ1hwQ5Av92cTFk3L6RBErr6QM0rZMCw2gYIi1IxZ9MjUHIGbFa6DAqO7b
JcA/TEKQhCSHBAT9tucDBHJuomM018J6NOwu+EAsM+/xX1axOJ+eG005XFMv8NyK
2JI2RK2LLOcsdT71YlW1JXZvUWAk1U+2nYXhEFR2MeFxUn+5NzcW3ihgSDL1Kqaa
lXzM+4LogkSJ+s0ji+BsUsIQ/yBH4Fwh6KZzINAbAaiBhv94nLsjOrXfgrJenPWX
g6KkXPTiVoWKsqWmGGLu
=NGnn
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Feb_2013_14_46_41_+1100_8o7Cg1dZcQ9S=kvl--
