Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab3EXORg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:17:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703Ab3EXORe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:17:34 -0400
Date: Fri, 24 May 2013 17:17:54 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Subject: [PATCH v3 03/11] frv: uaccess s/might_sleep/might_fault/
Message-ID: <1369404522-12927-3-git-send-email-mst@redhat.com>
References: <cover.1368702323.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1368702323.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only reason uaccess routines might sleep
is if they fault. Make this explicit.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/frv/include/asm/uaccess.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/frv/include/asm/uaccess.h b/arch/frv/include/asm/uaccess.h
index 0b67ec5..3ac9a59 100644
--- a/arch/frv/include/asm/uaccess.h
+++ b/arch/frv/include/asm/uaccess.h
@@ -280,14 +280,14 @@ extern long __memcpy_user(void *dst, const void *src, unsigned long count);
 static inline unsigned long __must_check
 __copy_to_user(void __user *to, const void *from, unsigned long n)
 {
-       might_sleep();
+       might_fault();
        return __copy_to_user_inatomic(to, from, n);
 }
 
 static inline unsigned long
 __copy_from_user(void *to, const void __user *from, unsigned long n)
 {
-       might_sleep();
+       might_fault();
        return __copy_from_user_inatomic(to, from, n);
 }
 
-- 
MST
