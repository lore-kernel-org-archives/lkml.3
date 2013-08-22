Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab3HVHvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:51:09 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:42833 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab3HVHvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:51:07 -0400
Message-ID: <5215C2E3.7000905@linux.vnet.ibm.com>
Date: Thu, 22 Aug 2013 15:50:59 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: open list <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH 02/11] sched/cleanup: remove the extra parm of alloc_thread_info_node()
References: <5215C233.9060907@linux.vnet.ibm.com>
In-Reply-To: <5215C233.9060907@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082207-2000-0000-0000-00000D69FEFF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parm 'tsk' has not been used, remove it to make code clean.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/fork.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index e23bb19..457945f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -144,8 +144,7 @@ void __weak arch_release_thread_info(struct thread_info *ti)
  * kmemcache based allocator.
  */
 # if THREAD_SIZE >= PAGE_SIZE
-static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
-						  int node)
+static struct thread_info *alloc_thread_info_node(int node)
 {
 	struct page *page = alloc_pages_node(node, THREADINFO_GFP_ACCOUNTED,
 					     THREAD_SIZE_ORDER);
@@ -160,8 +159,7 @@ static inline void free_thread_info(struct thread_info *ti)
 # else
 static struct kmem_cache *thread_info_cache;
 
-static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
-						  int node)
+static struct thread_info *alloc_thread_info_node(int node)
 {
 	return kmem_cache_alloc_node(thread_info_cache, THREADINFO_GFP, node);
 }
@@ -302,7 +300,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 	if (!tsk)
 		return NULL;
 
-	ti = alloc_thread_info_node(tsk, node);
+	ti = alloc_thread_info_node(node);
 	if (!ti)
 		goto free_tsk;
 
-- 
1.7.9.5

