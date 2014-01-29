Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaA2MqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 07:46:25 -0500
Received: from sauhun.de ([89.238.76.85]:50142 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbaA2MqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 07:46:23 -0500
Date: Wed, 29 Jan 2014 13:46:21 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.14
Message-ID: <20140129124614.GA8314@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

another pull request from the i2c subsystem. Mostly bugfixes, small but
wanted cleanups, and Paul's init.h removal applied. Please pull.

Thanks,

   Wolfram


The following changes since commit 3aacd625f20129f5a41ea3ff3b5353b0e4dabd01:

  Merge branch 'akpm' (incoming from Andrew) (2014-01-23 19:11:50 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-current

for you to fetch changes up to 6ff4b105163223741f5a82804f9695221017ae42:

  i2c: rcar: fix NACK error code (2014-01-26 22:48:36 +0100)

----------------------------------------------------------------
Ben Dooks (4):
      i2c: rcar: do not print error if device nacks transfer
      i2c: rcar: use devm_clk_get to ensure clock is properly ref-counted
      i2c: update i2c_algorithm documentation
      i2c: rcar: fix NACK error code

Jean Delvare (1):
      i2c: piix4: Standardize log messages

Paul Gortmaker (2):
      i2c: acorn: is tristate and should use module.h
      i2c: delete non-required instances of include <linux/init.h>

Shane Huang (2):
      i2c: piix4: Add support for AMD ML and CZ SMBus changes
      i2c: piix4: Use different message for AMD Auxiliary SMBus Controller

Wolfram Sang (1):
      i2c: rely on driver core when sanitizing devices

 Documentation/i2c/busses/i2c-piix4         |  2 +-
 drivers/i2c/algos/i2c-algo-bit.c           |  1 -
 drivers/i2c/algos/i2c-algo-pca.c           |  1 -
 drivers/i2c/algos/i2c-algo-pcf.c           |  1 -
 drivers/i2c/busses/Kconfig                 |  1 +
 drivers/i2c/busses/i2c-acorn.c             |  2 +-
 drivers/i2c/busses/i2c-ali1535.c           |  1 -
 drivers/i2c/busses/i2c-ali1563.c           |  1 -
 drivers/i2c/busses/i2c-ali15x3.c           |  1 -
 drivers/i2c/busses/i2c-amd756.c            |  1 -
 drivers/i2c/busses/i2c-amd8111.c           |  1 -
 drivers/i2c/busses/i2c-au1550.c            |  1 -
 drivers/i2c/busses/i2c-cbus-gpio.c         |  1 -
 drivers/i2c/busses/i2c-cpm.c               |  1 -
 drivers/i2c/busses/i2c-eg20t.c             |  1 -
 drivers/i2c/busses/i2c-exynos5.c           |  1 -
 drivers/i2c/busses/i2c-highlander.c        |  1 -
 drivers/i2c/busses/i2c-hydra.c             |  1 -
 drivers/i2c/busses/i2c-ibm_iic.c           |  1 -
 drivers/i2c/busses/i2c-iop3xx.c            |  1 -
 drivers/i2c/busses/i2c-isch.c              |  1 -
 drivers/i2c/busses/i2c-ismt.c              |  1 -
 drivers/i2c/busses/i2c-mpc.c               |  1 -
 drivers/i2c/busses/i2c-nforce2.c           |  1 -
 drivers/i2c/busses/i2c-ocores.c            |  1 -
 drivers/i2c/busses/i2c-octeon.c            |  1 -
 drivers/i2c/busses/i2c-pca-platform.c      |  1 -
 drivers/i2c/busses/i2c-piix4.c             | 44 +++++++++++++++++++++---------
 drivers/i2c/busses/i2c-pmcmsp.c            |  1 -
 drivers/i2c/busses/i2c-powermac.c          |  1 -
 drivers/i2c/busses/i2c-puv3.c              |  1 -
 drivers/i2c/busses/i2c-rcar.c              | 22 +++++++--------
 drivers/i2c/busses/i2c-scmi.c              |  1 -
 drivers/i2c/busses/i2c-sh7760.c            |  1 -
 drivers/i2c/busses/i2c-simtec.c            |  1 -
 drivers/i2c/busses/i2c-sis630.c            |  1 -
 drivers/i2c/busses/i2c-sis96x.c            |  1 -
 drivers/i2c/busses/i2c-via.c               |  1 -
 drivers/i2c/busses/i2c-xiic.c              |  1 -
 drivers/i2c/busses/i2c-xlr.c               |  1 -
 drivers/i2c/busses/scx200_i2c.c            |  1 -
 drivers/i2c/i2c-core.c                     | 13 +++------
 drivers/i2c/muxes/i2c-arb-gpio-challenge.c |  1 -
 drivers/i2c/muxes/i2c-mux-gpio.c           |  1 -
 drivers/i2c/muxes/i2c-mux-pca9541.c        |  1 -
 drivers/i2c/muxes/i2c-mux-pca954x.c        |  1 -
 drivers/i2c/muxes/i2c-mux-pinctrl.c        |  1 -
 include/linux/i2c.h                        | 16 ++++++++++-
 48 files changed, 64 insertions(+), 77 deletions(-)

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS6PgWAAoJEBQN5MwUoCm2VKsQAKXmRnTE+bYC1BMP0LaAOojH
fCE2gRZhTnircj2Gh/gapLeiE0lUJACBwHWgfAw6S+Ax3DTcvXRzVB/wA5nHOeph
Yahq2gpe40da9/8wJQV8zIo9fgZcQE8tCshHTHLc1VJkPjej/stXlzcRynSNip0Y
YdY9WkplDAQBNU9trrxKzxPz6KWicd0Wilbp3BJlV2+YsA9VqgVqj5HZrbR2msVw
fZdpNuAbN+EEHIIiZ9GmPBV/3ZiAEXbYJtJRghiPSfVqlqAjqVOvOjpwAPo30kjz
33mAYOKHINB0pf5U7+LckNrn1OeDNpXvZe2AxqgNBWb3sHwrLPb+Dvf4336tkrB5
d6O0LSyVufNdFr9kMby6/Hd8tRkrixyDYvmSZkDXIVb/WQC+oazighnbNr0z47iB
3KE3y9V/gl7EcCQy9DCEBC9Qt2Yutqb4oL0nQflgGQN5UEBwGTV8Bpomuq5hJKuo
TJNsT+qhDS649FTt/0q+4UT3UalmYQ9f+Un0dhcUhVcRoDeycBgnPTFuNFDpsEFD
m00P3aG54C71SwQ8uac16eqNir7u5u1XVJ5erlN9QWcikxsZiHy4VyfRBKXfp6cZ
wB7tjhzJZAIscuK0yaINTEYFX2w6h0T9+D6F55vooy4SS8nPe+FjRyiriZl4ggB/
uSy3z8IJlNBpeMgQzrC1
=mjtK
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
