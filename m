Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab3BSQj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 11:39:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758438Ab3BSQj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 11:39:57 -0500
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ezKJShqmIJk+6B9sTAy4"
Organization: Red Hat UK Ltd
Date: Tue, 19 Feb 2013 16:38:34 +0000
Message-ID: <1361291914.2704.19.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ezKJShqmIJk+6B9sTAy4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following GFS2 patches for the merge window,

Steve.

---------------------------------------------------------------------------
This is one of the smallest collections of patches for the merge
window for some time. There are some clean ups relating to the
transaction code and the shrinker, which are mostly in preparation
for further development, but also make the code much easier to
follow in these areas.

There is a patch which allows the use of ->writepages even in the
default ordered write mode for all writebacks. This results in
sending larger i/os to the block layer, and a subsequent increase
in performance. It also reduces the number of different i/o paths
by one.

There is also a bug fix reinstating the withdraw ack system which
somehow got lost when the lock modules were merged into GFS2.

---------------------------------------------------------------------------
The following changes since commit 6abb7c25775b7fb2225ad0508236d63ca710e65f=
:

  Merge tag 'regulator-3.8-rc5' of git://git.kernel.org/pub/scm/linux/kerne=
l/git/broonie/regulator (2013-01-28 22:44:53 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-nmw.git mast=
er

Bob Peterson (1):
      GFS2: Get a block reservation before resizing a file

Steven Whitehouse (9):
      GFS2: Separate LRU scanning from shrinker
      GFS2: Merge revoke adding functions
      GFS2: Split gfs2_trans_add_bh() into two
      GFS2: Copy gfs2_trans_add_bh into new data/meta functions
      GFS2: Merge gfs2_attach_bufdata() into trans.c
      GFS2: Clean up freeze code
      GFS2: Use ->writepages for ordered writes
      GFS2: Split glock lru processing into two parts
      GFS2: Reinstate withdraw ack system

 fs/gfs2/aops.c       |   17 +++----
 fs/gfs2/bmap.c       |   30 +++++++-----
 fs/gfs2/dir.c        |   30 ++++++------
 fs/gfs2/file.c       |    4 +-
 fs/gfs2/glock.c      |  116 +++++++++++++++++++++++++++++++++-------------
 fs/gfs2/incore.h     |    8 ++--
 fs/gfs2/inode.c      |    8 ++--
 fs/gfs2/log.c        |   76 ++++++++++++++----------------
 fs/gfs2/log.h        |   12 +++++
 fs/gfs2/lops.c       |   83 +---------------------------------
 fs/gfs2/lops.h       |   14 +-----
 fs/gfs2/meta_io.c    |   35 --------------
 fs/gfs2/meta_io.h    |    3 -
 fs/gfs2/ops_fstype.c |    4 +-
 fs/gfs2/quota.c      |    4 +-
 fs/gfs2/rgrp.c       |   18 ++++----
 fs/gfs2/super.c      |   70 ++++------------------------
 fs/gfs2/super.h      |    3 -
 fs/gfs2/sys.c        |   48 ++++++++++++++------
 fs/gfs2/trans.c      |  124 +++++++++++++++++++++++++++++++++++++++++++++-=
----
 fs/gfs2/trans.h      |    3 +-
 fs/gfs2/util.c       |    3 +
 fs/gfs2/xattr.c      |   36 +++++++-------
 23 files changed, 375 insertions(+), 374 deletions(-)


--=-ezKJShqmIJk+6B9sTAy4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRI6qFAAoJEMrg3m4a/8jSWaYP/jZsga/9ts5wiyVieyRuDjV8
ncMPi+Mmne5iCWixbg3BRkkA5LQrsj3o1fPvVdx0QtwnQVHx5g9erDlsAp7PquUC
9hXjgYy27SJAM5S1GwXsPZNQQ2PLD59ErpF7FBD7e0DPOpWhI7HbuySglGNI3L+S
VZWh4RB0tcb/JwEU1Wt9lSjDoVH8mH8kgsOGJYZn9D3LCiRDIeuFTbAKnYk2BVQ/
2brKxjaoUgSufchOlTnI65a8CIPorDa60Ab9j3Xp0c+Kgk0wEfyoxwWeUfZ68zQ5
vmRUxiEyAa0PEc1yfu3KZxZfQJnO/u16PXioMSg9Q1zhK1yghAv+h/OU3vQ12/jY
88JeH1zMR2Bm7KLqOMXQnXNFdJfGQ/ADQyAYAFGr+YiQqw1gkFyxZgqEdPkrG6gF
z2/Jilwx7d6gC/1hhj5OMw/UDXFHYvPjYrcPrOGRx6ac1GSacmVEOkoxFFg6XjdH
xaAYfDL2CsZ47WCSbp2Ip/+OHA/4pza8zW/qSccrg/s6t5R6J7hvFZfx4v2wMhqW
BCQypwb55ejHOXd6mE9tZTKPoPtprlSdabJ5VumF5v3nZ5nCzWOn09khmXzJVn4C
kyHEb1iPqYQgeqIstwNqD+F7pLiwmV0/i5qS1DAcUi7D9NoiaYGD9R4ROQzLJYBR
ocsIPB/mW/14w1AG6NuZ
=OauT
-----END PGP SIGNATURE-----

--=-ezKJShqmIJk+6B9sTAy4--

