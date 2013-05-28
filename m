Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086Ab3E1NUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:20:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50369 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933986Ab3E1NUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:20:23 -0400
Date: Tue, 28 May 2013 06:19:29 -0700
From: "tip-bot for Michael S. Tsirkin" <tipbot@zytor.com>
Message-ID: <tip-ac093f8d5e76be1f2654acfd7a59d339ba037654@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, mst@redhat.com,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mst@redhat.com, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <1369577426-26721-5-git-send-email-mst@redhat.com>
References: <1369577426-26721-5-git-send-email-mst@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/mm] microblaze: uaccess s/might_sleep/might_fault/
Git-Commit-ID: ac093f8d5e76be1f2654acfd7a59d339ba037654
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac093f8d5e76be1f2654acfd7a59d339ba037654
Gitweb:     http://git.kernel.org/tip/ac093f8d5e76be1f2654acfd7a59d339ba037654
Author:     Michael S. Tsirkin <mst@redhat.com>
AuthorDate: Sun, 26 May 2013 17:30:56 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 09:41:08 +0200

microblaze: uaccess s/might_sleep/might_fault/

The only reason uaccess routines might sleep
is if they fault. Make this explicit.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1369577426-26721-5-git-send-email-mst@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
