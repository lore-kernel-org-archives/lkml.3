Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbaGWDSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 23:18:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14399 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755576AbaGWDSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 23:18:05 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <linux-kernel@vger.kernel.org>
CC: <akpm@linux-foundation.org>, Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH] kernel: printk: fix bool assignements
Date: Wed, 23 Jul 2014 11:17:58 +0800
Message-ID: <1406085478-19221-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-23_01:2014-07-22,2014-07-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=1
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1407230043
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coccinelle warnings.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 kernel/printk/printk.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 13e839d..89894e5 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -881,7 +881,7 @@ static bool __read_mostly ignore_loglevel;
 
 static int __init ignore_loglevel_setup(char *str)
 {
-	ignore_loglevel = 1;
+	ignore_loglevel = true;
 	pr_info("debug: ignoring loglevel setting.\n");
 
 	return 0;
@@ -948,7 +948,7 @@ static inline void boot_delay_msec(int level)
 #endif
 
 #if defined(CONFIG_PRINTK_TIME)
-static bool printk_time = 1;
+static bool printk_time = true;
 #else
 static bool printk_time;
 #endif
@@ -1959,12 +1959,12 @@ int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, cha
 	return -1;
 }
 
-bool console_suspend_enabled = 1;
+bool console_suspend_enabled = true;
 EXPORT_SYMBOL(console_suspend_enabled);
 
 static int __init console_suspend_disable(char *str)
 {
-	console_suspend_enabled = 0;
+	console_suspend_enabled = false;
 	return 1;
 }
 __setup("no_console_suspend", console_suspend_disable);
-- 
1.7.9.5

