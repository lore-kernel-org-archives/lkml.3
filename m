Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab3EZObI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 10:31:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab3EZObG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 10:31:06 -0400
Date: Sun, 26 May 2013 17:30:56 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Simek <monstr@monstr.eu>,
        microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH v3-resend 05/11] microblaze: uaccess
 s/might_sleep/might_fault/
Message-ID: <1369577426-26721-5-git-send-email-mst@redhat.com>
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
---
 arch/microblaze/include/asm/uaccess.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/microblaze/include/asm/uaccess.h b/arch/microblaze/include/asm/uaccess.h
index efe59d8..2fc8bf7 100644
--- a/arch/microblaze/include/asm/uaccess.h
+++ b/arch/microblaze/include/asm/uaccess.h
@@ -145,7 +145,7 @@ static inline unsigned long __must_check __clear_user(void __user *to,
 static inline unsigned long __must_check clear_user(void __user *to,
 							unsigned long n)
 {
-	might_sleep();
+	might_fault();
 	if (unlikely(!access_ok(VERIFY_WRITE, to, n)))
 		return n;
 
@@ -371,7 +371,7 @@ extern long __user_bad(void);
 static inline long copy_from_user(void *to,
 		const void __user *from, unsigned long n)
 {
-	might_sleep();
+	might_fault();
 	if (access_ok(VERIFY_READ, from, n))
 		return __copy_from_user(to, from, n);
 	return n;
@@ -385,7 +385,7 @@ static inline long copy_from_user(void *to,
 static inline long copy_to_user(void __user *to,
 		const void *from, unsigned long n)
 {
-	might_sleep();
+	might_fault();
 	if (access_ok(VERIFY_WRITE, to, n))
 		return __copy_to_user(to, from, n);
 	return n;
-- 
MST
