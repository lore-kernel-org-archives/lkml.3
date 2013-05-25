Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab3EYLzo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 07:55:44 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34762 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819Ab3EYLzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 07:55:42 -0400
From: Aditya Srivastava <adityasrivastava010@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        trivial@kernel.org, Aditya Srivastava <adityasrivastava010@gmail.com>
Subject: [PATCH 1/1] [PATCH v3.10-rc2 1/1] linux: kernel.h: Fixed coding style error
Date: Sat, 25 May 2013 17:25:32 +0530
Message-Id: <1369482932-31305-1-git-send-email-adityasrivastava010@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style errors found in /include/linux/kernel.h

Signed-off-by: Aditya Srivastava <adityasrivastava010@gmail.com>
---
 include/linux/kernel.h |   44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e9ef6d6..31dd69f 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -50,15 +50,15 @@
 #define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
 #define round_down(x, y) ((x) & ~__round_mask(x, y))
 
-#define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
-#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
-#define DIV_ROUND_UP_ULL(ll,d) \
+#define FIELD_SIZEOF(t, f) (sizeof(((t *)0)->f))
+#define DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+#define DIV_ROUND_UP_ULL(ll, d) \
 	({ unsigned long long _tmp = (ll)+(d)-1; do_div(_tmp, d); _tmp; })
 
 #if BITS_PER_LONG == 32
-# define DIV_ROUND_UP_SECTOR_T(ll,d) DIV_ROUND_UP_ULL(ll, d)
+# define DIV_ROUND_UP_SECTOR_T(ll, d) DIV_ROUND_UP_ULL(ll, d)
 #else
-# define DIV_ROUND_UP_SECTOR_T(ll,d) DIV_ROUND_UP(ll,d)
+# define DIV_ROUND_UP_SECTOR_T(ll, d) DIV_ROUND_UP(ll, d)
 #endif
 
 /* The `const' in roundup() prevents gcc-3.3 from calling __divdi3 */
@@ -149,7 +149,7 @@ extern int _cond_resched(void);
 #endif
 
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
-  void __might_sleep(const char *file, int line, int preempt_offset);
+void __might_sleep(const char *file, int line, int preempt_offset);
 /**
  * might_sleep - annotation for functions that can sleep
  *
@@ -163,7 +163,7 @@ extern int _cond_resched(void);
 # define might_sleep() \
 	do { __might_sleep(__FILE__, __LINE__, 0); might_resched(); } while (0)
 #else
-  static inline void __might_sleep(const char *file, int line,
+static inline void __might_sleep(const char *file, int line,
 				   int preempt_offset) { }
 # define might_sleep() do { might_resched(); } while (0)
 #endif
@@ -342,10 +342,10 @@ static inline int __must_check kstrtos32_from_user(const char __user *s, size_t
 
 /* Obsolete, do not use.  Use kstrto<foo> instead */
 
-extern unsigned long simple_strtoul(const char *,char **,unsigned int);
-extern long simple_strtol(const char *,char **,unsigned int);
-extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
-extern long long simple_strtoll(const char *,char **,unsigned int);
+extern unsigned long simple_strtoul(const char *, char **, unsigned int);
+extern long simple_strtol(const char *, char **, unsigned int);
+extern unsigned long long simple_strtoull(const char *, char **, unsigned int);
+extern long long simple_strtoll(const char *, char **, unsigned int);
 #define strict_strtoul	kstrtoul
 #define strict_strtol	kstrtol
 #define strict_strtoull	kstrtoull
@@ -355,7 +355,7 @@ extern int num_to_str(char *buf, int size, unsigned long long num);
 
 /* lib/printf utilities */
 
-extern __printf(2, 3) int sprintf(char *buf, const char * fmt, ...);
+extern __printf(2, 3) int sprintf(char *buf, const char *fmt, ...);
 extern __printf(2, 0) int vsprintf(char *buf, const char *, va_list);
 extern __printf(3, 4)
 int snprintf(char *buf, size_t size, const char *fmt, ...);
@@ -712,8 +712,8 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 	typeof(max) __max = (max);		\
 	(void) (&__val == &__min);		\
 	(void) (&__val == &__max);		\
-	__val = __val < __min ? __min: __val;	\
-	__val > __max ? __max: __val; })
+	__val = __val < __min ? __min : __val;	\
+	__val > __max ? __max : __val; })
 
 /*
  * ..and if you can't take the strict
@@ -724,12 +724,12 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 #define min_t(type, x, y) ({			\
 	type __min1 = (x);			\
 	type __min2 = (y);			\
-	__min1 < __min2 ? __min1: __min2; })
+	__min1 < __min2 ? __min1 : __min2; })
 
 #define max_t(type, x, y) ({			\
 	type __max1 = (x);			\
 	type __max2 = (y);			\
-	__max1 > __max2 ? __max1: __max2; })
+	__max1 > __max2 ? __max1 : __max2; })
 
 /**
  * clamp_t - return a value clamped to a given range using a given type
@@ -745,8 +745,8 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 	type __val = (val);			\
 	type __min = (min);			\
 	type __max = (max);			\
-	__val = __val < __min ? __min: __val;	\
-	__val > __max ? __max: __val; })
+	__val = __val < __min ? __min : __val;	\
+	__val > __max ? __max : __val; })
 
 /**
  * clamp_val - return a value clamped to a given range using val's type
@@ -763,8 +763,8 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 	typeof(val) __val = (val);		\
 	typeof(val) __min = (min);		\
 	typeof(val) __max = (max);		\
-	__val = __val < __min ? __min: __val;	\
-	__val > __max ? __max: __val; })
+	__val = __val < __min ? __min : __val;	\
+	__val > __max ? __max : __val; })
 
 
 /*
@@ -781,8 +781,8 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
  *
  */
 #define container_of(ptr, type, member) ({			\
-	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
-	(type *)( (char *)__mptr - offsetof(type,member) );})
+	const typeof(((type *)0)->member) * __mptr = (ptr);	\
+	(type *)((char *)__mptr - offsetof(type, member)); })
 
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
-- 
1.7.10.4

