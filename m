Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750993AbaABMl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:41:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbaABMl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:41:57 -0500
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Rs7tFd7mIt/vvfokWX7S"
Organization: Red Hat UK Ltd
Date: Thu, 02 Jan 2014 12:41:41 +0000
Message-ID: <1388666501.2746.16.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Rs7tFd7mIt/vvfokWX7S
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following bug fixes,

Steve.

-----------------------------------------------------------------

The following changes since commit 7e3528c3660a2e8602abc7858b0994d611f74bc3=
:

  slab.h: remove duplicate kmalloc declaration and fix kernel-doc warnings =
(2013-11-24 11:01:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes.git ta=
gs/gfs2-fixes

for you to fetch changes up to 0b3a2c9968d453d5827e635a6f3d69129f70af66:

  GFS2: Fix unsafe dereference in dump_holder() (2014-01-02 12:18:04 +0000)

----------------------------------------------------------------
Here is a set of small fixes for GFS2. There is a fix to drop
s_umount which is copied in from the core vfs, two patches
relate to a hard to hit "use after free" and memory leak.
Two patches related to using DIO and buffered I/O on the same
file to ensure correct operation in relation to glock state
changes. The final patch adds an RCU read lock to ensure
correct locking on an error path.

----------------------------------------------------------------
Bob Peterson (2):
      GFS2: Fix use-after-free race when calling gfs2_remove_from_ail
      GFS2: Fix slab memory leak in gfs2_bufdata

Steven Whitehouse (3):
      GFS2: don't hold s_umount over blkdev_put
      GFS2: Fix incorrect invalidation for DIO/buffered I/O
      GFS2: Wait for async DIO in glock state changes

Tetsuo Handa (1):
      GFS2: Fix unsafe dereference in dump_holder()

 fs/gfs2/aops.c       | 30 ++++++++++++++++++++++++++++++
 fs/gfs2/glock.c      |  2 ++
 fs/gfs2/glops.c      | 10 ++++++++--
 fs/gfs2/log.c        |  4 ++--
 fs/gfs2/meta_io.c    |  5 +++++
 fs/gfs2/ops_fstype.c | 12 +++++++++++-
 6 files changed, 58 insertions(+), 5 deletions(-)


--=-Rs7tFd7mIt/vvfokWX7S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJSxV5pAAoJEMrg3m4a/8jScAYP/R2qOrPsPl2kweaLBeNJBwq1
B5v0lRvAg9cNcSzNSJP8d+2cegHF0GRTxKsFZ+hNKBtBZAruSxZUoCjb76kKoANa
q1HHnsrr+9sqPHud4bwZER7U+Rjgbj6fmSEyuJVvRWGIXma1aQtpZJE2b7ceo0Bk
yMJQ2eSvMZsr/o1WIci/3g6d18YDTz+NVsH5UVb9kUqaYzdvjG8YS+kex/NzpJbx
HgJTCOu13HPJU2ssnucmyQRj/MtghXcwU2dbWP+wYRPEDhOpK2LgE5FzKcnf4nwj
NFV3mz9t5liMH2Ziq3htzoCUiArc6R4ZcNezeFhPqWrtQ6wofA5Kcgoj3q9MAx9A
ejoeKPUpHfVPomodenI4yWxByYNAALljbwyaxmZl9Lkv3/ivnCP1YyFVcDKgwgkf
LdHUQvpptZ02jCg3QU6BfYO0ZeQLNDxPtIesLExbfZQcDbc1b56/E9eN2+ptPvLM
FGSzy5b5La1rnKhavYJtlUdaEtNjhaJuh6CpJo4XBjOHmmp5Ec6/iS08VFkcYcnk
PyXl+vu5KRb6Zp7c09WFthbrDk9cUpFU+EY+8grHNSw4HO6ttuD3wF1LASW3PMh1
73OPvxIAF5axXLMRPZvAmCm71d9gK6AgsR/YweRXpC8IiGhkPcubqKdC87RacEbJ
5m7sLvzc5vI07EaBfODz
=FW7e
-----END PGP SIGNATURE-----

--=-Rs7tFd7mIt/vvfokWX7S--

