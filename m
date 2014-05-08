Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbaEHOEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:04:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47436 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbaEHOAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:00:48 -0400
Message-Id: <20140508135840.956784204@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 08 May 2014 15:58:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 00/20] arch atomic 'cleanup'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series continues the arch atomic rework started with the smp_mb__
interface cleanup.

In this series we (mostly) reduce the atomic implementations by eliminating
repetition through use of CPP macros.

A future series will use these macros to implement more atomic ops. With these
macros we can end up with more atomic ops while the total LoC still shrinks.

Furthermore, rewrite the asm-generic/atomic implementations to require less and
provide more.

This series is compile tested on a number of archs, but only boot tested on
x86_64.

XXX: someone should try and unify all the hash locked atomic implementations,
there's about 4 of them in the tree.

---
 arch/alpha/include/asm/atomic.h          |  225 ++++--------
 arch/arc/include/asm/atomic.h            |  194 +++-------
 arch/arm/include/asm/atomic.h            |  313 ++++++-----------
 arch/arm64/include/asm/atomic.h          |  213 ++++-------
 arch/avr32/include/asm/atomic.h          |   96 ++---
 arch/cris/include/arch-v10/arch/system.h |    2 
 arch/cris/include/asm/atomic.h           |   57 +--
 arch/hexagon/include/asm/atomic.h        |   68 ++-
 arch/ia64/include/asm/atomic.h           |  182 ++++-----
 arch/m32r/include/asm/atomic.h           |  151 +++-----
 arch/m68k/include/asm/atomic.h           |  119 +++---
 arch/metag/include/asm/atomic_lnkget.h   |  121 ++----
 arch/metag/include/asm/atomic_lock1.h    |   76 +---
 arch/mips/include/asm/atomic.h           |  565 ++++++++++---------------------
 arch/mn10300/include/asm/atomic.h        |  129 ++-----
 arch/parisc/include/asm/atomic.h         |  121 ++++--
 arch/powerpc/include/asm/atomic.h        |  216 ++++-------
 arch/sh/include/asm/atomic-grb.h         |  121 ++----
 arch/sh/include/asm/atomic-irq.h         |   62 +--
 arch/sh/include/asm/atomic-llsc.h        |  101 ++---
 arch/sparc/include/asm/atomic_32.h       |   19 -
 arch/sparc/include/asm/atomic_64.h       |   49 +-
 arch/sparc/include/asm/barrier_32.h      |    1 
 arch/sparc/include/asm/processor.h       |    2 
 arch/sparc/kernel/smp_64.c               |    2 
 arch/sparc/lib/atomic32.c                |   25 -
 arch/sparc/lib/atomic_64.S               |  175 ++++-----
 arch/sparc/lib/ksyms.c                   |   25 -
 arch/x86/include/asm/atomic.h            |   15 
 arch/xtensa/include/asm/atomic.h         |  231 ++++--------
 include/asm-generic/atomic.h             |  174 ++++-----
 include/asm-generic/atomic64.h           |   20 -
 lib/atomic64.c                           |   83 +---
 33 files changed, 1609 insertions(+), 2344 deletions(-)

