Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3CKPzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:55:21 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:56738 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3CKPzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:55:20 -0400
MIME-Version: 1.0
Date: Mon, 11 Mar 2013 23:55:18 +0800
Message-ID: <CAPgLHd82XEZEP4eDvmvPjdHHz6u40+16W1GZeCWWw6Cj3SAwCg@mail.gmail.com>
Subject: [PATCH] clk: prima2: fix return value check in sirfsoc_of_clk_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mturquette@linaro.org, Baohua.Song@csr.com
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function clk_get() returns ERR_PTR()
not NULL. The NULL test in the return value check should
be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/clk/clk-prima2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-prima2.c b/drivers/clk/clk-prima2.c
index f8e9d0c..b208665 100644
--- a/drivers/clk/clk-prima2.c
+++ b/drivers/clk/clk-prima2.c
@@ -1113,7 +1113,7 @@ void __init sirfsoc_of_clk_init(void)
 
 	for (i = pll1; i < maxclk; i++) {
 		prima2_clks[i] = clk_register(NULL, prima2_clk_hw_array[i]);
-		BUG_ON(!prima2_clks[i]);
+		BUG_ON(IS_ERR(prima2_clks[i]);
 	}
 	clk_register_clkdev(prima2_clks[cpu], NULL, "cpu");
 	clk_register_clkdev(prima2_clks[io],  NULL, "io");


