Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3AYKlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:41:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40834 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab3AYKlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:41:00 -0500
Date: Fri, 25 Jan 2013 02:40:15 -0800
From: tip-bot for Paul Bolle <pebolle@tiscali.nl>
Message-ID: <tip-61b48fd031db92de6fe74ebba4bc3799bd55c3fa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, bfields@redhat.com, pebolle@tiscali.nl,
        skinsbursky@parallels.com, tglx@linutronix.de
Reply-To: pebolle@tiscali.nl, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, skinsbursky@parallels.com,
        peterz@infradead.org, tglx@linutronix.de, bfields@redhat.com
In-Reply-To: <1359060797.1325.33.camel@x61.thuisdomein>
References: <1359060797.1325.33.camel@x61.thuisdomein>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Silence warning if CONFIG_LOCKDEP isn
 't set
Git-Commit-ID: 61b48fd031db92de6fe74ebba4bc3799bd55c3fa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 02:40:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61b48fd031db92de6fe74ebba4bc3799bd55c3fa
Gitweb:     http://git.kernel.org/tip/61b48fd031db92de6fe74ebba4bc3799bd55c3fa
Author:     Paul Bolle <pebolle@tiscali.nl>
AuthorDate: Thu, 24 Jan 2013 21:53:17 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 25 Jan 2013 08:43:57 +0100

lockdep: Silence warning if CONFIG_LOCKDEP isn't set

Since commit c9a4962881929df7f1ef6e63e1b9da304faca4dd ("nfsd:
make client_lock per net") compiling nfs4state.o without
CONFIG_LOCKDEP set, triggers this GCC warning:

    fs/nfsd/nfs4state.c: In function ‘free_client’:
    fs/nfsd/nfs4state.c:1051:19: warning: unused variable ‘nn’ [-Wunused-variable]

The cause of that warning is that lockdep_assert_held() compiles
away if CONFIG_LOCKDEP is not set. Silence this warning by using
the argument to lockdep_assert_held() as a nop if CONFIG_LOCKDEP
is not set.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: J. Bruce Fields <bfields@redhat.com>
Link: http://lkml.kernel.org/r/1359060797.1325.33.camel@x61.thuisdomein
Signed-off-by: Ingo Molnar <mingo@kernel.org>
--
 include/linux/lockdep.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
---
 include/linux/lockdep.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 2bca44b..f05631e 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -410,7 +410,7 @@ struct lock_class_key { };
 
 #define lockdep_depth(tsk)	(0)
 
-#define lockdep_assert_held(l)			do { } while (0)
+#define lockdep_assert_held(l)			do { (void)(l); } while (0)
 
 #define lockdep_recursing(tsk)			(0)
 
