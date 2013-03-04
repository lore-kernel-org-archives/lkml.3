Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab3CDARF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 19:17:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652Ab3CDARD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 19:17:03 -0500
Date: Mon, 4 Mar 2013 11:16:40 +1100
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux RAID <linux-raid@vger.kernel.org>,
        Jonathan Brassow <jbrassow@redhat.com>,
        Joe Lawrence <Joe.Lawrence@stratus.com>,
        Sebastian Riemer <sebastian.riemer@profitbricks.com>,
        Ben Hutchings <ben@decadent.org.uk>, Dan Williams <djbw@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Tregaron Bayly <tbayly@bluehost.com>
Subject: [PULL REQUEST] md updates for 3.9
Message-ID: <20130304111640.32c428a0@notabene.brown>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/N6r4ySdiHrw0nrxpbyoZ0nl"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/N6r4ySdiHrw0nrxpbyoZ0nl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200:

  Linux 3.8 (2013-02-18 15:58:34 -0800)

are available in the git repository at:

  git://neil.brown.name/md tags/md-3.9

for you to fetch changes up to f3378b48705154b9089affb2d2e939622aea68f1:

  md: expedite metadata update when switching  read-auto -> active (2013-02=
-28 11:59:03 +1100)

Thanks,
NeilBrown



----------------------------------------------------------------
md updates for 3.9

mostly little bugfixes.
Only "feature" is a new RAID10 layout which slightly
improves the number of sets of devices that can concurrently
fail, without data loss.

----------------------------------------------------------------
Joe Lawrence (1):
      md: raid1,10: Handle REQ_WRITE_SAME flag in write bios

Jonathan Brassow (4):
      MD RAID10: Minor non-functional code changes
      MD RAID10: Improve redundancy for 'far' and 'offset' algorithms (part=
 1)
      MD RAID10: Improve redundancy for 'far' and 'offset' algorithms (part=
 2)
      DM RAID: Add support for MD's RAID10 "far" and "offset" algorithms

NeilBrown (6):
      md: fix two bugs when attempting to resize RAID0 array.
      md: raid0: fix error return from create_stripe_zones.
      md/raid0: improve error message when converting RAID4-with-spares to =
RAID0
      md/raid1,raid10: fix deadlock with freeze_array()
      md: remove CONFIG_MULTICORE_RAID456
      md: expedite metadata update when switching  read-auto -> active

Sebastian Riemer (1):
      md: protect against crash upon fsync on ro array

 Documentation/device-mapper/dm-raid.txt |  44 +++++++++++++---
 drivers/md/Kconfig                      |  11 ----
 drivers/md/dm-raid.c                    | 123 ++++++++++++++++++++++++++++=
++++++++-------
 drivers/md/md.c                         |  19 ++++++-
 drivers/md/raid0.c                      |  13 +++--
 drivers/md/raid1.c                      |   8 ++-
 drivers/md/raid10.c                     |  97 ++++++++++++++++++++++++++--=
------
 drivers/md/raid10.h                     |   5 ++
 drivers/md/raid5.c                      |  38 +------------
 9 files changed, 256 insertions(+), 102 deletions(-)

--Sig_/N6r4ySdiHrw0nrxpbyoZ0nl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUTPn6Dnsnt1WYoG5AQJ+oBAAg+2xRZxttGjUsLj96mu1BCo97u9ink2V
TSJ1KtIx2cPD6mVJTtoO+r0U4EdXNoAk2TbuqLTWmYW/O8qeSgARsefMxujJv6KJ
hF9kEtrUowo0wYPqeYFVIrkL0llXcd3iVP+oj44D2SjuwrwnfHLX4uTO3k/Dfxif
hHnKnM2lW+3hnNWijKxR4hjJv4INWlvIesrThJHyspzdnzP6z6C6sFEBkic5/J6o
vIxBPvPUx3b6mSCIObNJ8BwUX7toT6ltMED4TPL1KUQEn1zsbWIYB1NVf7yZrHeC
LCz/653qNxajJ/lJdmyM/0SVFZZ9UnKDXex8VCnZPzKIlJbsQ38y2UBxjPZtbTTz
tGYH5w8BkQ8nTev/TOXPtjYWZJ0/RfuhSMuRzYXq6JDH3J9WLnFr/Mhv7FkAkRaP
o5//dUPtAGh7dU9okUrm/KPnfbT36U5Eg83BDM9o4F2EIEfQVcFQMOr8PfFF2ROS
5/F6fnz7Man6KxXGk/NZYashgTTrYtggUZC+s86iJGXM22kKyE3NWEAdREl2ncBw
V0EiuhCwskLqmYcMdES63VdVKNzLoSs0uGOW/XdvCgQZChWJcYwy8Oxm/ZNIj3dm
zp8hNm9qsmMXIm6pAxGOKb3KmzEYmRbF3BrORclQf0XPnhacAmuOCXAdAys0t3FI
vFupkzlcYU4=
=mPES
-----END PGP SIGNATURE-----

--Sig_/N6r4ySdiHrw0nrxpbyoZ0nl--
