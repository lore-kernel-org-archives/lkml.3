Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab3C2KCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 06:02:04 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:57838 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab3C2KBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 06:01:03 -0400
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, paulmck@linux.vnet.ibm.com,
        fweisbec@gmail.com, benh@kernel.crashing.org, paulus@samba.org,
        Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 0/6] powerpc: Support context tracking for Power pSeries
Date: Fri, 29 Mar 2013 18:00:15 +0800
Message-Id: <1364551221-23177-1-git-send-email-zhong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032909-2674-0000-0000-000008677E6C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches try to support context tracking for Power arch, beginning with
64-bit pSeries. The codes are ported from that of the x86_64, and in each
patch, I listed the corresponding patch for x86.

Would you please help review and give your comments?

v2:

I rebased the patches against 3.9-rcs, and also added a patch to replace
the exception handling with the generic code in tip timers/nohz.

I assume these patches would get in through powerpc tree, so I didn't combine
the new patch (#6) with the original one (#2). So that if powerpc tree picks
these, it could pick the first five patches, and apply patch #6 later
when the dependency enters into powerpc tree (maybe on some 3.10-rcs).

I'm also wondering whether it is possible for these to go through
tip timers/nohz, so for now, patches #6 and #2 could be combined into one, and
no need to  worry about the issues caused by arch/common code merging. And it
might also make future changes easier.

Thanks, Zhong

Li Zhong (6):
  powerpc: Syscall hooks for context tracking subsystem
  powerpc: Exception hooks for context tracking subsystem
  powerpc: Exit user context on notify resume
  powerpc: Use the new schedule_user API on userspace preemption
  powerpc: select HAVE_CONTEXT_TRACKING for pSeries
  powerpc: Use generic code for exception handling

 arch/powerpc/include/asm/context_tracking.h |   10 +++
 arch/powerpc/include/asm/thread_info.h      |    7 ++-
 arch/powerpc/kernel/entry_64.S              |    3 +-
 arch/powerpc/kernel/ptrace.c                |    5 ++
 arch/powerpc/kernel/signal.c                |    5 ++
 arch/powerpc/kernel/traps.c                 |   91 ++++++++++++++++++++-------
 arch/powerpc/mm/fault.c                     |   16 ++++-
 arch/powerpc/mm/hash_utils_64.c             |   38 ++++++++---
 arch/powerpc/platforms/pseries/Kconfig      |    1 +
 9 files changed, 140 insertions(+), 36 deletions(-)
 create mode 100644 arch/powerpc/include/asm/context_tracking.h

-- 
1.7.9.5

