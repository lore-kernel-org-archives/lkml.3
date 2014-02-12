Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaBLNgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 08:36:01 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38384 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaBLNf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 08:35:28 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Guenter Roeck <linux@roeck-us.net>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 04/11] watchdog: xilinx: Move no_timeout to probe function
Date: Wed, 12 Feb 2014 14:34:35 +0100
Message-Id: <e1b370a86bbc9b389cfccfccce94014ff0d03788.1392212059.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1392212059.git.michal.simek@xilinx.com>
References: <cover.1392212059.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1392212059.git.michal.simek@xilinx.com>
References: <cover.1392212059.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-11873-1392212123-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-11873-1392212123-0001

no_timeout should be local variable because it is used
only in probe function.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
---

Changes in v3: None
Changes in v2: None

 drivers/watchdog/of_xilinx_wdt.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index 7f371ed..1f7ad91 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -52,7 +52,6 @@ struct xwdt_device {
 static struct xwdt_device xdev;

 static  u32 timeout;
-static  u8  no_timeout;

 static  DEFINE_SPINLOCK(spinlock);

@@ -160,8 +159,7 @@ static int xwdt_probe(struct platform_device *pdev)
 	u32 *tmptr;
 	u32 *pfreq;
 	struct resource *res;
-
-	no_timeout = 0;
+	bool no_timeout = false;

 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	xdev.base = devm_ioremap_resource(&pdev->dev, res);
@@ -173,14 +171,14 @@ static int xwdt_probe(struct platform_device *pdev)

 	if (pfreq == NULL) {
 		pr_warn("The watchdog clock frequency cannot be obtained!\n");
-		no_timeout = 1;
+		no_timeout = true;
 	}

 	tmptr = (u32 *)of_get_property(pdev->dev.of_node,
 					"xlnx,wdt-interval", NULL);
 	if (tmptr == NULL) {
 		pr_warn("Parameter \"xlnx,wdt-interval\" not found in device tree!\n");
-		no_timeout = 1;
+		no_timeout = true;
 	} else {
 		xdev.wdt_interval = *tmptr;
 	}
--
1.8.2.3


--=_mimegpg-monstr-desktop-11873-1392212123-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlL7eJsACgkQykllyylKDCHehwCgizzJMwWPwTNrWobolC+icBMk
KXwAn1jgYiQ2wK3K/9uRKMMHblUjpbqB
=tVRv
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-11873-1392212123-0001--
