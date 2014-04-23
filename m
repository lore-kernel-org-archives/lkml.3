Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaDWAd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 20:33:29 -0400
Received: from ozlabs.org ([103.22.144.67]:40290 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbaDWAd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 20:33:27 -0400
Date: Wed, 23 Apr 2014 10:33:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the vfs tree
Message-Id: <20140423103321.b936dc0700263bbaf617d03d@canb.auug.org.au>
In-Reply-To: <20140422112653.bff070556db8f7d28187695a@canb.auug.org.au>
References: <20140422112653.bff070556db8f7d28187695a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Apr_2014_10_33_21_+1000_hIx4cr1L1+9Mwuv5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Apr_2014_10_33_21_+1000_hIx4cr1L1+9Mwuv5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

On Tue, 22 Apr 2014 11:26:53 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the vfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> fs/nfs/direct.c: In function 'nfs_direct_read_schedule_iovec':
> fs/nfs/direct.c:382:4: error: implicit declaration of function 'vfree' [-=
Werror=3Dimplicit-function-declaration]
>     vfree(pagevec);
>     ^
>=20
> Caused by commit 2703e4cd2d57 ("new helper: iov_iter_get_pages_alloc()").
>=20
> I have used the vfs tree from next-20140417 for today.

With mixed feelings, I have added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 23 Apr 2014 10:29:35 +1000
Subject: [PATCH] vfs: using vfree requires including vmalloc.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/nfs/direct.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 775cc5031eea..9116d9a49406 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -47,6 +47,7 @@
 #include <linux/slab.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/module.h>
+#include <linux/vmalloc.h>
=20
 #include <linux/nfs_fs.h>
 #include <linux/nfs_page.h>
--=20
1.9.2

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__23_Apr_2014_10_33_21_+1000_hIx4cr1L1+9Mwuv5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTVwpVAAoJEMDTa8Ir7ZwVg7AP/1UzjYWo4ABdcel5w+aRbj5d
Tb1gQilVla+5wFiSMmcj8CjgV/uVjK5WMZueNC36zgbd12txX+nyFgkglHMMI1/D
mWMM8FjCZGwXwZsVMw1jEDg9fOUj77BiqESiO2h09WeEpbCOb8kaBQ2twLVRBYXI
DhoVzdwCLH9FE7Ac+0o9cfEmj60Wm3zMxbPHONtOt2+OAwCKI+XkafsooqyMyM7O
KKJBxN6JkCZbOWjbc59iConPxZEQuZgl+Ad99NDkFd7BhUVX9a0VvJ3w6sE8vwEb
TH3+LoGdGbzFiTObzsC9hpfB+xFTW1NYUSA3GeBym5JlummNcSBkFMhelkQ0wGAf
cE0/H244m/98UaEvWSHo2hydhpWDYpVWFlGfFo4aDQCpDBBq9uRzYP0HpcPJnEtK
ovkk6pJFYuKSm6j16eUaPD1PFh++mrme2jJyUstRqXpbdR58a+/Dnifa+oi3+EPx
ZlYAE+m4gTUtii9GDhlNObCws3FJA/A+O9/8n5yhbd4VsWhdwFapvX27+Taj7T6i
EE0u+ozUJWyBkx2bGiOLTusoNGMj6U4JUC8LkEfI4Z2Fi/vn4pyBbbqapvwYiZWh
hAT+hzeOID2g4PjpzOgNplbTRYZmb4fR18JuxmnK6saJetVVLLq9vUIo2KBzc5AV
s5IOJdxcYhJnTniNDI6W
=pGfS
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Apr_2014_10_33_21_+1000_hIx4cr1L1+9Mwuv5--
