Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbbA2NI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:08:59 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:42069 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbbA2NIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:08:47 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Barry.Song@csr.com, baruch@tkos.co.il, linux@rempel-privat.de,
        rob.herring@linaro.org, thierry.reding@gmail.com
Subject: [PATCH 9/9] dts: versatile: Add sysregs node
Date: Thu, 29 Jan 2015 14:08:19 +0100
Message-Id: <1422536899-16609-9-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422536899-16609-1-git-send-email-daniel.lezcano@linaro.org>
References: <54CA3044.6070501@linaro.org>
 <1422536899-16609-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

The Versatile boards have the same sysregs as other ARM Ltd boards. Add
the nodes in order to enable support for 24MHz counter as sched_clock.

This is a minimal node definition as the existing sub node definition
used on VExpress has some issues raised by Linus W.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree@vger.kernel.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
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
1.9.1

