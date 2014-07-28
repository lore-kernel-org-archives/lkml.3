Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaG1JRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 05:17:46 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:62844 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaG1JRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 05:17:45 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Appana Durga Kedareswara Rao <appanad@xilinx.com>, monstr@monstr.eu,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] ARM: zynq: DT: Add CAN node
Date: Mon, 28 Jul 2014 11:17:31 +0200
Message-Id: <e3f45b291bb1247787d1092dbe191e852e1758f3.1406539042.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-23289-1406539051-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-23289-1406539051-0001

Add node describing Zynq's CAN controller.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Changes in v3:
- Fix clocks description for can1

Changes in v2:
- Add can1
- Enable can0 for zc702
- Use status property

 arch/arm/boot/dts/zynq-7000.dtsi | 26 +++++++++++++++++++++++++-
 arch/arm/boot/dts/zynq-zc702.dts |  4 ++++
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index ef11dab30446..6cc83d4c6c76 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -71,7 +71,31 @@
 			interrupts = <0 7 4>;
 			interrupt-parent = <&intc>;
 			clocks = <&clkc 12>;
-		};
+		};
+
+		can0: can@e0008000 {
+			compatible = "xlnx,zynq-can-1.0";
+			status = "disabled";
+			clocks = <&clkc 19>, <&clkc 36>;
+			clock-names = "can_clk", "pclk";
+			reg = <0xe0008000 0x1000>;
+			interrupts = <0 28 4>;
+			interrupt-parent = <&intc>;
+			tx-fifo-depth = <0x40>;
+			rx-fifo-depth = <0x40>;
+		};
+
+		can1: can@e0009000 {
+			compatible = "xlnx,zynq-can-1.0";
+			status = "disabled";
+			clocks = <&clkc 20>, <&clkc 37>;
+			clock-names = "can_clk", "pclk";
+			reg = <0xe0009000 0x1000>;
+			interrupts = <0 51 4>;
+			interrupt-parent = <&intc>;
+			tx-fifo-depth = <0x40>;
+			rx-fifo-depth = <0x40>;
+		};

 		gpio0: gpio@e000a000 {
 			compatible = "xlnx,zynq-gpio-1.0";
diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
index 5e09cee33d42..835c3089c61c 100644
--- a/arch/arm/boot/dts/zynq-zc702.dts
+++ b/arch/arm/boot/dts/zynq-zc702.dts
@@ -29,6 +29,10 @@

 };

+&can0 {
+	status = "okay";
+};
+
 &gem0 {
 	status = "okay";
 	phy-mode = "rgmii";
--
1.8.2.3


--=_mimegpg-monstr-desktop-23289-1406539051-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlPWFSsACgkQykllyylKDCGfPwCdG6iDKZzIgahhjQmgWkR7eI8t
QgQAn2tQzEYKKFaEVyf9/q1iLCwrsfB+
=WMwn
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-23289-1406539051-0001--
