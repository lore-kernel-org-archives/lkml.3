Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab3BKM3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:29:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60136 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab3BKM3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:29:11 -0500
Date: Mon, 11 Feb 2013 04:28:56 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-8299c063bfa238da87fbdd15b1c3a31ca6e8ff74@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <1360456781-32462-7-git-send-email-sasha.levin@oracle.com>
References: <1360456781-32462-7-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] liblockdep:
  Prevent multiple declarations of CALLER_ADDR0
Git-Commit-ID: 8299c063bfa238da87fbdd15b1c3a31ca6e8ff74
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Feb 2013 04:29:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8299c063bfa238da87fbdd15b1c3a31ca6e8ff74
Gitweb:     http://git.kernel.org/tip/8299c063bfa238da87fbdd15b1c3a31ca6e8ff74
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Sat, 9 Feb 2013 19:39:37 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Feb 2013 10:12:39 +0100

liblockdep: Prevent multiple declarations of CALLER_ADDR0

They are declared once in the public and once in the private
headers, prevent declaring them twice if both headers are used.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: jamie.iles@oracle.com
Cc: penberg@kernel.org
Cc: acme@ghostprotocols.net
Cc: paulus@samba.org
Cc: namhyung@kernel.org
Cc: peterz@infradead.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1360456781-32462-7-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/lib/lockdep/include/liblockdep/common.h | 3 +++
 tools/lib/lockdep/uinclude/linux/kernel.h     | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/tools/lib/lockdep/include/liblockdep/common.h b/tools/lib/lockdep/include/liblockdep/common.h
index a675ef0..1bad66c 100644
--- a/tools/lib/lockdep/include/liblockdep/common.h
+++ b/tools/lib/lockdep/include/liblockdep/common.h
@@ -3,8 +3,11 @@
 
 #include <pthread.h>
 
+#ifndef CALLER_ADDR0
 #define CALLER_ADDR0 (__builtin_return_address(0))
 #define _THIS_IP_ CALLER_ADDR0
+#endif
+
 #define NR_LOCKDEP_CACHING_CLASSES 2
 #define MAX_LOCKDEP_SUBCLASSES 8UL
 
diff --git a/tools/lib/lockdep/uinclude/linux/kernel.h b/tools/lib/lockdep/uinclude/linux/kernel.h
index da97ce8..af02ac1 100644
--- a/tools/lib/lockdep/uinclude/linux/kernel.h
+++ b/tools/lib/lockdep/uinclude/linux/kernel.h
@@ -28,7 +28,9 @@
 #define noinline
 #define list_add_tail_rcu list_add_tail
 
+#ifndef CALLER_ADDR0
 #define _THIS_IP_ CALLER_ADDR0
 #define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
+#endif
 
 #endif
