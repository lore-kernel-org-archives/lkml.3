Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351AbaFPTkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 15:40:53 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:56092 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815AbaFPTjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 15:39:31 -0400
From: Alex Elder <elder@linaro.org>
To: mporter@linaro.org, bcm@fixthebug.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/5] devicetree: bindings: document Broadcom CPU enable method
Date: Mon, 16 Jun 2014 14:39:43 -0500
Message-Id: <1402947587-13898-2-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402947587-13898-1-git-send-email-elder@linaro.org>
References: <1402947587-13898-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Broadcom mobile SoCs use a ROM-implemented holding pen for
controlled boot of secondary cores.  A special register is
used to communicate to the ROM that a secondary core should
start executing kernel code.  This enable method is currently
used for members of the bcm281xx and bcm21664 SoC families.

The use of an enable method also allows the SMP operation vector to
be assigned as a result of device tree content for these SoCs.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 Documentation/devicetree/bindings/arm/cpus.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
index 1fe72a0..cdca080 100644
--- a/Documentation/devicetree/bindings/arm/cpus.txt
+++ b/Documentation/devicetree/bindings/arm/cpus.txt
@@ -184,6 +184,7 @@ nodes to be present and contain the properties described below.
 			  can be one of:
 			    "allwinner,sun6i-a31"
 			    "arm,psci"
+			    "brcm,bcm11351-cpu-method"
 			    "marvell,armada-375-smp"
 			    "marvell,armada-380-smp"
 			    "marvell,armada-xp-smp"
@@ -215,6 +216,17 @@ nodes to be present and contain the properties described below.
 		Value type: <phandle>
 		Definition: Specifies the ACC[2] node associated with this CPU.
 
+	- secondary-boot-reg
+		Usage:
+			Required for systems that have an "enable-method"
+			property value of "brcm,bcm11351-cpu-method".
+		Value type: <u32>
+		Definition:
+			Specifies the physical address of the register used to
+			request the ROM holding pen code release a secondary
+			CPU.  The value written to the register is formed by
+			encoding the target CPU id into the low bits of the
+			physical start address it should jump to.
 
 Example 1 (dual-cluster big.LITTLE system 32-bit):
 
-- 
1.9.1

