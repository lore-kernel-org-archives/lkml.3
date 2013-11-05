Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab3KEPjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 10:39:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919Ab3KEPjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 10:39:22 -0500
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5AagjI9/8e5lLxgr8E9Y"
Organization: Red Hat UK Ltd
Date: Tue, 05 Nov 2013 15:39:07 +0000
Message-ID: <1383665947.2713.68.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5AagjI9/8e5lLxgr8E9Y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following changes when the merge window is open=
,

Steve.

---------------------------------------------------------------------------=
---
The following changes since commit 2147dbfd059eb7fefcfd5934f74f25f0693d4a1f=
:

  GFS2: Use generic list_lru for quota (2013-11-04 11:17:49 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-nmw.git tags=
/gfs2-merge-window

for you to fetch changes up to 2147dbfd059eb7fefcfd5934f74f25f0693d4a1f:

  GFS2: Use generic list_lru for quota (2013-11-04 11:17:49 +0000)

----------------------------------------------------------------
The main feature of interest this time is quota updates. There are
some clean ups and some patches to use the new generic lru list
code. There is still plenty of scope for some further changes in
due course - faster lookups of quota structures is very much
on the todo list. Also, a start has been made towards the more tricky
issue of using the generic lru code with glocks, but that will
have to be completed in a subsequent merge window.

The other, more minor feature, is that there have been a number of
performance patches which relate to block allocation. In particular
they will improve performance when the disk is nearly full.

----------------------------------------------------------------

Bob Peterson (5):
      GFS2: optimize rbm_from_block wrt bi_start
      GFS2: introduce bi_blocks for optimization
      GFS2: Do not reset flags on active reservations
      GFS2: Introduce rbm field bii
      GFS2: new function gfs2_rbm_incr

Miklos Szeredi (2):
      GFS2: d_splice_alias() can't return error
      GFS2: fix dentry leaks

Steven Whitehouse (12):
      GFS2: Clean up reservation removal
      GFS2: Add allocation parameters structure
      GFS2: Speed up starting point selection for block allocation
      GFS2: Move gfs2_icbit_munge into quota.c
      GFS2: Remove obsolete quota tunable
      GFS2: Make two similar quota code fragments into a function
      GFS2: Inline qd_trylock into gfs2_quota_unlock
      GFS2: Protect quota sync generation
      GFS2: Use lockref for glocks
      GFS2: Use reflink for quota data cache
      GFS2: Rename quota qd_lru_lock qd_lock
      GFS2: Use generic list_lru for quota


 fs/gfs2/aops.c          |    4=20
 fs/gfs2/bmap.c          |    7=20
 fs/gfs2/file.c          |   10 -
 fs/gfs2/glock.c         |   83 +++++-----
 fs/gfs2/glock.h         |    2=20
 fs/gfs2/glops.c         |    4=20
 fs/gfs2/incore.h        |   41 ++++-
 fs/gfs2/inode.c         |   44 +++--
 fs/gfs2/main.c          |   19 +-
 fs/gfs2/ops_fstype.c    |    2=20
 fs/gfs2/quota.c         |  371 +++++++++++++++++++++++++++----------------=
-----
 fs/gfs2/quota.h         |    9 -
 fs/gfs2/rgrp.c          |  212 +++++++++++++++++----------
 fs/gfs2/rgrp.h          |    4=20
 fs/gfs2/super.c         |    2=20
 fs/gfs2/sys.c           |    2=20
 fs/gfs2/util.c          |   20 --
 fs/gfs2/util.h          |    2=20
 fs/gfs2/xattr.c         |    3=20
 include/linux/lockref.h |    6=20
 lib/lockref.c           |    1=20
 21 files changed, 482 insertions(+), 366 deletions(-)


--=-5AagjI9/8e5lLxgr8E9Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJSeREXAAoJEMrg3m4a/8jSS5sP/2zUOCWRF1tO6V2a09AL1b6x
t1uIw2FeHd6Oucro58cDZnZfUv+o0yQ8GJQr+HSlQQHzV28OJiwElpWuCCS1Ubr7
2vWbewVkrOgLL36vI6LU3UznV0fi0MoUyTUmd0bG7oTE5XVuz2ynj3SoNzon02e/
NJFCrPriwiWhBHBUbjr7oJ8aIg2XWH4gc7aCzG6sD0hn+S7uQsyDs1E9QP7fqpaE
AyDnKKe+mDAsjDzEJ73HQ9d+s6L2XG8BDPDQJbuKvJVuhOWBp+elC/Isq4lA8XzI
+OZGBRcCgZbsjr7lqTWLW6PdyVukpr3kbyQyAZLRboEH22GiH7x5orqsQ+rRqdUo
+zMvIQKx4hqRdGqetu7HSsMK14AaNxvwHkAmG+i59yoKFJWjYLxn1jMVdJi9wcDJ
MWiuH3YqEJPsiGI/eP+L2P12TznzfBJYwOv/82jpQCW3astBjqVIaoPunlJqEsK6
QsbTRPYX+EAtnQfK1xFCR2Vql+yWzA3Uxn6szNPXnCrQjr+3k+85P0IVuFEdwV1K
R8+xW/5hXvQTwPg5fvIOELV6KCgRSMT1bLes9W6C6pYoQ7fCxZe7wXH8a6eM43QS
ijUIRXENlvZB2cPg1xLMMnJn+1zn8yXPHVlIl/HzWZ7NtA+qrNaVtQcLMhJQR3Mu
kLAjMX8uvfbzWUYSk/zW
=aawU
-----END PGP SIGNATURE-----

--=-5AagjI9/8e5lLxgr8E9Y--

