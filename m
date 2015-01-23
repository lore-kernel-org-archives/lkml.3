Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbbAWUku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 15:40:50 -0500
Received: from mga03.intel.com ([134.134.136.65]:27345 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbbAWUkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 15:40:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,456,1418112000"; 
   d="scan'208";a="674998209"
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v2 0/2] add support for new persistent memory instructions
Date: Fri, 23 Jan 2015 13:40:26 -0700
Message-Id: <1422045628-16225-1-git-send-email-ross.zwisler@linux.intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for two new persistent memory instructions, pcommit
and clwb.  These instructions were announced in the document "Intel
Architecture Instruction Set Extensions Programming Reference" with reference
number 319433-022.

https://software.intel.com/sites/default/files/managed/0d/53/319433-022.pdf

These patches apply cleanly to v3.19-rc5.

Changes from v1:

 - This series no longer updates the DRM code or clflush_cache_range to use
   clwb instead of clflushopt, as there was concern over whether clflushopt was
   used in some cases to explicitly evict lines from the processor cache.  I'll
   leave it up to the owners of this code to decide how they want to use clwb.

 - Reworked the clwb patch so that it doesn't use xsaveopt, as xsaveopt wasn't
   included in all GCC versions that the kernel needs to support. The assembly
   is now sort of complex because we need to hard code the clwb instruction to
   use a known register, but we also need to pull in the parameter as a memory
   constraint so that gcc doesn't reorder this instruction around other
   accesses to the same memory location.  Many thanks to hpa and Boris Petkov
   for their help on getting this right.

Cc: H Peter Anvin <h.peter.anvin@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>

Ross Zwisler (2):
  x86: Add support for the pcommit instruction
  x86: Add support for the clwb instruction

 arch/x86/include/asm/cpufeature.h    |  2 ++
 arch/x86/include/asm/special_insns.h | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

-- 
1.9.3

