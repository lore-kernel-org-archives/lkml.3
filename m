Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab3ENCQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 22:16:58 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:57865 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab3ENCQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 22:16:57 -0400
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, paulmck@linux.vnet.ibm.com,
        fweisbec@gmail.com, benh@kernel.crashing.org, paulus@samba.org,
        michael@ellerman.id.au, Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 0/5] powerpc: Support context tracking for Power pSeries
Date: Tue, 14 May 2013 10:16:39 +0800
Message-Id: <1368497804-21706-1-git-send-email-zhong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051402-3864-0000-0000-0000082181D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches try to support context tracking for Power arch, beginning with
64-bit pSeries. The codes are ported from that of the x86_64, and in each
patch, I listed the corresponding patch for x86.

v4:
fixed some cosmetic issues suggested by Ben.

Li Zhong (5):
  powerpc: Syscall hooks for context tracking subsystem
  powerpc: Exception hooks for context tracking subsystem
  powerpc: Exit user context on notify resume
  powerpc: Use the new schedule_user API on userspace preemption
  powerpc: select HAVE_CONTEXT_TRACKING for pSeries

 arch/powerpc/include/asm/context_tracking.h |   10 ++++
 arch/powerpc/include/asm/thread_info.h      |    7 ++-
 arch/powerpc/kernel/entry_64.S              |    3 +-
 arch/powerpc/kernel/ptrace.c                |    5 ++
 arch/powerpc/kernel/signal.c                |    5 ++
 arch/powerpc/kernel/traps.c                 |   80 +++++++++++++++++++--------
 arch/powerpc/mm/fault.c                     |   41 +++++++++-----
 arch/powerpc/mm/hash_utils_64.c             |   36 +++++++++---
 arch/powerpc/platforms/pseries/Kconfig      |    1 +
 9 files changed, 140 insertions(+), 48 deletions(-)
 create mode 100644 arch/powerpc/include/asm/context_tracking.h

-- 
1.7.9.5

