Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbbAFPoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:44:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801AbbAFPod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:44:33 -0500
Date: Tue, 6 Jan 2015 17:44:20 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>, sparclinux@vger.kernel.org
Subject: [PATCH v2 15/40] sparc64/uaccess: fix sparse errors
Message-ID: <1420558883-10131-16-git-send-email-mst@redhat.com>
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
 arch/sparc/include/asm/uaccess_64.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/include/asm/uaccess_64.h b/arch/sparc/include/asm/uaccess_64.h
index c990a5e..b80866d 100644
--- a/arch/sparc/include/asm/uaccess_64.h
+++ b/arch/sparc/include/asm/uaccess_64.h
@@ -145,7 +145,7 @@ case 2: __get_user_asm(__gu_val,uh,addr,__gu_ret); break; \
 case 4: __get_user_asm(__gu_val,uw,addr,__gu_ret); break; \
 case 8: __get_user_asm(__gu_val,x,addr,__gu_ret); break; \
 default: __gu_val = 0; __gu_ret = __get_user_bad(); break; \
-} data = (type) __gu_val; __gu_ret; })
+} data = (__force type) __gu_val; __gu_ret; })
 
 #define __get_user_nocheck_ret(data,addr,size,type,retval) ({ \
 register unsigned long __gu_val __asm__ ("l1"); \
@@ -155,7 +155,7 @@ case 2: __get_user_asm_ret(__gu_val,uh,addr,retval); break; \
 case 4: __get_user_asm_ret(__gu_val,uw,addr,retval); break; \
 case 8: __get_user_asm_ret(__gu_val,x,addr,retval); break; \
 default: if (__get_user_bad()) return retval; \
-} data = (type) __gu_val; })
+} data = (__force type) __gu_val; })
 
 #define __get_user_asm(x,size,addr,ret)					\
 __asm__ __volatile__(							\
-- 
MST

