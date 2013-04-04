Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763596Ab3DDGRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 02:17:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33081 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756663Ab3DDGRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 02:17:43 -0400
Date: Thu, 4 Apr 2013 17:17:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>
Subject: linux-next: manual merge of the akpm tree with the vfs tree
Message-Id: <20130404171739.4ca53305020a2422e0c00f64@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Apr_2013_17_17_39_+1100_AlzKg9dcn3CzinAu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Apr_2013_17_17_39_+1100_AlzKg9dcn3CzinAu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in fs/coredump.c
between commit d9fe6ea81efe ("lift sb_start_write() out of ->write()")
from the vfs tree and commit "coredump: sanitize the setting of
signal->group_exit_code" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/coredump.c
index 69d5141,4201338..0000000
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@@ -636,11 -641,8 +639,10 @@@ void do_coredump(siginfo_t *siginfo
  		goto close_fail;
  	if (displaced)
  		put_files_struct(displaced);
+=20
 +	file_start_write(cprm.file);
- 	retval =3D binfmt->core_dump(&cprm);
- 	if (retval)
- 		current->signal->group_exit_code |=3D 0x80;
+ 	core_dumped =3D binfmt->core_dump(&cprm);
 +	file_end_write(cprm.file);
 =20
  	if (ispipe && core_pipe_limit)
  		wait_for_dump_helpers(cprm.file);

--Signature=_Thu__4_Apr_2013_17_17_39_+1100_AlzKg9dcn3CzinAu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXRsDAAoJEECxmPOUX5FEXz0P/2eWwUU57VM0hNBheui3z5UI
vV8MjLqUFaAj5EIgp+DNgUKsHj8q7jEVb43WwW4NSwO0nNb2T6U4fHCHse/YhyoF
vOPVQkQ47KjA6523pUzqpmObQNrKio/b9uzTWz+atWVB5GP1rXVLoGGnBBARS3CS
tP6DDE5KDNJU8058ZM4qqM2vMPFdDr84eIidyHVEJfYIiQUBsrCR44T8s1dWUycD
y3cQYdHXHP1RtMZ+W2/60LU6nbfiRU9wAJxofzNnMKsj15wglPCaLKXZ930Ve+QI
YdHWEiM2jqob0BEL7TGcVaqzFzWs5FNo8jjPmH8bC5ZGR3aEMWEqTVtrSmkkjEFq
fQcheh+Sv9U8ndmtsRMJ7hpLr9IkJKypYL8+GdDYuFgIyN28Z0l42xIuHj/6UN9X
6mzmirFsRXHEfSFGuNinhJDTOzZkI3uCr7G0GcIx5L1vppvoVSkjGbcEFAZ5hkbF
hsBjwy3xVcbEIsZBNYCJlFdkHZrKQi+1B6dquMbFmhsX4yq8GES2cZbbCSsFCP+2
KMZgVMDzDahATQkA5ZgSDvDFyIXzdgsnIM4yrXYNMTJ7mcBdYGIf4vA50FtwyZj8
c/IxmtTBEmOoS3Is3KqVOuscWyJRcvlPQ+AM/Zzes+H8U/v9sLKlu1I02tVf0VbN
uahsCuqNzCReqHNUhMJJ
=D0SE
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Apr_2013_17_17_39_+1100_AlzKg9dcn3CzinAu--
