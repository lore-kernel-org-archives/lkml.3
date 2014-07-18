Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747AbaGRFjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 01:39:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbaGRFja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 01:39:30 -0400
Date: Fri, 18 Jul 2014 15:39:19 +1000
From: NeilBrown <neilb@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <tao.peng@emc.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH] stating/lustre: fix misuse of current->parent.
Message-ID: <20140718153919.58e0164d@notabene.brown>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/JXZQuo/IDBpNtsy8VeQ13Bo"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/JXZQuo/IDBpNtsy8VeQ13Bo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



current->parent is used by ptrace to redirect some signal delivery
to the ptracer.  It should only be used by 'ptrace' or 'signal' code.
All other users should  use current->real_parent, which is the real
parent.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/st=
aging/lustre/lustre/llite/lproc_llite.c
index 77ee9e58cf87..5c5d2d6470f1 100644
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
+++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -909,7 +909,7 @@ void ll_stats_ops_tally(struct ll_sb_info *sbi, int op,=
 int count)
 		 sbi->ll_stats_track_id =3D=3D current->pid)
 		lprocfs_counter_add(sbi->ll_stats, op, count);
 	else if (sbi->ll_stats_track_type =3D=3D STATS_TRACK_PPID &&
-		 sbi->ll_stats_track_id =3D=3D current->parent->pid)
+		 sbi->ll_stats_track_id =3D=3D current->real_parent->pid)
 		lprocfs_counter_add(sbi->ll_stats, op, count);
 	else if (sbi->ll_stats_track_type =3D=3D STATS_TRACK_GID &&
 		 sbi->ll_stats_track_id =3D=3D

--Sig_/JXZQuo/IDBpNtsy8VeQ13Bo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU8izBznsnt1WYoG5AQIiqQ/+OfwkYQLgz+oigq6qZbIUtjn/vLhyZG2d
oa2i2YaZPiwTw3ZoSAj7chrLZBReMoVq/n4wNw5feApsLkkRGGqmlbwxyECoWVHV
66mSwtrCRMAfIMe2gtbb/osZjYstQt4hch3v6motUlOebWzV8lVJqkVOaVT+NkwQ
wGBUvXOc7iKvQyQ3zIF+jFZiU/6RxZAlprtkwEuqx3ClvKltnvW+KnCd2birUVqq
h1ipskpaW93ScCe+rrqamnrSk04RX+CdNe+lKDJ2Gk5mGx4/nwLH5XiQeEwgThRD
0RGu+onLP2HRId1dyDhGJ4BP+lrpl5y//eBIEBjdw0Hz9eruo5XtswVMYFLevw6v
Ym6GZeUXumC/h1EueAk/g9bNWEjgvOXY6lWgWmaOpZeYFsVKxEHrDXGWmTmle6YH
gdIKScVSJSG/TPI21G9fUKh6XHROi7RNCu1BA+SzXkfSwp66U9O7Cesuci4wBrHo
0UMGrIUCHdAQWcHumQmtxOgySrDQ0tzTFO0eJJST/fjvv9oWNosb9ugXqUiQfE5q
44Jnqt9uZSIoolMr00+pCA448DsR7ROTaD/pJaH2rDlqiIX0pyzjy/jHQYnoHZQ7
Bf8NMnP2X5Z1vb9pl1u0nZTKSyqTkSfyxePOKUVS7tF4T39+2w9gtg3WnHOsnB8Y
YZH11CPeHqo=
=FVGF
-----END PGP SIGNATURE-----

--Sig_/JXZQuo/IDBpNtsy8VeQ13Bo--
