Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462AbaDXLqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:46:24 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43760 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbaDXLqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:46:17 -0400
Date: Thu, 24 Apr 2014 12:46:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org
Message-ID: <20140424114604.GO12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="03jbcFpG94FdlGUx"
Content-Disposition: inline
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] spi updates for v3.15
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--03jbcFpG94FdlGUx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit a798c10faf62a505d24e5f6213fbaf904a39623f:

  Linux 3.15-rc2 (2014-04-20 11:08:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3.15-rc2

for you to fetch changes up to 201f9e4dd5ecdefa70d4cf94750a667e2382d13f:

  Merge remote-tracking branches 'spi/fix/atmel', 'spi/fix/bfin5xx', 'spi/fix/hspi' and 'spi/fix/sirf' into spi-linus (2014-04-23 13:50:18 +0100)

----------------------------------------------------------------

spi: Fixes for v3.15

A few driver specific fixes here:

 - SH HSPI was dealing with its clocks incorrectly which meant it didn't
   work on some SoCs, fixing this also requires a small fix to one of
   the SoC clock trees to avoid breaking existing users.
 - The SiRF driver appears to have had several quality problems, it's
   fairly new and not widely used so this isn't too worrying.
 - A brute force fix for excessive locking in the Atmel driver, it needs
   further investigation but this deals with the immediate issue.
 - A build fix for the Blackfin driver.

----------------------------------------------------------------
Alexander Stein (1):
      spi: atmel: Fix scheduling while atomic bug

Mark Brown (1):
      Merge remote-tracking branches 'spi/fix/atmel', 'spi/fix/bfin5xx', 'spi/fix/hspi' and 'spi/fix/sirf' into spi-linus

Qipan Li (3):
      spi: sirf: correct TXFIFO empty interrupt status bit
      spi: sirf: set SPI controller in RISC IO chipselect mode
      spi: sirf: make GPIO chipselect function work well

Simon Horman (2):
      ARM: shmobile: r8a7778: Use clks as MSTP007 parent
      spi: sh-hspi: Do not specifically request shyway_clk clock

Steven Miao (1):
      spi: bfin5xx: fix build error

 arch/arm/mach-shmobile/clock-r8a7778.c |  2 +-
 drivers/spi/spi-atmel.c                |  3 +++
 drivers/spi/spi-bfin5xx.c              |  1 +
 drivers/spi/spi-sh-hspi.c              |  4 ++--
 drivers/spi/spi-sirf.c                 | 20 +++++++++++++++++---
 5 files changed, 24 insertions(+), 6 deletions(-)

--03jbcFpG94FdlGUx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTWPl5AAoJELSic+t+oim9EK0QAJuUEZNI1Rt9YMQHBvyPTQLx
C3Ik1eRNVBP7tIMeP1mO3K43Q5KOM7qzDV9Sp+ss1faHpFRm2WgzFVGTuDCQhNEN
4j3IcSDauICJfWfdBEvMA3byNCto1VRvUy/EjSCgLXV3xSvCaXIuwUrO91XdWZag
vK6nqgAOWWh37bW2ThaBD2G8xB+uRNu9yrZL/CZfCsM/ZNF18DbhNaBBDy5NixOu
TxId2fjAux35I7oV6Zq9lWAvFe8ubU3pNEvU0kFsReYoDnQjFLLwCDq4NQJAc2lO
NXdUKivMF0lJzb3iLTtaQzrUgGo+Ib78N+PUzZhA0qi4CzgtXUITrTd8SX4vgVmQ
cd4lBVTgWK1kNQpeXOwPDYVwY1usPBX+xFMlv0VHIsNMwfqhV5MheBUVYotHFqBL
wzO4SQMJ71Ux+Udm9WPYHr1U6IKuk2OdAZpzCAuo+ujGRNUZXbAvHG2oNpxB5MCC
ynB45Ht01V84mo7/u2qSIjOLh3gzZgnny1JmQcf5lsKdvaLdQJjvIC9lj1XDa6L1
5JKHa/R+u1+AsVlk3OSUHVisgW9RF7UPJMXKf1+AghMMw/KJINFEyZ4w32kzxiH4
D0nzSprKIJyBRNlYKcB4XnvcgkF7bQ8la/JDbkPsDSCCv2ZSotBk8uZZdny2w7pg
bMwUiK7RHY9a74j0Z14X
=HW/s
-----END PGP SIGNATURE-----

--03jbcFpG94FdlGUx--
