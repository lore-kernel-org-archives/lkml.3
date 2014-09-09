Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbaIIOyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:54:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41073 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbaIIOyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:54:00 -0400
Date: Tue, 9 Sep 2014 07:53:08 -0700
From: tip-bot for Andreea-Cristina Bernat <tipbot@zytor.com>
Message-ID: <tip-70691d4a0bf7c871559d4ef1b0056edefbca123b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, acme@kernel.org, tglx@linutronix.de,
        bernat.ada@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, acme@kernel.org,
        bernat.ada@gmail.com
In-Reply-To: <20140822132605.GA20130@ada>
References: <20140822132605.GA20130@ada>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/core: Replace rcu_assign_pointer()
  with RCU_INIT_POINTER()
Git-Commit-ID: 70691d4a0bf7c871559d4ef1b0056edefbca123b
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

Commit-ID:  70691d4a0bf7c871559d4ef1b0056edefbca123b
Gitweb:     http://git.kernel.org/tip/70691d4a0bf7c871559d4ef1b0056edefbca123b
Author:     Andreea-Cristina Bernat <bernat.ada@gmail.com>
AuthorDate: Fri, 22 Aug 2014 16:26:05 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 9 Sep 2014 06:53:05 +0200

perf/core: Replace rcu_assign_pointer() with RCU_INIT_POINTER()

The use of "rcu_assign_pointer()" is NULLing out the pointer.
According to RCU_INIT_POINTER()'s block comment:

  "1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"

it is better to use it instead of rcu_assign_pointer() because it has a
smaller overhead.

The following Coccinelle semantic patch was used:
  @@
  @@

  - rcu_assign_pointer
  + RCU_INIT_POINTER
    (..., NULL)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Link: http://lkml.kernel.org/r/20140822132605.GA20130@ada
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 01bd42e..f917dec 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5908,7 +5908,7 @@ static void swevent_hlist_release(struct swevent_htable *swhash)
 	if (!hlist)
 		return;
 
-	rcu_assign_pointer(swhash->swevent_hlist, NULL);
+	RCU_INIT_POINTER(swhash->swevent_hlist, NULL);
 	kfree_rcu(hlist, rcu_head);
 }
 
