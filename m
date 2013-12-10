Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3LJIBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:01:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab3LJIA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:00:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arnaud Ebalard <arno@natisbad.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.10 52/52] ARM: mvebu: second PCIe unit of Armada XP mv78230 is only x1 capable
Date: Tue, 10 Dec 2013 00:01:25 -0800
Message-Id: <20131210075957.820955791@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075954.196229872@linuxfoundation.org>
References: <20131210075954.196229872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaud Ebalard <arno@natisbad.org>

commit 12b69a599745fc9e203f61fbb7160b2cc5f479dd upstream.

Various Marvell datasheets advertise second PCIe unit of mv78230
flavour of Armada XP as x4/quad x1 capable. This second unit is in
fact only x1 capable. This patch fixes current mv78230 .dtsi to
reflect that, i.e. makes 1.0 the second interface (instead of 2.0
at the moment). This was successfully tested on a mv78230-based
ReadyNAS 2120 platform with a x1 device (FL1009 XHCI controller)
connected to this second interface.

Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Acked-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/armada-xp-mv78230.dtsi |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/arm/boot/dts/armada-xp-mv78230.dtsi
+++ b/arch/arm/boot/dts/armada-xp-mv78230.dtsi
@@ -81,7 +81,7 @@
 			/*
 			 * MV78230 has 2 PCIe units Gen2.0: One unit can be
 			 * configured as x4 or quad x1 lanes. One unit is
-			 * x4/x1.
+			 * x1 only.
 			 */
 			pcie-controller {
 				compatible = "marvell,armada-xp-pcie";
@@ -94,10 +94,10 @@
 				bus-range = <0x00 0xff>;
 
 				ranges = <0x82000000 0 0x40000 0x40000 0 0x00002000   /* Port 0.0 registers */
-					0x82000000 0 0x42000 0x42000 0 0x00002000   /* Port 2.0 registers */
 					0x82000000 0 0x44000 0x44000 0 0x00002000   /* Port 0.1 registers */
 					0x82000000 0 0x48000 0x48000 0 0x00002000   /* Port 0.2 registers */
 					0x82000000 0 0x4c000 0x4c000 0 0x00002000   /* Port 0.3 registers */
+					0x82000000 0 0x80000 0x80000 0 0x00002000   /* Port 1.0 registers */
 					0x82000000 0 0xe0000000 0xe0000000 0 0x08000000   /* non-prefetchable memory */
 					0x81000000 0 0	  0xe8000000 0 0x00100000>; /* downstream I/O */
 
@@ -165,19 +165,19 @@
 					status = "disabled";
 				};
 
-				pcie@9,0 {
+				pcie@5,0 {
 					device_type = "pci";
-					assigned-addresses = <0x82000800 0 0x42000 0 0x2000>;
-					reg = <0x4800 0 0 0 0>;
+					assigned-addresses = <0x82000800 0 0x80000 0 0x2000>;
+					reg = <0x2800 0 0 0 0>;
 					#address-cells = <3>;
 					#size-cells = <2>;
 					#interrupt-cells = <1>;
 					ranges;
 					interrupt-map-mask = <0 0 0 0>;
-					interrupt-map = <0 0 0 0 &mpic 99>;
-					marvell,pcie-port = <2>;
+					interrupt-map = <0 0 0 0 &mpic 62>;
+					marvell,pcie-port = <1>;
 					marvell,pcie-lane = <0>;
-					clocks = <&gateclk 26>;
+					clocks = <&gateclk 9>;
 					status = "disabled";
 				};
 			};


