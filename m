Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934072Ab3E1NQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:16:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50313 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933986Ab3E1NQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:16:31 -0400
Date: Tue, 28 May 2013 06:15:40 -0700
From: "tip-bot for Michael S. Tsirkin" <tipbot@zytor.com>
Message-ID: <tip-56d2ef789f7c424918abdf6b95d84a64c1473220@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        catalin.marinas@arm.com, mst@redhat.com, peterz@infradead.org,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mst@redhat.com, catalin.marinas@arm.com, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org,
        akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <1369577426-26721-2-git-send-email-mst@redhat.com>
References: <1369577426-26721-2-git-send-email-mst@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/mm] arm64: uaccess s/might_sleep/might_fault/
Git-Commit-ID: 56d2ef789f7c424918abdf6b95d84a64c1473220
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

Commit-ID:  56d2ef789f7c424918abdf6b95d84a64c1473220
Gitweb:     http://git.kernel.org/tip/56d2ef789f7c424918abdf6b95d84a64c1473220
Author:     Michael S. Tsirkin <mst@redhat.com>
AuthorDate: Sun, 26 May 2013 17:30:42 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 09:41:06 +0200

arm64: uaccess s/might_sleep/might_fault/

The only reason uaccess routines might sleep
is if they fault. Make this explicit.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1369577426-26721-2-git-send-email-mst@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
