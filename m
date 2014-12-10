Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbaLJP4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:56:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113AbaLJP4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:56:08 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH] xen: switch to post-init routines in xen mmu.c earlier
Date: Wed, 10 Dec 2014 16:56:03 +0100
Message-Id: <1418226963-24873-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the virtual mapped linear p2m list the post-init mmu operations
must be used for setting up the p2m mappings, as in case of
CONFIG_FLATMEM the init routines may trigger BUGs.

Reported-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 6ab6150..a1a429a 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1225,6 +1225,7 @@ static void __init xen_pagetable_p2m_setup(void)
 static void __init xen_pagetable_init(void)
 {
 	paging_init();
+	xen_post_allocator_init();
 
 	xen_pagetable_p2m_setup();
 
@@ -1236,7 +1237,6 @@ static void __init xen_pagetable_init(void)
 		xen_remap_memory();
 
 	xen_setup_shared_info();
-	xen_post_allocator_init();
 }
 static void xen_write_cr2(unsigned long cr2)
 {
-- 
2.1.2

