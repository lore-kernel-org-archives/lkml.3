Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbbAPMzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:55:20 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48927 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbbAPMzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:55:18 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] spi: xilinx: Use standard num-cs binding
Date: Fri, 16 Jan 2015 13:55:14 +0100
Message-Id: <67f3c196833c427a489ca2c530d08987a6b5ee2a.1421412912.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-28521-1421412914-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-28521-1421412914-0001

Use standard num-cs binding property and setup
"xlnx,num-ss-bits" as deprecated.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/spi/spi-xilinx.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index 79bd84f43430..30e5180195bb 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -338,8 +338,15 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 		num_cs = pdata->num_chipselect;
 		bits_per_word = pdata->bits_per_word;
 	} else {
-		of_property_read_u32(pdev->dev.of_node, "xlnx,num-ss-bits",
-					  &num_cs);
+		if (of_property_read_u32(pdev->dev.of_node, "num-cs",
+					 &num_cs)) {
+			if (!of_property_read_u32(pdev->dev.of_node,
+						  "xlnx,num-ss-bits",
+						  &num_cs)) {
+				dev_err(&pdev->dev,
+					"property name 'xlnx,num-ss-bits' is deprecated.\n");
+			}
+		}
 	}

 	if (!num_cs) {
--
1.8.2.3


--=_mimegpg-monstr-desktop-28521-1421412914-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlS5CjIACgkQykllyylKDCHv/wCfadPigO5FEf+BRTEyCVCvcZx7
9BYAnRlqeZk/yQcoF84u0e/a+yRo3QEe
=UaPi
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-28521-1421412914-0001--
