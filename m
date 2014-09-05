Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaIEGbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:31:00 -0400
Received: from kepler.killerwolves.net ([103.4.235.74]:51827 "EHLO
	kepler.killerwolves.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaIEGa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:30:59 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2014 02:30:58 EDT
X-Spam-Check-By: kepler
From: klightspeed@killerwolves.net
To: linux-arm-kernel@lists.infradead.org, Arnaud Ebalard <arno@natisbad.org>
Cc: Ben Peddell <klightspeed@killerwolves.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: MVEBU: Netgear RN102: Use Hardware BCH ECC
Date: Fri,  5 Sep 2014 16:23:53 +1000
Message-Id: <1409898233-9273-1-git-send-email-klightspeed@killerwolves.net>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bootloader on the Netgear ReadyNAS RN102 uses Hardware BCH ECC
(strength = 4), while the pxa3xx NAND driver by default uses 
Hamming ECC (strength = 1).

This patch changes the ECC mode on these machines to match that
of the bootloader and of the stock firmware, so that for example
updating the kernel is possible without requiring a serial
connection.

This patch depends on commit 5b3e507 (mtd: nand: pxa3xx: Use ECC
strength and step size devicetree binding)

Signed-off-by: Ben Peddell <klightspeed@killerwolves.net>
---
 arch/arm/boot/dts/armada-370-netgear-rn102.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/armada-370-netgear-rn102.dts b/arch/arm/boot/dts/armada-370-netgear-rn102.dts
index d6d572e..285524f 100644
--- a/arch/arm/boot/dts/armada-370-netgear-rn102.dts
+++ b/arch/arm/boot/dts/armada-370-netgear-rn102.dts
@@ -143,6 +143,10 @@
 				marvell,nand-enable-arbiter;
 				nand-on-flash-bbt;
 
+				/* Use Hardware BCH ECC */
+				nand-ecc-strength = <4>;
+				nand-ecc-step-size = <512>;
+
 				partition@0 {
 					label = "u-boot";
 					reg = <0x0000000 0x180000>;  /* 1.5MB */
-- 
1.8.5.5

