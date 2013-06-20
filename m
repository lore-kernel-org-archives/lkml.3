Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965189Ab3FTMDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:03:22 -0400
Received: from multi.imgtec.com ([194.200.65.239]:27107 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab3FTMDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:03:21 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/7] metag: tz1090: select and instantiate pinctrl-tz1090
Date: Thu, 20 Jun 2013 13:02:35 +0100
Message-ID: <1371729758-10196-5-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371729758-10196-1-git-send-email-james.hogan@imgtec.com>
References: <1371729758-10196-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_20_13_03_19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select PINCTRL and PINCTRL_TZ1090 from SOC_TZ1090 to enable the main pin
controller driver once it is merged, and instantiate it from
tz1090.dtsi.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 arch/metag/Kconfig.soc          | 2 ++
 arch/metag/boot/dts/tz1090.dtsi | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/metag/Kconfig.soc b/arch/metag/Kconfig.soc
index 433befd..944dc30 100644
--- a/arch/metag/Kconfig.soc
+++ b/arch/metag/Kconfig.soc
@@ -20,6 +20,8 @@ config SOC_TZ1090
 	select METAG_LNKGET_AROUND_CACHE
 	select METAG_META21
 	select METAG_SMP_WRITE_REORDERING
+	select PINCTRL
+	select PINCTRL_TZ1090
 	help
 	  This is a Toumaz Technology Xenif TZ1090 (A.K.A. Comet) SoC containing
 	  a 2-threaded HTP.
diff --git a/arch/metag/boot/dts/tz1090.dtsi b/arch/metag/boot/dts/tz1090.dtsi
index 0ed8023..f9cb189 100644
--- a/arch/metag/boot/dts/tz1090.dtsi
+++ b/arch/metag/boot/dts/tz1090.dtsi
@@ -43,5 +43,11 @@
 			             <29 IRQ_TYPE_LEVEL_HIGH>, /* Perip 1 (IR) */
 			             <31 IRQ_TYPE_LEVEL_HIGH>; /* Perip 2 (WDT) */
 		};
+
+		pinctrl: pinctrl@02005800 {
+			#gpio-range-cells = <3>;
+			compatible = "img,tz1090-pinctrl";
+			reg = <0x02005800 0xe4>;
+		};
 	};
 };
-- 
1.8.1.2


