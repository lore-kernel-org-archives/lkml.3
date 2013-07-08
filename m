Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab3GHN30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:29:26 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:46217 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3GHN3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:29:24 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Mark Brown <broonie@kernel.org>, linux-spi <linux-spi@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net
Subject: [PATCH v1 1/4] spi/xilinx: Remove CONFIG_OF from the driver
Date: Mon,  8 Jul 2013 15:29:14 +0200
Message-Id: <ff70173bee5f9223ffea2b92b903b4e46ef8b323.1373290150.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-25808-1373290157-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-25808-1373290157-0001

dev.of_node is in struct device all the time.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/spi/spi-xilinx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index 35503b4..f3de5e5 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -375,7 +375,6 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 		bits_per_word = pdata->bits_per_word;
 	}

-#ifdef CONFIG_OF
 	if (pdev->dev.of_node) {
 		const __be32 *prop;
 		int len;
@@ -386,7 +385,6 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 		if (prop && len >= sizeof(*prop))
 			num_cs = __be32_to_cpup(prop);
 	}
-#endif

 	if (!num_cs) {
 		dev_err(&pdev->dev,
--
1.8.2.3


--=_mimegpg-monstr-desktop-25808-1373290157-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlHavq0ACgkQykllyylKDCE5sACglQAYrddQ8oLj9Kd0MT6ROq8s
AeYAoIR14RsU9s3bjSUT5TF6KyEMsxl6
=grs1
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-25808-1373290157-0001--
