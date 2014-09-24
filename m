Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbaIXCSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 22:18:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbaIXCSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 22:18:42 -0400
Date: Wed, 24 Sep 2014 12:18:05 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexander Lyakas <alex.bolshoy@gmail.com>,
        Bassow Jonathan <jbrassow@redhat.com>,
        majianpeng <majianpeng@gmail.com>
Subject: [GIT PULL REQUEST] late md/raid1 bug fixes for 3.17
Message-ID: <20140924121805.1b8c3bd9@notabene.brown>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/QljXSobAto.fu36eG_FouWA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/QljXSobAto.fu36eG_FouWA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
 it is amazing how much easier it is to find bugs when you know one is ther=
e.
Two bug reports resulted in finding 7 bugs!!

All are tagged for -stable.  Those that can't cause (rare) data corruption,
cause lockups.

Thanks,
NeilBrown


The following changes since commit d030671f3f261e528dc6e396a13f10859a74ae7c:

  Merge branch 'for-3.17-fixes' of git://git.kernel.org/pub/scm/linux/kerne=
l/git/tj/cgroup (2014-09-07 20:20:16 -0700)

are available in the git repository at:

  git://git.neil.brown.name/md/ tags/md/3.17-more-fixes

for you to fetch changes up to b8cb6b4c121e1bf1963c16ed69e7adcb1bc301cd:

  md/raid1: fix_read_error should act on all non-faulty devices. (2014-09-2=
2 11:26:01 +1000)

----------------------------------------------------------------
Bugfixes for md/raid1

particularly, but not only, fixing new "resync" code.

----------------------------------------------------------------
NeilBrown (8):
      md/raid1: intialise start_next_window for READ case to avoid hang
      md/raid1:  be more cautious where we read-balance during resync.
      md/raid1: clean up request counts properly in close_sync()
      md/raid1: make sure resync waits for conflicting writes to complete.
      md/raid1: Don't use next_resync to determine how far resync has progr=
essed
      md/raid1: update next_resync under resync_lock.
      md/raid1: count resync requests in nr_pending.
      md/raid1: fix_read_error should act on all non-faulty devices.

 drivers/md/raid1.c | 40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

--Sig_/QljXSobAto.fu36eG_FouWA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCIp3Tnsnt1WYoG5AQKbMxAAhiexXpi77Wd6U0NZh9iOp7WOMgumksuR
PIKawMoq8+TYmyjD0+OsL4bvVbyv8agRHZMm6Q0bYII7xljHW71+UijTuOayJZJJ
xDoyDJcntIuv7OZRliKbgV9Rq3JtxxQGb3s4/zV69FCJBQzdB+4ojuN6yHLORWCP
JD0YFPgGKttAOuBuOlfnp+gQAH4+bLYQLBu1SYOXsF4cklA4XzXQC0N4cQ1ORCNm
plvby+m5IoMC/hxvOyDa1TO1sVaunEH85T/dtG/6fPemELUI8N/czI2vfJhgWc0S
Sa62KBgYfNQL4KhOogEVss/J8QjlHkSIflCvozdAFRh6flddXietYzVd88WNJthQ
33zFh1NgWRGS3C0VzFJNIx4RBU5Ll/U22f8XwxGGKViwZ5MOR8RRHyJQH5gL3K/h
MSwlA5+XD5r8xYogJEhQ/ARLKCMnl/ObRCoKg00aMoOV3z3sXaw04ur6f7sg7GDW
Ad3Ge3Xns7n7/HdWfzV5wtp55XMvSmV4Tl0iBBF3BL/skBv8Au8+0+QIwCKOaVhh
aKwymo+AtaJ/gNg56puQeKbzXcb+YBZoROkG15N7e7rfsfAS2rk8ToNF69mgDX1o
jr+mToK5DFdWvimmMWJA71fwBlY1TXT1uDSCGm7I7Nlaot9yniI2hrv3j4zGkT/b
zdkEnLITOjM=
=rnmJ
-----END PGP SIGNATURE-----

--Sig_/QljXSobAto.fu36eG_FouWA--
