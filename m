Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab3JUJAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:00:10 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56345 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab3JUJAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 05:00:05 -0400
From: Russ Dill <Russ.Dill@ti.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Russ Dill <Russ.Dill@ti.com>
Subject: [PATCH] clk: mux: Return a sane value on error
Date: Mon, 21 Oct 2013 09:59:50 +0100
Message-Id: <1382345990-20623-1-git-send-email-Russ.Dill@ti.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The get_parent op is defined as returning u8, but clk-mux is
returning negative values on error.  Code within drivers/clk/clk.c
uses this return value as an index into an array which could
cause an oops.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
---
 drivers/clk/clk-mux.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
index 4f96ff3..cc06015 100644
--- a/drivers/clk/clk-mux.c
+++ b/drivers/clk/clk-mux.c
@@ -51,7 +51,7 @@ static u8 clk_mux_get_parent(struct clk_hw *hw)
 		for (i = 0; i < num_parents; i++)
 			if (mux->table[i] == val)
 				return i;
-		return -EINVAL;
+		return 0;
 	}
 
 	if (val && (mux->flags & CLK_MUX_INDEX_BIT))
@@ -61,7 +61,7 @@ static u8 clk_mux_get_parent(struct clk_hw *hw)
 		val--;
 
 	if (val >= num_parents)
-		return -EINVAL;
+		return 0;
 
 	return val;
 }
-- 
1.8.3.2

