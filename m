Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab3AWDJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 22:09:38 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:44884 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab3AWDJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 22:09:35 -0500
Date: Wed, 23 Jan 2013 14:09:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>, Nishanth Menon <nm@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: manual merge of the trivial tree with the pm tree
Message-Id: <20130123140929.9026f41a7821c0bcd1db6c9d@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Jan_2013_14_09_29_+1100_f7+ijyVCurwp2PHo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jan_2013_14_09_29_+1100_f7+ijyVCurwp2PHo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/devfreq/exynos4_bus.c between commit 8fa938acb318 ("PM / devfreq:
exynos4_bus: honor RCU lock usage") from the pm tree and commit
8a168ca7074b ("treewide: Fix typo in various drivers") from the trivial
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/devfreq/exynos4_bus.c
index 46d94e9,e1ac076..0000000
--- a/drivers/devfreq/exynos4_bus.c
+++ b/drivers/devfreq/exynos4_bus.c
@@@ -658,7 -636,7 +658,7 @@@ static int exynos4_bus_target(struct de
  	if (old_freq =3D=3D freq)
  		return 0;
 =20
- 	dev_dbg(dev, "targetting %lukHz %luuV\n", freq, new_oppinfo.volt);
 -	dev_dbg(dev, "targeting %lukHz %luuV\n", freq, opp_get_voltage(opp));
++	dev_dbg(dev, "targeting %lukHz %luuV\n", freq, new_oppinfo.volt);
 =20
  	mutex_lock(&data->lock);
 =20

--Signature=_Wed__23_Jan_2013_14_09_29_+1100_f7+ijyVCurwp2PHo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/1RpAAoJEECxmPOUX5FEk90P/RGdVO9PUyp/bi1S7yXIQdlT
9kb1rpGFebXndR6FMy+qWMwl2FPsbX5AtRa7kZBi09MKYNE4hHh5VlDHA35woWjO
tEabhH4v0/lQXSDWJspsZDUfJz/eVJjiayFj/iEPsMAIf9kVXEtaO3tMlWQGpx5m
xL0wPN48HonPIpW6mVfXEnZIBIAUwkOqkAxkVoehlZA/BJuK1tzwvOHzZHv6LD5X
F9ytDkI5ybzSTUH/LHqp+byUePAWrrTRK+d1qdkI//LrsGsP4wgi9jL+dXgvtpka
5hJ0Rz7uw2cjrMBSMjMIk1KbEZMhtR2FpV8c30BiCdU5MkTp3BgfO1TFVRLLaDS8
xRKDvqR5K+/EbW2FOtwS7VQB/nOSL6hr3xIGeSa7ZxuBUA28g4v7HIBswpWaEbxA
vkhPtEGruWwexs05UorqssdIby1hAuKEIzWzXGlDmgM9Hd7ayOMKkD22WUdyRoK7
C8T0p3tvlHbw94zFS22h+RY+Hi16tISHEq3alQw+piluxOcvuWubnfLlAhsdEZSG
mMTgpElADC17MEIM+3ZRy5Q3qL5yYEZUPfoPBAfIEW2c1IJXaWg9jdWSlyxeJzQX
e0n3CAhlTYEpxrkIFqQSOv1lALPcLfna0UhsVDnsDhZ4XVY4lHlSPR4a8KEVRdkC
MwCjzNW3lb12MfuyDNDe
=BAFy
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jan_2013_14_09_29_+1100_f7+ijyVCurwp2PHo--
