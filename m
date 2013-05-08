Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab3EHVbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:31:24 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25187 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab3EHVbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:31:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: akpm@linux-foundation.org, bob.liu@oracle.com, dan.magenheimer@oracle.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/8] xen/tmem: Split out the different module/boot options.
Date: Wed,  8 May 2013 17:31:03 -0400
Message-Id: <1368048668-8140-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368048668-8140-1-git-send-email-konrad.wilk@oracle.com>
References: <1368048668-8140-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are three options - depending on what combination of
CONFIG_FRONTSWAP, CONFIG_CLEANCACHE and CONFIG_XEN_SELFBALLOONING
is used. Lets split them out nicely out in three groups to
make it easier to clean up.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/tmem.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/tmem.c b/drivers/xen/tmem.c
index edf7e18..c2ee188 100644
--- a/drivers/xen/tmem.c
+++ b/drivers/xen/tmem.c
@@ -49,10 +49,8 @@ __setup("nocleancache", no_cleancache);
 
 #ifdef CONFIG_FRONTSWAP
 static bool disable_frontswap __read_mostly;
-static bool disable_frontswap_selfshrinking __read_mostly;
 #ifdef CONFIG_XEN_TMEM_MODULE
 module_param(disable_frontswap, bool, S_IRUGO);
-module_param(disable_frontswap_selfshrinking, bool, S_IRUGO);
 #else
 static int __init no_frontswap(char *s)
 {
@@ -61,8 +59,15 @@ static int __init no_frontswap(char *s)
 }
 __setup("nofrontswap", no_frontswap);
 #endif
-#else /* CONFIG_FRONTSWAP */
+#endif /* CONFIG_FRONTSWAP */
+
+#ifdef CONFIG_FRONTSWAP
+static bool disable_frontswap_selfshrinking __read_mostly;
+#ifdef CONFIG_XEN_TMEM_MODULE
+module_param(disable_frontswap_selfshrinking, bool, S_IRUGO);
+#else
 #define disable_frontswap_selfshrinking 1
+#endif
 #endif /* CONFIG_FRONTSWAP */
 
 #define TMEM_CONTROL               0
-- 
1.8.1.4

