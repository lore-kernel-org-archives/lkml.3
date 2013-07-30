Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3G3Lpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 07:45:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38626 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3G3Lp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 07:45:28 -0400
Date: Tue, 30 Jul 2013 12:45:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>, Chris Ball <cjb@laptop.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20130730114502.GQ9858@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JcE26DgBcHfjBx04"
Content-Disposition: inline
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 0/5] Optional regulator support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JcE26DgBcHfjBx04
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This patch series adds a variant of regulator_get() which allows
regulator consumers to tell the core that the supply they are requesting
may genuinely be absent in the system.  The goal is to help address some
of the problems with handling errors in regulator_get() in drivers that
are newly converted to the regulator API by allowing the core to provide
stub regulators for supplies that aren't hooked up without disrupting
the operation of drivers like MMC drivers which may genuinely not have
some of their supplies hooked up.

Currently the code simply introduces a new API call with exactly the
same implementation as regulator_get() so there should be zero impact
=66rom the series other than a slightly larger kernel.

Right now all the MMC users are converted over as-is, though it does
look like drivers such as sdhci really ought to be insisting on having a
regulator for VMMC in the same way that the MMC core helper does (and
indeed in that case it looks like it ought to be converted over to the
core code).

If this series is OK I'd like to merge it via the regulator tree so that
the functionality to make use of the optional regulators can be built
out on top of it.

Mark Brown (5):
      regulator: core: Provide hints to the core about optional supplies
      mmc: core: Indicate that vmmcq may be absent
      mmc: sdhci: Indicate that regulators may be absent
      mmc: dw_mmc: Indicate that regulators may be absent
      mmc: pxamci: Indicate that regulators may be absent

 drivers/mmc/core/core.c            |  2 +-
 drivers/mmc/host/dw_mmc.c          |  2 +-
 drivers/mmc/host/pxamci.c          |  2 +-
 drivers/mmc/host/sdhci.c           |  4 +--
 drivers/regulator/core.c           | 59 ++++++++++++++++++++++++++++++++++=
++++
 include/linux/regulator/consumer.h | 18 +++++++++++-
 6 files changed, 81 insertions(+), 6 deletions(-)

--JcE26DgBcHfjBx04
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR96c7AAoJELSic+t+oim9UMQP/Rw2Y0Wxsd7HxYY2pP6lgoGV
FeObmBpllazP/U/tfjMDbgO/TjOygzRvqZdAk5IMJn4oRq1ZnuWqi9nq7wA5Hm4z
Ws9HAvIZ4WfPltUOPfFJtQ3sfpuHyRSH8wpP3CwXcXoYCPboTCQpk10/YCjCKHm5
0AJu2lVCp4MBpQGIh5RhjGLlE+orYtszk0Cbi8U++uxTSrnoh8FcinPwpl3oeOm4
gMUnW9f57+NGOHzG9ApxYNxEIIBuwhVS34qXFQSUvs2RRB3MxmO/JkEaaX5QnxSf
K0T0TlYI2roZgBy7k94qkW3AedqsnLhEIEtGdb0pADpoem81xLvc+2w1t+vDptlt
qYgzeE4oLq5jSJvVtoIYIOlR1yn8THpr8UpBhmlvo8qma2nlqfuovMN4lMds/vuu
0F4u2Fzkcgfoa+Y7i2ZfqNbvE8ZTAr4fpo9qbMO//94rtxrVOSWunQzVsv6nxrI+
gfm0/NHGhVbuZMgBk39YJKSWFGZ0Ma+M3kIYdcRF8iX0K5CLqASHMxYVTbhSX6o1
/hkymm06ylIRoUzyJC8pr4WytoSov4ck2iA/n6J3R8YYSl6DGUASpH12bVocBWqr
adBeNxKpF58WwZusE5Yk+4aJJlts3H16hbm2SFJ0vkDMjaR9k3PNVTSKglqI7Fk4
EZP0MFiSUlFHrAm8j+nG
=nuCq
-----END PGP SIGNATURE-----

--JcE26DgBcHfjBx04--
