Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3IJEVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 00:21:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab3IJEVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 00:21:35 -0400
Date: Tue, 10 Sep 2013 14:21:18 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux RAID <linux-raid@vger.kernel.org>, Shaohua Li <shli@kernel.org>,
        Dave Jones <davej@fedoraproject.org>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>, Ken Steele <ken@tilera.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PULL REQUEST] md update for v3.12
Message-ID: <20130910142118.5ad5cd18@notabene.brown>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2D_C6ZYY=Z8BZt.0c8JK.fq"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/2D_C6ZYY=Z8BZt.0c8JK.fq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit d8dfad3876e4386666b759da3c833d62fb8b2267:

  Linux 3.11-rc7 (2013-08-25 17:43:22 -0700)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md/3.12

for you to fetch changes up to bfc90cb0936f5b972706625f38f72c7cb726c20a:

  raid5: only wakeup necessary threads (2013-09-02 10:31:29 +1000)

----------------------------------------------------------------
md update for v3.12

Headline item is multithreading for RAID5 so that more
IO/sec can be supported on fast (SSD) devices.
Also TILE-Gx SIMD suppor for RAID6 calculations and an
assortment of bug fixes.

----------------------------------------------------------------
Dave Jones (1):
      md: Fix apparent cut-and-paste error in super_90_validate

Ken Steele (1):
      RAID: add tilegx SIMD implementation of raid6

Max Filippov (1):
      raid6/test: replace echo -e with printf

NeilBrown (6):
      md: don't call md_allow_write in get_bitmap_file.
      md: fix safe_mode buglet.
      md: Don't test all of mddev->flags at once.
      md: avoid deadlock when dirty buffers during md_stop.
      md/raid5: use seqcount to protect access to shape in make_request.
      md/raid5: flush out all pending requests before proceeding with resha=
pe.

Shaohua Li (5):
      raid5: make release_stripe lockless
      raid5: fix stripe release order
      raid5: offload stripe handle to workqueue
      raid5: sysfs entry to control worker thread number
      raid5: only wakeup necessary threads

 drivers/md/md.c         |  54 +++++---
 drivers/md/md.h         |   8 +-
 drivers/md/raid5.c      | 362 ++++++++++++++++++++++++++++++++++++++++++++=
+---
 drivers/md/raid5.h      |  22 +++
 include/linux/raid/pq.h |   1 +
 lib/raid6/Makefile      |   6 +
 lib/raid6/algos.c       |   3 +
 lib/raid6/test/Makefile |   9 +-
 lib/raid6/tilegx.uc     |  86 ++++++++++++
 9 files changed, 510 insertions(+), 41 deletions(-)
 create mode 100644 lib/raid6/tilegx.uc

--Sig_/2D_C6ZYY=Z8BZt.0c8JK.fq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUi6ePjnsnt1WYoG5AQLY+A//S72bG7plpMaYMdf2tPmnC1+mmkfioFmq
S7rSf/BBoGjMnZqH/wwaRBJBJnq5rPhHwXoHSXDBCRBWb8c+XnJXAf38DzR4JD9i
IdW08wVHW5OTQoltXVRqeGzIlLtDsO4U+wvwiTfnVbUVU6XJ6HEbUqvMWwatTiTq
sAj/eQp774wgOR3rlcZadaSZVAduA5CwRV894LEQFIZv5XBC4EAAtKL7f4jJKjQN
nzfXj+nUYn4wawx3VHW2iJ+OFH3hLQv8fRQetTdtunGeP9Ch4aBnmuw1msXB2cf0
U+pKMImgxwdZ9SS7f+olEgun9ptrhCs35Hk9Y8eRX6T6kZnweaugv1oO9fhxnSUa
y5kv4afHBl4QKA79A7dJWwX2RAgSci4JAyrP8BzFcO1jXSoxp2RLkPknKufn4ydD
YNLTgxOouqiM8sWU92TvkyGTtHNlEaCmT/hCCZwCdcYlKaFFcwlaVamrZYPbcIuu
Ez6+AbwV+w3NKml0wBE8Wla+49u0+nubqJFv/iNLfoc36sIaFvzh6vS7qWLvEFUA
eprgdO0C4Vpkhs9I3GeJ+kQ7QERA0DbbP1DoWrn9gfy9Y9ryu2IFPW+c9D+jWjmO
VTg5/QdL/L6fAxF9L6AbTOgFgZxL71oVID9Fu2Sixs8r+xMW2vs97WZuj7PYovUb
RcddoXzbxS4=
=GNKC
-----END PGP SIGNATURE-----

--Sig_/2D_C6ZYY=Z8BZt.0c8JK.fq--
