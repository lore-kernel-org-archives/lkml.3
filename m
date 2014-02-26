Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaBZIEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 03:04:43 -0500
Received: from ozlabs.org ([203.10.76.45]:60535 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaBZIEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 03:04:41 -0500
Date: Wed, 26 Feb 2014 19:04:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20140226190436.53e6cf83e03ef4261577b94c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Feb_2014_19_04_36_+1100_g4iRjQyie.e.FZ4a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Feb_2014_19_04_36_+1100_g4iRjQyie.e.FZ4a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (x86_64
allmodconfig) failed like this:

fs/notify/fanotify/fanotify_user.c: In function 'SYSC_fanotify_init':
fs/notify/fanotify/fanotify_user.c:707:8: error: 'struct fanotify_event_inf=
o' has no member named 'response'
  oevent->response =3D 0;
        ^

Caused by my bad conflict resolution.  I added the following merge fix
patch (but I am not too sure of it).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 26 Feb 2014 19:01:03 +1100
Subject: [PATCH] fanotify: fix for bad merge resolution

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/notify/fanotify/fanotify_user.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanoti=
fy_user.c
index 0edc47f7dfae..0d378a8cd279 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -704,7 +704,6 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, uns=
igned int, event_f_flags)
=20
 	group->fanotify_data.f_flags =3D event_f_flags;
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
-	oevent->response =3D 0;
 	spin_lock_init(&group->fanotify_data.access_lock);
 	init_waitqueue_head(&group->fanotify_data.access_waitq);
 	INIT_LIST_HEAD(&group->fanotify_data.access_list);
--=20
1.9.0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__26_Feb_2014_19_04_36_+1100_g4iRjQyie.e.FZ4a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDaAYAAoJEMDTa8Ir7ZwVg/IP/iZJy+Th3fdVvfYsRaUH5tVP
TwAOsVRXhlO5f/PD/ac6bcHygzju4xqZWxbe/e6aj+zcrmB2NwEX0ndHQMSKOWfU
GKcLt00FGwZlP05tBmJA+OmVHlnNfk++l4UXk1f/twStDeFGaacgju/hPlAVOM3+
NQncRd/OQTO+Spc0LqjzoOzb2w5uZqU+b40JmeoYbChUkgVctlLyUeNPqurOVZ/m
wZwSo+UJTWIyxmwSlPwkolSbcQEdRH9gASLLSZ+ZvLwIiC9xWg990f/I1iKsTRRu
qhy4oIb58LBT47uJSSISnKHnBiyx7wm1FTZQfS3KE4aT5e86o5KbbhQTqYVwyclC
P3dvdHB8KDPBjhaoVjEKc7XthxZbsRjWGBheBuGG5sQ+VH8HxffvGDb8XRweR+Tk
VdfKN4bbS/2oPDXu4ouoA7e0qP7181F2oVUJ5eqvYJ+TvoBJ9q85We0KeJJC6Yhl
DmCvHqDwlSwF0Bo67zOvpkOOdUJi9mw+bcl2Fi0bFx9FEFptUnY+UnVz0IvMUfYo
CQJQw7G60Z8+xmh6IYNpK7fIkEHCIl27Lpy+BxG4IgLPc7fdgM1nz7HbW4jFyAxv
gS7HxwgTExKqlN6g3Iua8DkgJJquW6ONQ/40+GU7udjNb76tpL1/1R3+KH7kuB/H
MCvIdJQ7koKxNR9FYRSM
=KRCq
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Feb_2014_19_04_36_+1100_g4iRjQyie.e.FZ4a--
