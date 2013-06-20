Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935470Ab3FTMDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:03:44 -0400
Received: from multi.imgtec.com ([194.200.65.239]:27123 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab3FTMDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:03:23 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 7/7] metag: tz1090: instantiate gpio-tz1090-pdc
Date: Thu, 20 Jun 2013 13:02:38 +0100
Message-ID: <1371729758-10196-8-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371729758-10196-1-git-send-email-james.hogan@imgtec.com>
References: <1371729758-10196-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_20_13_03_19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instantiate the PDC GPIO controller driver from tz1090.dtsi ready for
when it is merged.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 arch/metag/boot/dts/tz1090.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/metag/boot/dts/tz1090.dtsi b/arch/metag/boot/dts/tz1090.dtsi
index 66cf55d..24ea7d2 100644
--- a/arch/metag/boot/dts/tz1090.dtsi
+++ b/arch/metag/boot/dts/tz1090.dtsi
@@ -90,5 +90,19 @@
 				gpio-ranges = <&pinctrl 0 60 30>;
 			};
 		};
+
+		pdc_gpios: gpios@02006500 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			compatible = "img,tz1090-pdc-gpio";
+			reg = <0x02006500 0x100>;
+
+			interrupt-parent = <&pdc>;
+			interrupts =	<8  IRQ_TYPE_NONE>,
+					<9  IRQ_TYPE_NONE>,
+					<10 IRQ_TYPE_NONE>;
+			gpio-ranges = <&pdc_pinctrl 0 0 7>;
+		};
 	};
 };
-- 
1.8.1.2


