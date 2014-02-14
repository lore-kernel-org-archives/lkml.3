Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaBNSaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:30:06 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:55833 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbaBNSaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:30:00 -0500
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org
Cc: Alex Elder <elder@linaro.org>, Tim Kryger <tim.kryger@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] clk: bcm281xx: don't disable unused peripheral clocks
Date: Fri, 14 Feb 2014 12:29:19 -0600
Message-Id: <1392402560-12929-3-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392402560-12929-1-git-send-email-elder@linaro.org>
References: <1392402560-12929-1-git-send-email-elder@linaro.org>
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

