Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab3KGB0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 20:26:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:6748 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab3KGB0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 20:26:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="431033135"
Subject: [PATCH v4 0/4] MCS Lock: MCS lock code cleanup and optimizations
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Will Deacon <will.deacon@arm.com>, "Figo.zhang" <figo1802@gmail.com>
References: <cover.1383783691.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Nov 2013 17:26:40 -0800
Message-ID: <1383787600.11046.363.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch series, we separated out the MCS lock code which was
previously embedded in the mutex.c.  This allows for easier reuse of
MCS lock in other places like rwsem and qrwlock.  We also did some micro
optimizations and barrier cleanup.

This patches were previously part of the rwsem optimization patch series
but now we spearate them out.

Tim Chen

v4:
1. Move patch series to the latest tip after v3.12

v3:
1. modified memory barriers to support non x86 architectures that have
weak memory ordering.

v2:
1. change export mcs_spin_lock as a GPL export symbol
2. corrected mcs_spin_lock to references


Jason Low (2):
  MCS Lock: optimizations and extra comments
  MCS Lock: Barrier corrections

Tim Chen (1):
  MCS Lock: Restructure the MCS lock defines and locking code into its
    own file

Waiman Long (2):
  MCS Lock: Make mcs_spinlock.h includable in other files
  MCS Lock: Allow architecture specific memory barrier in lock/unlock

 arch/x86/include/asm/barrier.h |    6 +++
 include/linux/mcs_spinlock.h   |   25 ++++++++++
 include/linux/mutex.h          |    5 +-
 kernel/locking/Makefile        |    6 +-
 kernel/locking/mcs_spinlock.c  |   96 ++++++++++++++++++++++++++++++++++++++++
 kernel/locking/mutex.c         |   60 +++----------------------
 6 files changed, 140 insertions(+), 58 deletions(-)
 create mode 100644 include/linux/mcs_spinlock.h
 create mode 100644 kernel/locking/mcs_spinlock.c

-- 
1.7.4.4


