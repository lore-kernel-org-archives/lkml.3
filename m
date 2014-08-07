Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbaHGBzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 21:55:04 -0400
Received: from mail-yh0-f66.google.com ([209.85.213.66]:63571 "EHLO
	mail-yh0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaHGBzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 21:55:01 -0400
X-Greylist: delayed 764 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2014 21:55:00 EDT
From: Nick Krause <xerofoiify@gmail.com>
To: Magnus Damm <magnus.damm@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        "GitAuthor: Nick Krause" <xerofoiify@gmail.com>,
        linux-sh@vger.kernel.org (open list:SUPERH),
        linux-kernel@vger.kernel.org (open list)
Cc: josh@joshtriplett.org
Subject: [PATCH] sh: bug: add unreachable() to silence warnings
Date: Thu,  7 Aug 2014 03:42:20 +0200
Message-Id: <1407375741-3209-1-git-send-email-xerofoiify@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SuperH BUG() have warnings like

kernel/sched/core.c:2692:1: warning: control reaches end of non-void function
[-Wreturn-type]
net/core/ethtool.c:236:1: warning: control reaches end of non-void function
[-Wreturn-type]

Other BUG() implementations
have added unreachable() at end becuase of which I guess
it does not showthese errors. We can silence them using unreachable().

Signed-off-by: Nick Krause <xerofoify@gmail.com>
---
 arch/sh/include/asm/bug.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sh/include/asm/bug.h b/arch/sh/include/asm/bug.h
index dcf2780..1ae948f 100644
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
2.0.1

