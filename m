Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbaEMAbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 20:31:35 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:65504 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaEMAaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 20:30:15 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <robh@kernel.org>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 3/7] clk: sunxi: avoid double DT matching
Date: Mon, 12 May 2014 19:29:49 -0500
Message-Id: <1399940993-1773-4-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399940993-1773-1-git-send-email-robherring2@gmail.com>
References: <1399940993-1773-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Use for_each_matching_node_and_match instead of for_each_matching_node plus
of_match_node to avoid searching the DT twice for each node.

The sunxi DT scanning code should really be re-worked rather than have
its own private matching infrastructure. It is working around needing a
function pointer and a data pointer for each compatible match.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: "Emilio López" <emilio@elopez.com.ar>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clk/sunxi/clk-sunxi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index bd7dc73..7977106 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -1278,8 +1278,7 @@ static void __init of_sunxi_table_clock_setup(const struct of_device_id *clk_mat
 	const struct of_device_id *match;
 	void (*setup_function)(struct device_node *, const void *) = function;
 
-	for_each_matching_node(np, clk_match) {
-		match = of_match_node(clk_match, np);
+	for_each_matching_node_and_match(np, clk_match, match) {
 		data = match->data;
 		setup_function(np, data);
 	}
-- 
1.9.1

