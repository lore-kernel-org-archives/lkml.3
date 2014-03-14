Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbaCNRGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:06:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53432 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbaCNRGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:06:47 -0400
Date: Fri, 14 Mar 2014 17:06:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jeff Layton <jlayton@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140314170637.6370787172f6b7a78a5c2812@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__14_Mar_2014_17_06_37_+0000_F0NUV4c0Re.Mjfyy"
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: manual merge of the compat tree with the
 file-private-locks tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Mar_2014_17_06_37_+0000_F0NUV4c0Re.Mjfyy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Heiko,

Today's linux-next merge of the compat tree got a conflict in fs/compat.c b=
etween commit 1ed1950c412f1b ("locks: add new fcntl cmd values for handling=
 file private locks") from the file-private-locks tree and commit 932602e23=
8329 ("fs/compat: convert to COMPAT_SYSCALL_DEFINE with changing parameter =
types") from the compat tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

diff --cc fs/compat.c
index 800914a1092a,19252b97f0cc..000000000000
--- a/fs/compat.c
+++ b/fs/compat.c
@@@ -399,23 -399,8 +399,23 @@@ static int put_compat_flock64(struct fl
  }
  #endif
 =20
 +static unsigned int
 +convert_fcntl_cmd(unsigned int cmd)
 +{
 +      switch (cmd) {
 +      case F_GETLK64:
 +              return F_GETLK;
 +      case F_SETLK64:
 +              return F_SETLK;
 +      case F_SETLKW64:
 +              return F_SETLKW;
 +      }
 +
 +      return cmd;
 +}
 +
- asmlinkage long compat_sys_fcntl64(unsigned int fd, unsigned int cmd,
-               unsigned long arg)
+ COMPAT_SYSCALL_DEFINE3(fcntl64, unsigned int, fd, unsigned int, cmd,
+                      compat_ulong_t, arg)
  {
        mm_segment_t old_fs;
        struct flock f;


--Signature=_Fri__14_Mar_2014_17_06_37_+0000_F0NUV4c0Re.Mjfyy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTIzceAAoJELSic+t+oim9OTsP/28a7Q3x6cbg/lahfUftUXeD
isd0o5aPRZYFzPACDj2Ye8OTJRuTcPfEcN5wXzokWMZQUlANpmDBhK/7HS4zh/Tm
1iHEpZYForriKkhAzLy/QX1X1WX0rO7L3NTploGsRLI9L5rNiUCmOoL/H2f4GUcD
BHpaCw4lm1pBMBYCXakOn24TbgBvWlPoopSghDiNdLLaV2JpNLzELNMWMG7uNTNv
JxRVAk+BljQNUXIA/wwHiNZGd10JX2OymSMEaJa3fO7GKpUaUfWTwFl/wBkvwnej
KrfAKa8I5HfHXbNSLQ7Nu3r+Aypxpah+ZD1YAdd0dB1j0yX9MOBDX0HVIbK7bap8
l09PzxtNeo52nuCGP2Gv6/6l09R6oEBBHMbDtIEdGfWNJIw5SVwlzz7tVoN/S2AO
7deqCQyzC0KENp/M2d8mmWRDLXS7j4nXhX2AYT/0G5T8hbsQe1R2jPudzg9ZzUG9
q5BiURoCQXvUrpJ7o2W7X48owztKvfwhcw/oqfqJUnQhJAGEwU9bebaTP8I+sZCd
/Lm6j/eetKzeh2MFdX+ryRcipT3geiHSXceN3jh6tNM7mbu/QJQFkEjfHbx/+ZIx
b2uklta7D26AktV4ztiR0s1ZVQdO3BXkA2ZaYmJGzz1jmBH6e/GQ58voq+3otZ0/
1pMWz0N/31in1emkRALQ
=CyIz
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Mar_2014_17_06_37_+0000_F0NUV4c0Re.Mjfyy--
