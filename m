Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab3JVQMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:12:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:35238 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875Ab3JVQMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:12:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,549,1378882800"; 
   d="scan'208";a="420881097"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 10/11] asmlinkage: Mark rwsem functions that can be called from assembler asmlinkage
Date: Tue, 22 Oct 2013 09:12:25 -0700
Message-Id: <1382458346-24811-11-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
References: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 lib/rwsem.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 19c5fa9..1d66e08 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -143,6 +143,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
 /*
  * wait for the read lock to be granted
  */
+__visible
 struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 {
 	long count, adjustment = -RWSEM_ACTIVE_READ_BIAS;
@@ -190,6 +191,7 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 /*
  * wait until we successfully acquire the write lock
  */
+__visible
 struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 {
 	long count, adjustment = -RWSEM_ACTIVE_WRITE_BIAS;
@@ -252,6 +254,7 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
  * handle waking up a waiter on the semaphore
  * - up_read/up_write has decremented the active part of count if we come here
  */
+__visible
 struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
@@ -272,6 +275,7 @@ struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
  * - caller incremented waiting part of count and discovered it still negative
  * - just wake up any readers at the front of the queue
  */
+__visible
 struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
-- 
1.8.3.1

