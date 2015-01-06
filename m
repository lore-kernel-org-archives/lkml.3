Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbbAFPyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:54:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755594AbbAFPoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:44:06 -0500
Date: Tue, 6 Jan 2015 17:43:57 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Subject: [PATCH v2 08/40] m32r/uaccess: fix sparse errors
Message-ID: <1420558883-10131-9-git-send-email-mst@redhat.com>
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
 arch/m32r/include/asm/uaccess.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m32r/include/asm/uaccess.h b/arch/m32r/include/asm/uaccess.h
index 84fe7ba..d076942 100644
--- a/arch/m32r/include/asm/uaccess.h
+++ b/arch/m32r/include/asm/uaccess.h
@@ -218,7 +218,7 @@ extern int fixup_exception(struct pt_regs *regs);
 	unsigned long __gu_val;						\
 	might_fault();							\
 	__get_user_size(__gu_val,(ptr),(size),__gu_err);		\
-	(x) = (__typeof__(*(ptr)))__gu_val;				\
+	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
 	__gu_err;							\
 })
 
@@ -230,7 +230,7 @@ extern int fixup_exception(struct pt_regs *regs);
 	might_fault();							\
 	if (access_ok(VERIFY_READ,__gu_addr,size))			\
 		__get_user_size(__gu_val,__gu_addr,(size),__gu_err);	\
-	(x) = (__typeof__(*(ptr)))__gu_val;				\
+	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
 	__gu_err;							\
 })
 
-- 
MST

