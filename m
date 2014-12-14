Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbaLNQyd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 11:54:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbaLNQxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 11:53:19 -0500
Date: Sun, 14 Dec 2014 18:53:10 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH 17/18] xtensa/uaccess: fix sparse errors
Message-ID: <1418575877-21488-18-git-send-email-mst@redhat.com>
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
 arch/xtensa/include/asm/uaccess.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/include/asm/uaccess.h b/arch/xtensa/include/asm/uaccess.h
index c7211e7..876eb38 100644
--- a/arch/xtensa/include/asm/uaccess.h
+++ b/arch/xtensa/include/asm/uaccess.h
@@ -320,7 +320,7 @@ __asm__ __volatile__(					\
 ({								\
 	long __gu_err, __gu_val;				\
 	__get_user_size(__gu_val,(ptr),(size),__gu_err);	\
-	(x) = (__typeof__(*(ptr)))__gu_val;			\
+	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
 	__gu_err;						\
 })
 
@@ -330,7 +330,7 @@ __asm__ __volatile__(					\
 	const __typeof__(*(ptr)) *__gu_addr = (ptr);			\
 	if (access_ok(VERIFY_READ,__gu_addr,size))			\
 		__get_user_size(__gu_val,__gu_addr,(size),__gu_err);	\
-	(x) = (__typeof__(*(ptr)))__gu_val;				\
+	(x) = (__force __typeof__(*(ptr)))__gu_val;				\
 	__gu_err;							\
 })
 
-- 
MST

