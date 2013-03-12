Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305Ab3CLSuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:50:11 -0400
Received: from nat-pool-12-rdu.redhat.com ([66.187.233.206]:31155 "EHLO
	intel-canoepass-08.lab.bos.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932612Ab3CLSuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:50:09 -0400
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Mar 2013 14:50:09 EDT
From: Don Zickus <dzickus@redhat.com>
To: akpm@linux-foundation.org
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@kernel.org,
        chuansheng.liu@intel.com, paulmck@linux.vnet.ibm.com,
        anish kumar <anish198519851985@gmail.com>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH] Add comments to explain watchdog_disabled variable
Date: Tue, 12 Mar 2013 14:44:08 -0400
Message-Id: <1363113848-18344-1-git-send-email-dzickus@redhat.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

This watchdog_disabled flag is a bit cryptic. However it's usefulness is multifold.
Uses are:
1. Check if smpboot_register_percpu_thread function passed.
2. Makes sure that user enables and disables the watchdog in sequence
   i.e. enable watchdog->disable watchdog->enable watchdog
   Unlike enable watchdog->enable watchdog which is wrong.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
[small text cleanups]
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 75a2ab3..238477b 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -518,6 +518,11 @@ int proc_dowatchdog(struct ctl_table *table, int write,
 		return ret;
 
 	set_sample_period();
+	/*
+	 * Watchdog threads shouldn't be enabled if they are
+	 * disabled. The 'watchdog_disabled' variable check in
+	 * watchdog_*_all_cpus() function takes care of this.
+	 */
 	if (watchdog_enabled && watchdog_thresh)
 		watchdog_enable_all_cpus();
 	else
-- 
1.7.1

