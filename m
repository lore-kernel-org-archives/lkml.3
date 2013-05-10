Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab3EJQii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 12:38:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64355 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab3EJQig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 12:38:36 -0400
X-AuditID: cbfee61a-b7fd56d0000022fd-a2-518d228a323a
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: mturquette@linaro.org
Cc: kyungmin.park@samsung.com, kgene.kim@samsung.com, inki.dae@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] clk: samsung: Add CLK_IGNORE_UNUSED flag for the sysreg clocks
Date: Fri, 10 May 2013 18:38:09 +0200
Message-id: <1368203889-12547-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIJMWRmVeSWpSXmKPExsVy+t9jAd0upd5Ag4YWK4tJ9yewWPQuuMpm
	cbbpDbvF5V1z2CxmnN/HZPF0wkU2i8Nv2lkd2D3uXNvD5tG3ZRWjx+dNcgHMUVw2Kak5mWWp
	Rfp2CVwZL78tYSqYI1jx8Ml2lgbGc3xdjJwcEgImEmvO/WOHsMUkLtxbz9bFyMUhJLCIUeLg
	xa0sEE4Hk0T/xoUsIFVsAoYSvUf7GEFsEQFJiQefp4MVMQvsYZTYvfwkK0hCWMBf4tvnc8wg
	NouAqsSinvtAKzg4eAXcJJo3OYKYEgIKEnMm2Uxg5F7AyLCKUTS1ILmgOCk911CvODG3uDQv
	XS85P3cTIzggnkntYFzZYHGIUYCDUYmHV0GgN1CINbGsuDL3EKMEB7OSCG/y7Z5AId6UxMqq
	1KL8+KLSnNTiQ4zSHCxK4rwHWq0DhQTSE0tSs1NTC1KLYLJMHJxSDYy220Jfay1nbXpXcZxp
	ouv8a59F3je//aBz5w2vvDGTs2DaqRkL7f76BC81+24rudN5r/Wc7x6qhwx1RXVyhJYfPTRt
	9ke/58WXev0m69SqTov/+JmzQj2CVTzkyUZPtsq6deUVvKqmHbkR2/1vdz/mP1JVrjVTzi+1
	8+nlg17c4f/CGzzuqCuxFGckGmoxFxUnAgAR0mmJBAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently no driver *) handles the sysreg clock, with an assumption
that this clock is always left in its default state (enabled).

Before commit 6e6aac7590f902d14d90bace3fd499
ARM: EXYNOS: Migrate clock support to common clock framework

the sysreg clock was not even defined and hence wasn't handled
explicitly in the kernel.

To restore the previous behaviour disable masking the sysreg clock
off in the clock core by default.

*) Except the Exynos4x12 FIMC-IS driver, which will be modified
   to not touch the sysreg clock.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/clk/samsung/clk-exynos4.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index 070bbeb..0f2f5e5 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -797,7 +797,8 @@ struct samsung_gate_clock exynos4210_gate_clks[] __initdata = {
 	GATE(smmu_pcie, "smmu_pcie", "aclk133", GATE_IP_FSYS, 18, 0, 0),
 	GATE(modemif, "modemif", "aclk100", GATE_IP_PERIL, 28, 0, 0),
 	GATE(chipid, "chipid", "aclk100", E4210_GATE_IP_PERIR, 0, 0, 0),
-	GATE(sysreg, "sysreg", "aclk100", E4210_GATE_IP_PERIR, 0, 0, 0),
+	GATE(sysreg, "sysreg", "aclk100", E4210_GATE_IP_PERIR, 0,
+			CLK_IGNORE_UNUSED, 0),
 	GATE(hdmi_cec, "hdmi_cec", "aclk100", E4210_GATE_IP_PERIR, 11, 0, 0),
 	GATE(smmu_rotator, "smmu_rotator", "aclk200",
 			E4210_GATE_IP_IMAGE, 4, 0, 0),
@@ -826,7 +827,8 @@ struct samsung_gate_clock exynos4x12_gate_clks[] __initdata = {
 	GATE(smmu_mdma, "smmu_mdma", "aclk200", E4X12_GATE_IP_IMAGE, 5, 0, 0),
 	GATE(mipi_hsi, "mipi_hsi", "aclk133", GATE_IP_FSYS, 10, 0, 0),
 	GATE(chipid, "chipid", "aclk100", E4X12_GATE_IP_PERIR, 0, 0, 0),
-	GATE(sysreg, "sysreg", "aclk100", E4X12_GATE_IP_PERIR, 1, 0, 0),
+	GATE(sysreg, "sysreg", "aclk100", E4X12_GATE_IP_PERIR, 1,
+			CLK_IGNORE_UNUSED, 0),
 	GATE(hdmi_cec, "hdmi_cec", "aclk100", E4X12_GATE_IP_PERIR, 11, 0, 0),
 	GATE(sclk_mdnie0, "sclk_mdnie0", "div_mdnie0",
 			SRC_MASK_LCD0, 4, CLK_SET_RATE_PARENT, 0),
--
1.7.9.5

