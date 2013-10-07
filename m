Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab3JGAyy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 20:54:54 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:43860 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab3JGAyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 20:54:53 -0400
From: Felipe Pena <felipensp@gmail.com>
To: Mike Turquette <mturquette@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Felipe Pena <felipensp@gmail.com>
Subject: [PATCH 1/1] clk/zynq: Fix possible memory leak
Date: Sun,  6 Oct 2013 21:55:17 -0300
Message-Id: <1381107317-18120-1-git-send-email-felipensp@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The zynq_clk_register_fclk function can leak memory (fclk_lock) when unable 
to alloc memory for fclk_gate_lock

Signed-off-by: Felipe Pena <felipensp@gmail.com>
---
 drivers/clk/zynq/clkc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
index cc40fe6..7ea4b5c 100644
--- a/drivers/clk/zynq/clkc.c
+++ b/drivers/clk/zynq/clkc.c
@@ -117,6 +117,7 @@ static void __init zynq_clk_register_fclk(enum zynq_clk fclk,
 		goto err;
 	fclk_gate_lock = kmalloc(sizeof(*fclk_gate_lock), GFP_KERNEL);
 	if (!fclk_gate_lock)
+		kfree(fclk_lock);
 		goto err;
 	spin_lock_init(fclk_lock);
 	spin_lock_init(fclk_gate_lock);
-- 
1.7.10.4

