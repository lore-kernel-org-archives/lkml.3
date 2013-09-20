Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab3ITBgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 21:36:00 -0400
Received: from smtprelay0249.hostedemail.com ([216.40.44.249]:58062 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752050Ab3ITBf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 21:35:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3868:4321:5007:6261:10004:10026:10848:11658:11914:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: knee80_8b41d4779f728
X-Filterd-Recvd-Size: 1847
From: Joe Perches <joe@perches.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] framebuffer: Add fb_<level> convenience logging macros
Date: Thu, 19 Sep 2013 18:35:54 -0700
Message-Id: <0926c7a34ac51c4cbb67debd0d883f41891e75d9.1379640011.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add fb_<level> convenience macros for emitting the
"fb%d: ", struct fb_info->node value.

Neatens and shortens the code a bit.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/fb.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/fb.h b/include/linux/fb.h
index ffac70a..70c4836 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -792,4 +792,16 @@ extern int fb_find_mode(struct fb_var_screeninfo *var,
 			const struct fb_videomode *default_mode,
 			unsigned int default_bpp);
 
+/* Convenience logging macros */
+#define fb_err(fb_info, fmt, ...)					\
+	pr_err("fb%d: " fmt, (fb_info)->node, ##__VA_ARGS__)
+#define fb_notice(info, fmt, ...)					\
+	pr_notice("fb%d: " fmt, (fb_info)->node, ##__VA_ARGS__)
+#define fb_warn(fb_info, fmt, ...)					\
+	pr_warn("fb%d: " fmt, (fb_info)->node, ##__VA_ARGS__)
+#define fb_info(fb_info, fmt, ...)					\
+	pr_info("fb%d: " fmt, (fb_info)->node, ##__VA_ARGS__)
+#define fb_dbg(fb_info, fmt, ...)					\
+	pr_debug("fb%d: " fmt, (fb_info)->node, ##__VA_ARGS__)
+
 #endif /* _LINUX_FB_H */
-- 
1.8.1.2.459.gbcd45b4.dirty

