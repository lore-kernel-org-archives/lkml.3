Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaAJQsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:48:13 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52131 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaAJQsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:48:09 -0500
Date: Fri, 10 Jan 2014 16:48:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140110164802.GO29039@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RHdRtM27np9fZUoh"
Content-Disposition: inline
X-Cookie: May I ask a question?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] spi fixes for v3.13
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RHdRtM27np9fZUoh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit d6e0a2dd12f4067a5bcefb8bbd8ddbeff800afbc:

  Linux 3.13-rc7 (2014-01-04 15:12:14 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3.13-rc7

for you to fetch changes up to 8d850279cb16a75c712abf8d11721170e8a48e33:

  Merge remote-tracking branches 'spi/fix/bcm63xx', 'spi/fix/dspi', 'spi/fix/hspi', 'spi/fix/imx', 'spi/fix/msiof', 'spi/fix/qspi' and 'spi/fix/rspi' into spi-linus (2014-01-09 18:26:06 +0000)

----------------------------------------------------------------

spi: Updates for v3.13

This update is larger than I would like, mostly due to me being lazy
over Christmas, so it'd be totally understandable if you didn't want to
pull.  There's a smattering of small driver fixes here plus a few core
things, the bits that jump out are:

 - Fix error handling if we fail to set up a transfer when the driver
   uses transfer_one_message() so we don't hang.
 - Change the way we check for conflicting device registrations to work
   with ACPI, as of v3.13 ACPI overrides the device name so the simple
   check for device name that we had been using no longer works.
 - A fix to avoid races between /CS and data transfer starting in the
   i.MX driver from Marek Vasut (this is the largest driver fix but
   very well analysed.

otherwise everything is both small and localised.

----------------------------------------------------------------
Axel Lin (3):
      spi: ti-qspi: Fix getting correct address for qspi
      spi: sh-hspi: Fix modalias for sh-hspi
      spi: fsl-dspi: Add missing breaks for switch cases

Daniel Santos (1):
      spidev: fix hang when transfer_one_message fails

Geert Uytterhoeven (2):
      spi: rspi: Fix NULL pointer dereference on SH7757
      spi: rspi: Fix typo when clearing SPSR_OVRF

Jonas Gorski (1):
      spi/bcm63xx: don't substract prepend length from total length

Marek Vasut (1):
      spi: spi-imx: Fix out-of-order CS/SCLK operation at low speeds

Mark Brown (2):
      Merge remote-tracking branch 'spi/fix/core' into spi-linus
      Merge remote-tracking branches 'spi/fix/bcm63xx', 'spi/fix/dspi', 'spi/fix/hspi', 'spi/fix/imx', 'spi/fix/msiof', 'spi/fix/qspi' and 'spi/fix/rspi' into spi-linus

Mika Westerberg (1):
      spi: Check conflicting CS based on spi->chip_select instead of device name

Sourav Poddar (1):
      spi/qspi: Fix runtime resume path

Takashi Yoshii (1):
      spi: spi-sh-msiof: round up div to fix freq calculation

Wei Yongjun (1):
      spi: bcm63xx: fix reference leak to master in bcm63xx_spi_remove()

 drivers/spi/spi-bcm63xx.c  |  2 --
 drivers/spi/spi-fsl-dspi.c |  2 ++
 drivers/spi/spi-imx.c      | 27 +++++++++++++++++++++++++--
 drivers/spi/spi-rspi.c     |  7 ++++---
 drivers/spi/spi-sh-hspi.c  |  2 +-
 drivers/spi/spi-sh-msiof.c |  2 +-
 drivers/spi/spi-ti-qspi.c  | 12 ++----------
 drivers/spi/spi.c          | 22 ++++++++++++++++------
 8 files changed, 51 insertions(+), 25 deletions(-)

--RHdRtM27np9fZUoh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS0CQ/AAoJELSic+t+oim9RUUP/iHZ3+LLOYNGx4BD6VED4OL9
7r1X4OaMRWhsbDjVIobbokafBlk8/DqyzFl9vFb6qvrXUHIhb7h8McnQnyRMZz9y
H081K/N71elS9wNBij3eC/fSop0Jr5xvgGkS86uxMkSpkHTJOi3amykedJ+EfY05
cEh4shBL9/nH7BPKjbElZXJz/EeR0vaMSKKYW5hg7yzLAgfOhoe/0u+xmaT2pgkb
Nzes/x7yr+37Rq4sggjIfsxq/yu+YPNl7I9LUfYTGoqLtVl+EMNUDaThNDno78G4
FTCk1PFAxcvVE8Kt1P7Yjcdys1KIk/vfRqqUaKmXbafZG8d3pzoS5BdJAZSdcj0r
Ow7ysXx3HbkwSaRjrqiph+sMwGLWsdLO1TTkOS/8Dxn/5OWFNCmwP2UlENqdETcJ
Marr/z+8rHGy/7iITAFdhdkF39TW8PxNQS/yb2/7njD8PlrV9G0gYaR/nQ4Vra8x
GzDDpRR/0XjHn/l/kD/XLKjDAqvqOrrmW9dxZfS87Ke25FI6HPo2YdRYNnaOp+PF
/XYs1o1wqdTwWr7AsmXQg8H/JU6KWLxROYpt79up3R+Z+NdF0SFm3sQAUOMKGv/g
xbhWCcIu5pDZ3H1Imr14XF/a2ZKu3YaNSDcL9clqKzIusWWZZCH/QRM6XujNGGPi
TUsnV9lIYCohEBgt29Mn
=wplD
-----END PGP SIGNATURE-----

--RHdRtM27np9fZUoh--
