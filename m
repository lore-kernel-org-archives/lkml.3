Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaIPXcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:32:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46412 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaIPXcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:32:01 -0400
Date: Tue, 16 Sep 2014 16:31:46 -0700
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140916233146.GG7960@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zd5GkkQQtETumrwc"
Content-Disposition: inline
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] SPI fixes for v3.17
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zd5GkkQQtETumrwc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 9e82bf014195d6f0054982c463575cdce24292be:

  Linux 3.17-rc5 (2014-09-14 17:50:12 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3.17-rc5

for you to fetch changes up to 94b0955ddd1ea4ea1089a282dd8058765fffe937:

  Merge remote-tracking branches 'spi/fix/davinci', 'spi/fix/dw', 'spi/fix/fsl', 'spi/fix/pl022', 'spi/fix/rockchip' and 'spi/fix/sirf' into spi-linus (2014-09-16 16:20:19 -0700)

----------------------------------------------------------------
spi: Fixes for v3.17

A few driver specific fixes for v3.17:

 - Fix davinci so that GPIO chip selects work with deferred probe of
   GPIOs (which could happen in production depending on kernel config)
   plus one incremental stylistic fix to that.
 - Several fixes for the newly introduced rockchip driver that came up
   in wider testing of the device.
 - A couple of small things in the sirf driver, one bug that would stop
   DMA transfers working and another update to follow the documented
   procedure in the datasheet.
 - Fix some memory leaks with devm_kzalloc() being used outside of the
   device bind path.

----------------------------------------------------------------
Axel Lin (2):
      spi: fsl: Don't use devm_kzalloc in master->setup callback
      spi: dw: Don't use devm_kzalloc in master->setup callback

Doug Anderson (3):
      spi/rockchip: Fix the wait_for_idle() timeout
      spi/rockchip: Don't warn if SPI is busy but disabled
      spi/rockchip: Mark DMA as optional

Grygorii Strashko (2):
      spi: davinci: request cs_gpio's from probe
      spi: davinci: remove empty function davinci_spi_cleanup

Mark Brown (1):
      Merge remote-tracking branches 'spi/fix/davinci', 'spi/fix/dw', 'spi/fix/fsl', 'spi/fix/pl022', 'spi/fix/rockchip' and 'spi/fix/sirf' into spi-linus

Qipan Li (2):
      spi: sirf: enable RX_IO_DMA_INT interrupt
      spi: sirf: add fifo reset/start for cmd transfer

Roland Stigge (1):
      spi/pl022: Fix error message

 .../devicetree/bindings/spi/spi-rockchip.txt       |  8 +++--
 drivers/spi/spi-davinci.c                          | 39 ++++++++++++++--------
 drivers/spi/spi-dw.c                               | 12 +++++--
 drivers/spi/spi-fsl-espi.c                         | 15 +++++++--
 drivers/spi/spi-fsl-spi.c                          | 10 ++++--
 drivers/spi/spi-pl022.c                            |  2 +-
 drivers/spi/spi-rockchip.c                         |  5 +--
 drivers/spi/spi-sirf.c                             |  5 ++-
 8 files changed, 68 insertions(+), 28 deletions(-)

--zd5GkkQQtETumrwc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUGMhhAAoJECTWi3JdVIfQVywH/19uJyBM4BXxLXdI0bjiAafl
bxBxSj+X0vTu2Ux5PsxzAoePgQu3rTRAybpjGSNerV8YVTG1zscZL7F/81TsNhQH
cFx6Z+Ndlhl+e4TMIUspH9BurQ3sUY1mlC5b4I3SXB7YLllV+n8NnPOsNHCR9fvm
Pzy4XPHF+hC1rIvWxtG+Jc5gWme3sGCcqF5fS1V2FmbPGyDa849mR1Vvu6CgQGIg
0A8drYYKhehmIG2nZhijWZc00yf0fPdJMDXBFeLIf0g/taoE8hKb2yoikXXpZ4H0
MLdNv6Zy9fNrCntOGjEVJ/Dq7eLQwi3icHuub9cgyr9lKSLFVkzXV2WN1Na3GP8=
=Wi7Y
-----END PGP SIGNATURE-----

--zd5GkkQQtETumrwc--
