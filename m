Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750960AbaKZTQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 14:16:59 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39722 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaKZTQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 14:16:58 -0500
Date: Wed, 26 Nov 2014 19:15:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org
Message-ID: <20141126191501.GT7712@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DzoDmdq79ow+k1Jf"
Content-Disposition: inline
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] spi fixes for v3.18
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DzoDmdq79ow+k1Jf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 5d01410fe4d92081f349b013a2e7a95429e4f2c9:

  Linux 3.18-rc6 (2014-11-23 15:25:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3.18-rc6

for you to fetch changes up to ec058615f1fbc03837ab048b1bb7291370b46cef:

  Merge remote-tracking branches 'spi/fix/dw' and 'spi/fix/sirf' into spi-linus (2014-11-26 19:05:25 +0000)

----------------------------------------------------------------
spi: Fixes for v3.18

There's a couple of driver fixes here, plus one core fix for the DMA
mapping which wasn't doing the right thing for vmalloc()ed addresses
that hadn't been through kmap().  It's fairly rare to use vmalloc() with
SPI and it's a subset of those users who might fail so it's unsurprising
that this wasn't noticed sooner.

----------------------------------------------------------------
Charles Keepax (1):
      spi: Fix mapping from vmalloc-ed buffer to scatter list

Mark Brown (2):
      Merge remote-tracking branch 'spi/fix/dma' into spi-linus
      Merge remote-tracking branches 'spi/fix/dw' and 'spi/fix/sirf' into spi-linus

Qipan Li (1):
      spi: sirf: fix word width configuration

Thor Thayer (1):
      spi: dw: Fix dynamic speed change.

 drivers/spi/spi-dw.c   | 6 +-----
 drivers/spi/spi-sirf.c | 4 ++--
 drivers/spi/spi.c      | 6 +++---
 3 files changed, 6 insertions(+), 10 deletions(-)

--DzoDmdq79ow+k1Jf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdia0AAoJECTWi3JdVIfQVcwH/A9xnuS6CARl4XT9227PdDSH
vfhKnzvEGboc6xz9LyVwawXEp8UgNrdSgV8+KbATY7VWbgk4qw06TtrsDxxQGpL3
Vg8ll5EIrLVh1KgclsbLxF3solX01mwpsNDoiyUL9bL00X+WLW8Mo0EwTWhFbBr6
7CjD3Aj2jJXBXV2iS/8QloZ8cOiCxDp1kZ0dpIqS/pYwOQ6bXcRkejB7zIIOg3i2
uKdsmBxXXmI8BlGtmoIH0oI27cQP+dfOIHK1z6KcT0oIrPAaAiZixE9s/iAMxnrN
/RngooFWe/2iN+iFcXH/+8u+S2YcRKZ5HF2+KOHcXBapLJcIeg3cyT+fj7Eehn0=
=8p3H
-----END PGP SIGNATURE-----

--DzoDmdq79ow+k1Jf--
