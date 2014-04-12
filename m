Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbaDLR7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 13:59:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57194 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbaDLR7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 13:59:16 -0400
From: Colin King <colin.king@canonical.com>
To: Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: versatile: free icst on error return
Date: Sat, 12 Apr 2014 18:59:14 +0100
Message-Id: <1397325554-1439-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit a183da63 introduced a new error return path that does
not kfree icst if the kmemdup of desc->params fails.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/clk/versatile/clk-icst.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/versatile/clk-icst.c b/drivers/clk/versatile/clk-icst.c
index a820b0c..eb3a1e4 100644
--- a/drivers/clk/versatile/clk-icst.c
+++ b/drivers/clk/versatile/clk-icst.c
@@ -140,6 +140,7 @@ struct clk *icst_clk_register(struct device *dev,
 
 	pclone = kmemdup(desc->params, sizeof(*pclone), GFP_KERNEL);
 	if (!pclone) {
+		kfree(icst);
 		pr_err("could not clone ICST params\n");
 		return ERR_PTR(-ENOMEM);
 	}
-- 
1.9.1

