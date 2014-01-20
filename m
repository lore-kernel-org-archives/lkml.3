Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbaATTQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 14:16:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbaATTPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 14:15:50 -0500
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-f7t3E6FppXZBcPxGDAfU"
Organization: Red Hat UK Ltd
Date: Mon, 20 Jan 2014 19:15:00 +0000
Message-ID: <1390245301.2743.25.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-f7t3E6FppXZBcPxGDAfU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following patches,

Steve.
----------------------------------------------------------------

The following changes since commit 7a262d2ed9fa42fad8c4f243f8025580b58cf2f6=
:

  Merge git://git.kernel.org/pub/scm/virt/kvm/kvm (2014-01-02 14:50:18 -080=
0)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-nmw.git tags=
/gfs2-merge-window

for you to fetch changes up to d57b9c9a999a8f4475fe73fba629c964245800ca:

  GFS2: revert "GFS2: d_splice_alias() can't return error" (2014-01-18 09:5=
0:53 +0000)

----------------------------------------------------------------
The main topics this time are allocation, in the form of Bob's
improvements when searching resource groups and several updates
to quotas which should increase scalability. The quota changes
follow on from those in the last merge window, and there will
likely be further work to come in this area in due course.

There are also a few patches which help to improve efficiency
of adding entries into directories, and clean up some of that
code.

One on-disk change is included this time, which is to write some
additional information which should be useful to fsck and
also potentially for debugging.

Other than that, its just a few small random bug fixes and
clean ups.

----------------------------------------------------------------
Bob Peterson (5):
      GFS2: If requested is too large, use the largest extent in the rgrp
      GFS2: Drop inadequate rgrps from the reservation tree
      GFS2: Implement a "rgrp has no extents longer than X" scheme
      GFS2: Increase i_writecount during gfs2_setattr_chown
      GFS2: Small cleanup

J. Bruce Fields (1):
      GFS2: revert "GFS2: d_splice_alias() can't return error"

Steven Whitehouse (18):
      GFS2: Clean up releasepage
      GFS2: Remove gfs2_quota_change_host structure
      GFS2: Remove test which is always true
      GFS2: Use range based functions for rgrp sync/invalidation
      GFS2: Use only a single address space for rgrps
      GFS2: Add directory addition info structure
      GFS2: Consolidate transaction blocks calculation for dir add
      GFS2: Remember directory insert point
      GFS2: For exhash conversion, only one block is needed
      GFS2: Add hints to directory leaf blocks
      GFS2: Add initialization for address space in super block
      GFS2: No need to invalidate pages for a dio read
      GFS2: Use RCU/hlist_bl based hash for quotas
      GFS2: Only run logd and quota when mounted read/write
      GFS2: Clean up quota slot allocation
      GFS2: Move quota bitmap operations under their own lock
      GFS2: Fix kbuild test robot reported warning
      GFS2: Don't use ENOBUFS when ENOMEM is the correct error code

 fs/gfs2/aops.c                   |  23 +--
 fs/gfs2/dir.c                    |  90 +++++++++--
 fs/gfs2/dir.h                    |  19 ++-
 fs/gfs2/glock.c                  |  29 ++--
 fs/gfs2/glock.h                  |   2 +-
 fs/gfs2/glops.c                  |  26 +--
 fs/gfs2/incore.h                 |  23 ++-
 fs/gfs2/inode.c                  | 118 +++++++++-----
 fs/gfs2/lops.c                   |   5 +
 fs/gfs2/main.c                   |   1 +
 fs/gfs2/meta_io.c                |   3 +
 fs/gfs2/ops_fstype.c             |  58 ++-----
 fs/gfs2/quota.c                  | 342 +++++++++++++++++++----------------=
----
 fs/gfs2/quota.h                  |   1 +
 fs/gfs2/rgrp.c                   | 113 +++++++++----
 fs/gfs2/rgrp.h                   |   2 +-
 fs/gfs2/super.c                  |  43 ++++-
 include/uapi/linux/gfs2_ondisk.h |  11 +-
 18 files changed, 550 insertions(+), 359 deletions(-)


--=-f7t3E6FppXZBcPxGDAfU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJS3XWwAAoJEMrg3m4a/8jSu4EP/2XPrCncb2XTD5bQisiO9D5l
vFUL02oI7OZ+pf3PfQMkReNojU+DXBZ5KbFlVuFvh5mxdhyxrA0WQ0k9QIYHKU3U
41fnPN6OvbWhtbPDHLZel8r3GFue7s/t+A5He4+nNterz0kbMjN7pWzb25NtAWVY
MBj9WgrJZS2HtPpuQ8rNo3m+myFG9mb5ZCE9UsO2nDxO6sgRsGZF3T0nRyhLxsTm
ellDy5MwdSW0Xxq1ytslnwCA6FFWDygmrqlmUBUgLxBWmsXhn8b4gAWvGE0bVOeF
avEUMQE5CJ8x2fL06QZtuymKeEXX3/mmwC6uWxeYI7iVxjRy+2bkSgg27QMDZ2YZ
SoHMBonGihbAkm66lMHF3yLQd4B7X6Mqsl2YXa7bLviZHWXJumDKTCnEZjVdKApr
i5OcNSbMUDg2MHbtl3jTEHV1gsvoVxsNd4R+Sl5x03T/PSgM5YUoSd3OJ7jjnShL
YrsglRFIruGjnEwKVFPmERKudnosMlqxZzZ+ZgTEjzvqyezEKjI62GeypA4Tk7sa
N+4Ts0mxzkqoFxtkd75jGptaTm5AdXoNj3+WT0nkHo2lbhV6SVoFSU0rpBQvzi3Q
p/ZFObJxOrEGl4649K7QI3hpOFh5BuX0ny3dgE5/1O+PiVnIVl79iMTlQWW11Zxv
MhJNFMrFBw0CIv0Opcgu
=knDo
-----END PGP SIGNATURE-----

--=-f7t3E6FppXZBcPxGDAfU--

