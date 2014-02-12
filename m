Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaBLNmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 08:42:32 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:37873 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaBLNm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 08:42:27 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: linux@roeck-us.net, wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 11/11] watchdog: xilinx: Remove no_timeout variable
Date: Wed, 12 Feb 2014 14:41:25 +0100
Message-Id: <e0612677b5e59221ff4d91da27f261f2b7bbea66.1392212059.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <bdd7c2c78dd491d02d1c1ae8a59b92b7a1a17ec6.1392212059.git.michal.simek@xilinx.com>
References: <bdd7c2c78dd491d02d1c1ae8a59b92b7a1a17ec6.1392212059.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1392212059.git.michal.simek@xilinx.com>
References: <cover.1392212059.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-12542-1392212540-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-12542-1392212540-0001

Remove no_timeout variable and check variables
directly.

Suggested-by: Rob Herring <robherring2@gmail.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
---

Changes in v3: None
Changes in v2:
- New patch in this series

 drivers/watchdog/of_xilinx_wdt.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index 9dd16cf..c7fb85e 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -147,10 +147,9 @@ static u32 xwdt_selftest(struct xwdt_device *xdev)
 static int xwdt_probe(struct platform_device *pdev)
 {
 	int rc;
-	u32 pfreq, enable_once = 0;
+	u32 pfreq = 0, enable_once = 0;
 	struct resource *res;
 	struct xwdt_device *xdev;
-	bool no_timeout = false;
 	struct watchdog_device *xilinx_wdt_wdd;

 	xdev = devm_kzalloc(&pdev->dev, sizeof(*xdev), GFP_KERNEL);
@@ -168,19 +167,15 @@ static int xwdt_probe(struct platform_device *pdev)
 		return PTR_ERR(xdev->base);

 	rc = of_property_read_u32(pdev->dev.of_node, "clock-frequency", &pfreq);
-	if (rc) {
+	if (rc)
 		dev_warn(&pdev->dev,
 			 "The watchdog clock frequency cannot be obtained\n");
-		no_timeout = true;
-	}

 	rc = of_property_read_u32(pdev->dev.of_node, "xlnx,wdt-interval",
 				  &xdev->wdt_interval);
-	if (rc) {
+	if (rc)
 		dev_warn(&pdev->dev,
 			 "Parameter \"xlnx,wdt-interval\" not found\n");
-		no_timeout = true;
-	}

 	rc = of_property_read_u32(pdev->dev.of_node, "xlnx,wdt-enable-once",
 				  &enable_once);
@@ -194,7 +189,7 @@ static int xwdt_probe(struct platform_device *pdev)
 	 * Twice of the 2^wdt_interval / freq  because the first wdt overflow is
 	 * ignored (interrupt), reset is only generated at second wdt overflow
 	 */
-	if (!no_timeout)
+	if (pfreq && xdev->wdt_interval)
 		xilinx_wdt_wdd->timeout = 2 * ((1 << xdev->wdt_interval) /
 					  pfreq);

--
1.8.2.3


--=_mimegpg-monstr-desktop-12542-1392212540-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlL7ejwACgkQykllyylKDCE0mQCeI62dB0/wgkm4TLxCYhBsMyD5
BzYAn1xlvfxcoHLZVYWcNUcNdm8uMJqp
=g5vY
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-12542-1392212540-0001--
