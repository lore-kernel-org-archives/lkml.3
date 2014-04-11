Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbaDKX1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 19:27:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51572 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbaDKX13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 19:27:29 -0400
Date: Sat, 12 Apr 2014 09:27:17 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Shaohua Li <shli@kernel.org>, "majianpeng" <majianpeng@gmail.com>,
        Kent Overstreet <kmo@daterainc.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL REQUEST] md for 3.15
Message-ID: <20140412092717.1e1bec76@notabene.brown>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ebruKAj24/Pe_5AVIKGiAve"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ebruKAj24/Pe_5AVIKGiAve
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Not much happening in md/raid at the moment. Just a few bug fixes (one for
-stable) and a couple of performance tweaks.

NeilBrown


The following changes since commit 455c6fdbd219161bd09b1165f11699d6d73de11c:

  Linux 3.14 (2014-03-30 20:40:15 -0700)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md/3.15

for you to fetch changes up to e240c1839d11152b0355442f8ac6d2d2d921be36:

  raid5: get_active_stripe avoids device_lock (2014-04-09 14:42:42 +1000)

----------------------------------------------------------------
Just a few md patches for the 3.15 merge window.

----------------------------------------------------------------
NeilBrown (3):
      md/bitmap: don't abuse i_writecount for bitmap files.
      md/raid1: r1buf_pool_alloc: free allocate pages when subsequent alloc=
ation fails.
      md: avoid oops on unload if some process is in poll or select.

Shaohua Li (2):
      raid5: make_request does less prepare wait
      raid5: get_active_stripe avoids device_lock

 drivers/md/bitmap.c |  1 -
 drivers/md/md.c     | 65 ++++++++++++++++++++++++++-----------------------=
----
 drivers/md/md.h     |  1 -
 drivers/md/raid1.c  | 17 ++++++++++----
 drivers/md/raid5.c  | 28 +++++++++++++----------
 5 files changed, 61 insertions(+), 51 deletions(-)

--Sig_/ebruKAj24/Pe_5AVIKGiAve
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU0h6VTnsnt1WYoG5AQK0RRAArX5DILJWJHAE0hZ8gy5upjoPRFRmw1kX
gVKzYUr7crRvaZi0aGDFAaB9fxvp+hViZ8VAhWJv+pM1v3yDLJoE4ke1ex2BTUJT
Oq1svKvWB2NUK1ywHcoDuO4v9r092VOZytHS4EjorOjksJVRoZrzrdksZKB9JieJ
t4jfg/LHuiJvwehBBBDcck+THj5+Xlg/bwZRgbHcYsIA9A8xd/dtRagnTQ8N+R1Z
9vv+Fl5Zb4wEv7CTEzzCMrWh6Em6h2csrUfXMHo18wGpd71lQvoglRSsFFADwbo9
LXS5Wkjm1Od+0xeWUmMf02HgWGIJozCcKwxQQr/6WBcHeBwDGsV7rNNtb2OHCQTO
N7wNtb3MSJi6wTQulbhinWhmRNOiN5zcqRwsIpgFeUq9ux8MR0/RrsOo8KSFBiZR
ZGFZbkLIFlMvCSdzaqSTZ5C07hS17gAz3NrgdL4mdEiaZXuoivDbi2/24E8nDBwn
JerY0P4ApHzo+c3ki6OJvm2qDsrWk4aWIx+Gv8fGquz2eCsy8bF+UIAtFDSGUjjw
ctVxLCLSIARiF3YDL/WBv1TmWAKJQ0kyG7WqW634hpbtmII5wMve5bqCsaQRuMJ0
oPaqTqISfgxzDEm7s0D8q2uWFqRiCnxKAWnHOY+/xJcRaytJd6zdfmGMEwxhmLp4
r9oTfg46/NY=
=Ft32
-----END PGP SIGNATURE-----

--Sig_/ebruKAj24/Pe_5AVIKGiAve--
