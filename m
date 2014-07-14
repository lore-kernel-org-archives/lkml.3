Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbaGNRbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:31:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43249 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbaGNRbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:31:14 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, espfix: Remove stale ptemask
Date: Mon, 14 Jul 2014 19:31:00 +0200
Message-Id: <1405359060-9291-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Previous versions of the espfix had a single function which did setup
the pagetables. It was later split into BSP and AP version. Drop unused
leftovers after that split.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/espfix_64.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kernel/espfix_64.c b/arch/x86/kernel/espfix_64.c
index 6afbb16e9b79..7346ef3c3e0c 100644
--- a/arch/x86/kernel/espfix_64.c
+++ b/arch/x86/kernel/espfix_64.c
@@ -122,9 +122,6 @@ static void init_espfix_random(void)
 void __init init_espfix_bsp(void)
 {
 	pgd_t *pgd_p;
-	pteval_t ptemask;
-
-	ptemask = __supported_pte_mask;
 
 	/* Install the espfix pud into the kernel page directory */
 	pgd_p = &init_level4_pgt[pgd_index(ESPFIX_BASE_ADDR)];
-- 
2.0.0

