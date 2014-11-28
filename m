Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106AbaK1KyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:54:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbaK1KyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:54:05 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, andrew.cooper3@citrix.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V4 1/9] xen: fix some style issues in p2m.c
Date: Fri, 28 Nov 2014 11:53:50 +0100
Message-Id: <1417172039-8627-2-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1417172039-8627-1-git-send-email-jgross@suse.com>
References: <1417172039-8627-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The source arch/x86/xen/p2m.c has some coding style issues. Fix them.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/p2m.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 9201a38..73d354a 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -922,7 +922,7 @@ int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
 			continue;
 
 		if (map_ops[i].flags & GNTMAP_contains_pte) {
-			pte = (pte_t *) (mfn_to_virt(PFN_DOWN(map_ops[i].host_addr)) +
+			pte = (pte_t *)(mfn_to_virt(PFN_DOWN(map_ops[i].host_addr)) +
 				(map_ops[i].host_addr & ~PAGE_MASK));
 			mfn = pte_mfn(*pte);
 		} else {
@@ -970,7 +970,7 @@ int m2p_add_override(unsigned long mfn, struct page *page,
 		address = (unsigned long)__va(pfn << PAGE_SHIFT);
 		ptep = lookup_address(address, &level);
 		if (WARN(ptep == NULL || level != PG_LEVEL_4K,
-					"m2p_add_override: pfn %lx not mapped", pfn))
+			 "m2p_add_override: pfn %lx not mapped", pfn))
 			return -EINVAL;
 	}
 
@@ -1072,7 +1072,7 @@ int m2p_remove_override(struct page *page,
 		ptep = lookup_address(address, &level);
 
 		if (WARN(ptep == NULL || level != PG_LEVEL_4K,
-					"m2p_remove_override: pfn %lx not mapped", pfn))
+			 "m2p_remove_override: pfn %lx not mapped", pfn))
 			return -EINVAL;
 	}
 
@@ -1102,9 +1102,8 @@ int m2p_remove_override(struct page *page,
 			 * hypercall actually returned an error.
 			 */
 			if (kmap_op->handle == GNTST_general_error) {
-				printk(KERN_WARNING "m2p_remove_override: "
-						"pfn %lx mfn %lx, failed to modify kernel mappings",
-						pfn, mfn);
+				pr_warn("m2p_remove_override: pfn %lx mfn %lx, failed to modify kernel mappings",
+					pfn, mfn);
 				put_balloon_scratch_page();
 				return -1;
 			}
@@ -1112,14 +1111,14 @@ int m2p_remove_override(struct page *page,
 			xen_mc_batch();
 
 			mcs = __xen_mc_entry(
-					sizeof(struct gnttab_unmap_and_replace));
+				sizeof(struct gnttab_unmap_and_replace));
 			unmap_op = mcs.args;
 			unmap_op->host_addr = kmap_op->host_addr;
 			unmap_op->new_addr = scratch_page_address;
 			unmap_op->handle = kmap_op->handle;
 
 			MULTI_grant_table_op(mcs.mc,
-					GNTTABOP_unmap_and_replace, unmap_op, 1);
+				GNTTABOP_unmap_and_replace, unmap_op, 1);
 
 			mcs = __xen_mc_entry(0);
 			MULTI_update_va_mapping(mcs.mc, scratch_page_address,
-- 
2.1.2

