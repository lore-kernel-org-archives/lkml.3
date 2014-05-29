Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965151AbaE2OXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:23:55 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59301 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932809AbaE2Nt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Guy Briggs <rgb@redhat.com>,
        Eric Paris <eparis@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 011/103] sched: declare pid_alive as inline
Date: Thu, 29 May 2014 15:47:56 +0200
Message-Id: <67ded0151926a7721f71ba86cec60ca8ce6f072e.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 80e0b6e8a001361316a2d62b748fe677ec46b860 upstream.

We accidentally declared pid_alive without any extern/inline connotation.
Some platforms were fine with this, some like ia64 and mips were very angry.
If the function is inline, the prototype should be inline!

on ia64:
include/linux/sched.h:1718: warning: 'pid_alive' declared inline after
being called

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 62b89d2f9c01..8594b065d3a8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1501,7 +1501,7 @@ static inline pid_t task_tgid_vnr(struct task_struct *tsk)
 }
 
 
-static int pid_alive(const struct task_struct *p);
+static inline int pid_alive(const struct task_struct *p);
 static inline pid_t task_ppid_nr_ns(const struct task_struct *tsk, struct pid_namespace *ns)
 {
 	pid_t pid = 0;
-- 
1.9.3

