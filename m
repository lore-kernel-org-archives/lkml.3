Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbaAaOTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 09:19:17 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:36751 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263AbaAaOS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 09:18:58 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 09/10] watchdog: xilinx: Add missing binding
Date: Fri, 31 Jan 2014 15:18:18 +0100
Message-Id: <9c721b89ed2ceb6997809bb3363f852277e67dc2.1391177880.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
In-Reply-To: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-23171-1391177934-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-23171-1391177934-0001

Document current driver binding.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

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


--=_mimegpg-monstr-desktop-23171-1391177934-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlLrsM4ACgkQykllyylKDCEetwCfR90ezoQ8kAYOAF21M+LkcxPy
u8sAoJpV2sEEY4tRv9HpRTIZ1TZVDRf6
=067l
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-23171-1391177934-0001--
