Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab3I3PC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:02:56 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:43653 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab3I3PCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:02:53 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@au1.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "#3.9.." <stable@vger.kernel.org>
Subject: [GIT PULL] irq: updates for 3.13
Date: Mon, 30 Sep 2013 17:02:47 +0200
Message-Id: <1380553367-9631-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Thomas,

Please pull the irq/core-v5 branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	irq/core-v5

HEAD: f6f626fa877c96974fadc595ddd72543d8c6106b

It's the same as the series posted at:
	http://lkml.kernel.org/r/1380212686-25897-1-git-send-email-fweisbec@gmail.com

with Linus and Benjamin's ack added and a rebase against rc3.

It also contains the regression fix (with the same commit id) from my
other pull request.

Thanks,
	Frederic
---

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
