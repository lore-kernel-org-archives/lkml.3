Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbaBZTIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:08:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:34732 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbaBZTIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:08:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,549,1389772800"; 
   d="scan'208";a="490301424"
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/4] x86: Add and use support for clflushopt
Date: Wed, 26 Feb 2014 12:06:48 -0700
Message-Id: <1393441612-19729-1-git-send-email-ross.zwisler@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for the new clflushopt instruction and then
uses it in a few appropriate places in x86 specific code.  It does this using
the alternatives mechanism, so any platforms without support for clflushopt
will continue to use clflush instead.

clflushopt was announced in the document "Intel Architecture Instruction Set
Extensions Programming Reference" with Ref # 319433-018.

http://download-software.intel.com/sites/default/files/managed/50/1a/319433-018.pdf

clflushopt has the same flushing behavior as clflush, but has more relaxed
ordering.  clflushopt must be explicitly ordered by sfence or mfence.

The inline assembly for clflushopt was implemented using %P so that the
generated addresses will always be absolute instead of sometimes being RIP
relative.  This is necessary for the alternatives code to behave correctly.

Ross Zwisler (4):
  x86: Add support for clflushopt
  x86: Use clflushopt in clflush_cache_range
  x86: Use clflushopt in drm_clflush_page
  x86: Use clflushopt in drm_clflush_virt_range

 arch/x86/include/asm/cpufeature.h    |    1 +
 arch/x86/include/asm/special_insns.h |    8 ++++++++
 arch/x86/mm/pageattr.c               |    8 ++++----
 drivers/gpu/drm/drm_cache.c          |   10 ++++++++--
 4 files changed, 21 insertions(+), 6 deletions(-)

-- 
1.7.10.4

