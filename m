Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbbASLKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:10:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43069 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbbASLK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:10:29 -0500
Date: Mon, 19 Jan 2015 03:10:09 -0800
From: tip-bot for Michael Kerrisk <tipbot@zytor.com>
Message-ID: <tip-40a35503401a5a5ffd8bb03b120724e213160584@git.kernel.org>
Cc: mingo@kernel.org, hpa@zytor.com, tglx@linutronix.de, darren@dvhart.com,
        linux-kernel@vger.kernel.org, mtk.manpages@gmail.com
Reply-To: darren@dvhart.com, tglx@linutronix.de, mtk.manpages@gmail.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com
In-Reply-To: <54B9663D.9070000@gmail.com>
References: <54B9663D.9070000@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] doc:
  Fix misnamed FUTEX_CMP_REQUEUE_PI op constants
Git-Commit-ID: 40a35503401a5a5ffd8bb03b120724e213160584
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

Commit-ID:  40a35503401a5a5ffd8bb03b120724e213160584
Gitweb:     http://git.kernel.org/tip/40a35503401a5a5ffd8bb03b120724e213160584
Author:     Michael Kerrisk <mtk.manpages@gmail.com>
AuthorDate: Fri, 16 Jan 2015 20:27:57 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 Jan 2015 12:05:32 +0100

doc: Fix misnamed FUTEX_CMP_REQUEUE_PI op constants

FUTEX_CMP_REQUEUE_PI was misnamed in two different ways:
FUTEX_REQUEUE_CMP_PI and FUTEX_REQUEUE_PI. The existence of two
different misnamings leaves the reader wondering if we are talking
about two different operations. Furthermore, the misnamings mean
that grepping the source for the correct name (which doesn't
appear at all) won't find this documentation file.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Reviewed-by: Darren Hart <darren@dvhart.com>
Link: http://lkml.kernel.org/r/54B9663D.9070000@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/futex-requeue-pi.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/futex-requeue-pi.txt b/Documentation/futex-requeue-pi.txt
index 31b1661..77b36f5 100644
--- a/Documentation/futex-requeue-pi.txt
+++ b/Documentation/futex-requeue-pi.txt
@@ -98,7 +98,7 @@ rt_mutex_start_proxy_lock() and rt_mutex_finish_proxy_lock(), which
 allow the requeue code to acquire an uncontended rt_mutex on behalf
 of the waiter and to enqueue the waiter on a contended rt_mutex.
 Two new system calls provide the kernel<->user interface to
-requeue_pi: FUTEX_WAIT_REQUEUE_PI and FUTEX_REQUEUE_CMP_PI.
+requeue_pi: FUTEX_WAIT_REQUEUE_PI and FUTEX_CMP_REQUEUE_PI.
 
 FUTEX_WAIT_REQUEUE_PI is called by the waiter (pthread_cond_wait()
 and pthread_cond_timedwait()) to block on the initial futex and wait
@@ -107,7 +107,7 @@ result of a high-speed collision between futex_wait() and
 futex_lock_pi(), with some extra logic to check for the additional
 wake-up scenarios.
 
-FUTEX_REQUEUE_CMP_PI is called by the waker
+FUTEX_CMP_REQUEUE_PI is called by the waker
 (pthread_cond_broadcast() and pthread_cond_signal()) to requeue and
 possibly wake the waiting tasks. Internally, this system call is
 still handled by futex_requeue (by passing requeue_pi=1).  Before
@@ -120,12 +120,12 @@ task as a waiter on the underlying rt_mutex.  It is possible that
 the lock can be acquired at this stage as well, if so, the next
 waiter is woken to finish the acquisition of the lock.
 
-FUTEX_REQUEUE_PI accepts nr_wake and nr_requeue as arguments, but
+FUTEX_CMP_REQUEUE_PI accepts nr_wake and nr_requeue as arguments, but
 their sum is all that really matters.  futex_requeue() will wake or
 requeue up to nr_wake + nr_requeue tasks.  It will wake only as many
 tasks as it can acquire the lock for, which in the majority of cases
 should be 0 as good programming practice dictates that the caller of
 either pthread_cond_broadcast() or pthread_cond_signal() acquire the
-mutex prior to making the call. FUTEX_REQUEUE_PI requires that
+mutex prior to making the call. FUTEX_CMP_REQUEUE_PI requires that
 nr_wake=1.  nr_requeue should be INT_MAX for broadcast and 0 for
 signal.
