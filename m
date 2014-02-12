Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbaBLUFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 15:05:51 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:51246 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbaBLUFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 15:05:37 -0500
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org
Cc: Matt Porter <mporter@linaro.org>, Alex Elder <elder@linaro.org>,
        Tim Kryger <tim.kryger@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: bcm281xx: don't disable unused peripheral clocks
Date: Wed, 12 Feb 2014 14:05:23 -0600
Message-Id: <1392235528-25795-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the CLK_IGNORE_UNUSED flag when setting up a peripheral clock.
This prevents unused clocks from getting disabled, and by doing
this we can use the common clock code even before we've resolved
all the spots that need to get a reference to their clock.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Matt Porter <mporter@linaro.org>
---
 drivers/clk/bcm/clk-kona-setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/bcm/clk-kona-setup.c b/drivers/clk/bcm/clk-kona-setup.c
index f1e88fe..c7607fe 100644
--- a/drivers/clk/bcm/clk-kona-setup.c
+++ b/drivers/clk/bcm/clk-kona-setup.c
@@ -579,7 +579,7 @@ static int peri_clk_setup(struct ccu_data *ccu, struct peri_clk_data *data,
 			struct clk_init_data *init_data)
 {
 	init_data->ops = &kona_peri_clk_ops;
-	init_data->flags = 0;
+	init_data->flags = CLK_IGNORE_UNUSED;
 
 	return clk_sel_setup(data->clocks, &data->sel, init_data);
 }
-- 
1.7.9.5

