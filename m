Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab3KHG7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 01:59:04 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58253 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab3KHG7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 01:59:02 -0500
Date: Fri, 8 Nov 2013 17:58:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the userns tree
Message-Id: <20131108175848.6ca49f0ee8fe2a6c1125394a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Nov_2013_17_58_48_+1100_zPUBli5BQXfnIU=h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Nov_2013_17_58_48_+1100_zPUBli5BQXfnIU=h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

After merging the userns tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/namei.c: In function 'covered':
fs/namei.c:3528:2: error: too many arguments to function '__lookup_mnt'
  is_covered =3D d_mountpoint(dentry) && __lookup_mnt(mnt, dentry, 1);
  ^

Caused by my incomplete merge resolution between commits 474279dc0f77
("split __lookup_mnt() in two functions") from the vfs tree and
a3b4491433f2 ("vfs: Don't allow overwriting mounts in the current mount
namespace") from the userns tree.

I added the following fix up patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 8 Nov 2013 17:56:35 +1100
Subject: [PATCH] vfs: merge fixup for __lookup_mnt() API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 83463500c582..03d999bf9a89 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3525,7 +3525,7 @@ static bool covered(struct vfsmount *mnt, struct dent=
ry *dentry)
 	bool is_covered;
=20
 	rcu_read_lock();
-	is_covered =3D d_mountpoint(dentry) && __lookup_mnt(mnt, dentry, 1);
+	is_covered =3D d_mountpoint(dentry) && __lookup_mnt(mnt, dentry);
 	rcu_read_unlock();
=20
 	return is_covered;
--=20
1.8.4.2

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__8_Nov_2013_17_58_48_+1100_zPUBli5BQXfnIU=h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSfIutAAoJEMDTa8Ir7ZwVGFcP/13tx2QByMG2bR6nGIh+qq7u
C6c2QwCIVqxdg7YV0GZ16HQWpch1G93Oo+n2iN0wkHnwC33ud726Fx84t0876kzJ
BTMbR38DU57yPZQu7uHTACc4hfYV3tDRgBxqaZdReOka4EQYC8tcY/2fPKFbjQAy
CDhxdGo3fphqCVk0AGTZhq64/1voU5h9oCiOj1L3uD60W/kyuC8rbuQ2nH2Vt5nz
qYC1ACBro9Gqr1o9y8BRv65MSwH1fxpV1U66UUG+bPYtZ1UBLtdFwpShX2bwXxla
req9DUqKppzVn+o7Eo930MCux5+TZZWGik9M37R+xOeatvfgMkaNO8cQ/Zp+6ueR
Caihk2mX77QkukCvZdEFK9UYRv5H/eg+ETM40ujYKLUwtkjc0ohEOUkx7GVP1mDg
1zBSpCKDQOPdGPnQHAd2N935PE1a+paD8TEjB82/T8r1gumpLXE471c1FytEgoq+
agct2HMtp29cnzsPSEZeKzqbYwnXR+NauX9S/TcJLbcO1g/lOyyfjEPKyJ8vQHK0
r2N2epiR3NE21tnBBrP6ejrnBKAE9ZCZuqWFtwIG5+K8+fQjwNHB2urfdSQ505Yx
MSkg+d9siyz7CGTAs+3UTcJsLBCpX3SxCA9g597acv2xfYMtPSLiONjV/Y5mAb9V
qyUBOlPfzkBpAXuw40O0
=jwaJ
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Nov_2013_17_58_48_+1100_zPUBli5BQXfnIU=h--
