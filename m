Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab3KSX2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 18:28:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521Ab3KSX2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 18:28:12 -0500
Date: Wed, 20 Nov 2013 10:27:55 +1100
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jianpeng Ma <majianpeng@gmail.com>,
        "Baldysiak, Pawel" <pawel.baldysiak@intel.com>,
        Shaohua Li <shli@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Bian Yu <bianyu@kedacom.com>, Joe Perches <joe@perches.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        lkml <linux-kernel@vger.kernel.org>,
        linux RAID <linux-raid@vger.kernel.org>
Subject: [PULL REQUEST] md updates for 3.13
Message-ID: <20131120102755.0f88fe92@notabene.brown>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qtnzFXKuAU_MwK/_xlYfnzz"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qtnzFXKuAU_MwK/_xlYfnzz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit 39cf275a1a18ba3c7eb9b986c5c9b35b57332798:

  Merge branch 'sched-core-for-linus' of git://git.kernel.org/pub/scm/linux=
/kernel/git/tip/tip (2013-11-12 10:20:12 +0900)

are available in the git repository at:


  git://neil.brown.name/md/ tags/md/3.13

for you to fetch changes up to 60aaf933854511630e16be4efe0f96485e132de4:

  md/raid5: Use conf->device_lock protect changing of multi-thread resource=
s. (2013-11-19 15:19:18 +1100)

----------------------------------------------------------------
md update for 3.13.

Mostly optimisations and obscure bug fixes.
 - raid5 gets less lock contention
 - raid1 gets less contention between normal-io and resync-io
   during resync.

----------------------------------------------------------------
Aurelien Jarno (1):
      UAPI: include <asm/byteorder.h> in linux/raid/md_p.h

Bian Yu (1):
      raid5: Retry R5_ReadNoMerge flag when hit a read error.

Joe Perches (1):
      md: Convert use of typedef ctl_table to struct ctl_table

NeilBrown (5):
      md: fix calculation of stacking limits on level change.
      md/raid5.c: add proper locking to error path of raid5_start_reshape.
      md: fix some places where mddev_lock return value is not checked.
      md: use MD_RECOVERY_INTR instead of kthread_should_stop in resync thr=
ead.
      md/raid5: avoid deadlock when raid5 array has unack badblocks during =
md_stop_writes.

Shaohua Li (3):
      wait: add wait_event_cmd()
      raid5: relieve lock contention in get_active_stripe()
      raid5: relieve lock contention in get_active_stripe()

majianpeng (8):
      raid5: Use slow_path to release stripe when mddev->thread is null
      raid1: Add a field array_frozen to indicate whether raid in freeze st=
ate.
      raid1: Replace raise_barrier/lower_barrier with freeze_array/unfreeze=
_array when reconfiguring the array.
      raid1: Add some macros to make code clearly.
      raid1: Rewrite the implementation of iobarrier.
      md/raid5: For stripe with R5_ReadNoMerge, we replace REQ_FLUSH with R=
EQ_NOMERGE.
      md/raid5: Before freeing old multi-thread worker, it should flush the=
m.
      md/raid5: Use conf->device_lock protect changing of multi-thread reso=
urces.

 drivers/md/md.c                | 133 +++++++------
 drivers/md/raid1.c             | 162 +++++++++++++---
 drivers/md/raid1.h             |  15 ++
 drivers/md/raid10.c            |   6 +-
 drivers/md/raid5.c             | 420 +++++++++++++++++++++++++++++++------=
----
 drivers/md/raid5.h             |  16 +-
 include/linux/wait.h           |  25 +++
 include/uapi/linux/raid/md_p.h |   1 +
 8 files changed, 592 insertions(+), 186 deletions(-)

--Sig_/qtnzFXKuAU_MwK/_xlYfnzz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUovz+znsnt1WYoG5AQLWhxAAqXKr5sqoedKZ4AuDQj/duGTtdXi3rMHO
Wk2xDdor7QME8zxPNHFDDHDNsQBxVHRU2qVM4ZyAQaD/2y5d17Imyk5z0yUjlx7c
C7Yxp1Eaf2EOcFVWdKXMWgx3+rkAUV9bpMJCctVq59VxelVqbuYyGG1DsFDhkyLN
QGcsDhuWXnn9+By4ZN8GpsEjJoiRqOL/8QlMPFFzICSD+xypXtVZXMt44YsG0FnC
pC7+icueIU0MFxmo08Od7b4/haVZiXII6+uymA7tEkBy4CSykMV383SAhACqz5nc
gcW1mTmfrlC83asqmyyyQmwv9uKVU54WI1iN29wnb0N7RIMJJ/+u43XTUdkODJvH
AkhCPGVCnSogFk0NLoreCMiiqGkL41BloQnCVDYxMp8rX7DgsqUXwaRXF8XtFyvI
qgiEcBh7gvObZ/1jvF4bnba5wJnazcdVxqlcFbHNLgOr7fh2NAPUfEdi4Gm1zefM
PVtNJjEBK3WjAle6/mNbfaEQlRH4dvgi2tGi6SYmTQVCr5JyIp2fbHp2qTdUxZHq
6CDNf1/3mlFZEhPwEt9qF9tocmrOK19SeaEGif66Kr/2ZfBXOGN7TWrD/x5fZ4KT
Ig50ehpNbfLIrBJVxYupFkZ8c5FbvYdX0u7SuS1hrBy5NYewhqnIj6l4xe7qD4w/
N3vLswM1g9g=
=Ifss
-----END PGP SIGNATURE-----

--Sig_/qtnzFXKuAU_MwK/_xlYfnzz--
