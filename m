Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab3JIXdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 19:33:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35216 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757404Ab3JIXar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 19:30:47 -0400
From: Nishanth Menon <nm@ti.com>
To: Kevin Hilman <khilman@linaro.org>, Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, J Keerthy <j-keerthy@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH V6 15/15] ARM: dts: DRA7: add clock nodes for CPU
Date: Wed, 9 Oct 2013 18:30:14 -0500
Message-ID: <1381361414-8851-13-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381361414-8851-1-git-send-email-nm@ti.com>
References: <1381354144-7134-1-git-send-email-nm@ti.com>
 <1381361414-8851-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Keerthy <j-keerthy@ti.com>

DRA7 platforms use dpll_mpu_ck clock for CPU. Add same to common
definition.

Cc: Benoit Cousson <bcousson@baylibre.com>
[nm@ti.com: keep in sync with clock node changes]
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: J Keerthy <j-keerthy@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 92cbe3b..e723b52 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -42,6 +42,11 @@
 				1000000	1060000
 				1176000	1160000
 				>;
+
+			clocks = <&dpll_mpu_ck>;
+			clock-names = "cpu";
+
+			clock-latency = <300000>; /* From omap-cpufreq driver */
 		};
 		cpu@1 {
 			device_type = "cpu";
-- 
1.7.9.5

