Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab3CZK7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 06:59:53 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:38436 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab3CZK7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 06:59:51 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thomas.abraham@linaro.org, kgene.kim@samsung.com,
        linux-samsung-soc@vger.kernel.org, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 1/1] clk: samsung: Fix compilation error
Date: Tue, 26 Mar 2013 16:18:18 +0530
Message-Id: <1364294898-22618-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the below compilation error during non-dt build.
drivers/clk/samsung/clk.c: In function ‘samsung_clk_of_register_fixed_ext’:
drivers/clk/samsung/clk.c:252:2: error:
implicit declaration of function ‘for_each_matching_node_and_match’
[-Werror=implicit-function-declaration]
drivers/clk/samsung/clk.c:252:60: error: expected ‘;’ before ‘{’ token

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/clk/samsung/clk.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/samsung/clk.c b/drivers/clk/samsung/clk.c
index 91d12f3..78615dd 100644
--- a/drivers/clk/samsung/clk.c
+++ b/drivers/clk/samsung/clk.c
@@ -239,6 +239,7 @@ void __init samsung_clk_register_gate(struct samsung_gate_clock *list,
  * obtain the clock speed of all external fixed clock sources from device
  * tree and register it
  */
+#ifdef CONFIG_OF
 void __init samsung_clk_of_register_fixed_ext(
 			struct samsung_fixed_rate_clock *fixed_rate_clk,
 			unsigned int nr_fixed_rate_clk,
@@ -255,6 +256,7 @@ void __init samsung_clk_of_register_fixed_ext(
 	}
 	samsung_clk_register_fixed_rate(fixed_rate_clk, nr_fixed_rate_clk);
 }
+#endif
 
 /* utility function to get the rate of a specified clock */
 unsigned long _get_rate(const char *clk_name)
-- 
1.7.4.1

