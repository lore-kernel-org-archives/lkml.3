Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbbAHAfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:35:05 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:55710 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752396AbbAHAeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:34:36 -0500
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, linux-gpio@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>, Bao Truong <btruong@apm.com>
Subject: [PATCH V3 1/7] arm64: dts: Add APM X-Gene USB DTS node
Date: Wed,  7 Jan 2015 17:33:32 -0700
Message-Id: <1420677218-30743-2-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1420677218-30743-1-git-send-email-fkan@apm.com>
References: <1420677218-30743-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This parch adds the device tree nodes for APM X-Gnene USB host controller.
Since X-Gene SOC supports maximum 2 USB ports, 2 dts node are added.

Signed-off-by: Bao Truong <btruong@apm.com>
Signed-off-by: Feng Kan <fkan@apm.com>
---
 arch/arm64/boot/dts/apm/apm-storm.dtsi |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/boot/dts/apm/apm-storm.dtsi b/arch/arm64/boot/dts/apm/apm-storm.dtsi
index f1ad9c2..4b2ec83 100644
--- a/arch/arm64/boot/dts/apm/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm/apm-storm.dtsi
@@ -587,6 +587,25 @@
 			phy-names = "sata-phy";
 		};
 
+		/*
+		 * Do not change dwusb name, coded for backward compatibility
+		 */
+		usb0: dwusb@19000000 {
+			status = "disabled";
+			compatible = "xhci-platform";
+			reg =  <0x0 0x19000000 0x0 0x100000>;
+			interrupts = <0x0 0x89 0x4>;
+			dma-coherent;
+		};
+
+		usb1: dwusb@19800000 {
+			status = "disabled";
+			compatible = "xhci-platform";
+			reg =  <0x0 0x19800000 0x0 0x100000>;
+			interrupts = <0x0 0x8a 0x4>;
+			dma-coherent;
+		};
+
 		rtc: rtc@10510000 {
 			compatible = "apm,xgene-rtc";
 			reg = <0x0 0x10510000 0x0 0x400>;
-- 
1.7.1

