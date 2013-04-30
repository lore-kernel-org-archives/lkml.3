Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933964Ab3D3Xar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 19:30:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933834Ab3D3Xaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 19:30:35 -0400
Date: Wed, 1 May 2013 09:30:19 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux RAID <linux-raid@vger.kernel.org>, Shaohua Li <shli@kernel.org>,
        Hirokazu Takahashi <taka@valinux.co.jp>,
        Jonathan Brassow <jbrassow@redhat.com>, Martin Wilck <mwilck@arcor.de>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        majianpeng <majianpeng@gmail.com>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PULL-REQUEST] md update for 3.10
Message-ID: <20130501093019.766c038a@notabene.brown>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ILWmIplvB9IPAM+SC1jCwV7"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ILWmIplvB9IPAM+SC1jCwV7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit 824282ca7d250bd7c301f221c3cd902ce906d731:

  Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream=
-linus (2013-04-22 15:00:59 -0700)

are available in the git repository at:


  git://neil.brown.name/md/ tags/md-3.10

for you to fetch changes up to 32f9f570d04461a41bdcd5c1d93b41ebc5ce182a:

  MD: ignore discard request for hard disks of hybid raid1/raid10 array (20=
13-04-30 14:49:36 +1000)

----------------------------------------------------------------
Assorted md fixes for 3.10

A mixed bad of little fixes.  No real new functionality here.
Several patches are tagged for -stable.

----------------------------------------------------------------
Akinobu Mita (1):
      md: use set_bit_le and clear_bit_le

Hirokazu Takahashi (1):
      md: raid1/raid10 md devices leak memory when stopping

Jonathan Brassow (3):
      MD: Fix typos in MD documentation
      MD: Export 'md_reap_sync_thread' function
      DM RAID: Add message/status support for changing sync action

Martin Wilck (1):
      md/raid10: Allow skipping recovery when clean arrays are assembled

NeilBrown (7):
      md: never update metadata when array is read-only.
      md: use common code for all calls to ->hot_remove_disk()
      md: HOT_DISK_REMOVE shouldn't make a read-auto device active.
      md/raid5: avoid an extra write when writing to a known-bad-block.
      md: Allow devices to be re-added to a read-only array.
      md: don't update metadata when stopping a read-only array.
      md: bad block list should default to disabled.

Shaohua Li (1):
      MD: ignore discard request for hard disks of hybid raid1/raid10 array

majianpeng (1):
      md/raid5: Change or of some order to improve efficiency.

 Documentation/device-mapper/dm-raid.txt |  84 +++++++++---
 Documentation/md.txt                    |  16 +--
 drivers/md/bitmap.c                     |   4 +-
 drivers/md/dm-raid.c                    | 111 ++++++++++++++-
 drivers/md/md.c                         | 235 +++++++++++++++++++---------=
----
 drivers/md/md.h                         |   1 +
 drivers/md/raid1.c                      |   8 +-
 drivers/md/raid10.c                     |  24 +++-
 drivers/md/raid5.c                      |  16 ++-
 9 files changed, 368 insertions(+), 131 deletions(-)

--Sig_/ILWmIplvB9IPAM+SC1jCwV7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUYBUDDnsnt1WYoG5AQJQohAAvcAdIUZR7dS1sDYlLZfzUWC+u8v8p3Qt
Db8uGAspeIWnuLzLxqHVtN9HLs5/8dfUf0YjW5lh1+oqzPDTOwML4koDq8BjRLE+
mFP4JnKKvEH/t1Fp8280cWfSlnqcKeEP3cwxNHRHhwNs5rwMI/6tpCJ/WGbTc/DZ
od3svYKvbkzGhc8+2jCfJbBIQnsyHZM1Q61Ic87IZZfzpv07FVQFA8SOaZ0BfWge
KMdVtiHYm1jbhv9Uv2Z844mSN9sVwSzyFM14740W9mobDlCYpt9HU08J2Q78QoNY
26kgJSmwZlCqQAK+ulGZs7bPXpf0XBtMW8fkGYJUXhIKTFOv0VDXgE9IoINp6Gi4
b07Olp/kCK9M8SS8SvHKORZpqPnuzdHN3HyNZ6EoFCb4xf/1dv25/UK4aNaZlst5
z9RtwHO/Vwb+VHmnndxietc0RSBNmVB8wjpkfodXT9uIGnr6y/sMtN/vNC6D8Xe/
TaauUgHRd09+LmYOSLFGWZcLzkDLd38ld0bDK5/tH77EbtZBOdeXfqYTkCm3gduD
VHWJLw/RUkXASJkUrW+aIgVnW9N7/q8YOW3O64a3RMKRWsICgHlTPSaCoJM3Tfah
LTNyS/VE+dZEjTM8JVQeDmjxm3ZB0WbLL/2LVcLBLY0ce8cAeHD2p+b2NcqkNcCx
3agbflklMlA=
=AzwP
-----END PGP SIGNATURE-----

--Sig_/ILWmIplvB9IPAM+SC1jCwV7--
