Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbaIBXEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 19:04:07 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:51568 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbaIBXEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 19:04:04 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 1/3] clk: zynq: Remove unnecessary OOM message
Date: Tue,  2 Sep 2014 16:02:07 -0700
Message-Id: <1409698929-30143-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.0.1.g27b9230
In-Reply-To: <1409698929-30143-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1409698929-30143-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As checkpatch suggests:
  WARNING: Possible unnecessary 'out of memory' message,
remove an error message after failing kmalloc() from the PLL driver.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/clk/zynq/pll.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/clk/zynq/pll.c b/drivers/clk/zynq/pll.c
index cec97596fe65..00d72fb5c036 100644
--- a/drivers/clk/zynq/pll.c
+++ b/drivers/clk/zynq/pll.c
@@ -211,10 +211,8 @@ struct clk *clk_register_zynq_pll(const char *name, const char *parent,
 	};
 
 	pll = kmalloc(sizeof(*pll), GFP_KERNEL);
-	if (!pll) {
-		pr_err("%s: Could not allocate Zynq PLL clk.\n", __func__);
+	if (!pll)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	/* Populate the struct */
 	pll->hw.init = &initd;
-- 
2.1.0.1.g27b9230

