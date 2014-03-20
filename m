Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933748AbaCTSij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 14:38:39 -0400
Received: from fallback5.mail.ru ([94.100.176.59]:36583 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933434AbaCTSih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 14:38:37 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] clocksource: nspire: Fix compiler warning
Date: Thu, 20 Mar 2014 22:35:37 +0400
Message-Id: <1395340537-4102-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC      drivers/clocksource/zevio-timer.o
drivers/clocksource/zevio-timer.c:215:1: warning: comparison of distinct pointer types lacks a cast [enabled by default]

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/clocksource/zevio-timer.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/zevio-timer.c b/drivers/clocksource/zevio-timer.c
index ca81809..7ce4421 100644
--- a/drivers/clocksource/zevio-timer.c
+++ b/drivers/clocksource/zevio-timer.c
@@ -212,4 +212,9 @@ error_free:
 	return ret;
 }
 
-CLOCKSOURCE_OF_DECLARE(zevio_timer, "lsi,zevio-timer", zevio_timer_add);
+static void __init zevio_timer_init(struct device_node *node)
+{
+	BUG_ON(zevio_timer_add(node));
+}
+
+CLOCKSOURCE_OF_DECLARE(zevio_timer, "lsi,zevio-timer", zevio_timer_init);
-- 
1.8.3.2

