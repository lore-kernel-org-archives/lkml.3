Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbbA0Qyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:54:32 -0500
Received: from mga14.intel.com ([192.55.52.115]:50856 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758598AbbA0Qya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:54:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,475,1418112000"; 
   d="scan'208";a="518431615"
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v3 0/2] add support for new persistent memory instructions
Date: Tue, 27 Jan 2015 09:53:49 -0700
Message-Id: <1422377631-8986-1-git-send-email-ross.zwisler@linux.intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for two new persistent memory instructions, pcommit
and clwb.  These instructions were announced in the document "Intel
Architecture Instruction Set Extensions Programming Reference" with reference
number 319433-022.

https://software.intel.com/sites/default/files/managed/0d/53/319433-022.pdf

These patches apply cleanly to v3.19-rc6.

Changes from v2:

 - Added instruction descriptions and flows to the patch descriptions.
 - Added needed sfence to pcommit alternatives assembly.  The inline function
   is now called pcommit_sfence().  If pcommit is not supported on the platform
   both the pcommit and the sfence will be nops.

Cc: H Peter Anvin <h.peter.anvin@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>

Ross Zwisler (2):
  x86: Add support for the pcommit instruction
  x86: Add support for the clwb instruction

 arch/x86/include/asm/cpufeature.h    |  2 ++
 arch/x86/include/asm/special_insns.h | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

-- 
1.9.3

