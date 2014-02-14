Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaBND7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 22:59:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47873 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaBND70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 22:59:26 -0500
Date: Thu, 13 Feb 2014 19:59:16 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-3ebae4f3a2e746ae17f25c741e249294e7d6d7c2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1391845930-28580-9-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-9-git-send-email-ak@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] asmlinkage:
  Mark rwsem functions that can be called from assembler asmlinkage
Git-Commit-ID: 3ebae4f3a2e746ae17f25c741e249294e7d6d7c2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 19:59:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ebae4f3a2e746ae17f25c741e249294e7d6d7c2
Gitweb:     http://git.kernel.org/tip/3ebae4f3a2e746ae17f25c741e249294e7d6d7c2
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 8 Feb 2014 08:52:05 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 18:13:37 -0800

asmlinkage: Mark rwsem functions that can be called from assembler asmlinkage

Mark the rwsem functions that can be called from assembler asmlinkage.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1391845930-28580-9-git-send-email-ak@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 kernel/locking/rwsem-xadd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 19c5fa9..1d66e08 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
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
