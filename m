Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3GAFxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 01:53:19 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:65402 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab3GAFxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 01:53:18 -0400
X-AuditID: 9c930197-b7bf9ae000003cc9-77-51d1194c785d
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH] ktime: add missing declaration of ktime_get() in ktime.h
Date: Mon,  1 Jul 2013 14:53:15 +0900
Message-Id: <1372657995-10903-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cannot use ktime_get() API even if we include ktime.h, because there is
no declaration of this API in ktime.h. So add it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index bbca128..29954cd 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -357,6 +357,7 @@ static inline bool ktime_to_timespec_cond(const ktime_t kt, struct timespec *ts)
 #define LOW_RES_NSEC		TICK_NSEC
 #define KTIME_LOW_RES		(ktime_t){ .tv64 = LOW_RES_NSEC }
 
+extern ktime_t ktime_get(void);
 /* Get the monotonic time in timespec format: */
 extern void ktime_get_ts(struct timespec *ts);
 
-- 
1.7.9.5

