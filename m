Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaBZQnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:43:31 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:35187 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaBZQna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:43:30 -0500
From: Rashika Kheria <rashika.kheria@gmail.com>
To: josh@joshtriplett.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=20v3=5D=20drivers=3A=20cpufreq=3A=20Mark=20function=20as=20static=20in=20cpufreq=2Ec?=
Date: Wed, 26 Feb 2014 22:12:42 +0530
Message-Id: <1393432962-3647-1-git-send-email-rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20140226154625.GA10701@rashika>
References: <20140226154625.GA10701@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in cpufreq.c because it is not
used outside this file.

This eliminates the following warning in cpufreq.c:
drivers/cpufreq/cpufreq.c:355:9: warning: no previous prototype for ‘show_boost’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
Changes since v1:
Incorrect Fix
Changes since v2:
Show Changelog

 drivers/cpufreq/cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 08ca8c9..54fd670 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -352,7 +352,7 @@ EXPORT_SYMBOL_GPL(cpufreq_notify_post_transition);
 /*********************************************************************
  *                          SYSFS INTERFACE                          *
  *********************************************************************/
-ssize_t show_boost(struct kobject *kobj,
+static ssize_t show_boost(struct kobject *kobj,
 				 struct attribute *attr, char *buf)
 {
 	return sprintf(buf, "%d\n", cpufreq_driver->boost_enabled);
-- 
1.7.9.5

