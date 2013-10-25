Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab3JYNLB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:11:01 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54935 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753495Ab3JYNKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:10:05 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: daniel.lezcano@linaro.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        sboyd@codeaurora.org, kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v2 4/5] ARM: sun5i: a13: Add support for the High Speed Timers
Date: Fri, 25 Oct 2013 14:07:42 +0100
Message-Id: <1382706463-3892-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382706463-3892-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1382706463-3892-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A13 has support for two high speed timers. Now that we
have a driver to support it, we can enable them in the device tree.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Tested-by: Emilio López <emilio@elopez.com.ar>
---
 arch/arm/boot/dts/sun5i-a13.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
index ce8ef2a..1ccd75d 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -273,5 +273,12 @@
 			clock-frequency = <100000>;
 			status = "disabled";
 		};
+
+		timer@01c60000 {
+			compatible = "allwinner,sun5i-a13-hstimer";
+			reg = <0x01c60000 0x1000>;
+			interrupts = <82>, <83>;
+			clocks = <&ahb_gates 28>;
+		};
 	};
 };
-- 
1.8.4

