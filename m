Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192Ab3ENSWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:22:13 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:50686 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757748Ab3ENSUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:20:49 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: bob.liu@oracle.com, dan.magenheimer@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/9] xen/tmem: Fix compile warning.
Date: Tue, 14 May 2013 14:09:21 -0400
Message-Id: <1368554966-30469-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1368554966-30469-1-git-send-email-konrad.wilk@oracle.com>
References: <1368554966-30469-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We keep on getting:
drivers/xen/tmem.c:65:13: warning: ‘disable_frontswap_selfshrinking’ defined but not used [-Wunused-variable]

if CONFIG_FRONTSWAP=y and # CONFIG_CLEANCACHE is not set

Found by 0 day test project

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/tmem.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

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
1.7.7.6

