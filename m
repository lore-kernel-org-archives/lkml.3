Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbaF0N24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 09:28:56 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:34851 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753276AbaF0N0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 09:26:37 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH v2 14/14] drivers: clk: st: Use round to closest divider flag
Date: Fri, 27 Jun 2014 15:25:11 +0200
Message-Id: <1403875511-7710-15-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403875511-7710-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1403875511-7710-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-27_03:2014-06-27,2014-06-27,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses CLK_DIVIDER_ROUND_CLOSEST flag to specify
the divider has to round to closest div.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Acked-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/clk/st/clkgen-mux.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/st/clkgen-mux.c b/drivers/clk/st/clkgen-mux.c
index 9bdedc8..79dc40b 100644
--- a/drivers/clk/st/clkgen-mux.c
+++ b/drivers/clk/st/clkgen-mux.c
@@ -774,7 +774,8 @@ void __init st_of_clkgen_vcc_setup(struct device_node *np)
 		div->reg = reg + VCC_DIV_OFFSET;
 		div->shift = 2 * i;
 		div->width = 2;
-		div->flags = CLK_DIVIDER_POWER_OF_TWO;
+		div->flags = CLK_DIVIDER_POWER_OF_TWO |
+			CLK_DIVIDER_ROUND_CLOSEST;
 
 		mux->reg = reg + VCC_MUX_OFFSET;
 		mux->shift = 2 * i;
-- 
1.9.1

