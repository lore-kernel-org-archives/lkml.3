Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaFJMbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:31:07 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:44261 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaFJMbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:31:04 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 0/2] Per-task wait_queue_t
Date: Tue, 10 Jun 2014 14:29:17 +0200
Message-Id: <1402403359-6023-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CA+55aFyYQES1CbEfYzRkFas_aw=+YNSbDoLRJpjh2sDFxVV3vg@mail.gmail.com>
References: <CA+55aFyYQES1CbEfYzRkFas_aw=+YNSbDoLRJpjh2sDFxVV3vg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an attempt to reduce the stack footprint of various functions
(those using any of the wait_event_* macros), by removing the need to
allocate a wait_queue_t on the stack and instead use a single instance
embedded in task_struct. I'm not really sure where the best place to
put it is; I just placed it next to other list bookkeeping fields.

For now, there is a little unconditional debugging. This could later
be removed or maybe be made dependent on some CONFIG_* variable. The
idea of using ->flags is taken from Pavel [1] (I originally stored
(void*)1 into ->private).

Compiles, but not actually tested.

[1] http://thread.gmane.org/gmane.linux.kernel/1720670

Rasmus Villemoes (2):
  wait: Introduce per-task wait_queue_t
  wait: Use the per-task wait_queue_t in ___wait_event macro

 include/linux/sched.h | 23 +++++++++++++++++++++++
 include/linux/wait.h  | 18 ++++++++++--------
 kernel/fork.c         |  1 +
 3 files changed, 34 insertions(+), 8 deletions(-)

-- 
1.9.2

