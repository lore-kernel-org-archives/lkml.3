Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894AbaEML7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:59:33 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:42471 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932671AbaEML7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:59:31 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Subject: [PATCH 2/2] drivers: clk: st: authorize propagate rate change for clockgenD0
Date: Tue, 13 May 2014 13:57:33 +0200
Message-Id: <1399982253-21079-3-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399982253-21079-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1399982253-21079-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-13_03:2014-05-13,2014-05-13,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows the spread of change rate only for clockgenD0
clocks.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
---
 arch/arm/boot/dts/stih407-clock.dtsi | 1 +
 drivers/clk/st/clk-flexgen.c         | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/stih407-clock.dtsi b/arch/arm/boot/dts/stih407-clock.dtsi
index 5f1c83c..7fad261 100644
--- a/arch/arm/boot/dts/stih407-clock.dtsi
+++ b/arch/arm/boot/dts/stih407-clock.dtsi
@@ -204,6 +204,7 @@
 					"CLK_PCM_1",
 					"CLK_PCM_2",
 					"CLK_SPDIFF";
+				set-rate-parent;
 			};
 		};
 
diff --git a/drivers/clk/st/clk-flexgen.c b/drivers/clk/st/clk-flexgen.c
index f3ed700..5629988 100644
--- a/drivers/clk/st/clk-flexgen.c
+++ b/drivers/clk/st/clk-flexgen.c
@@ -306,6 +306,8 @@ void __init st_of_flexgen_setup(struct device_node *np)
 		if (*clk_name == '\0')
 			continue;
 
+		flex_flags = of_clk_get_flags(np);
+
 		clk = clk_register_flexgen(clk_name, parents, num_parents,
 					   reg, rlock, i, flex_flags);
 
-- 
1.9.1

