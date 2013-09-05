Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab3IEPdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 11:33:32 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:45558 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3IEPdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 11:33:31 -0400
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
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 0/3] irq: Fix stack overflow due to softirq called on current stack 
Date: Thu,  5 Sep 2013 17:33:21 +0200
Message-Id: <1378395204-25342-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1378330796.4321.50.camel@pasglop>
References: <1378330796.4321.50.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series is a proposition to fix the crash reported here: http://lkml.kernel.org/r/1378330796.4321.50.camel%40pasglop
And it has the upside to also consolidate a bit the arch do_softirq overriden implementation.

Only tested in x86-64 for now.

Thanks.

Frederic Weisbecker (3):
  irq: Consolidate do_softirq() arch overriden implementations
  irq: Execute softirq on its own stack on irq exit
  irq: Comment on the use of inline stack for ksoftirq

 arch/metag/kernel/irq.c    |   56 +++++++++++++++++------------------------
 arch/parisc/kernel/irq.c   |   17 +-----------
 arch/powerpc/kernel/irq.c  |   17 +-----------
 arch/s390/kernel/irq.c     |   52 +++++++++++++++----------------------
 arch/sh/kernel/irq.c       |   60 ++++++++++++++++++-------------------------
 arch/sparc/kernel/irq_64.c |   31 +++++++---------------
 arch/x86/kernel/irq_32.c   |   34 +++++++++----------------
 arch/x86/kernel/irq_64.c   |   18 ++-----------
 include/linux/interrupt.h  |   11 ++++++++
 kernel/softirq.c           |   10 +++----
 10 files changed, 112 insertions(+), 194 deletions(-)

-- 
1.7.5.4

