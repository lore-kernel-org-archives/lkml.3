Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934083Ab3E1NYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:24:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50421 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491Ab3E1NYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:24:07 -0400
Date: Tue, 28 May 2013 06:23:18 -0700
From: "tip-bot for Michael S. Tsirkin" <tipbot@zytor.com>
Message-ID: <tip-f8abe86cc4fbd4ba083fd151b88e02fb3ce88b9c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, mst@redhat.com,
        peterz@infradead.org, cmetcalf@tilera.com, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mst@redhat.com, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, cmetcalf@tilera.com, akpm@linux-foundation.org,
        tglx@linutronix.de
In-Reply-To: <1369577426-26721-8-git-send-email-mst@redhat.com>
References: <1369577426-26721-8-git-send-email-mst@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/mm] tile: uaccess s/might_sleep/might_fault/
Git-Commit-ID: f8abe86cc4fbd4ba083fd151b88e02fb3ce88b9c
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

Commit-ID:  f8abe86cc4fbd4ba083fd151b88e02fb3ce88b9c
Gitweb:     http://git.kernel.org/tip/f8abe86cc4fbd4ba083fd151b88e02fb3ce88b9c
Author:     Michael S. Tsirkin <mst@redhat.com>
AuthorDate: Sun, 26 May 2013 17:31:48 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 09:41:09 +0200

tile: uaccess s/might_sleep/might_fault/

The only reason uaccess routines might sleep
is if they fault. Make this explicit.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1369577426-26721-8-git-send-email-mst@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
 
