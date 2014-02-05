Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbaBEUND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:13:03 -0500
Received: from mail.windriver.com ([147.11.1.11]:55683 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbaBEUIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:08:17 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Darren Hart <dvhart@linux.intel.com>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 201/213] futex: Fix bug in WARN_ON for NULL q.pi_state
Date: Wed, 5 Feb 2014 15:02:36 -0500
Message-ID: <1391630568-49251-202-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhart@linux.intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f27071cb7fe3e1d37a9dbe6c0dfc5395cd40fa43 upstream.

The WARN_ON in futex_wait_requeue_pi() for a NULL q.pi_state was testing
the address (&q.pi_state) of the pointer instead of the value
(q.pi_state) of the pointer. Correct it accordingly.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>
Link: http://lkml.kernel.org/r/1c85d97f6e5f79ec389a4ead3e367363c74bd09a.1342809673.git.dvhart@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/futex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 4a8f72850152..d4e7f0ea1f94 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2321,7 +2321,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 		 * signal.  futex_unlock_pi() will not destroy the lock_ptr nor
 		 * the pi_state.
 		 */
-		WARN_ON(!&q.pi_state);
+		WARN_ON(!q.pi_state);
 		pi_mutex = &q.pi_state->pi_mutex;
 		ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
 		debug_rt_mutex_free_waiter(&rt_waiter);
-- 
1.8.5.2

