Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbaIIOyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:54:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41076 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbaIIOyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:54:00 -0400
Date: Tue, 9 Sep 2014 07:52:53 -0700
From: tip-bot for Andreea-Cristina Bernat <tipbot@zytor.com>
Message-ID: <tip-e0455e194a5e0cf49bc7596a20d4f7e47995b9c6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, acme@kernel.org, tglx@linutronix.de,
        bernat.ada@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, acme@kernel.org,
        bernat.ada@gmail.com
In-Reply-To: <20140822141536.GA32051@ada>
References: <20140822141536.GA32051@ada>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/callchain: Replace rcu_assign_pointer()
  with RCU_INIT_POINTER()
Git-Commit-ID: e0455e194a5e0cf49bc7596a20d4f7e47995b9c6
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

Commit-ID:  e0455e194a5e0cf49bc7596a20d4f7e47995b9c6
Gitweb:     http://git.kernel.org/tip/e0455e194a5e0cf49bc7596a20d4f7e47995b9c6
Author:     Andreea-Cristina Bernat <bernat.ada@gmail.com>
AuthorDate: Fri, 22 Aug 2014 17:15:36 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 9 Sep 2014 06:53:04 +0200

perf/callchain: Replace rcu_assign_pointer() with RCU_INIT_POINTER()

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
Cc: paulmck@linux.vnet.ibm.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Link: http://lkml.kernel.org/r/20140822141536.GA32051@ada
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/callchain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 97b67df..f2a88de 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -52,7 +52,7 @@ static void release_callchain_buffers(void)
 	struct callchain_cpus_entries *entries;
 
 	entries = callchain_cpus_entries;
-	rcu_assign_pointer(callchain_cpus_entries, NULL);
+	RCU_INIT_POINTER(callchain_cpus_entries, NULL);
 	call_rcu(&entries->rcu_head, release_callchain_buffers_rcu);
 }
 
