Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbaE2DTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 23:19:47 -0400
Received: from ozlabs.org ([103.22.144.67]:36090 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbaE2DTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:19:46 -0400
Date: Thu, 29 May 2014 13:19:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: linux-next: manual merge of the vfs tree with Linus' tree
Message-ID: <20140529131934.21302fff@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/FyQLvGJNsmsVESocvmh87k0"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/FyQLvGJNsmsVESocvmh87k0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in fs/splice.c
between commitb6dd6f473883  ("vfs: fix vmplice_to_user()") from Linus'
tree and commit 71d8e532b154 ("start adding the tag to iov_iter") from
the vfs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/splice.c
index e246954ea48c,9dc23de0f146..000000000000
--- a/fs/splice.c
+++ b/fs/splice.c
@@@ -1546,10 -1556,9 +1556,10 @@@ static long vmsplice_to_user(struct fil
  	ret =3D rw_copy_check_uvector(READ, uiov, nr_segs,
  				    ARRAY_SIZE(iovstack), iovstack, &iov);
  	if (ret <=3D 0)
 -		return ret;
 +		goto out;
 =20
 +	count =3D ret;
- 	iov_iter_init(&iter, iov, nr_segs, count, 0);
+ 	iov_iter_init(&iter, READ, iov, nr_segs, count);
 =20
  	sd.len =3D 0;
  	sd.total_len =3D count;

--Sig_/FyQLvGJNsmsVESocvmh87k0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJThqdMAAoJEMDTa8Ir7ZwVlrAP/jPcDpNzWMhB8R31P3k7Y9jI
YOIaHL6cWzZIqLkop6SJD7PbwqLVd4LQKCHkcKSj4OX109Y0TtBZULqPYGrAVDhI
FEP8QYVCMoJQBU+/ReexXmyiXobfKkLL+whvRJVRJ48/t7DtqGpgXfNTCFOvg1Cs
UnN8IEoPINc1sogoNHHLeQeMiU2g7Zsi95is3sjeEFHMtb2nz5uO4mUqzd2yENzW
Vswf7eG7wJZGnr3qG0/Uf9rvjYaIiyh7vyB+DP5EWDvq1754WiDGwqbuvO3Ow5WL
axhvQYtpz4iMeTdhP9XJUaWZFjr2szqe8wNcKSJZmh1bJUFq+k3CZlgc/lLRQA/t
mQXpnvJYfAz6VMjg5klTK6nF6y8WljupfRFGLuPJrJXwaogVpKRWCvRuxgq5kd7y
0buV/YueF2+yQK4uX6IqM4z6mkFWvBtY2rE15176AvMlmrVk4zTq3Xg5A27H4yy/
9GKvfUHvfcVq6IqgbqBb8UkXsMzQQK0BTxcvjn+enJQfxccoySwtlLIgxD6/Oc9+
dibnkfZ+OFClQmi/CLAtdR9s3egHjojpgps/Lk6nQQnngPMT8jYpYq2rSywCsTAY
w1EV866FIaWJSreVuLx5Rcv4+NyKjhLBie6l3hiIfI7DFAM1J98UQepCKnO0Cr+G
/mAliNlPRM2Xz+N/Rd9m
=qRdl
-----END PGP SIGNATURE-----

--Sig_/FyQLvGJNsmsVESocvmh87k0--
