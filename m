Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaBKG4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 01:56:35 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:62311 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaBKG4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 01:56:23 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Guenter Roeck <linux@roeck-us.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 09/11] watchdog: xilinx: Add missing binding
Date: Tue, 11 Feb 2014 07:55:52 +0100
Message-Id: <85fbb492f75b17b916be694744bb053448e9db96.1392101734.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
References: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
In-Reply-To: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
References: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-9583-1392101779-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-9583-1392101779-0001

Document current driver binding.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---

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


--=_mimegpg-monstr-desktop-9583-1392101779-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlL5yZMACgkQykllyylKDCHhSACeIml2Vfq0xoGN7eRqMrc4RV2X
1E4Ani+WE0hw6ET3Iz0D8ftm5qdOOYOo
=7aWg
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-9583-1392101779-0001--
