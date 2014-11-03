Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaKCNCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:02:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbaKCNCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:02:12 -0500
From: Juergen Gross <jgross@suse.com>
To: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V6 02/18] x86: Use new cache mode type in include/asm/fb.h
Date: Mon,  3 Nov 2014 14:01:48 +0100
Message-Id: <1415019724-4317-3-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1415019724-4317-1-git-send-email-jgross@suse.com>
References: <1415019724-4317-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of directly using cache mode bits in the pte switch to usage of
the new cache mode type.

Based-on-patch-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fb.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/fb.h b/arch/x86/include/asm/fb.h
index 2519d06..c3dd5e7 100644
--- a/arch/x86/include/asm/fb.h
+++ b/arch/x86/include/asm/fb.h
@@ -8,8 +8,12 @@
 static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
 				unsigned long off)
 {
+	unsigned long prot;
+
+	prot = pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK;
 	if (boot_cpu_data.x86 > 3)
-		pgprot_val(vma->vm_page_prot) |= _PAGE_PCD;
+		pgprot_val(vma->vm_page_prot) =
+			prot | cachemode2protval(_PAGE_CACHE_MODE_UC_MINUS);
 }
 
 extern int fb_is_primary_device(struct fb_info *info);
-- 
1.8.4.5

