Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3ISTvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 15:51:15 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:47742 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab3ISTvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 15:51:14 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
Date: Thu, 19 Sep 2013 14:51:04 -0500
Message-Id: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Please consider this patchset for pulling from:

git://github.com/fweisbec/linux-dynticks.git
	irq/core-v2

HEAD: 539b9cde35b473483c722de110133cd757015947

It fixes stacks overruns reported by Benjamin Herrenschmidt:
http://lkml.kernel.org/r/1378330796.4321.50.camel%40pasglop

And Paul Mackerras gave a feedback here:
http://lkml.kernel.org/r/20130918065101.GA22060@drongo

Of course the fix probably comes at the expense of a performance
hit due to cache switch, miss, etc... when softirq are processed
at the end of interrupts, although I haven't tried to measure that.

Thanks.

---
Frederic Weisbecker (3):
  irq: Consolidate do_softirq() arch overriden implementations
  irq: Execute softirq on its own stack on irq exit
  irq: Comment on the use of inline stack for ksoftirqd

 arch/metag/kernel/irq.c    | 56 ++++++++++++++++++-------------------------
 arch/parisc/kernel/irq.c   | 17 ++-----------
 arch/powerpc/kernel/irq.c  | 17 +------------
 arch/s390/kernel/irq.c     | 52 ++++++++++++++++------------------------
 arch/sh/kernel/irq.c       | 60 +++++++++++++++++++---------------------------
 arch/sparc/kernel/irq_64.c | 31 ++++++++----------------
 arch/x86/kernel/irq_32.c   | 34 ++++++++++----------------
 arch/x86/kernel/irq_64.c   | 18 +++-----------
 include/linux/interrupt.h  | 11 +++++++++
 kernel/softirq.c           | 13 +++++-----
 10 files changed, 115 insertions(+), 194 deletions(-)

-- 
1.8.3.1

