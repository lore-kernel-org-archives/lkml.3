Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbaD2NRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:17:24 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:42279 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511AbaD2NRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:17:22 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: Lorenzo.Pieralisi@arm.com, shc_work@mail.ru, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] clocksource: nspire: Fix compiler warning
Date: Tue, 29 Apr 2014 15:17:20 +0200
Message-Id: <1398777440-12016-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398777440-12016-1-git-send-email-daniel.lezcano@linaro.org>
References: <535FA618.6080101@linaro.org>
 <1398777440-12016-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Shiyan <shc_work@mail.ru>

CC      drivers/clocksource/zevio-timer.o
drivers/clocksource/zevio-timer.c:215:1: warning: comparison of distinct pointer types lacks a cast [enabled by default]

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/zevio-timer.c |    7 ++++++-
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
1.7.9.5

