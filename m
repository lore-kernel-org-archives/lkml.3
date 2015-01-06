Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbbAFPob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:44:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755741AbbAFPo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:44:29 -0500
Date: Tue, 6 Jan 2015 17:44:17 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>, sparclinux@vger.kernel.org
Subject: [PATCH v2 14/40] sparc32/uaccess: fix sparse errors
Message-ID: <1420558883-10131-15-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio wants to read bitwise types from userspace using get_user.  At the
moment this triggers sparse errors, since the value is passed through an
integer.

Fix that up using __force.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/sparc/include/asm/uaccess_32.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/include/asm/uaccess_32.h b/arch/sparc/include/asm/uaccess_32.h
index 9634d08..8b571a0 100644
--- a/arch/sparc/include/asm/uaccess_32.h
+++ b/arch/sparc/include/asm/uaccess_32.h
@@ -164,7 +164,7 @@ case 2: __get_user_asm(__gu_val,uh,addr,__gu_ret); break; \
 case 4: __get_user_asm(__gu_val,,addr,__gu_ret); break; \
 case 8: __get_user_asm(__gu_val,d,addr,__gu_ret); break; \
 default: __gu_val = 0; __gu_ret = __get_user_bad(); break; \
-} } else { __gu_val = 0; __gu_ret = -EFAULT; } x = (type) __gu_val; __gu_ret; })
+} } else { __gu_val = 0; __gu_ret = -EFAULT; } x = (__force type) __gu_val; __gu_ret; })
 
 #define __get_user_check_ret(x,addr,size,type,retval) ({ \
 register unsigned long __gu_val __asm__ ("l1"); \
@@ -175,7 +175,7 @@ case 2: __get_user_asm_ret(__gu_val,uh,addr,retval); break; \
 case 4: __get_user_asm_ret(__gu_val,,addr,retval); break; \
 case 8: __get_user_asm_ret(__gu_val,d,addr,retval); break; \
 default: if (__get_user_bad()) return retval; \
-} x = (type) __gu_val; } else return retval; })
+} x = (__force type) __gu_val; } else return retval; })
 
 #define __get_user_nocheck(x,addr,size,type) ({ \
 register int __gu_ret; \
@@ -186,7 +186,7 @@ case 2: __get_user_asm(__gu_val,uh,addr,__gu_ret); break; \
 case 4: __get_user_asm(__gu_val,,addr,__gu_ret); break; \
 case 8: __get_user_asm(__gu_val,d,addr,__gu_ret); break; \
 default: __gu_val = 0; __gu_ret = __get_user_bad(); break; \
-} x = (type) __gu_val; __gu_ret; })
+} x = (__force type) __gu_val; __gu_ret; })
 
 #define __get_user_nocheck_ret(x,addr,size,type,retval) ({ \
 register unsigned long __gu_val __asm__ ("l1"); \
@@ -196,7 +196,7 @@ case 2: __get_user_asm_ret(__gu_val,uh,addr,retval); break; \
 case 4: __get_user_asm_ret(__gu_val,,addr,retval); break; \
 case 8: __get_user_asm_ret(__gu_val,d,addr,retval); break; \
 default: if (__get_user_bad()) return retval; \
-} x = (type) __gu_val; })
+} x = (__force type) __gu_val; })
 
 #define __get_user_asm(x,size,addr,ret)					\
 __asm__ __volatile__(							\
-- 
MST

