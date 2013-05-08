Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab3EHVcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:32:42 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25205 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab3EHVbY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:31:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: akpm@linux-foundation.org, bob.liu@oracle.com, dan.magenheimer@oracle.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/8] xen/tmem: Fix compile warning.
Date: Wed,  8 May 2013 17:31:04 -0400
Message-Id: <1368048668-8140-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368048668-8140-1-git-send-email-konrad.wilk@oracle.com>
References: <1368048668-8140-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We keep on getting:
drivers/xen/tmem.c:65:13: warning: ‘disable_frontswap_selfshrinking’ defined but not used [-Wunused-variable]

if CONFIG_FRONTSWAP=y and # CONFIG_CLEANCACHE is not set

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/tmem.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/tmem.c b/drivers/xen/tmem.c
index c2ee188..30bf974 100644
--- a/drivers/xen/tmem.c
+++ b/drivers/xen/tmem.c
@@ -61,14 +61,12 @@ __setup("nofrontswap", no_frontswap);
 #endif
 #endif /* CONFIG_FRONTSWAP */
 
-#ifdef CONFIG_FRONTSWAP
+#ifdef CONFIG_XEN_SELFBALLOONING
 static bool disable_frontswap_selfshrinking __read_mostly;
 #ifdef CONFIG_XEN_TMEM_MODULE
 module_param(disable_frontswap_selfshrinking, bool, S_IRUGO);
-#else
-#define disable_frontswap_selfshrinking 1
 #endif
-#endif /* CONFIG_FRONTSWAP */
+#endif /* CONFIG_XEN_SELFBALLOONING */
 
 #define TMEM_CONTROL               0
 #define TMEM_NEW_POOL              1
-- 
1.8.1.4

