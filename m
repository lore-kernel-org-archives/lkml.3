Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaJSBrX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 21:47:23 -0400
Received: from numascale.com ([213.162.240.84]:33164 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbaJSBrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 21:47:13 -0400
From: Daniel J Blueman <daniel@numascale.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Daniel J Blueman <daniel@numascale.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: [PATCH v2 5/5] Numachip: use 2GB memory block size
Date: Sun, 19 Oct 2014 09:45:52 +0800
Message-Id: <1413683152-31302-5-git-send-email-daniel@numascale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413683152-31302-1-git-send-email-daniel@numascale.com>
References: <1413683152-31302-1-git-send-email-daniel@numascale.com>
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

Use appropriate memory block size to reduce sysfs entry creation time
by 16x.

Boot-tested with the four permutations of X86_UV and X86_NUMACHIP.

Signed-off-by: Daniel J Blueman <daniel@numascale.com>
---
 arch/x86/mm/init_64.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 5621c47..22ea6de 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -53,6 +53,7 @@
 #include <asm/cacheflush.h>
 #include <asm/init.h>
 #include <asm/uv/uv.h>
+#include <asm/numachip/numachip.h>
 #include <asm/setup.h>
 
 #include "mm_internal.h"
@@ -1235,9 +1236,9 @@ static unsigned long probe_memory_block_size(void)
 	/* start from 2g */
 	unsigned long bz = 1UL<<31;
 
-#ifdef CONFIG_X86_UV
-	if (is_uv_system()) {
-		printk(KERN_INFO "UV: memory block size 2GB\n");
+#ifdef CONFIG_X86_64
+	if (is_uv_system() || is_numachip_system()) {
+		pr_info("Memory block size 2GB for large-SMP system\n");
 		return 2UL * 1024 * 1024 * 1024;
 	}
 #endif
-- 
1.9.1

