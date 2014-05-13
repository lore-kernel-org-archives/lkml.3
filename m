Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaEMDK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 23:10:29 -0400
Received: from mail1.windriver.com ([147.11.146.13]:49325 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbaEMDK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 23:10:27 -0400
From: <Wei.Yang@windriver.com>
To: <daniel.lezcano@linaro.org>
CC: <tglx@linutronix.de>, <rostedt@goodmis.org>,
        <linux-kernel@vger.kernel.org>, <wei.yang@windriver.com>
Subject: [PATCH v1] drivers/clocksource: do not trace read_sched_clock
Date: Tue, 13 May 2014 11:10:08 +0800
Message-ID: <1399950608-11873-1-git-send-email-Wei.Yang@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang Wei <Wei.Yang@windriver.com>

We do not need to trace read_sched_clock function,
so add notrace attribute for this function.

Signed-off-by: Yang Wei <Wei.Yang@windriver.com>
---
 drivers/clocksource/dw_apb_timer_of.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index 2a2ea27..d305fb0 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -106,7 +106,7 @@ static void __init add_clocksource(struct device_node *source_timer)
 	sched_rate = rate;
 }
 
-static u64 read_sched_clock(void)
+static u64 notrace read_sched_clock(void)
 {
 	return ~__raw_readl(sched_io_base);
 }
-- 
1.7.9.5

