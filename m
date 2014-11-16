Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbaKPKzE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 05:55:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34800 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbaKPKzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 05:55:00 -0500
Date: Sun, 16 Nov 2014 02:54:47 -0800
From: tip-bot for Juergen Gross <tipbot@zytor.com>
Message-ID: <tip-c27ce0af896b7cc1718995f2b3e66e2892d5081c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, stefan.bader@canonical.com,
        tglx@linutronix.de, jgross@suse.com, mingo@kernel.org, hpa@zytor.com
Reply-To: hpa@zytor.com, mingo@kernel.org, jgross@suse.com,
        stefan.bader@canonical.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
In-Reply-To: <1415019724-4317-3-git-send-email-jgross@suse.com>
References: <1415019724-4317-3-git-send-email-jgross@suse.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Use new cache mode type in include/asm/fb.h
Git-Commit-ID: c27ce0af896b7cc1718995f2b3e66e2892d5081c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c27ce0af896b7cc1718995f2b3e66e2892d5081c
Gitweb:     http://git.kernel.org/tip/c27ce0af896b7cc1718995f2b3e66e2892d5081c
Author:     Juergen Gross <jgross@suse.com>
AuthorDate: Mon, 3 Nov 2014 14:01:48 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 16 Nov 2014 11:04:24 +0100

x86: Use new cache mode type in include/asm/fb.h

Instead of directly using cache mode bits in the pte switch to usage of
the new cache mode type.

Based-on-patch-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stefan.bader@canonical.com
Cc: xen-devel@lists.xensource.com
Cc: konrad.wilk@oracle.com
Cc: ville.syrjala@linux.intel.com
Cc: david.vrabel@citrix.com
Cc: jbeulich@suse.com
Cc: toshi.kani@hp.com
Cc: plagnioj@jcrosoft.com
Cc: tomi.valkeinen@ti.com
Cc: bhelgaas@google.com
Link: http://lkml.kernel.org/r/1415019724-4317-3-git-send-email-jgross@suse.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
