Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab3JUOXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:23:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64598 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab3JUOTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 10:19:04 -0400
X-AuditID: cbfee61a-b7f836d0000025d7-12-526537d72db6
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, kyungmin.park@samsung.com,
        t.figa@samsung.com, kishon@ti.com, sw0312.kim@samsung.com,
        inki.dae@samsung.com, rahul.sharma@samsung.com, kgene.kim@samsung.com,
        s.nawrocki@samsung.com, thomas.abraham@linaro.org,
        mturquette@linaro.org, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 03/12] clk: exynos4: enable clk_set_parent() propagation for
 sclk_hdmi and sclk_mixer clocks
Date: Mon, 21 Oct 2013 16:18:22 +0200
Message-id: <1382365111-6533-4-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
References: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t9jAd3r5qlBBpOesFvMP3KO1eLK1/ds
	FpPuT2Cx6F1wlc3iwtMeNouzTW/YLS7vmsNmMeP8PiaLpxMusllMWXSY1eLwm3ZWixmTX7JZ
	rJ/xmsViXvtLVotjM5YwOvB73Lm2h83jfvdxJo++LasYPY7f2M7k8XmTXABrFJdNSmpOZllq
	kb5dAlfG6vuH2AuW8lRMu1zawLiBq4uRk0NCwERi3tHHLBC2mMSFe+vZuhi5OIQEFjFKrH79
	khXC6WKS+NXbxwZSxQbUcWzJZ0YQW0QgUeJX811mkCJmgUNMErtbpjCDJIQFciQe32sGK2IR
	UJWYtuUGmM0r4C7x+PZ5Roh18hJP70MM5RTwkDj1ci1YXAio5t23eSwTGHkXMDKsYhRNLUgu
	KE5KzzXUK07MLS7NS9dLzs/dxAgO02dSOxhXNlgcYhTgYFTi4Q1wSQkSYk0sK67MPcQowcGs
	JMJbZZoaJMSbklhZlVqUH19UmpNafIhRmoNFSZz3QKt1oJBAemJJanZqakFqEUyWiYNTqoFR
	ak72FoXozYVzl1/4tsauxV9pVcLph4n5jPlhEgq5TTprBJ0/37fJt8jTCm3nt2Ws2mkXa9D7
	Z/lufx3t+RWndzhw5G7/KbjBtIzh+GvBtHXXeq0P94mntHc48M+fsoRl7v5DqVv4Dkcd3ye5
	Os7NXqSGVaZX8tLVI+uTNSLPlU2oezcjQliJpTgj0VCLuag4EQCX9izdTwIAAA==
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
index df79ca6..1f58b7c 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -605,7 +605,8 @@ static struct samsung_gate_clock exynos4_gate_clks[] __initdata = {
 	 * the device name and clock alias names specified below for some
 	 * of the clocks can be removed.
 	 */
-	GATE(sclk_hdmi, "sclk_hdmi", "mout_hdmi", SRC_MASK_TV, 0, 0, 0),
+	GATE(sclk_hdmi, "sclk_hdmi", "mout_hdmi", SRC_MASK_TV, 0,
+			CLK_SET_PARENT_PARENT, 0),
 	GATE(sclk_spdif, "sclk_spdif", "mout_spdif", SRC_MASK_PERIL1, 8, 0, 0),
 	GATE(jpeg, "jpeg", "aclk160", GATE_IP_CAM, 6, 0, 0),
 	GATE(mie0, "mie0", "aclk160", GATE_IP_LCD0, 1, 0, 0),
@@ -801,7 +802,8 @@ static struct samsung_gate_clock exynos4210_gate_clks[] __initdata = {
 			E4210_SRC_MASK_LCD1, 12, CLK_SET_RATE_PARENT, 0),
 	GATE(sclk_sata, "sclk_sata", "div_sata",
 			SRC_MASK_FSYS, 24, CLK_SET_RATE_PARENT, 0),
-	GATE(sclk_mixer, "sclk_mixer", "mout_mixer", SRC_MASK_TV, 4, 0, 0),
+	GATE(sclk_mixer, "sclk_mixer", "mout_mixer", SRC_MASK_TV, 4,
+			CLK_SET_PARENT_PARENT, 0),
 	GATE(sclk_dac, "sclk_dac", "mout_dac", SRC_MASK_TV, 8, 0, 0),
 	GATE(tsadc, "tsadc", "aclk100", GATE_IP_PERIL, 15,
 			0, 0),
-- 
1.7.9.5

