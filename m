Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaBKNPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:15:19 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:47587 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaBKNPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:15:17 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, mturquette@linaro.org
Cc: nicolas.ferre@atmel.com, b.brezillon@overkiz.com,
        linux-arm-kernel@lists.infradead.org,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] clk:at91: Fix memory leak in of_at91_clk_master_setup()
Date: Tue, 11 Feb 2014 22:15:07 +0900
Message-Id: <1392124507-14463-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cppcheck detected following error
[clk-master.c:245]: (error) Memory leak: characteristics

The original code forgot to free characteristics when
irq_of_parse_and_map() failed.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/clk/at91/clk-master.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/at91/clk-master.c b/drivers/clk/at91/clk-master.c
index bd313f7..c1af80b 100644
--- a/drivers/clk/at91/clk-master.c
+++ b/drivers/clk/at91/clk-master.c
@@ -242,7 +242,7 @@ of_at91_clk_master_setup(struct device_node *np, struct at91_pmc *pmc,
 
 	irq = irq_of_parse_and_map(np, 0);
 	if (!irq)
-		return;
+		goto out_free_characteristics;
 
 	clk = at91_clk_register_master(pmc, irq, name, num_parents,
 				       parent_names, layout,
-- 
1.9.rc1

