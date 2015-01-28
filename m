Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbbA1VFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:05:23 -0500
Received: from mail-oi0-f44.google.com ([209.85.218.44]:41564 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687AbbA1U4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:56:19 -0500
From: Rob Herring <robh@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>
Subject: [PATCH 3/3] dts: versatile: add sysregs node
Date: Wed, 28 Jan 2015 11:56:32 -0600
Message-Id: <1422467792-2065-4-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422467792-2065-1-git-send-email-robh@kernel.org>
References: <1422467792-2065-1-git-send-email-robh@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Versatile boards have the same sysregs as other ARM Ltd boards. Add
the nodes in order to enable support for 24MHz counter as sched_clock.

This is a minimal node definition as the existing sub node definition
used on VExpress has some issues raised by Linus W.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree@vger.kernel.org
---
 arch/arm/boot/dts/versatile-ab.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/versatile-ab.dts b/arch/arm/boot/dts/versatile-ab.dts
index 27d0d9c..01f4019 100644
--- a/arch/arm/boot/dts/versatile-ab.dts
+++ b/arch/arm/boot/dts/versatile-ab.dts
@@ -252,6 +252,11 @@
 			#size-cells = <1>;
 			ranges = <0 0x10000000 0x10000>;
 
+			sysreg@0 {
+				compatible = "arm,versatile-sysreg", "syscon";
+				reg = <0x00000 0x1000>;
+			};
+
 			aaci@4000 {
 				compatible = "arm,primecell";
 				reg = <0x4000 0x1000>;
-- 
2.1.0

