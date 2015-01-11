Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbbAKLqp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 06:46:45 -0500
Received: from down.free-electrons.com ([37.187.137.238]:48255 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751645AbbAKLpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 06:45:08 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/5] clocksource: sun5i: Use of_io_request_and_map
Date: Sun, 11 Jan 2015 12:40:07 +0100
Message-Id: <1420976410-7826-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1420976410-7826-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1420976410-7826-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_iomap doesn't do a request_mem_region on the memory area defined in the DT
it maps. Switch to of_io_request_and_map to make sure we're the only users.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/timer-sun5i.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-sun5i.c b/drivers/clocksource/timer-sun5i.c
index 738853873a3b..ec82c4c69dfc 100644
--- a/drivers/clocksource/timer-sun5i.c
+++ b/drivers/clocksource/timer-sun5i.c
@@ -143,7 +143,8 @@ static void __init sun5i_timer_init(struct device_node *node)
 	int ret, irq;
 	u32 val;
 
-	timer_base = of_iomap(node, 0);
+	timer_base = of_io_request_and_map(node, 0,
+					   of_node_full_name(node));
 	if (!timer_base)
 		panic("Can't map registers");
 
-- 
2.2.1

