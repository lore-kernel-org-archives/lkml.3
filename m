Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab3EZOb4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 10:31:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741Ab3EZOby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 10:31:54 -0400
Date: Sun, 26 May 2013 17:31:48 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH v3-resend 08/11] tile: uaccess s/might_sleep/might_fault/
Message-ID: <1369577426-26721-8-git-send-email-mst@redhat.com>
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
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/uaccess.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/tile/include/asm/uaccess.h b/arch/tile/include/asm/uaccess.h
index 8a082bc..e4d44bd 100644
--- a/arch/tile/include/asm/uaccess.h
+++ b/arch/tile/include/asm/uaccess.h
@@ -442,7 +442,7 @@ extern unsigned long __copy_in_user_inatomic(
 static inline unsigned long __must_check
 __copy_in_user(void __user *to, const void __user *from, unsigned long n)
 {
-	might_sleep();
+	might_fault();
 	return __copy_in_user_inatomic(to, from, n);
 }
 
-- 
MST
