Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934014AbaFCXMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 19:12:22 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:47905 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaFCXMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 19:12:20 -0400
Date: Tue, 3 Jun 2014 19:12:15 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: bfields@fieldses.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull file locking changes for v3.16
Message-ID: <20140603191215.160cde5e@tlielax.poochiereds.net>
X-Mailer: Claws Mail 3.10.0 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/VAl67KA8cDcesDeWxM6AYIC"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/VAl67KA8cDcesDeWxM6AYIC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit cf01f4eef9fe367ec0d85b38dd7214e29e376cdb:

  locks: only validate the lock vs. f_mode in F_SETLK codepaths (2014-05-09=
 11:41:54 -0400)

are available in the git repository at:

  git://git.samba.org/jlayton/linux.git tags/locks-v3.16

for you to fetch changes up to 62af4f1f7df44ea0bb1a11c94ac9fb384bf1c564:

  locks: add some tracepoints in the lease handling code (2014-06-02 08:09:=
30 -0400)

----------------------------------------------------------------

File locking related changes for v3.16

Pretty quiet on the file-locking related front this cycle. Just some small
cleanups and the addition of some tracepoints in the lease handling code.

----------------------------------------------------------------
Fabian Frederick (1):
      fs/locks.c: replace seq_printf by seq_puts

Jeff Layton (2):
      locks: ensure that fl_owner is always initialized properly in flock a=
nd lease codepaths
      locks: add some tracepoints in the lease handling code

 drivers/staging/lustre/lustre/llite/file.c | 17 ++++++-----------
 fs/9p/vfs_file.c                           |  3 ---
 fs/afs/flock.c                             |  4 ----
 fs/ceph/locks.c                            | 10 ++--------
 fs/fuse/file.c                             |  1 -
 fs/locks.c                                 | 37 +++++++++++++++++++++++++-=
-----------
 fs/nfs/file.c                              |  4 ----
 include/trace/events/filelock.h            | 96 ++++++++++++++++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 129 insertions(+), 43 deletions(-)
 create mode 100644 include/trace/events/filelock.h

--Sig_/VAl67KA8cDcesDeWxM6AYIC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjlZPAAoJEAAOaEEZVoIVpZUQAKREVmI+6YGwOMInv9+yT06s
YdeV5hwiraFQqa9dpuVRdwcFbzpFq2sRxzQ88bT0pIsL9L8y6pIG/ROmUmx6pSFo
qS7PEaOAfApaM4mcI3JC+YzbdUgatq9zfraHJmwY4TCOFBK6YRsQ9458XfvkkQoc
Fo4rszP5CZlknPjEncHI8JWpUUk/1l2IL2o+ZqkgfqNk4G+/HA3mZBAaDtPE1qPW
iruSE8OMNwmIV+JwN4SXD5vFw1p4lWMqeC5wL3KxYL4/ean3Vhq7gJQ79cpu3i0d
CE15kFTLdDa4rprk5yIGNq6p/aMQxyd2IZR72mAIErx3ZuqBD3FdyziH97/tCAme
At3PTN8rWDq7RZw6lg2ZKAosG+wDYtXOLUXQ3VEX5enWq1tfoiXmtqkKD3y4280m
MTRpFeExuHBBcnUEhyalVq6HVmv9fHKAGmf9GakOlSHp1v5Hkk8g7bLudlvJOKch
seZ6AEJxuMFaQFjCdR4g/Q3Vva82RGHHtQLkG0Q3LNSLIjao7lQ4Ns3I+ObbWiTZ
MdqKCsHub5E3zfD7qYi+C8pMYFQbldEKdfhA3VrJXLJ1tA5jnspglLU88RTd2/Rt
ikvf1YK5qIqxZOg7e41OPB7AV3mTSyKMIQC6BgI+uVJV9ArZ0JJML1RtmsYrM0/v
+LSVjb+aLNHp2TyHitBc
=jnxu
-----END PGP SIGNATURE-----

--Sig_/VAl67KA8cDcesDeWxM6AYIC--
