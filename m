Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbaFFP4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:56:25 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:59406 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaFFP4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:56:05 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: peterz@infradead.org, mingo@kernel.org
Cc: mpatocka@redhat.com, torvalds@linux-foundation.org, jason.low2@hp.com,
        waiman.long@hp.com, jejb@parisc-linux.org, paulmck@linux.vnet.ibm.com,
        dave.anglin@bell.net, aswin@hp.com, davidlohr@hp.com,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: [PATCH 2/2] locking/rwsem: Disable optimistic spinning for PA-RISC
Date: Fri,  6 Jun 2014 08:55:40 -0700
Message-Id: <1402070140-15090-3-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1402070140-15090-1-git-send-email-davidlohr@hp.com>
References: <1402070140-15090-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PA-RISC's cmpxchg is not save against normal stores and the code used
for optimistic spinning is known broken because of this.

Disable for now.

[Changelog from PeterZ]
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 kernel/Kconfig.locks | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index e4c3162..125c77a 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -226,7 +226,7 @@ config MUTEX_SPIN_ON_OWNER
 
 config RWSEM_SPIN_ON_OWNER
        def_bool y
-       depends on SMP && RWSEM_XCHGADD_ALGORITHM
+       depends on SMP && RWSEM_XCHGADD_ALGORITHM && !PARISC
 
 config ARCH_USE_QUEUE_RWLOCK
 	bool
-- 
1.8.1.4

