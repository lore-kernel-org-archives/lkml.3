Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab3CUBFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 21:05:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52446 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab3CUBFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 21:05:32 -0400
Date: Thu, 21 Mar 2013 12:05:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: linux-next: manual merge of the v4l-dvb tree with the s390 tree
Message-Id: <20130321120522.611e75952eb159bcf97f9cdf@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Mar_2013_12_05_22_+1100_BJ6nn8pcER8gOiUd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Mar_2013_12_05_22_+1100_BJ6nn8pcER8gOiUd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
drivers/media/platform/Kconfig between commit c30f46bcf9b3
("drivers/Kconfig: add several missing GENERIC_HARDIRQS dependencies")
from the s390 tree and commit da508f579965 ("[media] media/v4l2:
VIDEOBUF2_DMA_CONTIG should depend on HAS_DMA") from the v4l-dvb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/media/platform/Kconfig
index a0639e7,42c62aa..0000000
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@@ -204,7 -204,7 +204,7 @@@ config VIDEO_SAMSUNG_EXYNOS_GS
 =20
  config VIDEO_SH_VEU
  	tristate "SuperH VEU mem2mem video processing driver"
- 	depends on VIDEO_DEV && VIDEO_V4L2 && GENERIC_HARDIRQS
 -	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
++	depends on VIDEO_DEV && VIDEO_V4L2 && GENERIC_HARDIRQS && HAS_DMA
  	select VIDEOBUF2_DMA_CONTIG
  	select V4L2_MEM2MEM_DEV
  	help

--Signature=_Thu__21_Mar_2013_12_05_22_+1100_BJ6nn8pcER8gOiUd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRSlzSAAoJEECxmPOUX5FEnpkQAJrZZNNSuiGFXge2eE94pkJM
rsDcCehCGN7ZUjUhXZwsyVBisbQGgUppthdzovWnhBNx7UBXDJ/zy9RW+yMwKZ9i
BQW6AK2lGMUsJsL2Yj4A631MYbL0PwejuYeSj7Tod1Ms3AdPgDi5xSwBT1Qbo+2X
3McslkMEfqlGpcNI4frXkxcQeIxVzY9w7e9dRuUGA4UHtpcOyo7K9EzCCxZycYbx
vP1CdjQLG66iph+1RpdULxyPxeryHbsaDZDKHS4ZlCFV5DoC70rw4t7FkfX/V3bO
BRNSW26Xj60CTBKwOfQwbPnl0qjgv8y0IS/5d9V8bvSlk88Hn7PamYgsK+NpaI6/
w5Z8xpz6dE8KY4UdNbtnx9FWL4xYkx6onVmrwP7Pjs2Rf6+cYpUbDa5qq7SknADv
dWFKefUG+Nr7rFvJsgv9q2dAeh2wi7Sg1kLcZA7GlJ4d8/y6mbnFvFn8wygdA0+M
xyNMDwJaUuI6UGWze82quN93aJqyknKwAj45/zos3TyTphseNOT6WU1I5XKy7WQh
6qkBK5CCqA3dj64+FJw9XEsOq2EPCSz6E2POXagcyXrUQNkYP1mq5FwgvNxRIyKU
J7aKaz8F5xHPuHUyY87NsCam4N+mDJcnGhQuH+oqt2F6z65t4BLd7WuroQGHW6km
04YRFi0f6HAmh2fSB6Ph
=jCN/
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Mar_2013_12_05_22_+1100_BJ6nn8pcER8gOiUd--
