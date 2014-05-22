Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaEVSCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:02:22 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:57267 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaEVSCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:02:20 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v3] clk: shmobile: mstp: Fix the is_enabled() operation
Date: Thu, 22 May 2014 20:02:14 +0200
Message-Id: <1400781734-19002-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The MSTP[SC]R registers have clock stop bits, not clock enable bits. The
bit value should thus be inverted in the is_enabled() operation.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Mike Turquette <mturquette@linaro.org>
---
v3:
  - This depends on commit 3c90c55dcde745bed81f6447f24ba96bda43d984
    ("drivers: sh: compile drivers/sh/pm_runtime.c if
    ARCH_SHMOBILE_MULTI"), which has entered mainline in v3.15-rc6.

v2:
  - New
---
 drivers/clk/shmobile/clk-mstp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/shmobile/clk-mstp.c b/drivers/clk/shmobile/clk-mstp.c
index 1f6324e29a80..2d2fe773ac81 100644
--- a/drivers/clk/shmobile/clk-mstp.c
+++ b/drivers/clk/shmobile/clk-mstp.c
@@ -112,7 +112,7 @@ static int cpg_mstp_clock_is_enabled(struct clk_hw *hw)
 	else
 		value = clk_readl(group->smstpcr);
 
-	return !!(value & BIT(clock->bit_index));
+	return !(value & BIT(clock->bit_index));
 }
 
 static const struct clk_ops cpg_mstp_clock_ops = {
-- 
1.9.1

