Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab3JNJ2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 05:28:47 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:56200 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab3JNJ2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 05:28:32 -0400
From: Matias Bjorling <m@bjorling.me>
To: tj@kernel.org, kmo@daterainc.com, paulmck@linux.vnet.ibm.com,
        tytso@mit.edu
Cc: linux-kernel@vger.kernel.org, Matias Bjorling <m@bjorling.me>
Subject: [PATCH] percpu_refcount: Export symbols
Date: Mon, 14 Oct 2013 10:55:32 +0200
Message-Id: <1381740932-14419-2-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381740932-14419-1-git-send-email-m@bjorling.me>
References: <1381740932-14419-1-git-send-email-m@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the interface to be used within modules.

Signed-off-by: Matias Bjorling <m@bjorling.me>
---
 lib/percpu-refcount.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 7deeb62..1a53d49 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -53,6 +53,7 @@ int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release)
 	ref->release = release;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(percpu_ref_init);
 
 /**
  * percpu_ref_cancel_init - cancel percpu_ref_init()
@@ -84,6 +85,7 @@ void percpu_ref_cancel_init(struct percpu_ref *ref)
 		free_percpu(ref->pcpu_count);
 	}
 }
+EXPORT_SYMBOL_GPL(percpu_ref_cancel_init);
 
 static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 {
@@ -156,3 +158,4 @@ void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 
 	call_rcu_sched(&ref->rcu, percpu_ref_kill_rcu);
 }
+EXPORT_SYMBOL_GPL(percpu_ref_kill_and_confirm);
-- 
1.8.1.2

