Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab3KHGuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 01:50:40 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36427 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab3KHGuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 01:50:39 -0500
Date: Fri, 8 Nov 2013 17:50:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the userns tree with the vfs tree
Message-Id: <20131108175032.3a6e3b9b5c8032242e417397@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Nov_2013_17_50_32_+1100_6svhF.vQH4hkMh.="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Nov_2013_17_50_32_+1100_6svhF.vQH4hkMh.=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the userns tree got a conflict in fs/mount.h
between commits 84550b9356af ("RCU'd vfsmounts") and 474279dc0f77 ("split
__lookup_mnt() in two functions") from the vfs tree and commit
d7e58b8abc4f ("vfs: Add a function to lazily unmount all mounts from any
dentry. v3") from the userns tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/mount.h
index d64c594be6c4,7a6a2bb3f290..000000000000
--- a/fs/mount.h
+++ b/fs/mount.h
@@@ -77,11 -78,9 +79,12 @@@ static inline int is_mounted(struct vfs
  	return !IS_ERR_OR_NULL(real_mount(mnt));
  }
 =20
 -extern struct mount *__lookup_mnt(struct vfsmount *, struct dentry *, int=
);
 +extern struct mount *__lookup_mnt(struct vfsmount *, struct dentry *);
 +extern struct mount *__lookup_mnt_last(struct vfsmount *, struct dentry *=
);
+ extern void detach_mounts(struct dentry *dentry);
 =20
 +extern bool legitimize_mnt(struct vfsmount *, unsigned);
 +
  static inline void get_mnt_ns(struct mnt_namespace *ns)
  {
  	atomic_inc(&ns->count);

--Signature=_Fri__8_Nov_2013_17_50_32_+1100_6svhF.vQH4hkMh.=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSfIm8AAoJEMDTa8Ir7ZwVWLwP/0sQ8IOb5KhUi1hANniCcpJf
GC3sEs0nghXsU6POV69lTjDjlzLo5ID0t17tCkwjyF3KXt4WWNvS9Yw0DDypbIOk
+3NWZ/lQ+xBbPH7OLT28o/hGJbHNMMFhomVkFaaxG0fKkGO5YLVvrkE7d15g/ZQF
TP7a9BFaMCLCqd156TtHXmYFV594zJ+BrSf03E1lTCkcRxacbKzzewvy0ZfD2wI2
z0auM852x7m72i6vEgpkcLgl5ZLq6Va2jd0D1J86A8o/XlTzjLR0c5XJCZAPSNCI
ROYW7xZSdrdJ75cnxq5qpcXy0qhz05lrLQvsji+FIy+Qka8onqnG7XOqCalhEL90
KpYOy1cz51wnRinN5oV1M5ESfcGBWoIMVnULzOnHo9RJ8Lt6ErnyAeguYxm2YOQE
ThAJIz2qYNy+ZIrHufXY/b1gFpbU9W11OsbArzLIQTjNNXnduTHQbdAN4KWLnlln
4icsPcyRkwa4nYm5GiQeBYjnC3UP0ml1jAj0FyjfGOprAQ6dWB1tY7W/BnIMY3o/
SM0dDEu01wng7jYtowJxnATZDO7b1B+WQuCGCyhXlr2p1nbbGoTqdLB6v5LIVpMl
RfDeknR3/bd689onKucXmUuxJGC1FUOQq8ELWq8zFn7w31Pbn+6ntQUHBicncLyP
i4FIcxL38sPn55jf8SY4
=F/p2
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Nov_2013_17_50_32_+1100_6svhF.vQH4hkMh.=--
