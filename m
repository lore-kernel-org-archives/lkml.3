Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaBJClR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:41:17 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47476 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbaBJClQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:41:16 -0500
Subject: [RESEND PATCH 0/3] powerpc: Free up an IPI message slot for tick
 broadcast IPIs
To: benh@kernel.crashing.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: deepthi@linux.vnet.ibm.com, arnd@arndb.de, geoff@infradead.org,
        mpe@ellerman.id.au, paul.gortmaker@windriver.com, paulus@samba.org,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
Date: Mon, 10 Feb 2014 08:07:36 +0530
Message-ID: <20140210023503.19345.30567.stgit@preeti>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021002-0320-0000-0000-0000026B525F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is a precursor for enabling deep idle states on powerpc,
when the local CPU timers stop. The tick broadcast framework in
the Linux Kernel today handles wakeup of such CPUs at their next timer event
by using an external clock device. At the expiry of this clock device, IPIs
are sent to the CPUs in deep idle states  so that they wakeup to handle their
respective timers. This patchset frees up one of the IPI slots on powerpc
so as to be used to handle the tick broadcast IPI.

On certain implementations of powerpc, such an external clock device is absent.
The support in the tick broadcast framework to handle wakeup of CPUs from
deep idle states on such implementations is currently in the tip tree.
https://lkml.org/lkml/2014/2/7/906
https://lkml.org/lkml/2014/2/7/876
https://lkml.org/lkml/2014/2/7/608

With the above support in place, this patchset is next in line to enable deep
idle states on powerpc.

The patchset has been appended by a RESEND tag since nothing has changed from
the previous post except for an added config condition around
tick_broadcast() which handles sending broadcast IPIs, and the update in the cover
letter.
---

Preeti U Murthy (1):
      cpuidle/ppc: Split timer_interrupt() into timer handling and interrupt handling routines

Srivatsa S. Bhat (2):
      powerpc: Free up the slot of PPC_MSG_CALL_FUNC_SINGLE IPI message
      powerpc: Implement tick broadcast IPI as a fixed IPI message


 arch/powerpc/include/asm/smp.h          |    2 -
 arch/powerpc/include/asm/time.h         |    1 
 arch/powerpc/kernel/smp.c               |   25 ++++++---
 arch/powerpc/kernel/time.c              |   86 ++++++++++++++++++-------------
 arch/powerpc/platforms/cell/interrupt.c |    2 -
 arch/powerpc/platforms/ps3/smp.c        |    2 -
 6 files changed, 73 insertions(+), 45 deletions(-)

-- 

