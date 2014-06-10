Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaFJLO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 07:14:59 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:59056 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaFJLO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:14:56 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Bresticker <abrestic@chromium.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] ARM: tegra: jetson-tk1: Add XUSB pad controller
Date: Tue, 10 Jun 2014 13:11:48 +0200
Message-Id: <1402398708-10722-4-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1402398708-10722-1-git-send-email-thierry.reding@gmail.com>
References: <1402398708-10722-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Assign lanes to the XUSB pads as used on the Jetson TK1.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm/boot/dts/tegra124-jetson-tk1.dts | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
index e31fb61a81d3..38d30877057c 100644
--- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
+++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
@@ -1619,6 +1619,32 @@
 		nvidia,sys-clock-req-active-high;
 	};
 
+	padctl@0,7009f000 {
+		pinctrl-0 = <&padctl_default>;
+		pinctrl-names = "default";
+
+		padctl_default: pinmux {
+			usb3 {
+				nvidia,lanes = "pcie-0", "pcie-1";
+				nvidia,function = "usb3";
+				nvidia,iddq = <0>;
+			};
+
+			pcie {
+				nvidia,lanes = "pcie-2", "pcie-3",
+					       "pcie-4";
+				nvidia,function = "pcie";
+				nvidia,iddq = <0>;
+			};
+
+			sata {
+				nvidia,lanes = "sata-0";
+				nvidia,function = "sata";
+				nvidia,iddq = <0>;
+			};
+		};
+	};
+
 	/* SD card */
 	sdhci@0,700b0400 {
 		status = "okay";
-- 
1.9.2

