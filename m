Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbbAEQEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 11:04:38 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:39427 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbbAEQEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 11:04:37 -0500
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH] clk: fix possible null pointer dereference
Date: Mon,  5 Jan 2015 18:04:23 +0200
Message-Id: <1420473863-30696-1-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 646cafc6 (clk: Change clk_ops->determine_rate to
return a clk_hw as the best parent) opens a possibility for
null pointer dereference, fix this.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 drivers/clk/clk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index f4963b7..d48ac71 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1366,7 +1366,7 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
 		new_rate = clk->ops->determine_rate(clk->hw, rate,
 						    &best_parent_rate,
 						    &parent_hw);
-		parent = parent_hw->clk;
+		parent = parent_hw ? parent_hw->clk : NULL;
 	} else if (clk->ops->round_rate) {
 		new_rate = clk->ops->round_rate(clk->hw, rate,
 						&best_parent_rate);
-- 
1.7.0.4

