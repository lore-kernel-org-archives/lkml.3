Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbaGVJ2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:28:41 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:34116 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbaGVJ2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:28:39 -0400
Date: Tue, 22 Jul 2014 10:28:34 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kernel@stlinux.com, maxime.coquelin@st.com, devicetree@vger.kernel.org
Subject: [PATCH v2 1/1] ARM: DT: STi: STiH416: Add DT node for ST's SATA
 device
Message-ID: <20140722092834.GA8406@lee--X1>
References: <1405931573-12407-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405931573-12407-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM: DT: STi: STiH416: Add DT node for ST's SATA device
    
Cc: devicetree@vger.kernel.org
Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/arch/arm/boot/dts/stih416-b2020.dts b/arch/arm/boot/dts/stih416-b2020.dts
index c3c2ac6..eb2f246 100644
--- a/arch/arm/boot/dts/stih416-b2020.dts
+++ b/arch/arm/boot/dts/stih416-b2020.dts
@@ -23,5 +23,9 @@
 				st,pcie-tx-pol-inv;
 			};
 		};
+
+		sata0: sata@fe380000{
+			status = "okay";
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/stih416-b2020e.dts b/arch/arm/boot/dts/stih416-b2020e.dts
index 80aff0f..99a699e 100644
--- a/arch/arm/boot/dts/stih416-b2020e.dts
+++ b/arch/arm/boot/dts/stih416-b2020e.dts
@@ -41,5 +41,9 @@
 				st,pcie-tx-pol-inv;
 			};
 		};
+
+		sata0: sata@fe380000{
+			status = "okay";
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 2b98a0a..060dd53 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -258,5 +258,21 @@
 				reg-names = "sata", "pcie", "syscfg";
 			};
 		};
+
+		sata0: sata@fe380000 {
+			compatible      = "st,sti-ahci";
+			reg             = <0xfe380000 0x1000>;
+			interrupts      = <GIC_SPI 157 IRQ_TYPE_NONE>;
+			interrupt-names = "hostc";
+			phys	        = <&phy_port0 MIPHY_TYPE_SATA>;
+			phy-names       = "sata-phy";
+			resets	        = <&powerdown STIH416_SATA0_POWERDOWN>,
+					  <&softreset STIH416_SATA0_SOFTRESET>;
+			reset-names     = "pwr-dwn", "sw-rst";
+			clock-names     = "ahci_clk";
+			clocks	        = <&clk_s_a0_ls CLK_ICN_REG>;
+
+			status	        = "disabled";
+		};
 	};
 };
