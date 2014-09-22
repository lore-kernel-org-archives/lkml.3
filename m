Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaIVRzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:55:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:21255 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085AbaIVRzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:55:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,572,1406617200"; 
   d="scan'208";a="606693092"
Subject: [PATCH] sched: Remove nested extern
From: Mark D Rustad <mark.d.rustad@intel.com>
To: sparse@chrisli.org
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        richard.weinberger@gmail.com, linux-sparse@vger.kernel.org,
        mingo@redhat.com, jeffrey.t.kirsher@intel.com, mark.d.rustad@intel.com,
        computersforpeace@gmail.com
Date: Mon, 22 Sep 2014 10:55:11 -0700
Message-ID: <20140922175511.62229.98784.stgit@mdrustad-wks.jf.intel.com>
In-Reply-To: <CAFLxGvwfuE-458duC9ARMLLMBCvZaBQnwDjPW6uJC4FAViBXjQ@mail.gmail.com>
References: <CAFLxGvwfuE-458duC9ARMLLMBCvZaBQnwDjPW6uJC4FAViBXjQ@mail.gmail.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid W=2 nested-externs warning by moving the nested extern to
a normal extern. This eliminates that warning which is generated
for every inclusion of sched.h in a kernel build when W=2 is used.
This also removes a point of maintenance if the definition of
delayacct_on were ever to change.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
---
 include/linux/delayacct.h |    1 -
 include/linux/sched.h     |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/delayacct.h b/include/linux/delayacct.h
index 6cee17c22313..51229790af00 100644
--- a/include/linux/delayacct.h
+++ b/include/linux/delayacct.h
@@ -30,7 +30,6 @@
 
 #ifdef CONFIG_TASK_DELAY_ACCT
 
-extern int delayacct_on;	/* Delay accounting turned on/off */
 extern struct kmem_cache *delayacct_cache;
 extern void delayacct_init(void);
 extern void __delayacct_tsk_init(struct task_struct *);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5c2c885ee52b..1f1dcfdcd92c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -825,6 +825,8 @@ struct task_delay_info {
 	u64 freepages_delay;	/* wait for memory reclaim */
 	u32 freepages_count;	/* total count of memory reclaim */
 };
+
+extern int delayacct_on;	/* Delay accounting turned on/off */
 #endif	/* CONFIG_TASK_DELAY_ACCT */
 
 static inline int sched_info_on(void)
@@ -832,7 +834,6 @@ static inline int sched_info_on(void)
 #ifdef CONFIG_SCHEDSTATS
 	return 1;
 #elif defined(CONFIG_TASK_DELAY_ACCT)
-	extern int delayacct_on;
 	return delayacct_on;
 #else
 	return 0;

