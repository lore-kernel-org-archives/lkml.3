Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423042Ab3FUGUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:20:50 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43601 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030248Ab3FUGUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:20:48 -0400
Date: Fri, 21 Jun 2013 09:20:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] clockevents: signedness bug checking sysfs_get_uname()
Message-ID: <20130621062032.GB10873@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We check "if (ret < 0) " later so it has to be signed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 38959c8..30554b9 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -584,7 +584,7 @@ static ssize_t sysfs_unbind_tick_dev(struct device *dev,
 				     const char *buf, size_t count)
 {
 	char name[CS_NAME_LEN];
-	size_t ret = sysfs_get_uname(buf, name, count);
+	ssize_t ret = sysfs_get_uname(buf, name, count);
 	struct clock_event_device *ce;
 
 	if (ret < 0)
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index e713ef7..228ace1 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -897,7 +897,7 @@ static ssize_t sysfs_override_clocksource(struct device *dev,
 					  struct device_attribute *attr,
 					  const char *buf, size_t count)
 {
-	size_t ret;
+	ssize_t ret;
 
 	mutex_lock(&clocksource_mutex);
 
@@ -925,7 +925,7 @@ static ssize_t sysfs_unbind_clocksource(struct device *dev,
 {
 	struct clocksource *cs;
 	char name[CS_NAME_LEN];
-	size_t ret;
+	ssize_t ret;
 
 	ret = sysfs_get_uname(buf, name, count);
 	if (ret < 0)
