Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaLNQzX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 11:55:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbaLNQxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 11:53:02 -0500
Date: Sun, 14 Dec 2014 18:52:56 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: [PATCH 14/18] sh/uaccess: fix sparse errors
Message-ID: <1418575877-21488-15-git-send-email-mst@redhat.com>
References: <1418575877-21488-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418575877-21488-1-git-send-email-mst@redhat.com>
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
 arch/sh/include/asm/uaccess.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sh/include/asm/uaccess.h b/arch/sh/include/asm/uaccess.h
index 9486376..484b1f9 100644
--- a/arch/sh/include/asm/uaccess.h
+++ b/arch/sh/include/asm/uaccess.h
@@ -60,7 +60,7 @@ struct __large_struct { unsigned long buf[100]; };
 	const __typeof__(*(ptr)) __user *__gu_addr = (ptr);	\
 	__chk_user_ptr(ptr);					\
 	__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
-	(x) = (__typeof__(*(ptr)))__gu_val;			\
+	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
 	__gu_err;						\
 })
 
@@ -71,7 +71,7 @@ struct __large_struct { unsigned long buf[100]; };
 	const __typeof__(*(ptr)) *__gu_addr = (ptr);			\
 	if (likely(access_ok(VERIFY_READ, __gu_addr, (size))))		\
 		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
-	(x) = (__typeof__(*(ptr)))__gu_val;				\
+	(x) = (__force __typeof__(*(ptr)))__gu_val;				\
 	__gu_err;							\
 })
 
-- 
MST

