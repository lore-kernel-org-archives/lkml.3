Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbaKPKzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 05:55:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34829 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbaKPKzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 05:55:51 -0500
Date: Sun, 16 Nov 2014 02:55:38 -0800
From: tip-bot for Juergen Gross <tipbot@zytor.com>
Message-ID: <tip-1c64216be16404df7fab33c793890bb5076e8123@git.kernel.org>
Cc: stefan.bader@canonical.com, mingo@kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com, jgross@suse.com
Reply-To: tglx@linutronix.de, linux-kernel@vger.kernel.org, jgross@suse.com,
        hpa@zytor.com, stefan.bader@canonical.com, mingo@kernel.org
In-Reply-To: <1415019724-4317-6-git-send-email-jgross@suse.com>
References: <1415019724-4317-6-git-send-email-jgross@suse.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Use new cache mode type in arch/x86/pci
Git-Commit-ID: 1c64216be16404df7fab33c793890bb5076e8123
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

Commit-ID:  1c64216be16404df7fab33c793890bb5076e8123
Gitweb:     http://git.kernel.org/tip/1c64216be16404df7fab33c793890bb5076e8123
Author:     Juergen Gross <jgross@suse.com>
AuthorDate: Mon, 3 Nov 2014 14:01:51 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 16 Nov 2014 11:04:25 +0100

x86: Use new cache mode type in arch/x86/pci

Instead of directly using the cache mode bits in the pte switch to
using the cache mode type.

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
Link: http://lkml.kernel.org/r/1415019724-4317-6-git-send-email-jgross@suse.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/pci/i386.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 37c1435..9b18ef3 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -433,14 +433,14 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 		return -EINVAL;
 
 	if (pat_enabled && write_combine)
-		prot |= _PAGE_CACHE_WC;
+		prot |= cachemode2protval(_PAGE_CACHE_MODE_WC);
 	else if (pat_enabled || boot_cpu_data.x86 > 3)
 		/*
 		 * ioremap() and ioremap_nocache() defaults to UC MINUS for now.
 		 * To avoid attribute conflicts, request UC MINUS here
 		 * as well.
 		 */
-		prot |= _PAGE_CACHE_UC_MINUS;
+		prot |= cachemode2protval(_PAGE_CACHE_MODE_UC_MINUS);
 
 	vma->vm_page_prot = __pgprot(prot);
 
