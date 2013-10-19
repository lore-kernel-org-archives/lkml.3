Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab3JSMQV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 08:16:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50250 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab3JSMQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 08:16:19 -0400
Date: Sat, 19 Oct 2013 13:15:48 +0100
From: Mark Brown <broonie@kernel.org>
To: "Eric W. Biederman" <ebiederman@twitter.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20131019121548.GX2443@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1Nu7YP1UHM0HELXm"
Content-Disposition: inline
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: linux-next: manual merge of the userns tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1Nu7YP1UHM0HELXm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Today's linux-next merge of the userns tree got a conflict in
fs/fuse/dir.c between 3c70b8eed (fuse: don't check_submounts_and_drop()
in RCU walk) in the fuse tree and 40216baa0 (vfs: Lazily remove mounts
on unlinked files and directories. v2) in the userns tree.

I fixed it up as below and can carry as required:

diff --cc fs/fuse/dir.c
index 0747f6e,b1cd7b7..0000000
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@@ -263,9 -259,7 +263,10 @@@ out
 =20
  invalid:
  	ret =3D 0;
 -	shrink_submounts_and_drop(entry);
 +
- 	if (!(flags & LOOKUP_RCU) && check_submounts_and_drop(entry) !=3D 0)
- 		ret =3D 1;
++	if (!(flags & LOOKUP_RCU))
++		shrink_submounts_and_drop(entry);
++
  	goto out;
  }
 =20

--1Nu7YP1UHM0HELXm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSYnfxAAoJELSic+t+oim9zP8P/3SpM+XFUGjS6zr7HUCpOE3D
Y55MLcmP+jYpZcHq9xFDlGvqpKBNN7W8Tz8rRaKKl7a+Y6cXoGFdPDiSDkxaOHet
INtW5d5CIryOos6711jcMrrau4ty+qrqvLUGt2W4ZLtwrpqIAGZDZPZTwvjU2PGI
KLsbqC77mqzSVIxMhzboubGwEWSZeWFGPsJhuCaR3LcWrZlQIOJJ2eJZyaU+busK
S6UIe/0+Fm9LQb41vTjkPRa9/KJCRgc/F63+jk+i+rO67krM5RC3x891YCmnENUv
4o3PmhrYHqkqP/q74bvRG03+DTJX+KSC2q2lhyFOhYo2p0idyALz6KJ4Qw+7bHuJ
hUE4ZTCrrn+sOjtM4LVCAKsgd13P52jlBKMFLXnYT72qOcBrYBpMmPtS1JGMWRAk
IKTuhfvujyz63VvhhpNnBFfAjLil9rwsno8NHLc4BegQ52Vb5BRrTwIPnfKBxD0M
rZ+o1tG6IQ2W+CozePIV/uAdzc6XI7D7104Kjp400x8y0l6A1pnFl1uESeK0ifxQ
SL3NZblB2selcMJWYWGYfdJzZ3P5DUxMXEzbI1ewsaJ/URYcYECvwQeOV1WGdN6f
+BOJ7XsbmUSt6kK3xJIOHxbIcBcMWl7wBmsIGlRri70HJ6Lub/hKWmv7nPeiwoYu
wjm/KwUvpuXJ53++M8KT
=el+p
-----END PGP SIGNATURE-----

--1Nu7YP1UHM0HELXm--
