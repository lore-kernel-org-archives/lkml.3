Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbaHGBNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 21:13:40 -0400
Received: from mail-yk0-f194.google.com ([209.85.160.194]:39214 "EHLO
	mail-yk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbaHGBNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 21:13:38 -0400
From: Nick Krause <xerofoiify@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org (open list:GENERIC INCLUDE/A...),
        linux-kernel@vger.kernel.org (open list)
Cc: josh@joshtriplett.org
Subject: [PATCH 1/1] bug: Add unreachable() to generic BUG() to silence warnings
Date: Thu,  7 Aug 2014 03:13:41 +0200
Message-Id: <1407374021-20682-1-git-send-email-xerofoiify@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures which use generic BUG() have warnings like 

kernel/sched/core.c:2692:1: warning: control reaches end of non-void function [-Wreturn-type]
net/core/ethtool.c:236:1: warning: control reaches end of non-void function [-Wreturn-type]

Other BUG() implementations
have added unreachable() at end but generic does not. I guess
that is why
it showing these errors. We can silence them using unreachable().

Signed-off-by: Nick Krause <xerofoify@gmail.com>
---
 include/asm-generic/bug.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 630dd23..effcc82 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -48,6 +48,7 @@ struct bug_entry {
 #define BUG() do { \
 	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __func__); \
 	panic("BUG!"); \
+	unreachable(); \
 } while (0)
 #endif
 
-- 
2.0.1

