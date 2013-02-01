Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab3BANuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:50:10 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:44105 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab3BANuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:50:07 -0500
From: anish kumar <anish198519851985@gmail.com>
To: akpm@linux-foundation.org, dzickus@redhat.com, tglx@linutronix.de,
        mingo@kernel.org, chuansheng.liu@intel.com,
        linux-kernel@vger.kernel.org
Cc: anish kumar <anish198519851985@gmail.com>
Subject: [PATCH] [Watchdog][Trivial] Added comments to explain watchdog_disabled variable
Date: Fri,  1 Feb 2013 19:19:07 +0530
Message-Id: <1359726547-21205-1-git-send-email-anish198519851985@gmail.com>
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
index 6ef638b..dfd843a 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -519,6 +519,11 @@ int proc_dowatchdog(struct ctl_table *table, int write,
 		return ret;
 
 	set_sample_period();
+	/*
+	 * We shouldn't enable watchdog threads if it is not
+	 * disabled.This is done by watchdog_disabled
+	 * variable check in watchdog_*_all_cpus function.
+	 */
 	if (watchdog_enabled && watchdog_thresh)
 		watchdog_enable_all_cpus();
 	else
-- 
1.7.1

