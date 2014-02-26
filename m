Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaBZPqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:46:45 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:49014 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaBZPqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:46:42 -0500
Date: Wed, 26 Feb 2014 21:16:25 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH] drivers: cpufreq: Remove unused function in cpufreq.c
Message-ID: <20140226154625.GA10701@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused function show_boost() in drivers/cpufreq/cpufreq.c.

This eliminates the following warning in drivers/cpufreq/cpufreq.c:
drivers/cpufreq/cpufreq.c:355:9: warning: no previous prototype for ‘show_boost’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/cpufreq/cpufreq.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 08ca8c9..6dce474 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -352,12 +352,6 @@ EXPORT_SYMBOL_GPL(cpufreq_notify_post_transition);
 /*********************************************************************
  *                          SYSFS INTERFACE                          *
  *********************************************************************/
-ssize_t show_boost(struct kobject *kobj,
-				 struct attribute *attr, char *buf)
-{
-	return sprintf(buf, "%d\n", cpufreq_driver->boost_enabled);
-}
-
 static ssize_t store_boost(struct kobject *kobj, struct attribute *attr,
 				  const char *buf, size_t count)
 {
-- 
1.7.9.5

