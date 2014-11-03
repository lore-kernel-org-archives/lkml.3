Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaKCNFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:05:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbaKCNCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:02:15 -0500
From: Juergen Gross <jgross@suse.com>
To: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V6 10/18] x86: Remove looking for setting of _PAGE_PAT_LARGE in pageattr.c
Date: Mon,  3 Nov 2014 14:01:56 +0100
Message-Id: <1415019724-4317-11-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1415019724-4317-1-git-send-email-jgross@suse.com>
References: <1415019724-4317-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When modifying page attributes via change_page_attr_set_clr() don't
test for setting _PAGE_PAT_LARGE, as this is
- never done
- PAT support for large pages is not included in the kernel up to now

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/mm/pageattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index ae242a7..87c0d36 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1307,7 +1307,7 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
 static inline int cache_attr(pgprot_t attr)
 {
 	return pgprot_val(attr) &
-		(_PAGE_PAT | _PAGE_PAT_LARGE | _PAGE_PWT | _PAGE_PCD);
+		(_PAGE_PAT | _PAGE_PWT | _PAGE_PCD);
 }
 
 static int change_page_attr_set_clr(unsigned long *addr, int numpages,
-- 
1.8.4.5

