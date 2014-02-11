Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaBKG5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 01:57:12 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:52092 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaBKG43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 01:56:29 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Guenter Roeck <linux@roeck-us.net>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 11/11] watchdog: xilinx: Remove no_timeout variable
Date: Tue, 11 Feb 2014 07:55:54 +0100
Message-Id: <52d86e3f2b957411deafbdfbd4bf93bb78f491ac.1392101734.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
References: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
In-Reply-To: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
References: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-9611-1392101786-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-9611-1392101786-0001

Remove no_timeout variable and check variables
directly.

Suggested-by: Rob Herring <robherring2@gmail.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Changes in v2:
- New patch in this series

 drivers/watchdog/of_xilinx_wdt.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index dad8fb5..fc91285 100644
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
@@ -195,7 +190,7 @@ static int xwdt_probe(struct platform_device *pdev)
 	 * Twice of the 2^wdt_interval / freq  because the first wdt overflow is
 	 * ignored (interrupt), reset is only generated at second wdt overflow
 	 */
-	if (!no_timeout)
+	if (pfreq && xdev->wdt_interval)
 		xilinx_wdt_wdd->timeout = 2 * ((1 << xdev->wdt_interval) /
 					  pfreq);

--
1.8.2.3


--=_mimegpg-monstr-desktop-9611-1392101786-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlL5yZoACgkQykllyylKDCHQ6gCcCFpUU6bCC6KkTf++tZ1jz71N
0IMAnjq7VC69Wx/a5il+e9fYLxTin89Y
=qnh8
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-9611-1392101786-0001--
