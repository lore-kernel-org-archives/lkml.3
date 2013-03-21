Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3CUAKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 20:10:12 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:47516 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab3CUAKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 20:10:11 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 0/4] ARM: add support for context tracking subsystem
Date: Wed, 20 Mar 2013 17:01:57 -0700
Message-Id: <1363824121-26169-1-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 91d1aa43 (context_tracking: New context tracking susbsystem)
generalized parts of the RCU userspace extended quiescent state into
the context tracking subsystem.  Context tracking is then used 
to implement adaptive tickless (a.k.a full nohz)

Mainline currently only includes x86 support for the context tracking
susbsystem and the goal of this series is to add ARM support, in order
to make adaptive tickless functional on ARM.

Depends on the prerequistes series: 
  [PATCH 0/3] ARM: context tracking support prerequisites
  http://marc.info/?l=linux-kernel&m=136382248131438&w=2

Both of which are combined on top of Frederic's 3.9-rc1-nohz1 branch
and available here:
git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux.git arm-nohz-v2/context-tracking

Using this, I tested adaptive tickless on a 2 CPU ARM SoC (OMAP4
Panda.)

Kevin Hilman (4):
  ARM: context tracking: add exception support
  ARM: context tracking: instrument system calls
  ARM: context tracking: handle post exception/syscall/IRQ work
  ARM: Kconfig: allow context tracking

 arch/arm/Kconfig                   |  1 +
 arch/arm/include/asm/thread_info.h |  4 +++-
 arch/arm/kernel/ptrace.c           | 11 +++++++++++
 arch/arm/kernel/signal.c           | 12 +++++++++---
 arch/arm/kernel/traps.c            | 18 +++++++++++++++++-
 arch/arm/mm/fault.c                | 32 +++++++++++++++++++++++++++-----
 6 files changed, 68 insertions(+), 10 deletions(-)

-- 
1.8.2

