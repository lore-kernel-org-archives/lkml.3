Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965402Ab3FTMEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:04:30 -0400
Received: from multi.imgtec.com ([194.200.65.239]:27111 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab3FTMDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:03:23 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6/7] metag: tz1090: select and instantiate pinctrl-tz1090-pdc
Date: Thu, 20 Jun 2013 13:02:37 +0100
Message-ID: <1371729758-10196-7-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371729758-10196-1-git-send-email-james.hogan@imgtec.com>
References: <1371729758-10196-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_20_13_03_19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select PINCTRL_TZ1090_PDC from SOC_TZ1090 to enable the PDC pin
controller driver once it is merged, and instantiate it from
tz1090.dtsi.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 arch/metag/Kconfig.soc          | 1 +
 arch/metag/boot/dts/tz1090.dtsi | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/metag/Kconfig.soc b/arch/metag/Kconfig.soc
index d61d687..973640f 100644
--- a/arch/metag/Kconfig.soc
+++ b/arch/metag/Kconfig.soc
@@ -23,6 +23,7 @@ config SOC_TZ1090
 	select METAG_SMP_WRITE_REORDERING
 	select PINCTRL
 	select PINCTRL_TZ1090
+	select PINCTRL_TZ1090_PDC
 	help
 	  This is a Toumaz Technology Xenif TZ1090 (A.K.A. Comet) SoC containing
 	  a 2-threaded HTP.
diff --git a/arch/metag/boot/dts/tz1090.dtsi b/arch/metag/boot/dts/tz1090.dtsi
index d9e537e..66cf55d 100644
--- a/arch/metag/boot/dts/tz1090.dtsi
+++ b/arch/metag/boot/dts/tz1090.dtsi
@@ -50,6 +50,12 @@
 			reg = <0x02005800 0xe4>;
 		};
 
+		pdc_pinctrl: pinctrl@02006500 {
+			#gpio-range-cells = <3>;
+			compatible = "img,tz1090-pdc-pinctrl";
+			reg = <0x02006500 0x100>;
+		};
+
 		gpios: gpios@02005800 {
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
1.8.1.2


