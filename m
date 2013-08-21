Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab3HUQrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:47:03 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:50602 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab3HUQrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:47:01 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>, Don Zickus <dzickus@redhat.com>
Subject: [RFC PATCH 4/6] seqlock: Add raw_seqbegin() for non-waiting readers
Date: Wed, 21 Aug 2013 18:42:19 +0200
Message-Id: <1377103341-15235-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1377103341-15235-1-git-send-email-fweisbec@gmail.com>
References: <1377103341-15235-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the seqlock version of raw_seqcount_begin() for readers
that can't wait for writers to complete their update and
who can live with seqlock read acquirement failure.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Don Zickus <dzickus@redhat.com>
---
 include/linux/seqlock.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 1829905..aa845de 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -203,6 +203,11 @@ static inline unsigned read_seqbegin(const seqlock_t *sl)
 	return read_seqcount_begin(&sl->seqcount);
 }
 
+static inline unsigned raw_seqbegin(const seqlock_t *sl)
+{
+	return raw_seqcount_begin(&sl->seqcount);
+}
+
 static inline unsigned read_seqretry(const seqlock_t *sl, unsigned start)
 {
 	return read_seqcount_retry(&sl->seqcount, start);
-- 
1.7.5.4

