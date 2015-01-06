Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbbAFPtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:49:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973AbbAFPpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:45:20 -0500
Date: Tue, 6 Jan 2015 17:45:00 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Steven Miao <realmz6@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net
Subject: [PATCH v2 27/40] blackfin: macro whitespace fixes
Message-ID: <1420558883-10131-28-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on arch/blackfin/include/asm/uaccess.h, I noticed
that some macros within this header are made harder to read because they
violate a coding style rule: space is missing after comma.

Fix it up.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/blackfin/include/asm/uaccess.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/blackfin/include/asm/uaccess.h b/arch/blackfin/include/asm/uaccess.h
index 4bf968c..90612a7 100644
--- a/arch/blackfin/include/asm/uaccess.h
+++ b/arch/blackfin/include/asm/uaccess.h
@@ -27,7 +27,7 @@ static inline void set_fs(mm_segment_t fs)
 	current_thread_info()->addr_limit = fs;
 }
 
-#define segment_eq(a,b) ((a) == (b))
+#define segment_eq(a, b) ((a) == (b))
 
 #define VERIFY_READ	0
 #define VERIFY_WRITE	1
@@ -68,11 +68,11 @@ struct exception_table_entry {
  * use the right size if we just have the right pointer type.
  */
 
-#define put_user(x,p)						\
+#define put_user(x, p)						\
 	({							\
 		int _err = 0;					\
 		typeof(*(p)) _x = (x);				\
-		typeof(*(p)) __user *_p = (p);				\
+		typeof(*(p)) __user *_p = (p);			\
 		if (!access_ok(VERIFY_WRITE, _p, sizeof(*(_p)))) {\
 			_err = -EFAULT;				\
 		}						\
@@ -102,7 +102,7 @@ struct exception_table_entry {
 		_err;						\
 	})
 
-#define __put_user(x,p) put_user(x,p)
+#define __put_user(x, p) put_user(x, p)
 static inline int bad_user_access_length(void)
 {
 	panic("bad_user_access_length");
@@ -121,10 +121,10 @@ static inline int bad_user_access_length(void)
 
 #define __ptr(x) ((unsigned long __force *)(x))
 
-#define __put_user_asm(x,p,bhw)				\
+#define __put_user_asm(x, p, bhw)			\
 	__asm__ (#bhw"[%1] = %0;\n\t"			\
 		 : /* no outputs */			\
-		 :"d" (x),"a" (__ptr(p)) : "memory")
+		 :"d" (x), "a" (__ptr(p)) : "memory")
 
 #define get_user(x, ptr)					\
 ({								\
@@ -136,10 +136,10 @@ static inline int bad_user_access_length(void)
 		BUILD_BUG_ON(ptr_size >= 8);			\
 		switch (ptr_size) {				\
 		case 1:						\
-			__get_user_asm(_val, _p, B,(Z));	\
+			__get_user_asm(_val, _p, B, (Z));	\
 			break;					\
 		case 2:						\
-			__get_user_asm(_val, _p, W,(Z));	\
+			__get_user_asm(_val, _p, W, (Z));	\
 			break;					\
 		case 4:						\
 			__get_user_asm(_val, _p,  , );		\
@@ -151,7 +151,7 @@ static inline int bad_user_access_length(void)
 	_err;							\
 })
 
-#define __get_user(x,p) get_user(x,p)
+#define __get_user(x, p) get_user(x, p)
 
 #define __get_user_bad() (bad_user_access_length(), (-EFAULT))
 
@@ -168,10 +168,10 @@ static inline int bad_user_access_length(void)
 #define __copy_to_user_inatomic __copy_to_user
 #define __copy_from_user_inatomic __copy_from_user
 
-#define copy_to_user_ret(to,from,n,retval) ({ if (copy_to_user(to,from,n))\
+#define copy_to_user_ret(to, from, n, retval) ({ if (copy_to_user(to, from, n))\
 				                 return retval; })
 
-#define copy_from_user_ret(to,from,n,retval) ({ if (copy_from_user(to,from,n))\
+#define copy_from_user_ret(to, from, n, retval) ({ if (copy_from_user(to, from, n))\
                                                    return retval; })
 
 static inline unsigned long __must_check
-- 
MST

