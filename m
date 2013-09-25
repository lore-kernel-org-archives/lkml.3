Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093Ab3IYQSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:18:20 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:44820 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab3IYQSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:18:18 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, <stable@vger.kernel.org>
Subject: [RFC PATCH 0/7] softirq: Consolidation and stack overrun fix v2
Date: Wed, 25 Sep 2013 18:17:59 +0200
Message-Id: <1380125886-10341-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So here is a respin after the discussion we had, plus some more
goodies:

* 1st patch is a short term pure regression fixe, with stable tag etc...
* 2nd patch now also generalize the softirq_count() check
* 4th improve debugging (just hope I did not mistake the !in_interrupt()
assumption in __do_softirq()
* more comments
* introduction of a longer term solution via a new arch symbol for archs
to tell about irq_exit() stack coverage.

Thanks.

Frederic Weisbecker (7):
  irq: Force hardirq exit's softirq processing on its own stack
  irq: Consolidate do_softirq() arch overriden implementations
  irq: Optimize call to softirq on hardirq exit
  irq: Improve a bit softirq debugging
  irq: Justify the various softirq stack choices
  irq: Optimize softirq stack selection in irq exit
  x86: Tell about irq stack coverage

 arch/metag/kernel/irq.c    | 52 ++++++++++++++++--------------------------
 arch/parisc/kernel/irq.c   | 17 ++------------
 arch/powerpc/kernel/irq.c  | 17 +-------------
 arch/s390/kernel/irq.c     | 52 +++++++++++++++++-------------------------
 arch/sh/kernel/irq.c       | 57 +++++++++++++++++-----------------------------
 arch/sparc/kernel/irq_64.c | 31 ++++++++-----------------
 arch/x86/include/asm/irq.h |  4 ++++
 arch/x86/kernel/entry_64.S |  4 ++--
 arch/x86/kernel/irq_32.c   | 30 +++++++-----------------
 arch/x86/kernel/irq_64.c   | 21 -----------------
 include/linux/interrupt.h  | 11 +++++++++
 kernel/softirq.c           | 40 ++++++++++++++++++++++++--------
 12 files changed, 130 insertions(+), 206 deletions(-)

-- 
1.8.3.1

