Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751138AbaKPVnx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 16:43:53 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38690 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaKPVnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 16:43:52 -0500
Date: Sun, 16 Nov 2014 16:43:49 -0500 (EST)
Message-Id: <20141116.164349.1450239074345762772.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Nov 2014 13:43:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here we have:

1) Fix NULL oops in Schizo PCI controller error handler.

2) Fix race between xchg and other operations on 32-bit sparc, from
   Andreas Larsson.

3) swab*() helpers need a dummy memory input operand to show data flow
   on 64-bit sparc.

4) Fix RCU warnings due to missing irq_{enter,exit}() around
   generic_smp_call_function*() calls.

Please pull, thanks a lot!

The following changes since commit 9f935675d41aa51ebf929fc977cf530ff7d1a7fc:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input (2014-10-31 19:51:11 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to 5a2b59d3993e8ca4f7788a48a23e5cb303f26954:

  sparc64: Fix constraints on swab helpers. (2014-11-16 13:19:32 -0800)

----------------------------------------------------------------
Andreas Larsson (1):
      sparc32: Implement xchg and atomic_xchg using ATOMIC_HASH locks

David S. Miller (3):
      sparc64: Fix crashes in schizo_pcierr_intr_other().
      sparc64: Do irq_{enter,exit}() around generic_smp_call_function*().
      sparc64: Fix constraints on swab helpers.

 arch/sparc/include/asm/atomic_32.h  |  2 +-
 arch/sparc/include/asm/cmpxchg_32.h | 12 ++----------
 arch/sparc/include/uapi/asm/swab.h  | 12 ++++++------
 arch/sparc/kernel/pci_schizo.c      |  6 +++---
 arch/sparc/kernel/smp_64.c          |  4 ++++
 arch/sparc/lib/atomic32.c           | 27 +++++++++++++++++++++++++++
 6 files changed, 43 insertions(+), 20 deletions(-)
