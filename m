Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaKCNCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:02:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49724 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbaKCNCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:02:13 -0500
From: Juergen Gross <jgross@suse.com>
To: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V6 03/18] x86: Use new cache mode type in drivers/video/fbdev/gbefb.c
Date: Mon,  3 Nov 2014 14:01:49 +0100
Message-Id: <1415019724-4317-4-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1415019724-4317-1-git-send-email-jgross@suse.com>
References: <1415019724-4317-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of directly using the cache mode bits in the pte switch to
using the cache mode type.

Based-on-patch-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/video/fbdev/gbefb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/gbefb.c b/drivers/video/fbdev/gbefb.c
index 4aa56ba..6d9ef39 100644
--- a/drivers/video/fbdev/gbefb.c
+++ b/drivers/video/fbdev/gbefb.c
@@ -54,7 +54,8 @@ struct gbefb_par {
 #endif
 #endif
 #ifdef CONFIG_X86
-#define pgprot_fb(_prot) ((_prot) | _PAGE_PCD)
+#define pgprot_fb(_prot) (((_prot) & ~_PAGE_CACHE_MASK) |	\
+			  cachemode2protval(_PAGE_CACHE_MODE_UC_MINUS))
 #endif
 
 /*
-- 
1.8.4.5

