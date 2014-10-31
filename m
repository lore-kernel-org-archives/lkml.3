Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623AbaJaLVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:21:47 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60047 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758904AbaJaLVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:21:44 -0400
Message-Id: <20141031111549.609601771@infradead.org>
User-Agent: quilt/0.61-1
Date: Fri, 31 Oct 2014 12:10:40 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, linux-kernel@vger.kernel.org
Cc: peter@hurleysoftware.com, oleg@redhat.com, rjw@rjwysocki.net,
        torvalds@linux-foundation.org, tglx@linutronix.de, eparis@redhat.com,
        umgwanakikbuti@gmail.com, marcel@holtmann.org, ebiederm@xmission.com,
        davem@davemloft.net, fengguang.wu@intel.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/7] wait: Remove wait_event_freezekillable()
References: <20141031111037.936236584@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-wait-freezable-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no user.. make it go away.

Cc: oleg@redhat.com
Cc: Rafael Wysocki <rjw@rjwysocki.net>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/freezer.h |   12 ------------
 1 file changed, 12 deletions(-)

--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -246,15 +246,6 @@ static inline int freezable_schedule_hrt
  * defined in <linux/wait.h>
  */
 
-#define wait_event_freezekillable(wq, condition)			\
-({									\
-	int __retval;							\
-	freezer_do_not_count();						\
-	__retval = wait_event_killable(wq, (condition));		\
-	freezer_count();						\
-	__retval;							\
-})
-
 /* DO NOT ADD ANY NEW CALLERS OF THIS FUNCTION */
 #define wait_event_freezekillable_unsafe(wq, condition)			\
 ({									\
@@ -302,9 +293,6 @@ static inline void set_freezable(void) {
 #define freezable_schedule_hrtimeout_range(expires, delta, mode)	\
 	schedule_hrtimeout_range(expires, delta, mode)
 
-#define wait_event_freezekillable(wq, condition)		\
-		wait_event_killable(wq, condition)
-
 #define wait_event_freezekillable_unsafe(wq, condition)			\
 		wait_event_killable(wq, condition)
 


