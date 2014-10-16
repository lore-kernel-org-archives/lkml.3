Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751001AbaJPGdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 02:33:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaJPGdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 02:33:15 -0400
Date: Thu, 16 Oct 2014 17:32:58 +1100
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux RAID <linux-raid@vger.kernel.org>,
        "Baldysiak, Pawel" <pawel.baldysiak@intel.com>,
        BillStuff <billstuff2001@sbcglobal.net>,
        Anton Blanchard <anton@samba.org>, Chao Yu <chao2.yu@samsung.com>,
        Markus Stockhausen <stockhausen@collogia.de>
Subject: [GIT PULL REQUEST] md updates for 3.18
Message-ID: <20141016173258.1ce9f964@notabene.brown>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/n.cQ_dJh.lO.egzZn2pGMoK"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/n.cQ_dJh.lO.egzZn2pGMoK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,
 here are some md updates for 3.18.

Thanks,
NeilBrown


The following changes since commit 8e0e99ba64c7ba46133a7c8a3e3f7de01f23bd93:

  md/raid5: disable 'DISCARD' by default due to safety concerns. (2014-10-0=
2 13:45:00 +1000)

are available in the git repository at:

  git://neil.brown.name/md tags/md/3.18

for you to fetch changes up to b395f75eabb3844c99244928293796ff42feaa3d:

  lib/raid6: Add log level to printks (2014-10-14 13:08:29 +1100)

----------------------------------------------------------------
md updates for 3.18

- a few minor bug fixes
- quite a lot of code tidy-up and simplification
- remove PRINT_RAID_DEBUG ioctl.  I'm fairly sure
  it is unused, and it isn't particularly useful.

----------------------------------------------------------------
Anton Blanchard (1):
      lib/raid6: Add log level to printks

Chao Yu (1):
      md: avoid potential long delay under pers_lock

Markus Stockhausen (1):
      md/raid5: fix init_stripe() inconsistencies

NeilBrown (18):
      md/bitmap: always wait for writes on unplug.
      md/raid1: minor typos and reformatting.
      md: use set_bit/clear_bit instead of shift/mask for bi_flags changes.
      md/raid10: another memory leak due to reshape.
      md/raid1: process_checks doesn't use its return value.
      md: be more relaxed about stopping an array which isn't started.
      md: use wait_event() to simplify md_super_wait()
      md: discard find_rdev_nr in favour of find_rdev_nr_rcu
      md: simplify export_array()
      md: Just use RCU when checking for overlap between arrays.
      md: don't start resync thread directly from md thread.
      md: remove unwanted white space from md.c
      md: don't allow "-sync" to be set for device in an active array.
      md: remove unnecessary test for MD_MAJOR in md_ioctl()
      md: clean up 'exit' labels in md_ioctl().
      md: remove MD_BUG()
      md: discard PRINT_RAID_DEBUG ioctl
      md: move EXPORT_SYMBOL to after function in md.c

 drivers/md/bitmap.c            |  16 +-
 drivers/md/linear.c            |   8 +-
 drivers/md/md.c                | 601 +++++++++++++------------------------=
----
 drivers/md/md.h                |  34 ++-
 drivers/md/multipath.c         |  28 +-
 drivers/md/raid0.c             |   9 +-
 drivers/md/raid1.c             |  37 +--
 drivers/md/raid1.h             |   2 -
 drivers/md/raid10.c            |  18 +-
 drivers/md/raid5.c             |  29 +-
 drivers/md/raid5.h             |   4 +-
 include/uapi/linux/raid/md_u.h |   1 -
 lib/raid6/algos.c              |  12 +-
 13 files changed, 266 insertions(+), 533 deletions(-)

--Sig_/n.cQ_dJh.lO.egzZn2pGMoK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVD9mmjnsnt1WYoG5AQIZvg/+JOH9S5JxMU6TpEJSRPty40bbGSebkPa1
3NUa7rDGsOtjIF5cH9/STPIQFsIhGxbbjCrHg0jRAi+mdDp8NGfCpwoOC1UriiKo
G5Tk3zKHUhjOjUYUQMMYoLi+SESEV6zbORnofoUdexiNOL8EEmlN4Lu1QwIMRcA6
O3wEXV8901OdWX+X5gDPxYrhiLGREb8fZl/GvsIH1lPKVsBwRuEhBPD7+NrE9rjk
BQ170VX5AEs1MWCxq1a0EmDxZ+UqrJ911MTTQ9a0RiNHa/7PIbV+hb/UhEIEberh
uuEMoDdKEA21Y4rSTy0e/2EACEzGnscFWed7outaaOJdVkmk0tdHlBNVkoUwku1i
77h0i6qtt3ZqKq2OuoVXYS2Wd1XXEWckEdc6DNzD0+AhrqMIOprpB5Z4QLLJ8Cny
6aBxWmm30Snny9qFtBIzUnHZh6j0sB9rxfChee5FThxAU38Xe4ol+ecQvdTKqYyT
aglBQ//YpULwR405N+boQ23x8J2rjab1Rn+zmZvIkMkzdrAwMCzh3CLCL1xUnyA5
/Ep760qSP66B9i3hpjP4I5NbM07rK02ipTkmFmlgpiBWOUxDMqyQOZLfRNl4rpq1
MXTTvOAB0Cez6qh6Ir3bDJRreaGSl6E/E17WP/JHSwacJOSQwWezKmL+aqNQwePW
6TMcr7+Q0fc=
=CjRF
-----END PGP SIGNATURE-----

--Sig_/n.cQ_dJh.lO.egzZn2pGMoK--
