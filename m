Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaKQAnJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 19:43:09 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:11620 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaKQAnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 19:43:04 -0500
X-AuditID: cbfee68d-f79296d000004278-8b-54694496524e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, broonie@kernel.org, mturquette@linaro.org,
        a.zummo@towertech.it
Cc: lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 3/5] clk: s2mps11: Add the support for S2MPS13 PMIC clock
Date: Mon, 17 Nov 2014 09:42:58 +0900
Message-id: <1416184980-532-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42JZI2JSpDvNJTPEYN4nU4slF6+yW0x9+ITN
	4vqX56wW84+cY7X4M6GVzWLS/QksFmeb3rBb3P96lNHi25UOJovLu+awWTydcJHN4nQ3q8XF
	FV+YHHg9ds66y+6xaVUnm8eda3vYPOadDPTo27KK0WP6vJ9MHp83yQWwR3HZpKTmZJalFunb
	JXBlNB3cylqwXqBiwp7PLA2MJ3m7GDk5JARMJGbNfMUGYYtJXLi3Hsjm4hASWMoo8WpTNxtM
	0YeOQ4wQiemMEp0vN7FCOE1MEnv3tDGDVLEJaEnsf3EDrENEIFri+NPjYB3MAp8ZJZ5d2sTe
	xcjBISzgKdHSrQpisgioSpx7UAJSzivgLNH+/QMjxDIFiWXLZ7KC2JwCLhIbmpeBjRcCqnnz
	+QbYdRICl9glzn89DbaLRUBA4tvkQywgMyUEZCU2HWCGmCMpcXDFDZYJjMILGBlWMYqmFiQX
	FCelFxnqFSfmFpfmpesl5+duYgTGzOl/z3p3MN4+YH2IUYCDUYmHd4NFRogQa2JZcWXuIUZT
	oA0TmaVEk/OBkZlXEm9obGZkYWpiamxkbmmmJM6rKPUzWEggPbEkNTs1tSC1KL6oNCe1+BAj
	EwenVAOjQn9Xs0O0YlvNK9v0mAIW4T9f1ukeV5r0UvDu2gBJkSKmoBnH7lq2H3r951C8jWnn
	N95Ml5+KOZOeP/2RoNzhVVXImtVyx+Pika/Wy+1E666/fb5J/Xak1OyXO15yTN2sNr/U4H6f
	9MFOTudtD8y5Zj2REGGbxPUgxWa1SDKLTPvutXZJxtxKLMUZiYZazEXFiQDne11NlAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t9jQd1pLpkhBruP6FosuXiV3WLqwyds
	Fte/PGe1mH/kHKvFnwmtbBaT7k9gsTjb9Ibd4v7Xo4wW3650MFlc3jWHzeLphItsFqe7WS0u
	rvjC5MDrsXPWXXaPTas62TzuXNvD5jHvZKBH35ZVjB7T5/1k8vi8SS6APaqB0SYjNTEltUgh
	NS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6FolhbLEnFKgUEBicbGS
	vh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY0bTwa2sBesFKibs+czSwHiSt4uRk0NCwETiQ8ch
	RghbTOLCvfVsXYxcHEIC0xklOl9uYoVwmpgk9u5pYwapYhPQktj/4gYbiC0iEC1x/OlxRpAi
	ZoHPjBLPLm1i72Lk4BAW8JRo6VYFMVkEVCXOPSgBKecVcJZo//4BapmCxLLlM1lBbE4BF4kN
	zcvAxgsB1bz5fINtAiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBEflMegfjqgaL
	Q4wCHIxKPLwbLDJChFgTy4orcw8xSnAwK4nwLtHJDBHiTUmsrEotyo8vKs1JLT7EaAp01ERm
	KdHkfGCyyCuJNzQ2MTOyNDI3tDAyNlcS5z3Yah0oJJCeWJKanZpakFoE08fEwSnVwCjsbnuY
	O4JVzlRgZamEqnnbXL/pX1fs5/xy8PTx3wWLikOe+uWkL99yMPRkozujmYnv/fzIelYH1Udl
	EZrxuq2xE660zLWvTpraK/u/vP75121+5V4KF1s40yYwy0pO8Xq/psfAm+1EXumXmNCaPrM5
	7tcZZcWLty1f332k+vH73dk6IW2TlViKMxINtZiLihMBT13oYN4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support for S2MPS13 PMIC clock which is same with existing
S2MPS14 RTC IP. But, S2MPS13 uses all of clocks (32khz_{ap|bt|cp}).

Cc: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/clk/clk-s2mps11.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index b7797fb..7bb13af 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -23,6 +23,7 @@
 #include <linux/clk-provider.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/samsung/s2mps11.h>
+#include <linux/mfd/samsung/s2mps13.h>
 #include <linux/mfd/samsung/s2mps14.h>
 #include <linux/mfd/samsung/s5m8767.h>
 #include <linux/mfd/samsung/core.h>
@@ -120,6 +121,24 @@ static struct clk_init_data s2mps11_clks_init[S2MPS11_CLKS_NUM] = {
 	},
 };
 
+static struct clk_init_data s2mps13_clks_init[S2MPS11_CLKS_NUM] = {
+	[S2MPS11_CLK_AP] = {
+		.name = "s2mps13_ap",
+		.ops = &s2mps11_clk_ops,
+		.flags = CLK_IS_ROOT,
+	},
+	[S2MPS11_CLK_CP] = {
+		.name = "s2mps13_cp",
+		.ops = &s2mps11_clk_ops,
		.flags = CLK_IS_ROOT,
+	},
+	[S2MPS11_CLK_BT] = {
+		.name = "s2mps13_bt",
+		.ops = &s2mps11_clk_ops,
+		.flags = CLK_IS_ROOT,
+	},
+};
+
 static struct clk_init_data s2mps14_clks_init[S2MPS11_CLKS_NUM] = {
 	[S2MPS11_CLK_AP] = {
 		.name = "s2mps14_ap",
@@ -184,6 +203,10 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 		s2mps11_reg = S2MPS11_REG_RTC_CTRL;
 		clks_init = s2mps11_clks_init;
 		break;
+	case S2MPS13X:
+		s2mps11_reg = S2MPS13_REG_RTCCTRL;
+		clks_init = s2mps13_clks_init;
+		break;
 	case S2MPS14X:
 		s2mps11_reg = S2MPS14_REG_RTCCTRL;
 		clks_init = s2mps14_clks_init;
@@ -279,6 +302,7 @@ static int s2mps11_clk_remove(struct platform_device *pdev)
 
 static const struct platform_device_id s2mps11_clk_id[] = {
 	{ "s2mps11-clk", S2MPS11X},
+	{ "s2mps13-clk", S2MPS13X},
 	{ "s2mps14-clk", S2MPS14X},
 	{ "s5m8767-clk", S5M8767X},
 	{ },
-- 
1.8.5.5

