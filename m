Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbaBRO3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:29:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:60260 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980AbaBRO3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:29:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,502,1389772800"; 
   d="scan'208";a="483436684"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, x86@kernel.org, linux-kbuild@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 06/20] lto: Disable LTO for sys_ni
Date: Tue, 18 Feb 2014 15:28:44 +0100
Message-Id: <1392733738-8290-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392733738-8290-1-git-send-email-andi@firstfloor.org>
References: <1392733738-8290-1-git-send-email-andi@firstfloor.org>
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

