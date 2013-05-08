Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab3EHVbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:31:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25239 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab3EHVb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:31:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: akpm@linux-foundation.org, bob.liu@oracle.com, dan.magenheimer@oracle.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 8/8] xen/tmem: Remove the usage of 'noselfballoon','selfballoon' and use 'tmem.selfballon' bool instead.
Date: Wed,  8 May 2013 17:31:08 -0400
Message-Id: <1368048668-8140-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368048668-8140-1-git-send-email-konrad.wilk@oracle.com>
References: <1368048668-8140-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the 'tmem' driver is the one that actually sets whether
it will use it or not so might as well make tmem responsible
for this knob.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/Kconfig           |  5 ++---
 drivers/xen/xen-selfballoon.c | 21 ---------------------
 2 files changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index b0337a6..221b3a6 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -19,11 +19,10 @@ config XEN_SELFBALLOONING
 	  by the current usage of anonymous memory ("committed AS") and
 	  controlled by various sysfs-settable parameters.  Configuring
 	  FRONTSWAP is highly recommended; if it is not configured, self-
-	  ballooning is disabled by default but can be enabled with the
-	  'selfballooning' kernel boot parameter.  If FRONTSWAP is configured,
+	  ballooning is disabled by default. If FRONTSWAP is configured,
 	  frontswap-selfshrinking is enabled by default but can be disabled
 	  with the 'tmem.selfshrink=0' kernel boot parameter; and self-ballooning
-	  is enabled by default but can be disabled with the 'noselfballooning'
+	  is enabled by default but can be disabled with the 'tmem.selfballooning=0'
 	  kernel boot parameter.  Note that systems without a sufficiently
 	  large swap device should not enable self-ballooning.
 
diff --git a/drivers/xen/xen-selfballoon.c b/drivers/xen/xen-selfballoon.c
index 012f9d9..ee49367 100644
--- a/drivers/xen/xen-selfballoon.c
+++ b/drivers/xen/xen-selfballoon.c
@@ -173,27 +173,6 @@ static void frontswap_selfshrink(void)
 	frontswap_shrink(tgt_frontswap_pages);
 }
 
-/* Disable with kernel boot option. */
-static bool use_selfballooning = true;
-
-static int __init xen_noselfballooning_setup(char *s)
-{
-	use_selfballooning = false;
-	return 1;
-}
-
-__setup("noselfballooning", xen_noselfballooning_setup);
-#else /* !CONFIG_FRONTSWAP */
-/* Enable with kernel boot option. */
-static bool use_selfballooning;
-
-static int __init xen_selfballooning_setup(char *s)
-{
-	use_selfballooning = true;
-	return 1;
-}
-
-__setup("selfballooning", xen_selfballooning_setup);
 #endif /* CONFIG_FRONTSWAP */
 
 #define MB2PAGES(mb)	((mb) << (20 - PAGE_SHIFT))
-- 
1.8.1.4

