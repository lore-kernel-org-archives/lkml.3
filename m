Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaJBNLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:11:45 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:35944 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaJBNLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:11:43 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: zynq: DT: Add cadence watchdog node
Date: Thu,  2 Oct 2014 15:11:27 +0200
Message-Id: <2079bb5b538a78c720cc7a1517c227376da1a3ba.1412255481.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-3789-1412255487-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-3789-1412255487-0001

Add the cadence watchdog node to the Zynq devicetree.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 arch/arm/boot/dts/zynq-7000.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 2690e6d01f71..ea2651cd92ec 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -314,5 +314,16 @@
 			reg = <0xf8f00600 0x20>;
 			clocks = <&clkc 4>;
 		};
+
+		watchdog0: watchdog@f8005000 {
+			clocks = <&clkc 45>;
+			compatible = "xlnx,zynq-wdt-r1p2";
+			device_type = "watchdog";
+			interrupt-parent = <&intc>;
+			interrupts = <0 9 1>;
+			reg = <0xf8005000 0x1000>;
+			reset = <0>;
+			timeout-sec = <10>;
+		};
 	};
 };
--
1.8.2.3


--=_mimegpg-monstr-desktop-3789-1412255487-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlQtTv8ACgkQykllyylKDCF1iACfcj/wTl9A6n18jlexoPqZsIXM
nkMAniS+P4ihESUnBau++sTtCuBbp3Sp
=/ZMu
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-3789-1412255487-0001--
