Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab3ENSWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:22:47 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:58547 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757717Ab3ENSUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:20:48 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: bob.liu@oracle.com, dan.magenheimer@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/9] xen/tmem: Split out the different module/boot options.
Date: Tue, 14 May 2013 14:09:20 -0400
Message-Id: <1368554966-30469-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1368554966-30469-1-git-send-email-konrad.wilk@oracle.com>
References: <1368554966-30469-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are three options - depending on what combination of
CONFIG_FRONTSWAP, CONFIG_CLEANCACHE and CONFIG_XEN_SELFBALLOONING
is used. Lets split them out nicely out in three groups to
make it easier to clean up.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/tmem.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

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
1.7.7.6

