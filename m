Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab3BPMOi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 07:14:38 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:47322 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab3BPMOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 07:14:37 -0500
From: anish kumar <anish198519851985@gmail.com>
To: akpm@linux-foundation.org, dzickus@redhat.com, mingo@kernel.org
Cc: chuansheng.liu@intel.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org,
        anish kumar <anish198519851985@gmail.com>
Subject: [PATCH] [Watchdog][Trivial] Added comments to explain watchdog_disabled variable
Date: Sat, 16 Feb 2013 17:44:09 +0530
Message-Id: <1361016849-5181-1-git-send-email-anish198519851985@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

This watchdog_disabled flag is bit of cryptic.Howerver it's usefullnes is multifold.
Uses are:
1. Check if smpboot_register_percpu_thread function passed.
2. Makes sure that user enables and disables the watchdog in sequence
   i.e. enable watchdog->disable watchdog->enable watchdog
   Unlike enable watchdog->enable watchdog which is wrong.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 kernel/watchdog.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 75a2ab3..8a20ebe 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -518,6 +518,11 @@ int proc_dowatchdog(struct ctl_table *table, int write,
 		return ret;
 
 	set_sample_period();
+	/*
+	 * Watchdog threads shouldn't be enabled if they are
+	 * disabled.'watchdog_disabled' variable check in
+	 * watchdog_*_all_cpus() function takes care of this.
+	 */
 	if (watchdog_enabled && watchdog_thresh)
 		watchdog_enable_all_cpus();
 	else
-- 
1.7.1

