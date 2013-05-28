Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934091Ab3E1NV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:21:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50383 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933921Ab3E1NV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:21:27 -0400
Date: Tue, 28 May 2013 06:20:45 -0700
From: "tip-bot for Michael S. Tsirkin" <tipbot@zytor.com>
Message-ID: <tip-3837a3cfe4a27836e0e9f207eb2d4f00b5a8fcba@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, mst@redhat.com,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mst@redhat.com, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <1369577426-26721-6-git-send-email-mst@redhat.com>
References: <1369577426-26721-6-git-send-email-mst@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/mm] mn10300: uaccess s/might_sleep/might_fault/
Git-Commit-ID: 3837a3cfe4a27836e0e9f207eb2d4f00b5a8fcba
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

Commit-ID:  3837a3cfe4a27836e0e9f207eb2d4f00b5a8fcba
Gitweb:     http://git.kernel.org/tip/3837a3cfe4a27836e0e9f207eb2d4f00b5a8fcba
Author:     Michael S. Tsirkin <mst@redhat.com>
AuthorDate: Sun, 26 May 2013 17:31:05 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 09:41:08 +0200

mn10300: uaccess s/might_sleep/might_fault/

The only reason uaccess routines might sleep
is if they fault. Make this explicit.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1369577426-26721-6-git-send-email-mst@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/mn10300/include/asm/uaccess.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mn10300/include/asm/uaccess.h b/arch/mn10300/include/asm/uaccess.h
index 780560b..107508a 100644
--- a/arch/mn10300/include/asm/uaccess.h
+++ b/arch/mn10300/include/asm/uaccess.h
@@ -471,13 +471,13 @@ extern unsigned long __generic_copy_from_user(void *, const void __user *,
 
 #define __copy_to_user(to, from, n)			\
 ({							\
-	might_sleep();					\
+	might_fault();					\
 	__copy_to_user_inatomic((to), (from), (n));	\
 })
 
 #define __copy_from_user(to, from, n)			\
 ({							\
-	might_sleep();					\
+	might_fault();					\
 	__copy_from_user_inatomic((to), (from), (n));	\
 })
 
