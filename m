Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab3EMFVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 01:21:48 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:44192 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab3EMFVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 01:21:47 -0400
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, paulmck@linux.vnet.ibm.com,
        fweisbec@gmail.com, benh@kernel.crashing.org, paulus@samba.org,
        michael@ellerman.id.au, Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [RFC PATCH v3 0/5] powerpc: Support context tracking for Power pSeries
Date: Mon, 13 May 2013 13:21:28 +0800
Message-Id: <1368422493-9831-1-git-send-email-zhong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051305-6102-0000-0000-0000038285AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches try to support context tracking for Power arch, beginning with
64-bit pSeries. The codes are ported from that of the x86_64, and in each
patch, I listed the corresponding patch for x86.

v3:

This version is mainly a rebasing, against 3.10-rc1, also as the common code 
to handle the exception are pulled into 3.10, so there is no dependency on 
tip tree. So patch #2 and #6 in previous version_2 is merged together. 

Li Zhong (5):
  powerpc: Syscall hooks for context tracking subsystem
  powerpc: Exception hooks for context tracking subsystem
  powerpc: Exit user context on notify resume
  powerpc: Use the new schedule_user API on userspace preemption
  powerpc: select HAVE_CONTEXT_TRACKING for pSeries

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

