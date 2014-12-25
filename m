Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaLYJa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 04:30:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbaLYJ3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 04:29:15 -0500
Date: Thu, 25 Dec 2014 11:29:02 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>, linux-metag@vger.kernel.org
Subject: [PATCH repost 09/16] metag/uaccess: fix sparse errors
Message-ID: <1419499661-8566-10-git-send-email-mst@redhat.com>
References: <1419499661-8566-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419499661-8566-1-git-send-email-mst@redhat.com>
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
 arch/metag/include/asm/uaccess.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/metag/include/asm/uaccess.h b/arch/metag/include/asm/uaccess.h
index 0748b0a..c314b45 100644
--- a/arch/metag/include/asm/uaccess.h
+++ b/arch/metag/include/asm/uaccess.h
@@ -135,7 +135,7 @@ extern long __get_user_bad(void);
 ({                                                              \
 	long __gu_err, __gu_val;                                \
 	__get_user_size(__gu_val, (ptr), (size), __gu_err);	\
-	(x) = (__typeof__(*(ptr)))__gu_val;                     \
+	(x) = (__force __typeof__(*(ptr)))__gu_val;                     \
 	__gu_err;                                               \
 })
 
@@ -145,7 +145,7 @@ extern long __get_user_bad(void);
 	const __typeof__(*(ptr)) __user *__gu_addr = (ptr);		\
 	if (access_ok(VERIFY_READ, __gu_addr, size))			\
 		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
-	(x) = (__typeof__(*(ptr)))__gu_val;                             \
+	(x) = (__force __typeof__(*(ptr)))__gu_val;                             \
 	__gu_err;                                                       \
 })
 
-- 
MST

