Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaBKG4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 01:56:38 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:61547 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbaBKG41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 01:56:27 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Guenter Roeck <linux@roeck-us.net>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: [PATCH v2 10/11] watchdog: xilinx: Enable this driver for Zynq
Date: Tue, 11 Feb 2014 07:55:53 +0100
Message-Id: <f9631b5faaea2e7eed64aab5922af272ebcf394c.1392101734.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
References: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
In-Reply-To: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
References: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-9597-1392101782-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-9597-1392101782-0001

Enable this driver for Zynq.
Move it to architecture independent Kconfig part.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
---

Changes in v2: None

Build tested by zero day testing system.
---
 drivers/watchdog/Kconfig | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 9db5d3c..6120403 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -111,6 +111,15 @@ config WM8350_WATCHDOG
 	  Support for the watchdog in the WM8350 AudioPlus PMIC.  When
 	  the watchdog triggers the system will be reset.

+config XILINX_WATCHDOG
+	tristate "Xilinx Watchdog timer"
+	select WATCHDOG_CORE
+	help
+	  Watchdog driver for the xps_timebase_wdt ip core.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called of_xilinx_wdt.
+
 # ALPHA Architecture

 # ARM Architecture
@@ -1022,19 +1031,6 @@ config M54xx_WATCHDOG

 # MicroBlaze Architecture

-config XILINX_WATCHDOG
-	tristate "Xilinx Watchdog timer"
-	depends on MICROBLAZE
-	select WATCHDOG_CORE
-	---help---
-	  Watchdog driver for the xps_timebase_wdt ip core.
-
-	  IMPORTANT: The xps_timebase_wdt parent must have the property
-	  "clock-frequency" at device tree.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called of_xilinx_wdt.
-
 # MIPS Architecture

 config ATH79_WDT
--
1.8.2.3


--=_mimegpg-monstr-desktop-9597-1392101782-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlL5yZYACgkQykllyylKDCFMogCdGTVipSJ4+3xz9EZQ7OB9FPcZ
/iMAoJJfo//23LwiXmY96udOsiSYQK93
=98bN
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-9597-1392101782-0001--
