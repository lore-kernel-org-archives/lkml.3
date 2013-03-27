Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab3C0OfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:35:25 -0400
Received: from multi.imgtec.com ([194.200.65.239]:39971 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab3C0OfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:35:23 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 2/3] metag: export _metag_da_present and cpu_2_hwthread_id
Date: Wed, 27 Mar 2013 14:35:13 +0000
Message-ID: <1364394914-21257-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364394914-21257-1-git-send-email-james.hogan@imgtec.com>
References: <1364394914-21257-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_27_14_35_24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the symbols _metag_da_present and cpu_2_hwthread_id to modules
(GPL only) to allow the imgdafs file system to be built as a module.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/kernel/da.c    | 2 ++
 arch/metag/kernel/setup.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/arch/metag/kernel/da.c b/arch/metag/kernel/da.c
index 52aabb6..a35dbed 100644
--- a/arch/metag/kernel/da.c
+++ b/arch/metag/kernel/da.c
@@ -5,12 +5,14 @@
  */
 
 
+#include <linux/export.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <asm/da.h>
 #include <asm/metag_mem.h>
 
 bool _metag_da_present;
+EXPORT_SYMBOL_GPL(_metag_da_present);
 
 int __init metag_da_probe(void)
 {
diff --git a/arch/metag/kernel/setup.c b/arch/metag/kernel/setup.c
index 8792461..4f5726f 100644
--- a/arch/metag/kernel/setup.c
+++ b/arch/metag/kernel/setup.c
@@ -124,6 +124,7 @@ struct machine_desc *machine_desc __initdata;
 u8 cpu_2_hwthread_id[NR_CPUS] __read_mostly = {
 	[0 ... NR_CPUS-1] = BAD_HWTHREAD_ID
 };
+EXPORT_SYMBOL_GPL(cpu_2_hwthread_id);
 
 /*
  * Map a hardware thread ID to a Linux CPU number
-- 
1.8.1.2


