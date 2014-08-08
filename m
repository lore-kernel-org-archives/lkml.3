Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaHHGU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 02:20:28 -0400
Received: from ozlabs.org ([103.22.144.67]:53228 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbaHHGU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 02:20:27 -0400
Date: Fri, 8 Aug 2014 16:20:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: linux-next: manual merge of the akpm tree with the vfs tree
Message-ID: <20140808162018.7f009c02@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/T6gu_8HRI.5kn/SuaKclQz3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/T6gu_8HRI.5kn/SuaKclQz3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
include/linux/fs.h between commit ed44724b79d8 ("acct: switch to
__kernel_write()") from the vfs tree and commit "fs.h: remove
unnecessary extern prototypes" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/fs.h
index 94187721ad41,dccf4bcc21bb..000000000000
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@@ -2357,16 -2356,15 +2357,16 @@@ static inline void i_readcount_inc(stru
  	return;
  }
  #endif
- extern int do_pipe_flags(int *, int);
+ int do_pipe_flags(int *, int);
 =20
- extern int kernel_read(struct file *, loff_t, char *, unsigned long);
- extern ssize_t kernel_write(struct file *, const char *, size_t, loff_t);
- extern ssize_t __kernel_write(struct file *, const char *, size_t, loff_t=
 *);
- extern struct file * open_exec(const char *);
+ int kernel_read(struct file *, loff_t, char *, unsigned long);
+ ssize_t kernel_write(struct file *, const char *, size_t, loff_t);
++ssize_t __kernel_write(struct file *, const char *, size_t, loff_t *);
+ struct file * open_exec(const char *);
  =20
  /* fs/dcache.c -- generic fs support functions */
- extern int is_subdir(struct dentry *, struct dentry *);
- extern int path_is_under(struct path *, struct path *);
+ int is_subdir(struct dentry *, struct dentry *);
+ int path_is_under(struct path *, struct path *);
 =20
  #include <linux/err.h>
 =20

--Sig_/T6gu_8HRI.5kn/SuaKclQz3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT5GwnAAoJEMDTa8Ir7ZwV8JUP/1DfXMOyKdeRvzZuT9X0xmXj
GIMMvG44zWxVDaPw4TJgqYhvovSJCUUPLNhg1p1E3GcbbNIpiRfiCLToQiI0sVcK
iMaoED8Wx4QAIJFyyZvcfKcDLdoaJiZJnubQb7f+tX4vBBpmGAgwTwidYoG6HwC8
IxyqSv0XCkHSD4YOeX24gd3yXEdHK8eOFrhC4ncDg9N675onWsdAE7+6hU1Y8tDo
56TIXakCGPqtlEbz5a+N1ROmoRhhtol2i/oaM1bY3AI7vpP/iyBsQwiVRyJCRn/3
6FYXt77pB/1anEI5Zm9MJER9FzUHen8NIaSYfEprCVuxcYdJlZc9/hPYAtaQybre
Z8bD5buhzhBIcdKT8Ey3i3lBSyjMvNIZzRTJa7/eL78siooR/fYNeC02qlqczruK
06Wj7NAY9VQr1t3cqXr3Buc6r+ZVQnc0/7LVu5dWNWmyItMNwjRCRRqyPzbjnUpl
ofXgzMo6pES+ywJyJHueinuZg7PnPiKgYPjN6yxvKgQaa4wAdIOsv6cSJAemrucb
cJvMJDRzW/vyt0TWirgJeDFCg27EkVSi51R+85vy1ijD2KSjTxPnbIeuKm1oRcGT
nVGV6qgYfSsdsWW+zPYzV0B1QGhj/Q9cOQ82s5bt2gHUUmwWEERoUmKTgq8wElil
HB4Nf3lbmDWPV/6ANU/W
=PcVF
-----END PGP SIGNATURE-----

--Sig_/T6gu_8HRI.5kn/SuaKclQz3--
