Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbaCKJA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:00:56 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:43095 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaCKJAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:00:51 -0400
From: Boris BREZILLON <brezillonboris@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH v3 2/4] clk: at91: propagate rate change on system clks
Date: Tue, 11 Mar 2014 10:00:33 +0100
Message-Id: <1394528435-23734-3-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394528435-23734-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1394528435-23734-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <b.brezillon@overkiz.com>

System clks are just gates, and thus do not provide any rate operations.
Authorize clk rate change to be propagated to system clk parents.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/clk/at91/clk-system.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/at91/clk-system.c b/drivers/clk/at91/clk-system.c
index 8f7c043..48c89fe 100644
--- a/drivers/clk/at91/clk-system.c
+++ b/drivers/clk/at91/clk-system.c
@@ -84,7 +84,7 @@ at91_clk_register_system(struct at91_pmc *pmc, const char *name,
 	 * (see drivers/memory) which would request and enable the ddrck clock.
 	 * When this is done we will be able to remove CLK_IGNORE_UNUSED flag.
 	 */
-	init.flags = CLK_IGNORE_UNUSED;
+	init.flags = CLK_SET_RATE_PARENT | CLK_IGNORE_UNUSED;
 
 	sys->id = id;
 	sys->hw.init = &init;
-- 
1.7.9.5

