Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaBLNn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 08:43:27 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:64515 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaBLNmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 08:42:17 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: linux@roeck-us.net, wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 09/11] watchdog: xilinx: Add missing binding
Date: Wed, 12 Feb 2014 14:41:23 +0100
Message-Id: <e05ec518eeefb0c7f08dad884fdf2f6c86c9c957.1392212059.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <bdd7c2c78dd491d02d1c1ae8a59b92b7a1a17ec6.1392212059.git.michal.simek@xilinx.com>
References: <bdd7c2c78dd491d02d1c1ae8a59b92b7a1a17ec6.1392212059.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1392212059.git.michal.simek@xilinx.com>
References: <cover.1392212059.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-12523-1392212532-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-12523-1392212532-0001

Document current driver binding.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---

Changes in v3: None
Changes in v2: None

 .../devicetree/bindings/watchdog/of-xilinx-wdt.txt | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/watchdog/of-xilinx-wdt.txt

diff --git a/Documentation/devicetree/bindings/watchdog/of-xilinx-wdt.txt b/Documentation/devicetree/bindings/watchdog/of-xilinx-wdt.txt
new file mode 100644
index 0000000..6d63782
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/of-xilinx-wdt.txt
@@ -0,0 +1,23 @@
+Xilinx AXI/PLB soft-core watchdog Device Tree Bindings
+---------------------------------------------------------
+
+Required properties:
+- compatible		: Should be "xlnx,xps-timebase-wdt-1.00.a" or
+			  "xlnx,xps-timebase-wdt-1.01.a".
+- reg			: Physical base address and size
+
+Optional properties:
+- clock-frequency	: Frequency of clock in Hz
+- xlnx,wdt-enable-once	: 0 - Watchdog can be restarted
+			  1 - Watchdog can be enabled just once
+- xlnx,wdt-interval	: Watchdog timeout interval in 2^<val> clock cycles,
+			  <val> is integer from 8 to 31.
+
+Example:
+axi-timebase-wdt@40100000 {
+	clock-frequency = <50000000>;
+	compatible = "xlnx,xps-timebase-wdt-1.00.a";
+	reg = <0x40100000 0x10000>;
+	xlnx,wdt-enable-once = <0x0>;
+	xlnx,wdt-interval = <0x1b>;
+} ;
--
1.8.2.3


--=_mimegpg-monstr-desktop-12523-1392212532-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlL7ejQACgkQykllyylKDCFaUgCfQza0A1FXx9uF8Kl0ChdizmKq
a6YAniH7PKQ8PvQJT6tf6iPoFCZm9DsA
=BMBl
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-12523-1392212532-0001--
