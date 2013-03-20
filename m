Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab3CTP61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:58:27 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30644 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab3CTP60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:58:26 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: williams@redhat.com, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] rtmutex-tester: set correct permissions on sysfs files
Date: Wed, 20 Mar 2013 11:58:25 -0400
Message-Id: <1363795105-5884-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.5
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs started complaining about cases where permissions don't
match what's in the sysfs ops structure (such as allowing read
without a "show" callback).

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/rtmutex-tester.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/rtmutex-tester.c b/kernel/rtmutex-tester.c
index 7890b10..1d96dd0 100644
--- a/kernel/rtmutex-tester.c
+++ b/kernel/rtmutex-tester.c
@@ -14,6 +14,7 @@
 #include <linux/spinlock.h>
 #include <linux/timer.h>
 #include <linux/freezer.h>
+#include <linux/stat.h>
 
 #include "rtmutex.h"
 
@@ -366,8 +367,8 @@ static ssize_t sysfs_test_status(struct device *dev, struct device_attribute *at
 	return curr - buf;
 }
 
-static DEVICE_ATTR(status, 0600, sysfs_test_status, NULL);
-static DEVICE_ATTR(command, 0600, NULL, sysfs_test_command);
+static DEVICE_ATTR(status, S_IRUSR, sysfs_test_status, NULL);
+static DEVICE_ATTR(command, S_IWUSR, NULL, sysfs_test_command);
 
 static struct bus_type rttest_subsys = {
 	.name = "rttest",
-- 
1.8.1.5

