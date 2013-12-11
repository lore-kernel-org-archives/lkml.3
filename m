Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab3LKMRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:17:48 -0500
Received: from [207.46.163.27] ([207.46.163.27]:14146 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751609Ab3LKMRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:17:35 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzd2iz1de098h8275bh1de097hz2dh839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
X-WSS-ID: 0MXN5VR-07-4WB-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <fweisbec@gmail.com>, <mingo@kernel.org>, <mingo@redhat.com>,
        <jacob.w.shin@gmail.com>
CC: <oleg@redhat.com>, <a.p.zijlstra@chello.nl>, <acme@ghostprotocols.net>,
        <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <sherry.hurwitz@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 4/4] perf/x86: Remove get_hbp_len and replace with bp_len
Date: Wed, 11 Dec 2013 06:28:26 -0600
Message-ID: <1386764906-1681-5-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386764906-1681-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1386764906-1681-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Shin <jacob.w.shin@gmail.com>

Clean up the logic for determining the breakpoint length

Signed-off-by: Jacob Shin <jacob.w.shin@gmail.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kernel/hw_breakpoint.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 647b675..4ada2c3 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -169,29 +169,6 @@ void arch_uninstall_hw_breakpoint(struct perf_event *bp)
 		set_dr_addr_mask(0, i);
 }
 
-static int get_hbp_len(u8 hbp_len)
-{
-	unsigned int len_in_bytes = 0;
-
-	switch (hbp_len) {
-	case X86_BREAKPOINT_LEN_1:
-		len_in_bytes = 1;
-		break;
-	case X86_BREAKPOINT_LEN_2:
-		len_in_bytes = 2;
-		break;
-	case X86_BREAKPOINT_LEN_4:
-		len_in_bytes = 4;
-		break;
-#ifdef CONFIG_X86_64
-	case X86_BREAKPOINT_LEN_8:
-		len_in_bytes = 8;
-		break;
-#endif
-	}
-	return len_in_bytes;
-}
-
 /*
  * Check for virtual address in kernel space.
  */
@@ -202,7 +179,7 @@ int arch_check_bp_in_kernelspace(struct perf_event *bp)
 	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
 
 	va = info->address;
-	len = get_hbp_len(info->len);
+	len = bp->attr.bp_len;
 
 	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
 }
-- 
1.8.1.2


