Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaFDJdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 05:33:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbaFDJda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 05:33:30 -0400
Message-ID: <1401874402.9373.2.camel@menhir>
Subject: GFS2: Pull request (merge window)
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Date: Wed, 04 Jun 2014 10:33:22 +0100
Organization: Red Hat UK Ltd
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-FdhrKbveLeLBINEiCL+G"
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FdhrKbveLeLBINEiCL+G
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following changes,

Steve.

---------------------------------------------------------------------------=
--
The following changes since commit 6ca2a88ad820af56535ed1e6936e0490cb6ec6dc=
:

  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux=
/kernel/git/tip/tip (2014-04-16 16:40:18 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-nmw.git tags=
/gfs2-merge-window

for you to fetch changes up to 0e48e055a7dfc0cf17bbabe4d9b523ee0b1a9ed6:

  GFS2: Prevent recovery before the local journal is set (2014-06-02 19:12:=
06 +0100)

----------------------------------------------------------------
This must be about the smallest merge window patch set ever for GFS2.
It is probably also the first one without a single patch from me. That
is down to a combination of factors, and I have some things in the works
that are not quite ready yet, that I hope to put in next time around.

Returning to what is here this time... we have 3 patches which fix
various warnings. Two are bug fixes (for quotas and also a
rare recovery race condition). The final patch, from Ben Marzinski,
is an important change in the freeze code which has been in
progress for some time. This removes the need to take and drop the
transaction lock for every single transaction, when the only time it
was used, was at file system freeze time. Ben's patch integrates the
freeze operation into the journal flush code as an alternative with
lower overheads and also lands up resolving some difficult to fix races
at the same time.

----------------------------------------------------------------
Abhi Das (1):
      GFS2: quotas not being refreshed in gfs2_adjust_quota

Benjamin Marzinski (1):
      GFS2: remove transaction glock

Bob Peterson (1):
      GFS2: Prevent recovery before the local journal is set

Fabian Frederick (3):
      GFS2: lops.c: replace 0 by NULL for pointers
      GFS2: fs/gfs2/bmap.c: kernel-doc warning fixes
      GFS2: fs/gfs2/file.c: kernel-doc warning fixes

 fs/gfs2/aops.c                   |  2 +-
 fs/gfs2/bmap.c                   |  8 ++--
 fs/gfs2/file.c                   | 12 +++---
 fs/gfs2/glops.c                  | 51 ++++++++++++++--------
 fs/gfs2/glops.h                  |  2 +-
 fs/gfs2/incore.h                 | 14 ++++--
 fs/gfs2/inode.c                  | 40 ++++++++++++-----
 fs/gfs2/log.c                    | 93 +++++++++++++++++++++++++++---------=
----
 fs/gfs2/log.h                    | 11 ++++-
 fs/gfs2/lops.c                   |  2 +-
 fs/gfs2/ops_fstype.c             | 25 ++++++++---
 fs/gfs2/quota.c                  |  3 +-
 fs/gfs2/recovery.c               | 22 +++++-----
 fs/gfs2/rgrp.c                   |  2 +-
 fs/gfs2/super.c                  | 69 ++++++++++++++++++-----------
 fs/gfs2/sys.c                    |  7 ++-
 fs/gfs2/trans.c                  | 44 +++----------------
 include/uapi/linux/gfs2_ondisk.h |  2 +-
 18 files changed, 246 insertions(+), 163 deletions(-)


--=-FdhrKbveLeLBINEiCL+G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTjufnAAoJEMrg3m4a/8jSh4MP/1WuMoN25uwH32CW3/CtXpM4
Wh4HpKe1ualY/fwRPfXEcX2+mJf0i2sgqfHPSE6GtiIvStJvLAwnzjP8OK8FqUn7
ldv2R3sZTzzfOk0OERu3cLFupQCJpm2agrU6ENV1xM4DyU2khbbA9A3pQJJUivXk
BPfi0GToMM04ZcaRJoxr2fau7r9CZXWuDLF0chXDMe+c+Hd3AA18rwymvpFJ+9jx
gX8hwNVStN21vAHzPSgXh/zh0WYmqtpC8Ynkjg14UaLlejF76kH/qCvo6oO4acuU
Wklg49SXtMwpDXKtf6p5JMZuVBIhl9TrfborLn2zh1/b4o3VeDOAaUrUA/IxH/0B
qR3ybpPwpSFDUm5baedgyKeEN7lv65lG/5xiwlys4B7+fO1w/yzfHFawaSEB1VC2
duQeT0P/zF6WwcerddmaTiyQ3EbplGAA6JUKIzkZ5TbWy42krJs0mZmC9jT6CmKW
n9w81T6r9m9v5bqQUT4DEn9fxyMDF3cMpriwOeGZO51jG4OIdcenytc+1s81sxTM
7r0vcTDUURawGqen7mLU50gGMRimLK1nsMfqRZzKoUGnTSgssyZfCoAivoPWlx28
CUig8mNi+EsgMXCkX3/8mXkfYWLzgGB9yOZ3gweWydyDSUJVxj2X30z2AU5Yk1dH
eaap4NhisvNG8XIX/7G8
=3Ifv
-----END PGP SIGNATURE-----

--=-FdhrKbveLeLBINEiCL+G--

