Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933946Ab3CMRod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:44:33 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:52415 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933096Ab3CMRob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:44:31 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] sched: Cputime update for 3.10
Date: Wed, 13 Mar 2013 18:44:21 +0100
Message-Id: <1363196663-4258-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the latest cputime accounting updates that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	sched/core

HEAD: d9a3c9823a2e6a543eb7807fb3d15d8233817ec5

Some users are complaining that their threadgroup's runtime accounting freezes
after a week or so of intense cpu-bound workload. This set tries to fix the issue
by reducing the risk of multiplication overflow in the cputime scaling code.

Thanks.

---
Frederic Weisbecker (2):
  math64: New div64_u64_rem helper
  sched: Lower chances of cputime scaling overflow

 include/linux/math64.h |   19 ++++++++++++++++++-
 kernel/sched/cputime.c |   46 ++++++++++++++++++++++++++++++++++------------
 lib/div64.c            |   19 +++++++++++++------
 3 files changed, 65 insertions(+), 19 deletions(-)

-- 
1.7.5.4

