Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab3FAQzs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 12:55:48 -0400
Received: from mail-ee0-f66.google.com ([74.125.83.66]:39663 "EHLO
	mail-ee0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab3FAQzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 12:55:44 -0400
From: Marcus Gelderie <redmnic@gmail.com>
To: john.stultz@linaro.org
Cc: linux-kernel@vger.kernel.org, Marcus Gelderie <redmnic@gmail.com>
Subject: [PATCH 1/1] kernel:time Export symbols of functions declared in linux/alarmtimer.h
Date: Sat,  1 Jun 2013 18:39:06 +0200
Message-Id: <1370104746-20993-1-git-send-email-redmnic@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export symbols so they can be used by
drivers/staging/android/alarm-dev.c. So far this is built-in but LKM
support is planned (see drivers/staging/android/TODO).

Signed-off-by: Marcus Gelderie <redmnic@gmail.com>
---
 kernel/time/alarmtimer.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index f11d83b..90eca2f 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -303,6 +303,7 @@ void alarm_init(struct alarm *alarm, enum alarmtimer_type type,
 	alarm->type = type;
 	alarm->state = ALARMTIMER_STATE_INACTIVE;
 }
+EXPORT_SYMBOL(alarm_init);
 
 /**
  * alarm_start - Sets an alarm to fire
@@ -323,6 +324,7 @@ int alarm_start(struct alarm *alarm, ktime_t start)
 	spin_unlock_irqrestore(&base->lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL(alarm_start);
 
 /**
  * alarm_try_to_cancel - Tries to cancel an alarm timer
@@ -344,7 +346,7 @@ int alarm_try_to_cancel(struct alarm *alarm)
 	spin_unlock_irqrestore(&base->lock, flags);
 	return ret;
 }
-
+EXPORT_SYMBOL(alarm_try_to_cancel);
 
 /**
  * alarm_cancel - Spins trying to cancel an alarm timer until it is done
@@ -361,7 +363,7 @@ int alarm_cancel(struct alarm *alarm)
 		cpu_relax();
 	}
 }
-
+EXPORT_SYMBOL(alarm_cancel);
 
 u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval)
 {
@@ -393,8 +395,7 @@ u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval)
 	alarm->node.expires = ktime_add(alarm->node.expires, interval);
 	return overrun;
 }
-
-
+EXPORT_SYMBOL(alarm_forward);
 
 
 /**
-- 
1.8.1.5

