Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934561Ab3GQXja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:39:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56199 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757495Ab3GQWso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:48:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Baruch Siach <baruch@tkos.co.il>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 008/145] clocksource: dw_apb: Fix error check
Date: Wed, 17 Jul 2013 15:45:40 -0700
Message-Id: <1374101277-7915-9-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baruch Siach <baruch@tkos.co.il>

commit 1a33bd2be705cbb3f57d7223b60baea441039307 upstream.

irq_of_parse_and_map() returns 0 on error, while the code checks for NO_IRQ.
This breaks on platforms that have NO_IRQ != 0.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/clocksource/dw_apb_timer_of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index f7dba5b..929e7ce 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -44,7 +44,7 @@ static void add_clockevent(struct device_node *event_timer)
 	u32 irq, rate;
 
 	irq = irq_of_parse_and_map(event_timer, 0);
-	if (irq == NO_IRQ)
+	if (irq == 0)
 		panic("No IRQ for clock event timer");
 
 	timer_get_base_and_rate(event_timer, &iobase, &rate);
-- 
1.8.1.2

