Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab3BANd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:33:58 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:46056 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab3BANd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:33:56 -0500
From: anish kumar <anish198519851985@gmail.com>
To: akpm@linux-foundation.org, dzickus@redhat.com, tglx@linutronix.de,
        mingo@kernel.org, chuansheng.liu@intel.com,
        linux-kernel@vger.kernel.org
Cc: anish kumar <anish198519851985@gmail.com>
Subject: [PATCH] [Watchdog][Trivial] Added comments to explain watchdog_disabled variable
Date: Fri,  1 Feb 2013 19:03:23 +0530
Message-Id: <1359725603-20471-1-git-send-email-anish198519851985@gmail.com>
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
 kernel/watchdog.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 75a2ab3..6ef638b 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -155,6 +155,7 @@ void touch_all_softlockup_watchdogs(void)
 	for_each_online_cpu(cpu)
 		per_cpu(watchdog_touch_ts, cpu) = 0;
 }
+EXPORT_SYMBOL(touch_all_softlockup_watchdogs);
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 void touch_nmi_watchdog(void)
-- 
1.7.1

