Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaB0Q0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:26:23 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42921 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbaB0Q0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:26:22 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86, pageattr: Correct WBINVD spelling in comment
Date: Thu, 27 Feb 2014 17:26:14 +0100
Message-Id: <1393518374-21984-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

It is WBINVD, for INValiDate and not "wbindv". Use caps for instruction
names, while at it.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/mm/pageattr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index a3488689e301..66e55e070ec7 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1389,10 +1389,10 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 	cache = cache_attr(mask_set);
 
 	/*
-	 * On success we use clflush, when the CPU supports it to
-	 * avoid the wbindv. If the CPU does not support it and in the
+	 * On success we use CLFLUSH, when the CPU supports it to
+	 * avoid the WBINVD. If the CPU does not support it and in the
 	 * error case we fall back to cpa_flush_all (which uses
-	 * wbindv):
+	 * WBINVD):
 	 */
 	if (!ret && cpu_has_clflush) {
 		if (cpa.flags & (CPA_PAGES_ARRAY | CPA_ARRAY)) {
-- 
1.9.0

