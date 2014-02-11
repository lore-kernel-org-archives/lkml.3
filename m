Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaBKG4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 01:56:19 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:36905 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbaBKG4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 01:56:14 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Guenter Roeck <linux@roeck-us.net>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 06/11] watchdog: xilinx: Fix all printk messages
Date: Tue, 11 Feb 2014 07:55:49 +0100
Message-Id: <431a55ec5ff9085997c7655f51be654848c23b2d.1392101734.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
References: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
In-Reply-To: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
References: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-9542-1392101770-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-9542-1392101770-0001

Use dev_ functions for printk messages.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
---

Changes in v2: None

 drivers/watchdog/of_xilinx_wdt.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index d28bd3f..c229cc4 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -10,8 +10,6 @@
  * 2 of the License, or (at your option) any later version.
  */

-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -42,7 +40,6 @@
 #define XWT_TIMER_FAILED            0xFFFFFFFF

 #define WATCHDOG_NAME     "Xilinx Watchdog"
-#define PFX WATCHDOG_NAME ": "

 struct xwdt_device {
 	void __iomem *base;
@@ -175,14 +172,16 @@ static int xwdt_probe(struct platform_device *pdev)
 					"clock-frequency", NULL);

 	if (pfreq == NULL) {
-		pr_warn("The watchdog clock frequency cannot be obtained!\n");
+		dev_warn(&pdev->dev,
+			 "The watchdog clock frequency cannot be obtained\n");
 		no_timeout = true;
 	}

 	tmptr = (u32 *)of_get_property(pdev->dev.of_node,
 					"xlnx,wdt-interval", NULL);
 	if (tmptr == NULL) {
-		pr_warn("Parameter \"xlnx,wdt-interval\" not found in device tree!\n");
+		dev_warn(&pdev->dev,
+			 "Parameter \"xlnx,wdt-interval\" not found\n");
 		no_timeout = true;
 	} else {
 		xdev->wdt_interval = *tmptr;
@@ -191,7 +190,8 @@ static int xwdt_probe(struct platform_device *pdev)
 	tmptr = (u32 *)of_get_property(pdev->dev.of_node,
 					"xlnx,wdt-enable-once", NULL);
 	if (tmptr == NULL) {
-		pr_warn("Parameter \"xlnx,wdt-enable-once\" not found in device tree!\n");
+		dev_warn(&pdev->dev,
+			 "Parameter \"xlnx,wdt-enable-once\" not found\n");
 		watchdog_set_nowayout(xilinx_wdt_wdd, true);
 	}

@@ -208,13 +208,13 @@ static int xwdt_probe(struct platform_device *pdev)

 	rc = xwdt_selftest(xdev);
 	if (rc == XWT_TIMER_FAILED) {
-		pr_err("SelfTest routine error!\n");
+		dev_err(&pdev->dev, "SelfTest routine error\n");
 		return rc;
 	}

 	rc = watchdog_register_device(xilinx_wdt_wdd);
 	if (rc) {
-		pr_err("cannot register watchdog (err=%d)\n", rc);
+		dev_err(&pdev->dev, "Cannot register watchdog (err=%d)\n", rc);
 		return rc;
 	}

--
1.8.2.3


--=_mimegpg-monstr-desktop-9542-1392101770-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlL5yYoACgkQykllyylKDCFGLgCeKZK3RW4xLCr9YTxrpY9EHtyF
wAsAn1xusgPxTjdiuFBt/IKiVodw0sen
=lMks
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-9542-1392101770-0001--
