Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab3IZQYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 12:24:54 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37846 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab3IZQYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 12:24:53 -0400
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
Subject: [PATCH 0/8] softirq: Consolidation and stack overrun fix v3
Date: Thu, 26 Sep 2013 18:24:38 +0200
Message-Id: <1380212686-25897-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Series is fixed to address Linus and Ben comments:

* Turn __ARCH_IRQ_EXIT_ON_IRQ_STACK old ad-hoc style symbol to proper Kconfig
(CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK)

* Activates it to powerpc as well.

* Fix a bit the changelog of patch 6/8

This applies on top of 06367d58f487a592de50e6e2327371c5e3b6188f
("Merge branch 'merge' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc")

And it can be pulled from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	irq/core-v4

HEAD: 0362b2ff8d67913a8ffc5d757500129ead56b007

Frederic Weisbecker (8):
  irq: Force hardirq exit's softirq processing on its own stack
  irq: Consolidate do_softirq() arch overriden implementations
  irq: Optimize call to softirq on hardirq exit
  irq: Improve a bit softirq debugging
  irq: Justify the various softirq stack choices
  irq: Optimize softirq stack selection in irq exit
  x86: Tell about irq stack coverage
  powerpc: Tell about irq stack coverage

 arch/Kconfig               | 10 ++++++++
 arch/metag/kernel/irq.c    | 52 ++++++++++++++++--------------------------
 arch/parisc/kernel/irq.c   | 17 ++------------
 arch/powerpc/Kconfig       |  1 +
 arch/powerpc/kernel/irq.c  | 17 +-------------
 arch/s390/kernel/irq.c     | 52 +++++++++++++++++-------------------------
 arch/sh/kernel/irq.c       | 57 +++++++++++++++++-----------------------------
 arch/sparc/kernel/irq_64.c | 31 ++++++++-----------------
 arch/x86/Kconfig           |  1 +
 arch/x86/kernel/entry_64.S |  4 ++--
 arch/x86/kernel/irq_32.c   | 30 +++++++-----------------
 arch/x86/kernel/irq_64.c   | 21 -----------------
 include/linux/interrupt.h  | 11 +++++++++
 kernel/softirq.c           | 40 ++++++++++++++++++++++++--------
 14 files changed, 138 insertions(+), 206 deletions(-)

-- 
1.8.3.1

