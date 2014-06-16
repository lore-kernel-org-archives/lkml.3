Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbaFPTj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 15:39:56 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:53755 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838AbaFPTjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 15:39:36 -0400
From: Alex Elder <elder@linaro.org>
To: mporter@linaro.org, bcm@fixthebug.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 5/5] ARM: dts: enable SMP support for bcm21664
Date: Mon, 16 Jun 2014 14:39:47 -0500
Message-Id: <1402947587-13898-6-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402947587-13898-1-git-send-email-elder@linaro.org>
References: <1402947587-13898-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define nodes representing the two Cortex A9 CPUs in a bcm21644 SoC.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 arch/arm/boot/dts/bcm21664.dtsi | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/boot/dts/bcm21664.dtsi b/arch/arm/boot/dts/bcm21664.dtsi
index 8b36682..2016b72 100644
--- a/arch/arm/boot/dts/bcm21664.dtsi
+++ b/arch/arm/boot/dts/bcm21664.dtsi
@@ -27,6 +27,25 @@
 		bootargs = "console=ttyS0,115200n8";
 	};
 
+       cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		enable-method = "brcm,bcm11351-cpu-method";
+		secondary-boot-reg = <0x35004178>;
+
+		cpu0: cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0>;
+		};
+
+		cpu1: cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <1>;
+		};
+	};
+
 	gic: interrupt-controller@3ff00100 {
 		compatible = "arm,cortex-a9-gic";
 		#interrupt-cells = <3>;
-- 
1.9.1

