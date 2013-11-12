Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab3KLGUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 01:20:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab3KLGU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 01:20:29 -0500
Date: Tue, 12 Nov 2013 17:20:14 +1100
From: NeilBrown <neilb@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] add cond_resched() to shrink_dcache_for_umount_subtree()
Message-ID: <20131112172014.79f44db6@notabene.brown>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gY.uCq9/aXjS26.wUwOmZz6"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/gY.uCq9/aXjS26.wUwOmZz6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Much like the other shrink_dcache_*() functions,
shrink_dcache_for_umount_subtree() could run for a long time if the dcache
has many entries, so an occasional "cond_resched" is needed to avoid stalls
and soft-lockup warnings.

Unlike the other shrinkers, there is no cond_resched call here.  So add one.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/fs/dcache.c b/fs/dcache.c
index ae6ebb88ceff..1811fa19b419 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1154,6 +1154,7 @@ static void shrink_dcache_for_umount_subtree(struct d=
entry *dentry)
=20
 		dentry =3D list_entry(dentry->d_subdirs.next,
 				    struct dentry, d_u.d_child);
+		cond_resched()
 	}
 }
=20

--Sig_/gY.uCq9/aXjS26.wUwOmZz6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUoHInznsnt1WYoG5AQIqZw//RrESzirf9Nts3qajkkykRK8cMuvyLKI/
SNkD/MZkHZZmz7BZ+LoVJwzzhLw4cwQV8TxJgb3AyXwVYm4QMCYEKt4Ju8GlW8js
qAq18LcFTSlKjh8HrlWGz6pOsAkWQ8aPd/BEuRJONvYfZ9SRTp0ZTj9Mhx1Jo2cN
ykVKTXAwfKaAjUS6iqapiJZEJE1j5bbLLDznHY1WWW0zO0eZ24GZQlprwaWIeq+/
9R9264sDIQ6waGmJ3in8MFrWzCK7KbXm3ZMPO8DhhmNgQQKxeQMq2mWkttYeqARq
CVasDmrkaYNDL4yYX9HqwgfbZ8ECoYAFfJDeNhcL1HFFKi6VJrfuZ1VNKT+FZ2ub
R60ItwAqYx9gqfkt3sp/zgOMYOdRgReetPsjcB/x7uqdUthgzmtz8+hbWIG9BAWs
LFcJcEwyFam1VnUw6qxwkQsSlFyC4ZMScrKFIS6NEbefUFtH7RSF7/C9rIbj2ziP
401iOHqzr+Q2vkZ4KOVJvGQlFxVIz9h6/4nYPXt5TvBUt/GYQyi0S69L5zVdZXmn
lk4KTJDQoQKuOPohZAP3q+aLgqyzoMVMUrgK04euUJNe8PfsMF18NdLe+6mPe1xW
Qw8NIzkM5UUV3HY3377mAL6AwvNE9eME4F1xspJqJSnjgzGElWGk7Ce9cydsB0K4
K3Wr5OPI+n0=
=eY+Y
-----END PGP SIGNATURE-----

--Sig_/gY.uCq9/aXjS26.wUwOmZz6--
