Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab3IIJW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 05:22:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab3IIJW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 05:22:27 -0400
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2zscOioLiWCx2cSIm66K"
Organization: Red Hat UK Ltd
Date: Mon, 09 Sep 2013 10:22:28 +0100
Message-ID: <1378718548.2728.4.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2zscOioLiWCx2cSIm66K
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following changes,

Steve.
------------------------------------------------------
The following changes since commit d6a5e06cd17a3f901231e345e4acc1c3dab9fbb8=
:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes =
(2013-08-19 09:30:12 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-nmw.git tags=
/gfs2-merge-window

for you to fetch changes up to 0c9018097fe2966d80fe39e5c9ca94bb436ec369:

  GFS2: dirty inode correctly in gfs2_write_end (2013-09-05 09:04:24 +0100)

----------------------------------------------------------------
This is possibly the smallest ever set of GFS2 patches for a merge
window. Also, most of them are bug fixes this time. Two of my
three patches (moving gfs2_sync_meta and merging the two writepage
implementations) are clean ups with the third (taking the glock ref
in examine_bucket) being a fix for a difficult to hit race condition.

The removal of an unused memory barrier is a clean up from Bob Peterson,
and the "spectator" relates to a rarely used mount option. Ben
Marzinski's patch fixes a corner case where the incorrect inode
flags were being set, resulting in incorrect behaviour on fsync.

----------------------------------------------------------------
Benjamin Marzinski (1):
      GFS2: dirty inode correctly in gfs2_write_end

Bob Peterson (2):
      GFS2: Remove unnecessary memory barrier
      GFS2: Don't flag consistency error if first mounter is a spectator

Steven Whitehouse (3):
      GFS2: Move gfs2_sync_meta to lops.c
      GFS2: Take glock reference in examine_bucket()
      GFS2: Merge ordered and writeback writepage

 fs/gfs2/aops.c       | 44 +++++++++++--------------------------------
 fs/gfs2/file.c       |  4 +++-
 fs/gfs2/glock.c      | 13 +++++--------
 fs/gfs2/lops.c       | 18 ++++++++++++++++++
 fs/gfs2/meta_io.c    | 18 ------------------
 fs/gfs2/meta_io.h    | 26 +++++++++++---------------
 fs/gfs2/ops_fstype.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++=
++--
 7 files changed, 99 insertions(+), 77 deletions(-)



--=-2zscOioLiWCx2cSIm66K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJSLZNOAAoJEMrg3m4a/8jSFskP/3RrZcrGXUCY7LM1fQHPzre3
dPrWp1kTTULHfYjdj4GA3eUhQcW/8H/GJv5yJ99LGX9jfgVgsgn8Q1em6s6OF/c+
FbhfiLjvQbjnRspXxVHeVuwmIhVAchGBtl8q04uGwU0w+qyzGulsL9kefOlV8y5r
ca58H0rClLswomCsQaIcmoUzSJ51SBW1Fz4YWnREKBD9axY54E4+Zxs3lIWKN5uU
iwbgrBjyNKGffkSzsxI6v8WmBsDiDM7ep1dAKi60CqOSswHpVwKvYxFIH9PCIOaA
/wvoJB96FEgZLQ6zL3883LYRA2CAxSguJM/MONdTOj3gC9bW9HG2ZbpEpL5hAt1o
eAjXk80/ZhTEsVRuFhXxtUrewe15uaMpyhnLKoXpVgUOSe0s00jdH0YyV33YHqcR
y+FN6B/K8XxEN1/O7ECa5b/kLTfRPWGpAiq00epOcIQVnB8V4+XR6U/sgeHfAo01
ZUpoKQGiiIjZtkz4JLUC3SmB02DhuYsH9RdepdMpHDbizajJdR50uVxu4vK2UFX/
34m7I4y3OhquTs8/70NWhkJOXOuc/IQvA9LSqp+ZvxESz9uSzHEGNwN+5ktlHTT6
jgF2RdTNT05XqQKfyqff5ovTcHqRZSSZ8lf7MHsKZLNpRcqkNPGB9ud0PQgcVpTM
PN2ch3QeDjrhJHFBiS6G
=vwLj
-----END PGP SIGNATURE-----

--=-2zscOioLiWCx2cSIm66K--

