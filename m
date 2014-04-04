Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaDDOyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:54:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28188 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbaDDOyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:54:35 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-f7-533ec7aa825d
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: t.figa@samsung.com, mturquette@linaro.org, kgene.kim@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, airlied@linux.ie, rob.herring@calxeda.com,
        sylvester.nawrocki@gmail.com, a.hajda@samsung.com, kishon@ti.com,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 3/4] clk: exynos4: enable clk_set_parent() propagation for
 sclk_hdmi and sclk_mixer clocks
Date: Fri, 04 Apr 2014 16:53:20 +0200
Message-id: <1396623201-26000-4-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1396623201-26000-1-git-send-email-t.stanislaws@samsung.com>
References: <1396623201-26000-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t9jQd1Vx+2CDQ4vFbe4te4cq0XvuZNM
	FvOPAFlXvr5ns5h0fwKLRe+Cq2wWF572sFmcbXrDbrHp8TVWi8u75rBZzDi/j8ni6YSLbBaH
	Vxxgspgx+SWbxbzPO5ks1s94zWIxr/0lq4Ogx4LPV9g9ds66y+5x59oeNo/t3x6wetzvPs7k
	sXlJvUffllWMHsdvbGfy+LxJLoAzissmJTUnsyy1SN8ugSvj/Kf7LAWTeSq2r7nN1MC4lKuL
	kZNDQsBE4u2hv0wQtpjEhXvr2boYuTiEBKYzSuz4fZ4FwulikuhtO8sIUsUG1HFsyWdGkISI
	wCpGiYn/n7KDOMwCm5gkdjZ2s4BUCQvkSFxe9RpsLouAqsSfpXeA4hwcvAIeEue3C0KsU5To
	fjaBDcTmFPCU6F3ynRnEFgIq6V6zgGUCI+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmb
	GMEh/kxqB+PKBotDjAIcjEo8vB077IKFWBPLiitzDzFKcDArifDWTQAK8aYkVlalFuXHF5Xm
	pBYfYpTmYFES5z3Qah0oJJCeWJKanZpakFoEk2Xi4JRqYFw+fdLEz+euuofrJP/vXdBj5X1X
	Kubeue23HzzbMuf3I0MrqybFHt9l5VXhhRMb5aWe2bp/vr44Tu7LnlSh8hz/7RXCL7d/DHjY
	wvWa1/j1h/dTH+o3z3+QtPc7n8/B8k7L1bIy78UDN6xmvS+vbXzh+MqZYfOzfudt6mthWGju
	JP/4xjLeFb5KLMUZiYZazEXFiQAbXfv0bQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables clk_set_parent() propagation for clocks used
by s5p-tv and exynos-drm drivers.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/clk/samsung/clk-exynos4.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index 528f8eb..87b8264 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -680,7 +680,8 @@ static struct samsung_gate_clock exynos4_gate_clks[] __initdata = {
 	 * the device name and clock alias names specified below for some
 	 * of the clocks can be removed.
 	 */
-	GATE(CLK_SCLK_HDMI, "sclk_hdmi", "mout_hdmi", SRC_MASK_TV, 0, 0, 0),
+	GATE(CLK_SCLK_HDMI, "sclk_hdmi", "mout_hdmi", SRC_MASK_TV, 0,
+		CLK_SET_PARENT_PARENT, 0),
 	GATE(CLK_SCLK_SPDIF, "sclk_spdif", "mout_spdif", SRC_MASK_PERIL1, 8, 0,
 		0),
 	GATE(CLK_JPEG, "jpeg", "aclk160", GATE_IP_CAM, 6, 0, 0),
@@ -880,7 +881,8 @@ static struct samsung_gate_clock exynos4210_gate_clks[] __initdata = {
 			E4210_SRC_MASK_LCD1, 12, CLK_SET_RATE_PARENT, 0),
 	GATE(CLK_SCLK_SATA, "sclk_sata", "div_sata",
 			SRC_MASK_FSYS, 24, CLK_SET_RATE_PARENT, 0),
-	GATE(CLK_SCLK_MIXER, "sclk_mixer", "mout_mixer", SRC_MASK_TV, 4, 0, 0),
+	GATE(CLK_SCLK_MIXER, "sclk_mixer", "mout_mixer", SRC_MASK_TV, 4,
+			CLK_SET_PARENT_PARENT, 0),
 	GATE(CLK_SCLK_DAC, "sclk_dac", "mout_dac", SRC_MASK_TV, 8, 0, 0),
 	GATE(CLK_TSADC, "tsadc", "aclk100", GATE_IP_PERIL, 15,
 			0, 0),
-- 
1.7.9.5

