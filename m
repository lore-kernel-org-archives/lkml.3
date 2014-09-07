Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaIGSas (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 14:30:48 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:39115 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaIGSaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 14:30:46 -0400
From: Mathias Krause <minipli@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>
Subject: [PATCH] x86-64, ptdump: Mark espfix area only if existent
Date: Sun,  7 Sep 2014 20:30:29 +0200
Message-Id: <1410114629-24523-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should classify the espfix area as such only if we actually have
enabled the corresponding option. Otherwise the page table dump might
look confusing.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Arjan van de Ven <arjan.van.de.ven@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/dump_pagetables.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 167ffcac16ed..95a427e57887 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -48,7 +48,9 @@ enum address_markers_idx {
 	LOW_KERNEL_NR,
 	VMALLOC_START_NR,
 	VMEMMAP_START_NR,
+# ifdef CONFIG_X86_ESPFIX64
 	ESPFIX_START_NR,
+# endif
 	HIGH_KERNEL_NR,
 	MODULES_VADDR_NR,
 	MODULES_END_NR,
@@ -71,7 +73,9 @@ static struct addr_marker address_markers[] = {
 	{ PAGE_OFFSET,		"Low Kernel Mapping" },
 	{ VMALLOC_START,        "vmalloc() Area" },
 	{ VMEMMAP_START,        "Vmemmap" },
+# ifdef CONFIG_X86_ESPFIX64
 	{ ESPFIX_BASE_ADDR,	"ESPfix Area", 16 },
+# endif
 	{ __START_KERNEL_map,   "High Kernel Mapping" },
 	{ MODULES_VADDR,        "Modules" },
 	{ MODULES_END,          "End Modules" },
-- 
1.7.10.4

