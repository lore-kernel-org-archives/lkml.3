Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaILJdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:33:08 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:54189 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750827AbaILJdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:33:06 -0400
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Sep 2014 05:33:06 EDT
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: mturquette@linaro.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <f9f5f59091b5f35ad85420f18807cf80>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Mark yao <mark.yao@rock-chips.com>
To: Mike Turquette <mturquette@linaro.org>, heiko@sntech.de
Cc: linux-kernel@vger.kernel.org, djkurtz@chromium.org, dianders@chromium.org,
        dkl@rock-chips.com, eddie.cai@rock-chips.com, xjq@rock-chips.com,
        kfx@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yxj@rock-chips.com, cym@rock-chips.com, zhengsq@rock-chips.com,
        caesar.wang@rock-chips.com, kever.yang@rock-chips.com,
        Mark yao <mark.yao@rock-chips.com>
Subject: [PATCH] clk: rockchip: rk3288: fix softreset register count
Date: Fri, 12 Sep 2014 17:24:46 +0800
Message-Id: <1410513887-17459-1-git-send-email-mark.yao@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rk3288 actually has 12 softresets, so fix the register count.

Signed-off-by: Mark yao <mark.yao@rock-chips.com>
---
 drivers/clk/rockchip/clk-rk3288.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index 0d8c6c5..2e1d790 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -711,7 +711,7 @@ static void __init rk3288_clk_init(struct device_node *np)
 	rockchip_clk_register_branches(rk3288_clk_branches,
 				  ARRAY_SIZE(rk3288_clk_branches));
 
-	rockchip_register_softrst(np, 9, reg_base + RK3288_SOFTRST_CON(0),
+	rockchip_register_softrst(np, 12, reg_base + RK3288_SOFTRST_CON(0),
 				  ROCKCHIP_SOFTRST_HIWORD_MASK);
 }
 CLK_OF_DECLARE(rk3288_cru, "rockchip,rk3288-cru", rk3288_clk_init);
-- 
1.9.1

