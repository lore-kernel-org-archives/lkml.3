Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab3FDOCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:02:55 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36037 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab3FDOCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:02:53 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <pcrost@xilinx.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net
Subject: [PATCH 2/3] spi: spi-xilinx: Clear dma_mask for xilinx spi controller
Date: Tue,  4 Jun 2013 16:02:35 +0200
Message-Id: <c5f546072e530c42e7ca15745ffa16729d72a5ac.1370354549.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <041d7ca272ef9499fab630294e3395110b3e31ac.1370354549.git.michal.simek@xilinx.com>
References: <041d7ca272ef9499fab630294e3395110b3e31ac.1370354549.git.michal.simek@xilinx.com>
In-Reply-To: <041d7ca272ef9499fab630294e3395110b3e31ac.1370354549.git.michal.simek@xilinx.com>
References: <041d7ca272ef9499fab630294e3395110b3e31ac.1370354549.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-11173-1370354569-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-11173-1370354569-0001

From: Michal Simek <monstr@monstr.eu>

mmc_spi driver tests if dma is available
through spi->master->dev.parent->dma_mask.
Microblaze supports DMA but xilinx_spi IP doesn't.
That's why clear dma_mask in the driver.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/spi/spi-xilinx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index 34d18dc..d690756 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -365,6 +365,9 @@ struct spi_master *xilinx_spi_init(struct device *dev, struct resource *mem,
 	if (!master)
 		return NULL;

+	/* clear the dma_mask, to try to disable use of dma */
+	master->dev.dma_mask = 0;
+
 	/* the spi->mode bits understood by this driver: */
 	master->mode_bits = SPI_CPOL | SPI_CPHA;

--
1.8.2.3


--=_mimegpg-monstr-desktop-11173-1370354569-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGt84kACgkQykllyylKDCGz3ACfS21iks94Xw6NYdhalm0PQdze
zgoAoJvw+q+mHR1k8SAWqbNDLzsDwuiZ
=YTp1
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-11173-1370354569-0001--
