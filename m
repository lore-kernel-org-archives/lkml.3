Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab3GBWyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 18:54:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59622 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab3GBWx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 18:53:58 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Joseph Lo <josephl@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] ARM: move body of head-common.S back to text section
Date: Tue,  2 Jul 2013 16:53:49 -0600
Message-Id: <1372805629-18382-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Commit 281ecb7 "arm: delete __cpuinit/__CPUINIT usage from all ARM
users" removed a __CPUINIT from head-common.S. However, the code
immediately before the removed tag was marked __INIT, and was missing
a match __FINIT. This caused code after the removed __CPUINIT to end
up in the init section rather than the main text section as desired.
This caused issues such as secondary CPU boot failures or crashes.
Add the missing __FINIT to solve this.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/kernel/head-common.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/kernel/head-common.S b/arch/arm/kernel/head-common.S
index 529ce99..a9dc804 100644
--- a/arch/arm/kernel/head-common.S
+++ b/arch/arm/kernel/head-common.S
@@ -122,6 +122,8 @@ __mmap_switched_data:
 	.long	init_thread_union + THREAD_START_SP @ sp
 	.size	__mmap_switched_data, . - __mmap_switched_data
 
+	__FINIT
+
 /*
  * This provides a C-API version of __lookup_processor_type
  */
-- 
1.8.1.5

