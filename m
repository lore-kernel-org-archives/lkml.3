Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab3LRTQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:16:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56663 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab3LRTPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:15:40 -0500
Message-Id: <20131218190806.370008594@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 18 Dec 2013 20:08:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: geert@linux-m68k.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, VICTORK@il.ibm.com, oleg@redhat.com,
        anton@samba.org, benh@kernel.crashing.org, fweisbec@gmail.com,
        mathieu.desnoyers@polymtl.ca, michael@ellerman.id.au,
        mikey@neuling.org, linux@arm.linux.org.uk, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, tony.luck@intel.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/4] arch: Introduce smp_load_acquire() and smp_store_release()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This should hopefully be the last posting of this series -- people felt it
needed one more mostly because last time I typoed the linux-kernel email
address.

If there are no further comments, Ingo will merge these patches in the next few
days.

---

These patches introduce 2 new barrier primitives:

  smp_load_acquire(p)
  smp_store_release(p, v)

See the first patch, which changes Documentation/memory-barriers.txt, to find
the exact definitions of what an ACQUIRE/RELEASE barrier is -- previously known
as LOCK/UNLOCK barriers.

The second patch moves the smp_mb__{before,after}_atomic_{dec,inc}() barriers
to asm/atomic.h for arc and hexagon -- they were already there for all other archs.

This cleans up asm/barrier.h, and the third patch makes more agressive use of
asm-generic/barrier.h to implement the simple cases.

Then the fourth patch adds the new primitives.

Previous versions were widely build tested -- this version is not, but it also
not significantly different.

These patches apply to:

  tip/master


---
Changes since the last version -- lkml.kernel.org/r/20131213145657.265414969@infradead.org

 - fixed linux-kernel email address
 - updated the Documentation patch

