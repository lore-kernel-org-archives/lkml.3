Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaCYKCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 06:02:09 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:45867
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293AbaCYKCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 06:02:07 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
From: Emil Medve <Emilian.Medve@Freescale.com>
To: <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <x86@kernel.org>
CC: Emil Medve <Emilian.Medve@Freescale.com>
Subject: [PATCH 1/3] memblock/x86: Use for_each_memblock()
Date: Tue, 25 Mar 2014 04:30:42 -0500
Message-ID: <1395739842-19237-1-git-send-email-Emilian.Medve@Freescale.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
---

This is a minor cleanup

 arch/x86/mm/numa.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 27aa0455..6b5e231 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -559,7 +559,7 @@ static void __init numa_clear_kernel_node_hotplug(void)
 	int i, nid;
 	nodemask_t numa_kernel_nodes = NODE_MASK_NONE;
 	unsigned long start, end;
-	struct memblock_type *type = &memblock.reserved;
+	struct memblock_region *r;
 
 	/*
 	 * At this time, all memory regions reserved by memblock are
@@ -573,8 +573,8 @@ static void __init numa_clear_kernel_node_hotplug(void)
 	}
 
 	/* Mark all kernel nodes. */
-	for (i = 0; i < type->cnt; i++)
-		node_set(type->regions[i].nid, numa_kernel_nodes);
+	for_each_memblock(reserved, r)
+		node_set(r->nid, numa_kernel_nodes);
 
 	/* Clear MEMBLOCK_HOTPLUG flag for memory in kernel nodes. */
 	for (i = 0; i < numa_meminfo.nr_blks; i++) {
-- 
1.9.1

