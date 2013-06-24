Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab3FXTbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:31:43 -0400
Received: from mail1.windriver.com ([147.11.146.13]:54050 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab3FXTbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:31:39 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: [PATCH 28/32] net: delete __cpuinit usage from all net files
Date: Mon, 24 Jun 2013 15:30:33 -0400
Message-ID: <1372102237-8757-29-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __cpuinit type of throwaway sections might have made sense
some time ago when RAM was more constrained, but now the savings
do not offset the cost and complications.  For example, the fix in
commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
is a good example of the nasty type of bugs that can be created
with improper use of the various __init prefixes.

After a discussion on LKML[1] it was decided that cpuinit should go
the way of devinit and be phased out.  Once all the users are gone,
we can then finally remove the macros themselves from linux/init.h.

This removes all the net/* uses of the __cpuinit macros
from all C files.

[1] https://lkml.org/lkml/2013/5/20/589

Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 net/core/flow.c | 4 ++--
 net/iucv/iucv.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/flow.c b/net/core/flow.c
index 7102f16..dfa602c 100644
--- a/net/core/flow.c
+++ b/net/core/flow.c
@@ -403,7 +403,7 @@ void flow_cache_flush_deferred(void)
 	schedule_work(&flow_cache_flush_work);
 }
 
-static int __cpuinit flow_cache_cpu_prepare(struct flow_cache *fc, int cpu)
+static int flow_cache_cpu_prepare(struct flow_cache *fc, int cpu)
 {
 	struct flow_cache_percpu *fcp = per_cpu_ptr(fc->percpu, cpu);
 	size_t sz = sizeof(struct hlist_head) * flow_cache_hash_size(fc);
@@ -421,7 +421,7 @@ static int __cpuinit flow_cache_cpu_prepare(struct flow_cache *fc, int cpu)
 	return 0;
 }
 
-static int __cpuinit flow_cache_cpu(struct notifier_block *nfb,
+static int flow_cache_cpu(struct notifier_block *nfb,
 			  unsigned long action,
 			  void *hcpu)
 {
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 4fe76ff..cd5b8ec 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -621,7 +621,7 @@ static void iucv_disable(void)
 	put_online_cpus();
 }
 
-static int __cpuinit iucv_cpu_notify(struct notifier_block *self,
+static int iucv_cpu_notify(struct notifier_block *self,
 				     unsigned long action, void *hcpu)
 {
 	cpumask_t cpumask;
-- 
1.8.1.2

