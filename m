Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab3EHVco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:32:44 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25200 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036Ab3EHVbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:31:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: akpm@linux-foundation.org, bob.liu@oracle.com, dan.magenheimer@oracle.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 7/8] xen/tmem: Remove the usage of 'noselfshrink' and use 'tmem.selfshrink' bool instead.
Date: Wed,  8 May 2013 17:31:07 -0400
Message-Id: <1368048668-8140-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368048668-8140-1-git-send-email-konrad.wilk@oracle.com>
References: <1368048668-8140-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the 'tmem' driver is the one that actually sets whether
it will use it or not so might as well make tmem responsible
for this knob.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/Kconfig           |  2 +-
 drivers/xen/xen-selfballoon.c | 15 ++-------------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index dd4d9cb..b0337a6 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -22,7 +22,7 @@ config XEN_SELFBALLOONING
 	  ballooning is disabled by default but can be enabled with the
 	  'selfballooning' kernel boot parameter.  If FRONTSWAP is configured,
 	  frontswap-selfshrinking is enabled by default but can be disabled
-	  with the 'noselfshrink' kernel boot parameter; and self-ballooning
+	  with the 'tmem.selfshrink=0' kernel boot parameter; and self-ballooning
 	  is enabled by default but can be disabled with the 'noselfballooning'
 	  kernel boot parameter.  Note that systems without a sufficiently
 	  large swap device should not enable self-ballooning.
diff --git a/drivers/xen/xen-selfballoon.c b/drivers/xen/xen-selfballoon.c
index f2ef569..012f9d9 100644
--- a/drivers/xen/xen-selfballoon.c
+++ b/drivers/xen/xen-selfballoon.c
@@ -60,8 +60,8 @@
  * be enabled with the "selfballooning" kernel boot option; similarly
  * selfballooning is enabled by default if frontswap is configured and
  * can be disabled with the "noselfballooning" kernel boot option.  Finally,
- * when frontswap is configured, frontswap-selfshrinking can be disabled
- * with the "noselfshrink" kernel boot option.
+ * when frontswap is configured,frontswap-selfshrinking can be disabled
+ * with the "tmem.selfshrink=0" kernel boot option.
  *
  * Selfballooning is disallowed in domain0 and force-disabled.
  *
@@ -120,9 +120,6 @@ static DECLARE_DELAYED_WORK(selfballoon_worker, selfballoon_process);
 /* Enable/disable with sysfs. */
 static bool frontswap_selfshrinking __read_mostly;
 
-/* Enable/disable with kernel boot option. */
-static bool use_frontswap_selfshrink = true;
-
 /*
  * The default values for the following parameters were deemed reasonable
  * by experimentation, may be workload-dependent, and can all be
@@ -176,14 +173,6 @@ static void frontswap_selfshrink(void)
 	frontswap_shrink(tgt_frontswap_pages);
 }
 
-static int __init xen_nofrontswap_selfshrink_setup(char *s)
-{
-	use_frontswap_selfshrink = false;
-	return 1;
-}
-
-__setup("noselfshrink", xen_nofrontswap_selfshrink_setup);
-
 /* Disable with kernel boot option. */
 static bool use_selfballooning = true;
 
-- 
1.8.1.4

