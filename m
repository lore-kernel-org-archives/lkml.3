Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaHMLwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:52:51 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:47134 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaHMLwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:52:47 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH 2/2] spi: cadence: Remove .owner field for driver
Date: Wed, 13 Aug 2014 13:52:40 +0200
Message-Id: <ba125364e38ac9a2a5e0c73039b1c83e7e1aa357.1407930755.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <d35c656e50eb7cc951499f13ef339d6aa1a23deb.1407930755.git.michal.simek@xilinx.com>
References: <d35c656e50eb7cc951499f13ef339d6aa1a23deb.1407930755.git.michal.simek@xilinx.com>
In-Reply-To: <d35c656e50eb7cc951499f13ef339d6aa1a23deb.1407930755.git.michal.simek@xilinx.com>
References: <d35c656e50eb7cc951499f13ef339d6aa1a23deb.1407930755.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-18634-1407930763-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-18634-1407930763-0001

There is no need to init .owner field.

Based on the patch from Peter Griffin <peter.griffin@linaro.org>
"mmc: remove .owner field for drivers using module_platform_driver"

This patch removes the superflous .owner field for drivers which
use the module_platform_driver API, as this is overriden in
platform_driver_register anyway."

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/spi/spi-cadence.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/spi/spi-cadence.c b/drivers/spi/spi-cadence.c
index 562ff83debd9..7b811e38c7ad 100644
--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -677,7 +677,6 @@ static struct platform_driver cdns_spi_driver = {
 	.remove	= cdns_spi_remove,
 	.driver = {
 		.name = CDNS_SPI_NAME,
-		.owner = THIS_MODULE,
 		.of_match_table = cdns_spi_of_match,
 		.pm = &cdns_spi_dev_pm_ops,
 	},
--
1.8.2.3


--=_mimegpg-monstr-desktop-18634-1407930763-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlPrUYsACgkQykllyylKDCHxjgCfRWAvlx8/w9bfqbgGsJojbWev
kL0An1UuN3Rtd+53f1MzqpYa9o2VkzO1
=yRfh
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-18634-1407930763-0001--
