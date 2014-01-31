Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbaAaENf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 23:13:35 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:48870 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbaAaENd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 23:13:33 -0500
Subject: [PATCH 0/3] powerpc: Free up an IPI message slot for tick broadcast
 IPIs
To: deepthi@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com, toshi.kani@hp.com,
        arnd@arndb.de, geoff@infradead.org, mpe@ellerman.id.au,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, afleming@freescale.com, anton@samba.org,
        srivatsa.bhat@linux.vnet.ibm.com, benh@kernel.crashing.org,
        paulus@samba.org, ady8radu@gmail.com, linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Fri, 31 Jan 2014 09:39:53 +0530
Message-ID: <20140131040631.13071.19603.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14013104-3532-0000-0000-000005274664
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
Adding support to the tick broadcast framework to handle wakeup of CPUs from
deep idle states on such implementations is currently under discussion.
https://lkml.org/lkml/2014/1/15/86
https://lkml.org/lkml/2014/1/24/28

Either way this patchset is essential to enable handling the tick broadcast IPIs.
---

Preeti U Murthy (1):
      cpuidle/ppc: Split timer_interrupt() into timer handling and interrupt handling routines

Srivatsa S. Bhat (2):
      powerpc: Free up the slot of PPC_MSG_CALL_FUNC_SINGLE IPI message
      powerpc: Implement tick broadcast IPI as a fixed IPI message


 arch/powerpc/include/asm/smp.h          |    2 -
 arch/powerpc/include/asm/time.h         |    1 
 arch/powerpc/kernel/smp.c               |   23 ++++++--
 arch/powerpc/kernel/time.c              |   86 ++++++++++++++++++-------------
 arch/powerpc/platforms/cell/interrupt.c |    2 -
 arch/powerpc/platforms/ps3/smp.c        |    2 -
 6 files changed, 71 insertions(+), 45 deletions(-)

-- 

