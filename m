Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaBNV3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:29:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:6596 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbaBNVW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:22:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,847,1384329600"; 
   d="scan'208";a="475474914"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-kbuild@vger.kernel.org, mmarek@suse.cz,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 06/19] lto: Disable LTO for sys_ni
Date: Fri, 14 Feb 2014 22:21:30 +0100
Message-Id: <1392412903-25733-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
References: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The assembler alias code in cond_syscall does not work
when compiled for LTO. Just disable LTO for that file.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/Makefile b/kernel/Makefile
index bc010ee..31c26c6 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -18,6 +18,9 @@ CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_irq_work.o = -pg
 endif
 
+# cond_syscall is currently not LTO compatible
+CFLAGS_sys_ni.o = $(DISABLE_LTO)
+
 obj-y += sched/
 obj-y += locking/
 obj-y += power/
-- 
1.8.5.2

