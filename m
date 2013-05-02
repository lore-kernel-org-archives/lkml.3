Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889Ab3EBCVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 22:21:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807Ab3EBCVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 22:21:47 -0400
Date: Thu, 2 May 2013 05:21:34 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH RFC] x86: uaccess s/might_sleep/might_fault/
Message-ID: <20130502022134.GA7700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only reason uaccess routines might sleep
is if they fault. Make this explicit for
__copy_from_user_nocache, and consistent with
copy_from_user and friends.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

I've updated all other arches as well - still
build-testing. Any objections to the x86 patch?

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
