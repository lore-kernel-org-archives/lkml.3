Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbbAPT2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:28:04 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:44633 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781AbbAPT2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:28:01 -0500
Message-ID: <54B9663D.9070000@gmail.com>
Date: Fri, 16 Jan 2015 20:27:57 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: mtk.manpages@gmail.com, Ingo Molnar <mingo@elte.hu>,
        Darren Hart <darren@dvhart.com>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] doc: Fix misnamed FUTEX_CMP_REQUEUE_PI 'op' constants
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Kerrisk <mtk.manpages@gmail.com>

FUTEX_CMP_REQUEUE_PI was misnamed in two different ways:
FUTEX_REQUEUE_CMP_PI and FUTEX_REQUEUE_PI. The existence of two
different misnamings leaves the reader wondering if we are talking
about two different operations. Furthermore, the misnamings mean
that grepping the source for the correct name (which doesn't
appear at all) won't find this documentation file.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
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
-- 
1.9.3

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
