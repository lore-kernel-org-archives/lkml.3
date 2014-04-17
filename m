Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbaDQHMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 03:12:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59229 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaDQHMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 03:12:17 -0400
Date: Thu, 17 Apr 2014 17:12:06 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Shaohua Li <shli@kernel.org>, Fengguang Wu <fengguang.wu@intel.com>,
        linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL REQUEST] one md BUG-fix for 3.15-rc
Message-ID: <20140417171206.4518ce1d@notabene.brown>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zQuCShl/8bIbouHL1a8/VU9"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zQuCShl/8bIbouHL1a8/VU9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit e240c1839d11152b0355442f8ac6d2d2d921be36:

  raid5: get_active_stripe avoids device_lock (2014-04-09 14:42:42 +1000)

are available in the git repository at:

  git://neil.brown.name/md tags/3.15-fixes

for you to fetch changes up to c7a6d35e463caacab08ca0333bdec5b8bdce8bbb:

  raid5: fix a race of stripe count check (2014-04-17 17:05:28 +1000)

----------------------------------------------------------------
One BUG fix for md for recent commit

----------------------------------------------------------------
Shaohua Li (1):
      raid5: fix a race of stripe count check

 drivers/md/raid5.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 25247a852912..ad1b9bea446e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4370,8 +4370,7 @@ static struct stripe_head *__get_priority_stripe(stru=
ct r5conf *conf, int group)
 		sh->group =3D NULL;
 	}
 	list_del_init(&sh->lru);
-	atomic_inc(&sh->count);
-	BUG_ON(atomic_read(&sh->count) !=3D 1);
+	BUG_ON(atomic_inc_return(&sh->count) !=3D 1);
 	return sh;
 }
=20

--Sig_/zQuCShl/8bIbouHL1a8/VU9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU09+xjnsnt1WYoG5AQJbIQ//XMqRGAgxP5AL7QW5A58Oa9sqvlN4snpe
T3i16tl6STTQ/PVzkDhtDFn21h65SBjhrVREqBjSZRcAtrZicU0z4OB8cchFEtci
772fNRb2aLfuiVql4SE2yiDB/k47MfhUG9ZHzv7AVJQF2CZ2jHudGM7kZcbZP/Mf
LJwQ37JkMdoTRbGl4ChZnZK3OPXZH+UaoVAWXXattcii2zjmGApkGilpjugZzSRP
A8ns6pJFUxD1FuSeTW9C8HdztH5WUageLFn3/9ECorlfO3/40+Rc9PT4e2LUJq3h
HkNIYuUhiD4lSTjrCAHNPNazfdqT5/bwv4JAjZ1+khsCH05UhE2BTtWbLql4xt1q
IeRbmDCEFddRW8vnxbP5F+RevxECXhAasDH8ciDkP06w6yXj4pB796s7QjUi0CHh
RlS7E09u82U79uXTNKecjOpjyTsRb6bngpMOyqxdDR3QatoCH5a3MM1w3Q+5nNyc
1kxWTXi5HwHAqym/PTEMKNfEAErZvpaC2loCP3tbRLeNDCNB7SMcIyG2un1M6y2V
g5Cz5GsCAhoJyY9MUgpBXJy94AODTyb8dg6il4QbZLCmPNrCWfuGIXjAmkeAzTpE
RPKKXyE2JtO0k7nzNHZ6kjWYCrDDKau8/a95cOtiq9eXbe0QvXi7ihFaxrGC8PvD
bgA2ZAdsTos=
=0qsC
-----END PGP SIGNATURE-----

--Sig_/zQuCShl/8bIbouHL1a8/VU9--
