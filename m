Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3JWLn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:43:28 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:51735 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab3JWLn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:43:27 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sched/wait: Fix build breakage
Date: Wed, 23 Oct 2013 13:40:55 +0200
Message-Id: <1382528455-29911-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wait_event_interruptible_lock_irq() macro is missing a semi-colon
which causes a build failure in the i915 DRM driver.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 include/linux/wait.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 0395985..a6a1ed9 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -765,7 +765,7 @@ do {									\
 	int __ret = 0;							\
 	if (!(condition))						\
 		__ret = __wait_event_interruptible_lock_irq(wq,		\
-						condition, lock,)	\
+						condition, lock,);	\
 	__ret;								\
 })
 
-- 
1.8.4

