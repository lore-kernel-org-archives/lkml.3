Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaIDOw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:52:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbaIDOw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:52:57 -0400
From: Aaron Tomlin <atomlin@redhat.com>
To: peterz@infradead.org
Cc: mingo@redhat.com, dzickus@redhat.com, bmr@redhat.com, jcastillo@redhat.com,
        atomlin@redhat.com, oleg@redhat.com, pzijlstr@redhat.com,
        riel@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        x86@kernel.org, rostedt@goodmis.org, hannes@cmpxchg.org,
        aneesh.kumar@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, minchan@kernel.org
Subject: [PATCH 0/2] sched: Always check the integrity of the canary
Date: Thu,  4 Sep 2014 15:50:22 +0100
Message-Id: <1409842224-11847-1-git-send-email-atomlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently in the event of a stack overrun a call to schedule()
does not check for this type of corruption. This corruption is
often silent and can go unnoticed. However once the corrupted
region is examined at a later stage, the outcome is undefined
and often results in a sporadic page fault which cannot be
handled.

The first patch provides a helper to determine the integrity
of the canary. While the second patch checks for a stack
overrun and takes appropriate action since the damage is
already done, there is no point in continuing.

Aaron Tomlin (2):
  sched: Add helper for task stack page overrun checking
  sched: BUG when stack end location is over written

 arch/powerpc/mm/fault.c    | 6 ++----
 arch/x86/mm/fault.c        | 5 +----
 include/linux/sched.h      | 3 +++
 kernel/sched/core.c        | 3 +++
 kernel/trace/trace_stack.c | 5 ++---
 5 files changed, 11 insertions(+), 11 deletions(-)

-- 
1.9.3

