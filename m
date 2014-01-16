Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaAPI3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 03:29:04 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:46402 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaAPI3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 03:29:02 -0500
MIME-Version: 1.0
Date: Thu, 16 Jan 2014 16:29:00 +0800
Message-ID: <CAPgLHd-XC6xeUxQJBNe=grLvZUxSc_bcrEVo=Tc1jbyGmHjdgw@mail.gmail.com>
Subject: [PATCH -next] clocksource: keystone: Fix return value check in keystone_timer_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: daniel.lezcano@linaro.org, tglx@linutronix.de
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, function of_clk_get() returns ERR_PTR()
and never returns NULL. The NULL test in the return value
check should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/clocksource/timer-keystone.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-keystone.c b/drivers/clocksource/timer-keystone.c
index cbac8d0..4ca05ec 100644
--- a/drivers/clocksource/timer-keystone.c
+++ b/drivers/clocksource/timer-keystone.c
@@ -168,7 +168,7 @@ static void __init keystone_timer_init(struct device_node *np)
 	}
 
 	clk = of_clk_get(np, 0);
-	if (!clk) {
+	if (IS_ERR(clk)) {
 		pr_err("%s: failed to get clock\n", __func__);
 		iounmap(timer.base);
 		return;

