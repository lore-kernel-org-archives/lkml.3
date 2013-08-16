Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab3HPHIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 03:08:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58399 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab3HPHIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 03:08:17 -0400
X-IronPort-AV: E=Sophos;i="4.89,892,1367942400"; 
   d="scan'208";a="8217640"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        rjw@sisk.pl, liwanp@linux.vnet.ibm.com, tj@kernel.org,
        akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH 4/6] acpi cleanup: Use pr_err() instead of printk() in arch/x86/mm/srat.c
Date: Fri, 16 Aug 2013 15:06:47 +0800
Message-Id: <1376636809-10159-5-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1376636809-10159-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1376636809-10159-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/16 15:06:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/16 15:06:38,
	Serialize complete at 2013/08/16 15:06:38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pr_err() instead of printk() in arch/x86/mm/srat.c

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/srat.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 6286e89..32b9597 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -33,7 +33,7 @@ static __init int setup_node(int pxm)
 
 static __init void bad_srat(void)
 {
-	printk(KERN_ERR "SRAT: SRAT not used.\n");
+	pr_err("SRAT: SRAT not used.\n");
 	acpi_numa = -1;
 }
 
@@ -77,7 +77,7 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 	}
 	node = setup_node(pxm);
 	if (node < 0) {
-		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
+		pr_err("SRAT: Too many proximity domains %x\n", pxm);
 		bad_srat();
 		return;
 	}
@@ -113,7 +113,7 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 		pxm |= *((unsigned int*)pa->proximity_domain_hi) << 8;
 	node = setup_node(pxm);
 	if (node < 0) {
-		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
+		pr_err("SRAT: Too many proximity domains %x\n", pxm);
 		bad_srat();
 		return;
 	}
@@ -160,7 +160,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 
 	node = setup_node(pxm);
 	if (node < 0) {
-		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
+		pr_err("SRAT: Too many proximity domains.\n");
 		goto out_err_bad_srat;
 	}
 
-- 
1.7.1

