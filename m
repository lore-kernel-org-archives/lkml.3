Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaBEIl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 03:41:59 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:46801 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaBEIlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 03:41:08 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com, mturquette@linaro.org
Cc: b.brezillon@overkiz.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jason@lakedaemon.net
Subject: [PATCH v2 2/4] clk: at91: propagate rate change on system clks
Date: Wed,  5 Feb 2014 09:37:36 +0100
Message-Id: <1391589458-28018-3-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391589458-28018-1-git-send-email-jjhiblot@traphandler.com>
References: <1391589458-28018-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <b.brezillon@overkiz.com>

System clks are just gates, and thus do not provide any rate operations.
Authorize clk rate change to be propagated to system clk parents.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/clk/at91/clk-system.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/at91/clk-system.c b/drivers/clk/at91/clk-system.c
index 8f7c043..a98557b 100644
--- a/drivers/clk/at91/clk-system.c
+++ b/drivers/clk/at91/clk-system.c
@@ -84,7 +84,8 @@ at91_clk_register_system(struct at91_pmc *pmc, const char *name,
 	 * (see drivers/memory) which would request and enable the ddrck clock.
 	 * When this is done we will be able to remove CLK_IGNORE_UNUSED flag.
 	 */
-	init.flags = CLK_IGNORE_UNUSED;
+	init.flags = CLK_SET_RATE_GATE | CLK_SET_RATE_PARENT |
+		     CLK_IGNORE_UNUSED;
 
 	sys->id = id;
 	sys->hw.init = &init;
-- 
1.8.5.2

