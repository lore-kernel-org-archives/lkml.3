Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaKFEw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 23:52:27 -0500
Received: from numascale.com ([213.162.240.84]:33564 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbaKFEwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 23:52:24 -0500
From: Daniel J Blueman <daniel@numascale.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>
Cc: Daniel J Blueman <daniel@numascale.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH] x86: Drop redundant memory-block sizing code
Date: Thu,  6 Nov 2014 12:50:14 +0800
Message-Id: <1415249414-20888-1-git-send-email-daniel@numascale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <ojh5M-xh-17@gated-at.bofh.it>
References: <ojh5M-xh-17@gated-at.bofh.it>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the unused code from selecting a fixed memory block size of 2GB
on large-memory x86-64 systems.

Signed-off-by: Daniel J Blueman <daniel@numascale.com>
---
 arch/x86/mm/init_64.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index ebca30f..09c0567 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1243,28 +1243,12 @@ int in_gate_area_no_mm(unsigned long addr)
 
 static unsigned long probe_memory_block_size(void)
 {
-	/* start from 2g */
-	unsigned long bz = 1UL<<31;
-
 	if (totalram_pages >= (64ULL << (30 - PAGE_SHIFT))) {
 		pr_info("Using 2GB memory block size for large-memory system\n");
 		return 2UL * 1024 * 1024 * 1024;
 	}
 
-	/* less than 64g installed */
-	if ((max_pfn << PAGE_SHIFT) < (16UL << 32))
-		return MIN_MEMORY_BLOCK_SIZE;
-
-	/* get the tail size */
-	while (bz > MIN_MEMORY_BLOCK_SIZE) {
-		if (!((max_pfn << PAGE_SHIFT) & (bz - 1)))
-			break;
-		bz >>= 1;
-	}
-
-	printk(KERN_DEBUG "memory block size : %ldMB\n", bz >> 20);
-
-	return bz;
+	return MIN_MEMORY_BLOCK_SIZE;
 }
 
 static unsigned long memory_block_size_probed;
-- 
1.9.1

