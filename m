Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbbAFPoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:44:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755741AbbAFPoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:44:22 -0500
Date: Tue, 6 Jan 2015 17:44:06 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Jonas Bonn <jonas@southpole.se>, linux@openrisc.net
Subject: [PATCH v2 11/40] openrisc/uaccess: fix sparse errors
Message-ID: <1420558883-10131-12-git-send-email-mst@redhat.com>
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
 arch/openrisc/include/asm/uaccess.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/openrisc/include/asm/uaccess.h b/arch/openrisc/include/asm/uaccess.h
index ab2e7a1..a6bd07c 100644
--- a/arch/openrisc/include/asm/uaccess.h
+++ b/arch/openrisc/include/asm/uaccess.h
@@ -192,7 +192,7 @@ struct __large_struct {
 ({								\
 	long __gu_err, __gu_val;				\
 	__get_user_size(__gu_val, (ptr), (size), __gu_err);	\
-	(x) = (__typeof__(*(ptr)))__gu_val;			\
+	(x) = (__force __typeof__(*(ptr)))__gu_val;		\
 	__gu_err;						\
 })
 
@@ -202,7 +202,7 @@ struct __large_struct {
 	const __typeof__(*(ptr)) * __gu_addr = (ptr);			\
 	if (access_ok(VERIFY_READ, __gu_addr, size))			\
 		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
-	(x) = (__typeof__(*(ptr)))__gu_val;				\
+	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
 	__gu_err;							\
 })
 
-- 
MST

