Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965430Ab3FTMDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:03:25 -0400
Received: from multi.imgtec.com ([194.200.65.239]:27111 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab3FTMDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:03:23 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5/7] metag: tz1090: select and instantiate gpio-tz1090
Date: Thu, 20 Jun 2013 13:02:36 +0100
Message-ID: <1371729758-10196-6-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371729758-10196-1-git-send-email-james.hogan@imgtec.com>
References: <1371729758-10196-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_20_13_03_19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select ARCH_WANT_OPTIONAL_GPIOLIB from SOC_TZ1090 to allow GPIOLIB and
GPIO_TZ1090 (the main gpio driver) to be enabled once it is merged, and
instantiate it from tz1090.dtsi.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 arch/metag/Kconfig.soc          |  1 +
 arch/metag/boot/dts/tz1090.dtsi | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/arch/metag/Kconfig.soc b/arch/metag/Kconfig.soc
index 944dc30..d61d687 100644
--- a/arch/metag/Kconfig.soc
+++ b/arch/metag/Kconfig.soc
@@ -16,6 +16,7 @@ config META21_FPGA
 
 config SOC_TZ1090
 	bool "Toumaz Xenif TZ1090 SoC (Comet)"
+	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select IMGPDC_IRQ
 	select METAG_LNKGET_AROUND_CACHE
 	select METAG_META21
diff --git a/arch/metag/boot/dts/tz1090.dtsi b/arch/metag/boot/dts/tz1090.dtsi
index f9cb189..d9e537e 100644
--- a/arch/metag/boot/dts/tz1090.dtsi
+++ b/arch/metag/boot/dts/tz1090.dtsi
@@ -49,5 +49,40 @@
 			compatible = "img,tz1090-pinctrl";
 			reg = <0x02005800 0xe4>;
 		};
+
+		gpios: gpios@02005800 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "img,tz1090-gpio";
+			reg = <0x02005800 0x90>;
+
+			gpios0: bank@0 {
+				gpio-controller;
+				interrupt-controller;
+				#gpio-cells = <2>;
+				#interrupt-cells = <2>;
+				reg = <0>;
+				interrupts = <13 IRQ_TYPE_LEVEL_HIGH>;
+				gpio-ranges = <&pinctrl 0 0 30>;
+			};
+			gpios1: bank@1 {
+				gpio-controller;
+				interrupt-controller;
+				#gpio-cells = <2>;
+				#interrupt-cells = <2>;
+				reg = <1>;
+				interrupts = <14 IRQ_TYPE_LEVEL_HIGH>;
+				gpio-ranges = <&pinctrl 0 30 30>;
+			};
+			gpios2: bank@2 {
+				gpio-controller;
+				interrupt-controller;
+				#gpio-cells = <2>;
+				#interrupt-cells = <2>;
+				reg = <2>;
+				interrupts = <15 IRQ_TYPE_LEVEL_HIGH>;
+				gpio-ranges = <&pinctrl 0 60 30>;
+			};
+		};
 	};
 };
-- 
1.8.1.2


