Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422840AbaKNWEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:04:23 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:62375 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422642AbaKNWEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:04:22 -0500
Date: Fri, 14 Nov 2014 14:04:19 -0800
From: Dmitry Torokhov <dtor@chromium.org>
To: Ley Foon Tan <lftan@altera.com>
Cc: nios2-dev@lists.rocketboards.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nios2: fix error handling of irq_of_parse_and_map
Message-ID: <20141114220419.GA32497@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return value of irq_of_parse_and_map() is unsigned int, with 0
indicating failure, so testing for negative result never works.

Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
---

Not tested, found by casual code inspection.

 arch/nios2/kernel/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/nios2/kernel/time.c b/arch/nios2/kernel/time.c
index d90ca1b..23729e8 100644
--- a/arch/nios2/kernel/time.c
+++ b/arch/nios2/kernel/time.c
@@ -228,7 +228,7 @@ static __init void nios2_clockevent_init(struct device_node *timer)
 	nios2_timer_get_base_and_freq(timer, &iobase, &freq);
 
 	irq = irq_of_parse_and_map(timer, 0);
-	if (irq < 0)
+	if (!irq)
 		panic("Unable to parse timer irq\n");
 
 	nios2_ce.timer.base = iobase;
-- 
2.1.0.rc2.206.gedb03e5


-- 
Dmitry
