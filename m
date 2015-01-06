Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbbAFPoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:44:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555AbbAFPoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:44:03 -0500
Date: Tue, 6 Jan 2015 17:43:50 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH v2 06/40] cris/uaccess: fix sparse errors
Message-ID: <1420558883-10131-7-git-send-email-mst@redhat.com>
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
 arch/cris/include/asm/uaccess.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/cris/include/asm/uaccess.h b/arch/cris/include/asm/uaccess.h
index 9145408..9cf5a23 100644
--- a/arch/cris/include/asm/uaccess.h
+++ b/arch/cris/include/asm/uaccess.h
@@ -153,7 +153,7 @@ struct __large_struct { unsigned long buf[100]; };
 ({								\
 	long __gu_err, __gu_val;				\
 	__get_user_size(__gu_val,(ptr),(size),__gu_err);	\
-	(x) = (__typeof__(*(ptr)))__gu_val;			\
+	(x) = (__force __typeof__(*(ptr)))__gu_val;		\
 	__gu_err;						\
 })
 
@@ -163,7 +163,7 @@ struct __large_struct { unsigned long buf[100]; };
 	const __typeof__(*(ptr)) *__gu_addr = (ptr);			\
 	if (access_ok(VERIFY_READ,__gu_addr,size))			\
 		__get_user_size(__gu_val,__gu_addr,(size),__gu_err);	\
-	(x) = (__typeof__(*(ptr)))__gu_val;				\
+	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
 	__gu_err;							\
 })
 
-- 
MST

