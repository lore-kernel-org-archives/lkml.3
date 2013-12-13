Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab3LMCLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:11:15 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:54667 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab3LMCKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:10:48 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        george.dunlap@eu.citrix.com, ian.jackson@eu.citrix.com,
        mukesh.rathor@oracle.com, tim@xen.org, jbeulich@suse.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH V10 10/14] xen/pvh: specify xen features strings cleanly for PVH
Date: Thu, 12 Dec 2013 21:10:17 -0500
Message-Id: <1386900621-27528-11-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

Use .ascii and .asciz to define xen feature string. Note, the PVH
string must be in a single line (not multiple lines with \) to keep the
assembler from putting null char after each string before \.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/xen-head.S |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 1a6bca1..45226cb 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -14,12 +14,11 @@
 #include <asm/xen/interface.h>
 
 #ifdef CONFIG_XEN_X86_PVH
-#define FEATURES_PVH "|writable_descriptor_tables" \
-		     "|auto_translated_physmap" \
-		     "|supervisor_mode_kernel" \
-		     "|hvm_callback_vector"
+
+#define PVH_FEATURES_STR  "|writable_descriptor_tables|auto_translated_physmap|supervisor_mode_kernel|hvm_callback_vector"
+
 #else
-#define FEATURES_PVH /* Not supported */
+#define PVH_FEATURES_STR  ""
 #endif
 
 	__INIT
@@ -104,7 +103,7 @@ NEXT_HYPERCALL(arch_6)
 #endif
 	ELFNOTE(Xen, XEN_ELFNOTE_ENTRY,          _ASM_PTR startup_xen)
 	ELFNOTE(Xen, XEN_ELFNOTE_HYPERCALL_PAGE, _ASM_PTR hypercall_page)
-	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb"FEATURES_PVH)
+        ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .ascii "!writable_page_tables|pae_pgdir_above_4gb"; .asciz PVH_FEATURES_STR);
 	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz "yes")
 	ELFNOTE(Xen, XEN_ELFNOTE_LOADER,         .asciz "generic")
 	ELFNOTE(Xen, XEN_ELFNOTE_L1_MFN_VALID,
-- 
1.7.7.6

