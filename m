Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261Ab3HNU4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:56:40 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57968 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933083Ab3HNU4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:56:39 -0400
From: Sergei Trofimovich <slyfox@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Sergei Trofimovich <slyfox@gentoo.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] cleanup: add forward declarations for inplace syscall wrappers
Date: Wed, 14 Aug 2013 23:53:20 +0300
Message-Id: <1376513600-6162-1-git-send-email-slyfox@gentoo.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch unclutters -Wmissing-prototypes warning types (enabled at make W=1)
    linux/include/linux/syscalls.h:190:18: warning: no previous prototype for 'SyS_semctl' [-Wmissing-prototypes]
      asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__)) \
                      ^
    linux/include/linux/syscalls.h:183:2: note: in expansion of macro '__SYSCALL_DEFINEx'
      __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
      ^
and adds forward declaration right before definition.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 include/linux/compat.h   | 1 +
 include/linux/syscalls.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 7f0c1dd..06e45cd 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -43,6 +43,7 @@
 #define COMPAT_SYSCALL_DEFINEx(x, name, ...)				\
 	asmlinkage long compat_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__));\
 	static inline long C_SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__));\
+	asmlinkage long compat_SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__));\
 	asmlinkage long compat_SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))\
 	{								\
 		return C_SYSC##name(__MAP(x,__SC_DELOUSE,__VA_ARGS__));	\
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 4147d70..bf1589e 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -186,6 +186,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 #define __SYSCALL_DEFINEx(x, name, ...)					\
 	asmlinkage long sys##name(__MAP(x,__SC_DECL,__VA_ARGS__));	\
 	static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__));	\
+	asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__));	\
 	asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))	\
 	{								\
 		long ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));	\
-- 
1.8.3.2

