Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbaCLBFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:05:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45109 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989AbaCLBFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:05:35 -0400
Date: Wed, 12 Mar 2014 01:05:25 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg KH <greg@kroah.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140312010525.b04a12173c7778df42da7a31@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__12_Mar_2014_01_05_25_+0000_0TIXGZuAqW=sSg5U"
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: manual merge of the usb tree with the  tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Mar_2014_01_05_25_+0000_0TIXGZuAqW=sSg5U
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in arch/arm/mach-te=
gra/Kconfig between commit 06c886a95cbb533 ("phy: mvebu-sata: prepare new D=
ove DT Kconfig variable") from the USB tree and commit ff1f0018cf66 ("drive=
rs: Enable building of Kirkwood drivers for mach-mvebu") from the mvebu tre=
e.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

diff --cc drivers/phy/Kconfig
index 05711ea4fd15,8d3c49cc500f..000000000000
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@@ -24,7 -27,7 +27,7 @@@ config PHY_EXYNOS_MIPI_VIDE
 =20
  config PHY_MVEBU_SATA
        def_bool y
-       depends on ARCH_KIRKWOOD || ARCH_DOVE || MACH_KIRKWOOD
 -      depends on ARCH_KIRKWOOD || ARCH_DOVE || MACH_DOVE
++      depends on ARCH_KIRKWOOD || ARCH_DOVE || MACH_KIRKWOOD || MACH_DOVE
        depends on OF
        select GENERIC_PHY
 =20

--Signature=_Wed__12_Mar_2014_01_05_25_+0000_0TIXGZuAqW=sSg5U
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIbBAEBAgAGBQJTH7LVAAoJELSic+t+oim95e8P+LCZBr//C1ACPxRjqzl5HP7P
U2HRVHiF+W9fiMMxVzVwjxQe/YcqpbInJB5xMx2blVWqlaOjn16b5jgR4C4C2Dcm
nDijCt8fxW24cLbWnKJJyDga9s6xS41RbAA+K76fGVNQ0rH3YQbsKzJw6amS00kj
4CWIdvZsEmOWkmRJh2vNd6C3SXj1+xTT11buw7knkcIgz94Na2kThrJeLJeBFCSh
xpP5dmW03kX67nCAu9FdJItXAOHT7a0Sx8Ijbsc0gG/HNKbFEZIDqYC+4T9F85rF
ueSstHWS4K9VPSlFvszjp0zxKwS33ld0WNCe2izXETWvSDoJ8Rtny+FAPrPadsi0
o+lL4hUBcKr0lmrGxUWLANcCbvhBwewxmXpjc9vpP1WJoQ65Fq4tQZsetGeJAfz0
ur8ys9pWLFLdMDuaPdSXafBE97TN1Deqgwlu2oKxAZDk7K15ur+ur4jXPHcQbSry
KcDfXV8vw9srjl4i2D16CFrrBDKfqckO7koCSuBPUyXelMoeNrS0vMp0Dz9IBJ4y
W5G1ziIn8soUJed+hoO3JV9d5PCl8yY6iKlOSqZ/dNyBLKGtJH1XkA4EBmz7LsT6
ZNuN8g+UzF8BZtpTEfpckUNY2IAi44BAd/w5mV8xCmDTFVr22lkfEwXK05yvcV69
El+0NfM/8T+PPu03VVU=
=RE5I
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Mar_2014_01_05_25_+0000_0TIXGZuAqW=sSg5U--
