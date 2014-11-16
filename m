Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbaKPKzS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 05:55:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34817 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbaKPKzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 05:55:16 -0500
Date: Sun, 16 Nov 2014 02:55:02 -0800
From: tip-bot for Juergen Gross <tipbot@zytor.com>
Message-ID: <tip-2d85ebf8e12e14694d6f9a4f34359c19f0738ace@git.kernel.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, jgross@suse.com,
        tglx@linutronix.de, stefan.bader@canonical.com, hpa@zytor.com
Reply-To: mingo@kernel.org, stefan.bader@canonical.com, tglx@linutronix.de,
        hpa@zytor.com, jgross@suse.com, linux-kernel@vger.kernel.org
In-Reply-To: <1415019724-4317-4-git-send-email-jgross@suse.com>
References: <1415019724-4317-4-git-send-email-jgross@suse.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Use new cache mode type in drivers/video/fbdev/
 gbefb.c
Git-Commit-ID: 2d85ebf8e12e14694d6f9a4f34359c19f0738ace
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

Commit-ID:  2d85ebf8e12e14694d6f9a4f34359c19f0738ace
Gitweb:     http://git.kernel.org/tip/2d85ebf8e12e14694d6f9a4f34359c19f0738ace
Author:     Juergen Gross <jgross@suse.com>
AuthorDate: Mon, 3 Nov 2014 14:01:49 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 16 Nov 2014 11:04:25 +0100

x86: Use new cache mode type in drivers/video/fbdev/gbefb.c

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
Link: http://lkml.kernel.org/r/1415019724-4317-4-git-send-email-jgross@suse.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
