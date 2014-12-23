Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbaLWVd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 16:33:28 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:33958 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaLWVd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 16:33:27 -0500
From: Fabio Estevam <festevam@gmail.com>
To: daniel.lezcano@linaro.org
Cc: baohua@kernel.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] clocksource: sirf: Remove unused variable
Date: Tue, 23 Dec 2014 19:33:11 -0200
Message-Id: <1419370391-15027-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove 'timer_div' variable to fix the following build warning:

drivers/clocksource/timer-marco.c: In function 'sirfsoc_marco_timer_init':
drivers/clocksource/timer-marco.c:260:6: warning: unused variable 'timer_div' [-Wunused-variable]

Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 drivers/clocksource/timer-marco.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clocksource/timer-marco.c b/drivers/clocksource/timer-marco.c
index 361a789..3ddb81f 100644
--- a/drivers/clocksource/timer-marco.c
+++ b/drivers/clocksource/timer-marco.c
@@ -257,7 +257,6 @@ static void __init sirfsoc_clockevent_init(void)
 /* initialize the kernel jiffy timer source */
 static void __init sirfsoc_marco_timer_init(struct device_node *np)
 {
-	u32 timer_div;
 	struct clk *clk;
 
 	clk = of_clk_get(np, 0);
-- 
1.9.1

