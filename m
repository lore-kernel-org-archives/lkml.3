Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbaCLOOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:14:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46064 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbaCLONK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:13:10 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] x86, pageattr: Correct WBINVD spelling in comment
Date: Wed, 12 Mar 2014 15:13:04 +0100
Message-Id: <1394633584-5509-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394633584-5509-1-git-send-email-bp@alien8.de>
References: <1394633584-5509-1-git-send-email-bp@alien8.de>
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
index b3b19f46c016..ba957c9b677c 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1377,10 +1377,10 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
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

