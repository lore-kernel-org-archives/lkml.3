Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab3LSL4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:56:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44656 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab3LSL4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:56:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 055/208] ARM: mvebu: use the virtual CPU registers to access coherency registers
Date: Thu, 19 Dec 2013 11:52:33 +0000
Message-Id: <1387454106-19326-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory CLEMENT <gregory.clement@free-electrons.com>

commit b6dda00cddcc71d2030668bc0cc0fed758c411c2 upstream.

The Armada XP provides a mechanism called "virtual CPU registers" or
"per-CPU register banking", to access the per-CPU registers of the
current CPU, without having to worry about finding on which CPU we're
running. CPU0 has its registers at 0x21800, CPU1 at 0x21900, CPU2 at
0x21A00 and CPU3 at 0x21B00. The virtual registers accessing the
current CPU registers are at 0x21000.

However, in the Device Tree node that provides the register addresses
for the coherency unit (which is responsible for ensuring coherency
between processors, and I/O coherency between processors and the
DMA-capable devices), a mistake was made: the CPU0-specific registers
were specified instead of the virtual CPU registers. This means that
the coherency barrier needed for I/O coherency was not behaving
properly when executed from a CPU different from CPU0. This patch
fixes that by using the virtual CPU registers.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Fixes: e60304f8cb7bb5 "arm: mvebu: Add hardware I/O Coherency support"
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/boot/dts/armada-370-xp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
index 90b1176..c058ce1 100644
--- a/arch/arm/boot/dts/armada-370-xp.dtsi
+++ b/arch/arm/boot/dts/armada-370-xp.dtsi
@@ -60,7 +60,7 @@
 
 			coherency-fabric@20200 {
 				compatible = "marvell,coherency-fabric";
-				reg = <0x20200 0xb0>, <0x21810 0x1c>;
+				reg = <0x20200 0xb0>, <0x21010 0x1c>;
 			};
 
 			serial@12000 {
-- 
1.8.3.2

