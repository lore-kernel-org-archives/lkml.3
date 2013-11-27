Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab3K0NxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 08:53:11 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54970 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131Ab3K0NxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:53:06 -0500
From: Will Deacon <will.deacon@arm.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
Subject: [PATCH] lockref: include mutex.h rather than reinvent arch_mutex_cpu_relax
Date: Wed, 27 Nov 2013 13:52:53 +0000
Message-Id: <1385560373-9775-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_mutex_cpu_relax is already conditionally defined in mutex.h, so
simply include that header rather than replicate the code here.

Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 lib/lockref.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/lib/lockref.c b/lib/lockref.c
index d2b123f8456b..f07a40d33871 100644
--- a/lib/lockref.c
+++ b/lib/lockref.c
@@ -1,5 +1,6 @@
 #include <linux/export.h>
 #include <linux/lockref.h>
+#include <linux/mutex.h>
 
 #if USE_CMPXCHG_LOCKREF
 
@@ -12,14 +13,6 @@
 #endif
 
 /*
- * Allow architectures to override the default cpu_relax() within CMPXCHG_LOOP.
- * This is useful for architectures with an expensive cpu_relax().
- */
-#ifndef arch_mutex_cpu_relax
-# define arch_mutex_cpu_relax() cpu_relax()
-#endif
-
-/*
  * Note that the "cmpxchg()" reloads the "old" value for the
  * failure case.
  */
-- 
1.8.2.2

