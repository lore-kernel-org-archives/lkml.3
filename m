Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaANA1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:27:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbaANA1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 3.10 50/62] clk: exynos5250: fix sysmmu_mfc{l,r} gate clocks
Date: Mon, 13 Jan 2014 16:27:15 -0800
Message-Id: <20140114002711.883189840@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/samsung/clk-exynos5250.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@ -325,8 +325,8 @@ struct samsung_gate_clock exynos5250_gat
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


