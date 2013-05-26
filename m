Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab3EZOa5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 10:30:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab3EZOas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 10:30:48 -0400
Date: Sun, 26 May 2013 17:30:42 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3-resend 02/11] arm64: uaccess s/might_sleep/might_fault/
Message-ID: <1369577426-26721-2-git-send-email-mst@redhat.com>
References: <1369575487-26176-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369575487-26176-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only reason uaccess routines might sleep
is if they fault. Make this explicit.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/uaccess.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 008f848..edb3d5c 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -166,7 +166,7 @@ do {									\
 
 #define get_user(x, ptr)						\
 ({									\
-	might_sleep();							\
+	might_fault();							\
 	access_ok(VERIFY_READ, (ptr), sizeof(*(ptr))) ?			\
 		__get_user((x), (ptr)) :				\
 		((x) = 0, -EFAULT);					\
@@ -227,7 +227,7 @@ do {									\
 
 #define put_user(x, ptr)						\
 ({									\
-	might_sleep();							\
+	might_fault();							\
 	access_ok(VERIFY_WRITE, (ptr), sizeof(*(ptr))) ?		\
 		__put_user((x), (ptr)) :				\
 		-EFAULT;						\
-- 
MST
