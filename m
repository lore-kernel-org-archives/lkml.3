Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967051Ab3HIAyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 20:54:45 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:57842 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966976Ab3HIAyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 20:54:44 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 0/4] nohz: Fix racy sleeptime stats
Date: Fri,  9 Aug 2013 02:54:34 +0200
Message-Id: <1376009678-7312-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a propsition to fix the bug described here:

http://lkml.kernel.org/r/1363660703.4993.3.camel@nexus
http://lkml.kernel.org/r/201304012205.DFC60784.HVOMJSFFLFtOOQ@I-love.SAKURA.ne.jp

You can try the following branch:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	timers/nohz-sleeptime-fix

Thanks,
	Frederic
---

Frederic Weisbecker (4):
      nohz: Only update sleeptime stats locally
      nohz: Synchronize sleep time stats with seqlock
      nohz: Consolidate sleep time stats read code
      nohz: Convert a few places to use local per cpu accesses


 include/linux/tick.h     |    2 +
 kernel/time/tick-sched.c |  124 +++++++++++++++++++--------------------------
 2 files changed, 54 insertions(+), 72 deletions(-)
