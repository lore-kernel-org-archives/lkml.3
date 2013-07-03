Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab3GCSNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:13:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49643 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932630Ab3GCSNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:13:01 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Will Deacon <will.deacon@arm.com>, Joseph Lo <josephl@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2] ARM: add missing __FINIT to head-common.S to match __INIT
Date: Wed,  3 Jul 2013 12:12:54 -0600
Message-Id: <1372875174-26812-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Macro __INIT is used to place various code in head-common.S into the init
section. This should be matched by a closing __FINIT at the end of the
code destined for the init section. Add this missing macro.

This historically caused no problem, because macro __CPUINIT was used at
the exact location where __FINIT was missing, which then placed following
code into the cpuinit section. However, with commit 22f0a2736 "init.h:
remove __cpuinit sections from the kernel" applied, __CPUINIT becomes a
no-op, thus leaving all this code in the init section, rather than the
regular text section. This caused issues such as secondary CPU boot
failures or crashes.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
v2: Moved __FINIT after lookup_processor_type, to correctly match the
location of __CPUINIT.

Russell, I assume I should add this to the ARM patch tracker.

This version is based on v3.10.
---
 arch/arm/kernel/head-common.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/kernel/head-common.S b/arch/arm/kernel/head-common.S
index 5b391a6..1fb887d 100644
--- a/arch/arm/kernel/head-common.S
+++ b/arch/arm/kernel/head-common.S
@@ -133,6 +133,8 @@ ENTRY(lookup_processor_type)
 	ldmfd	sp!, {r4 - r6, r9, pc}
 ENDPROC(lookup_processor_type)
 
+	__FINIT
+
 /*
  * Read processor ID register (CP#15, CR0), and look up in the linker-built
  * supported processor list.  Note that we can't use the absolute addresses
-- 
1.8.1.5

