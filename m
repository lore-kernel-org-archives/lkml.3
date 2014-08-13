Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaHML5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:57:47 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:34837 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaHML5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:57:46 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        Levente Kurusa <levex@linux.com>,
        Srikanth Thokala <sthokal@xilinx.com>,
        Jassi Brar <jassisinghbrar@gmail.com>, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] dma: xilinx: Remove .owner field for driver
Date: Wed, 13 Aug 2014 13:57:42 +0200
Message-Id: <f82330042cf6185a1f4e18232ebf6999662ae48f.1407931050.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-20168-1407931062-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-20168-1407931062-0001

There is no need to init .owner field.

Based on the patch from Peter Griffin <peter.griffin@linaro.org>
"mmc: remove .owner field for drivers using module_platform_driver"

This patch removes the superflous .owner field for drivers which
use the module_platform_driver API, as this is overriden in
platform_driver_register anyway."

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/dma/xilinx/xilinx_vdma.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma/xilinx/xilinx_vdma.c b/drivers/dma/xilinx/xilinx_vdma.c
index 42a13e8d4607..a6e64767186e 100644
--- a/drivers/dma/xilinx/xilinx_vdma.c
+++ b/drivers/dma/xilinx/xilinx_vdma.c
@@ -1365,7 +1365,6 @@ static const struct of_device_id xilinx_vdma_of_ids[] = {
 static struct platform_driver xilinx_vdma_driver = {
 	.driver = {
 		.name = "xilinx-vdma",
-		.owner = THIS_MODULE,
 		.of_match_table = xilinx_vdma_of_ids,
 	},
 	.probe = xilinx_vdma_probe,
--
1.8.2.3


--=_mimegpg-monstr-desktop-20168-1407931062-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlPrUrYACgkQykllyylKDCEXZgCdE3fxdzOBMsIKIWS/3f2QMTM5
VGIAn1fUMk1wJOlJUAvMicpYUK/vjW3T
=91Uu
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-20168-1407931062-0001--
