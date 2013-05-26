Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab3EZOcM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 10:32:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab3EZOcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 10:32:09 -0400
Date: Sun, 26 May 2013 17:31:55 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH v3-resend 09/11] x86: uaccess s/might_sleep/might_fault/
Message-ID: <1369577426-26721-9-git-send-email-mst@redhat.com>
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
Acked-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/uaccess_64.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 142810c..4f7923d 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -235,7 +235,7 @@ extern long __copy_user_nocache(void *dst, const void __user *src,
 static inline int
 __copy_from_user_nocache(void *dst, const void __user *src, unsigned size)
 {
-	might_sleep();
+	might_fault();
 	return __copy_user_nocache(dst, src, size, 1);
 }
 
-- 
MST
