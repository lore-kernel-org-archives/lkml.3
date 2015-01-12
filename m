Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbbALFFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 00:05:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbbALFFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 00:05:17 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, jbeulich@suse.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [Patch V2 1/4] xen: correct error for building p2m list on 32 bits
Date: Mon, 12 Jan 2015 06:05:07 +0100
Message-Id: <1421039110-11207-2-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1421039110-11207-1-git-send-email-jgross@suse.com>
References: <1421039110-11207-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In xen_rebuild_p2m_list() for large areas of invalid or identity
mapped memory the pmd entries on 32 bit systems are initialized
wrong. Correct this error.

Suggested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/p2m.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index d9660a5..36ae094 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -379,7 +379,7 @@ static void __init xen_rebuild_p2m_list(unsigned long *p2m)
 			p2m_missing_pte : p2m_identity_pte;
 		for (i = 0; i < PMDS_PER_MID_PAGE; i++) {
 			pmdp = populate_extra_pmd(
-				(unsigned long)(p2m + pfn + i * PTRS_PER_PTE));
+				(unsigned long)(p2m + pfn) + i * PMD_SIZE);
 			set_pmd(pmdp, __pmd(__pa(ptep) | _KERNPG_TABLE));
 		}
 	}
-- 
2.1.2

