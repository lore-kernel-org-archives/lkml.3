Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab3IMKbC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 06:31:02 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:63819 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab3IMKbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 06:31:01 -0400
From: elad.wexler@gmail.com
To: john.stultz@linaro.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Elad Wexler <elad.wexler@gmail.com>
Subject: [PATCH] Time: Clocksource: fix 'ret' data type of sysfs_override_clocksource() and sysfs_unbind_clocksource()
Date: Thu, 12 Sep 2013 13:28:54 +0300
Message-Id: <1378981734-15613-1-git-send-email-elad.wexler@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Elad Wexler <elad.wexler@gmail.com>

sysfs_override_clocksource(): The expression 'if (ret >= 0)' is always true.
This will cause clocksource_select() to always run.
Thus modified ret to be of type ssize_t.

sysfs_unbind_clocksource(): The expression 'if (ret < 0)' is always false.
So in case sysfs_get_uname() failed, the expression won't take an effect.
Thus modified ret to be of type ssize_t.

Signed-off-by: Elad Wexler <elad.wexler@gmail.com>
---
 kernel/time/clocksource.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 50a8736..6d28a52 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -924,7 +924,7 @@ static ssize_t sysfs_override_clocksource(struct device *dev,
 					  struct device_attribute *attr,
 					  const char *buf, size_t count)
 {
-	size_t ret;
+	ssize_t ret;
 
 	mutex_lock(&clocksource_mutex);
 
@@ -952,7 +952,7 @@ static ssize_t sysfs_unbind_clocksource(struct device *dev,
 {
 	struct clocksource *cs;
 	char name[CS_NAME_LEN];
-	size_t ret;
+	ssize_t ret;
 
 	ret = sysfs_get_uname(buf, name, count);
 	if (ret < 0)
-- 
1.8.3.1

