Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761804AbbA1Gpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 01:45:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761612AbbA1Goc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 01:44:32 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH 5/5] xen: cleanup arch/x86/xen/mmu.c
Date: Wed, 28 Jan 2015 07:44:25 +0100
Message-Id: <1422427465-25239-6-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1422427465-25239-1-git-send-email-jgross@suse.com>
References: <1422427465-25239-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a nested ifdef.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/mmu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 6a8bbf4..adca9e2 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1734,10 +1734,8 @@ static void __init xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
 		for (pteidx = 0; pteidx < PTRS_PER_PTE; pteidx++, pfn++) {
 			pte_t pte;
 
-#ifdef CONFIG_X86_32
 			if (pfn > max_pfn_mapped)
 				max_pfn_mapped = pfn;
-#endif
 
 			if (!pte_none(pte_page[pteidx]))
 				continue;
-- 
2.1.2

