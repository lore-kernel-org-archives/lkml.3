Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbaBGNWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:22:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41456 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbaBGLsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:02 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 018/233] clk: exynos5250: fix sysmmu_mfc{l,r} gate clocks
Date: Fri,  7 Feb 2014 11:43:57 +0000
Message-Id: <1391773652-25214-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Bresticker <abrestic@chromium.org>

commit 97c3557c3e0413efb1f021f582d1459760e22727 upstream.

The gate clocks for the MFC sysmmus appear to be flipped, i.e.
GATE_IP_MFC[2] gates sysmmu_mfcl and GATE_IP_MFC[1] gates sysmmu_mfcr.
Fix this so that the MFC will start up.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/clk/samsung/clk-exynos5250.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
index ad9f97b..50c4e3d 100644
--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@ -326,8 +326,8 @@ struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
 	GATE(smmu_gscl2, "smmu_gscl2", "aclk266", GATE_IP_GSCL, 9, 0, 0),
 	GATE(smmu_gscl3, "smmu_gscl3", "aclk266", GATE_IP_GSCL, 10, 0, 0),
 	GATE(mfc, "mfc", "aclk333", GATE_IP_MFC, 0, 0, 0),
-	GATE(smmu_mfcl, "smmu_mfcl", "aclk333", GATE_IP_MFC, 1, 0, 0),
-	GATE(smmu_mfcr, "smmu_mfcr", "aclk333", GATE_IP_MFC, 2, 0, 0),
+	GATE(smmu_mfcl, "smmu_mfcl", "aclk333", GATE_IP_MFC, 2, 0, 0),
+	GATE(smmu_mfcr, "smmu_mfcr", "aclk333", GATE_IP_MFC, 1, 0, 0),
 	GATE(rotator, "rotator", "aclk266", GATE_IP_GEN, 1, 0, 0),
 	GATE(jpeg, "jpeg", "aclk166", GATE_IP_GEN, 2, 0, 0),
 	GATE(mdma1, "mdma1", "aclk266", GATE_IP_GEN, 4, 0, 0),
-- 
1.8.3.2

