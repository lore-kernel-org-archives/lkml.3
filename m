Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaIZEbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 00:31:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:24235 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbaIZEbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 00:31:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,603,1406617200"; 
   d="scan'208";a="605641245"
From: Ong Boon Leong <boon.leong.ong@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH] x86, setup: Additional __flush_tlb for Quak X1000
Date: Fri, 26 Sep 2014 12:30:26 +0800
Message-Id: <1411705827-2522-1-git-send-email-boon.leong.ong@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With respect to submission sent below:
  "x86: Quark: Comment setup_arch for TLB/PGE bugfix"

__flush_tlb_all() does not take __flush_tlb() because cpu_has_pge
flag that is setup in head_32.S by CPUID and not changed much later.
So, the comment added are incorrect. Explaination below:

For change on:

  "x86/intel/quark: Switch off CR4.PGE so TLB flush uses CR3 instead"

The X86_FEATURE_PGE cap is cleared in early_cpu_init() -->
 early_identify_cpu() --> early_init_intel(). And, early_cpu_init()
is performed after the __flush_tlb_all() step.

Anyway, thanks to Bryan for submitting patch for Quark SoC.

FYI, the suggestion to add __flush_tlb() has been discussed with some
of the kernel developers CC'ed below inclusing HPA himself.

Thank you very much,
Ong Boon Leong

Ong Boon Leong (1):
  x86, setup: add __flush_tlb() for Intel Quark X1000

 arch/x86/kernel/setup.c |    7 +++++++
 1 file changed, 7 insertions(+)

-- 
1.7.9.5

