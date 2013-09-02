Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab3IBKcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 06:32:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:44353 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758539Ab3IBKcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 06:32:16 -0400
X-IronPort-AV: E=Sophos;i="4.89,1006,1367942400"; 
   d="scan'208";a="8376281"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: mingo@redhat.com, hpa@zytor.com, yinghai@kernel.org, penberg@kernel.org,
        jacob.shin@amd.com, tglx@linutronix.de, lenb@kernel.org, rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Subject: [PATCH RESEND 3/3] x86, mm: Move max_pfn_mapped definition to init.c.
Date: Mon, 2 Sep 2013 18:30:29 +0800
Message-Id: <1378117829-9095-4-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378117829-9095-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1378117829-9095-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/02 18:29:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/02 18:29:39,
	Serialize complete at 2013/09/02 18:29:39
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
index 7fa1ec3..698b9c6 100644
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

