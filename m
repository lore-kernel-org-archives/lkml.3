Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab3HWGs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 02:48:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:29915 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754739Ab3HWGs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 02:48:27 -0400
X-IronPort-AV: E=Sophos;i="4.89,939,1367942400"; 
   d="scan'208";a="8280361"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: mingo@redhat.com, hpa@zytor.com, yinghai@kernel.org, penberg@kernel.org,
        jacob.shin@amd.com, tglx@linutronix.de, lenb@kernel.org, rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Subject: [PATCH 3/3] x86, mm: Move max_pfn_mapped definition to init.c.
Date: Fri, 23 Aug 2013 14:31:20 +0800
Message-Id: <1377239480-32532-4-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377239480-32532-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1377239480-32532-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/23 14:30:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/23 14:30:52,
	Serialize complete at 2013/08/23 14:30:52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

min_pfn_mapped is defined in init.c, we can also define max_pfn_mapped here.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/kernel/setup.c |    8 --------
 arch/x86/mm/init.c      |    9 +++++++++
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f13df7b..382e20b 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -111,14 +111,6 @@
 #include <asm/alternative.h>
 #include <asm/prom.h>
 
-/*
- * max_pfn_mapped:     highest direct mapped pfn
- *
- * The direct mapping only covers E820_RAM regions, so the ranges and gaps are
- * represented by pfn_mapped
- */
-unsigned long max_pfn_mapped;
-
 #ifdef CONFIG_DMI
 RESERVE_BRK(dmi_alloc, 65536);
 #endif
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index a97749f..793204b 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -24,6 +24,15 @@ static unsigned long __initdata pgt_buf_start;
 static unsigned long __initdata pgt_buf_end;
 static unsigned long __initdata pgt_buf_top;
 
+/*
+ * max_pfn_mapped:     highest direct mapped pfn
+ * min_pfn_mapped:     lowest direct mapped pfn
+ *
+ * The direct mapping only covers E820_RAM regions, so the ranges and gaps are
+ * represented by pfn_mapped
+ */
+
+unsigned long max_pfn_mapped;
 static unsigned long min_pfn_mapped;
 
 static bool __initdata can_use_brk_pgt = true;
-- 
1.7.1

