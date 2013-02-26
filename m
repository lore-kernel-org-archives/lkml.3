Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab3BZRe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 12:34:29 -0500
Received: from mail.tpi.com ([70.99.223.143]:1925 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275Ab3BZRe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 12:34:28 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3.9-rc1] clk: vt8500: Fix variable name '*prate' compile error
Date: Tue, 26 Feb 2013 10:34:12 -0700
Message-Id: <1361900052-66917-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 72480014b86c8b51fb51c5c6a0525876055c37c7 (clk: vt8500: Fix device clock
divisor calculations) introduced a compile error in the naming of a variable in
vt8500_dclk_set_rate(). It looks like a simple cut and paste error.

Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/clk/clk-vt8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
index b5538bb..09c6331 100644
--- a/drivers/clk/clk-vt8500.c
+++ b/drivers/clk/clk-vt8500.c
@@ -157,7 +157,7 @@ static int vt8500_dclk_set_rate(struct clk_hw *hw, unsigned long rate,
 	divisor =  parent_rate / rate;
 
 	/* If prate / rate would be decimal, incr the divisor */
-	if (rate * divisor < *prate)
+	if (rate * divisor < parent_rate)
 		divisor++;
 
 	if (divisor == cdev->div_mask + 1)
-- 
1.7.9.5

