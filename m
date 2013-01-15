Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab3AOV1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:27:55 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:57433 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab3AOV1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:27:39 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 4/4] Export __lockdep_no_validate__
Date: Tue, 15 Jan 2013 13:25:42 -0800
Message-Id: <1358285142-10576-4-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1358285142-10576-1-git-send-email-koverstreet@google.com>
References: <1358285142-10576-1-git-send-email-koverstreet@google.com>
In-Reply-To: <20130114223202.GV26407@google.com>
References: <20130114223202.GV26407@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hack, but bcache needs a way around lockdep for locking during garbage
collection - we need to keep multiple btree nodes locked for coalescing
and rw_lock_nested() isn't really sufficient or appropriate here.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>
---
 kernel/lockdep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 7981e5b..861fbeb 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2997,6 +2997,7 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 EXPORT_SYMBOL_GPL(lockdep_init_map);
 
 struct lock_class_key __lockdep_no_validate__;
+EXPORT_SYMBOL_GPL(__lockdep_no_validate__);
 
 static int
 print_lock_nested_lock_not_held(struct task_struct *curr,
-- 
1.7.12

