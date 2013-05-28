Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077Ab3E1NRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:17:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50328 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933986Ab3E1NRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:17:47 -0400
Date: Tue, 28 May 2013 06:16:56 -0700
From: "tip-bot for Michael S. Tsirkin" <tipbot@zytor.com>
Message-ID: <tip-b607ae78ac8a78f8e5e36817500e7c311519f032@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, mst@redhat.com,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mst@redhat.com, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <1369577426-26721-3-git-send-email-mst@redhat.com>
References: <1369577426-26721-3-git-send-email-mst@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/mm] frv: uaccess s/might_sleep/might_fault/
Git-Commit-ID: b607ae78ac8a78f8e5e36817500e7c311519f032
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

Commit-ID:  b607ae78ac8a78f8e5e36817500e7c311519f032
Gitweb:     http://git.kernel.org/tip/b607ae78ac8a78f8e5e36817500e7c311519f032
Author:     Michael S. Tsirkin <mst@redhat.com>
AuthorDate: Sun, 26 May 2013 17:30:47 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 09:41:07 +0200

frv: uaccess s/might_sleep/might_fault/

The only reason uaccess routines might sleep
is if they fault. Make this explicit.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1369577426-26721-3-git-send-email-mst@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
 
