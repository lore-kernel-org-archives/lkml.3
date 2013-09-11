Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab3IKE3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:29:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19387 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab3IKE26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:28:58 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=3uglUQBn6ycA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=wHsu3u_-DFkA:10 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=DwbTJabnQYefcFOFEtYA:9 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042855.093490958@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Baruch Siach <baruch@tkos.co.il>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [018/251] clocksource: dw_apb: Fix error check
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0018-clocksource-dw_apb-Fix-error-check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Baruch Siach <baruch@tkos.co.il>

[ Upstream commit 1a33bd2be705cbb3f57d7223b60baea441039307 ]

irq_of_parse_and_map() returns 0 on error, while the code checks for NO_IRQ.
This breaks on platforms that have NO_IRQ != 0.

Cc: <stable@vger.kernel.org>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/clocksource/dw_apb_timer_of.c |    2 +-
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
1.7.10.4


