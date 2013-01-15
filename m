Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab3AOK2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 05:28:23 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56706 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab3AOK2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 05:28:20 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 1/1] clk-divider: fix is_power_of_two()
Date: Tue, 15 Jan 2013 10:28:05 +0000
Message-ID: <1358245685-4392-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_01_15_10_28_17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro is_power_of_two() in clk-divider.c was defined as !(i & ~i)
which is always true. Correct it to !(i & (i - 1)).

Also add brackets around the macro arguments in div_mask and
is_power_of_two, as well as around the is_power_of_two expression as a
whole to avoid any future operator precedence problems.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
---
I haven't tested this other than with a couple of compile time asserts.

 drivers/clk/clk-divider.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index a9204c6..13bca0c 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -29,8 +29,8 @@
 
 #define to_clk_divider(_hw) container_of(_hw, struct clk_divider, hw)
 
-#define div_mask(d)	((1 << (d->width)) - 1)
-#define is_power_of_two(i)	!(i & ~i)
+#define div_mask(d)	((1 << ((d)->width)) - 1)
+#define is_power_of_two(i)	(!((i) & ((i) - 1)))
 
 static unsigned int _get_table_maxdiv(const struct clk_div_table *table)
 {
-- 
1.7.7.6


