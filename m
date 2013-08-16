Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab3HPPmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:42:53 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:47801 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab3HPPmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:42:43 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH RESEND 0/4] nohz: Fix racy sleeptime stats
Date: Fri, 16 Aug 2013 17:42:29 +0200
Message-Id: <1376667753-29014-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a resend to include Oleg in Cc, no modification since last version
https://lkml.org/lkml/2013/8/8/638.

Tree is still:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz-sleeptime-fix

Thanks.

Frederic Weisbecker (4):
  nohz: Only update sleeptime stats locally
  nohz: Synchronize sleep time stats with seqlock
  nohz: Consolidate sleep time stats read code
  nohz: Convert a few places to use local per cpu accesses

 include/linux/tick.h     |    2 +
 kernel/time/tick-sched.c |  124 +++++++++++++++++++--------------------------
 2 files changed, 54 insertions(+), 72 deletions(-)

-- 
1.7.5.4

