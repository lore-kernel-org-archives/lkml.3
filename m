Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbaE1W5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 18:57:55 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:62151 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaE1W5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 18:57:53 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Brian Norris <computersforpeace@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH] SH: annotate code after BUG() as unreachable
Date: Wed, 28 May 2014 15:57:32 -0700
Message-Id: <1401317852-32386-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This squashes some warnings:

  CC      mm/bootmem.o
mm/bootmem.c: In function 'mark_bootmem':
mm/bootmem.c:379:1: warning: control reaches end of non-void function [-Wreturn-type]

  CC      kernel/sched/core.o
kernel/sched/core.c: In function 'pick_next_task':
kernel/sched/core.c:2610:1: warning: control reaches end of non-void function [-Wreturn-type]

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Cc: linux-sh@vger.kernel.org
---
 arch/sh/include/asm/bug.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sh/include/asm/bug.h b/arch/sh/include/asm/bug.h
index dcf278075429..1ae948f309f2 100644
--- a/arch/sh/include/asm/bug.h
+++ b/arch/sh/include/asm/bug.h
@@ -48,6 +48,7 @@ do {							\
 		   "i" (__FILE__),			\
 		   "i" (__LINE__), "i" (0),		\
 		   "i" (sizeof(struct bug_entry)));	\
+	unreachable();					\
 } while (0)
 
 #define __WARN_TAINT(taint)				\
-- 
1.9.1

