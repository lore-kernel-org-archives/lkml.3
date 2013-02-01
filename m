Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3BAK2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:28:03 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:49174 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab3BAK2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:28:00 -0500
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, paulmck@linux.vnet.ibm.com,
        fweisbec@gmail.com, benh@kernel.crashing.org, paulus@samba.org,
        Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [RFC PATCH 0/5] powerpc: Support context tracking for Power pSeries
Date: Fri,  1 Feb 2013 18:27:40 +0800
Message-Id: <1359714465-6297-1-git-send-email-zhong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020110-9574-0000-0000-0000066D67BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches try to support context tracking for Power arch, beginning with 
64-bit pSeries. The codes are ported from that of the x86_64, and in each
patch, I listed the corresponding patch for x86.

Would you please help review and give your comments?

Thanks, Zhong

Li Zhong (5):
  powerpc: Syscall hooks for context tracking subsystem
  powerpc: Exception hooks for context tracking subsystem
  powerpc: Exit user context on notify resume
  powerpc: Use the new schedule_user API on userspace preemption
  powerpc: select HAVE_CONTEXT_TRACKING for pSeries

 arch/powerpc/include/asm/context_tracking.h |   31 +++++++++++
 arch/powerpc/include/asm/thread_info.h      |    7 ++-
 arch/powerpc/kernel/entry_64.S              |    3 +-
 arch/powerpc/kernel/exceptions-64s.S        |    4 +-
 arch/powerpc/kernel/ptrace.c                |    5 ++
 arch/powerpc/kernel/signal.c                |    5 ++
 arch/powerpc/kernel/traps.c                 |   79 ++++++++++++++++++++-------
 arch/powerpc/mm/fault.c                     |   15 ++++-
 arch/powerpc/mm/hash_utils_64.c             |   17 ++++++
 arch/powerpc/platforms/pseries/Kconfig      |    1 +
 10 files changed, 141 insertions(+), 26 deletions(-)
 create mode 100644 arch/powerpc/include/asm/context_tracking.h

-- 
1.7.9.5

