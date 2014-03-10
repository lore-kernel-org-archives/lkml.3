Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbaCJMuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:50:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47316 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbaCJMuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:50:12 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <kishon@ti.com>, <george.cherian@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <rogerq@ti.com>,
        Mike Turquette <mturquette@linaro.org>, Tero Kristo <t-kristo@ti.com>
Subject: [PATCH v2 1/8] ARM: dts: dra7: Initialize USB_DPLL
Date: Mon, 10 Mar 2014 14:49:21 +0200
Message-ID: <1394455761-19226-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394197751-28984-2-git-send-email-rogerq@ti.com>
References: <1394197751-28984-2-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB_DPLL must be initialized and locked at boot so that
USB modules can work.

Program USB_DLL_M2 output to half rate as well.

Patch depends on
https://www.mail-archive.com/linux-omap@vger.kernel.org/msg101300.html

CC: Mike Turquette <mturquette@linaro.org>
CC: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 597979b..f376923 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -815,3 +815,11 @@
 };
 
 /include/ "dra7xx-clocks.dtsi"
+
+&dpll_usb_ck {
+        default-rate = <960000000>;
+};
+
+&dpll_usb_m2_ck {
+	default-rate = <480000000>;
+};
-- 
1.8.3.2

