Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab3BAUXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:23:35 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:39079 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728Ab3BAUXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:23:30 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: dan.magenheimer@oracle.com, konrad.wilk@oracle.com,
        sjenning@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, ngupta@vflare.org, rcj@linux.vnet.ibm.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 08/15] xen/tmem: Remove the subsys call.
Date: Fri,  1 Feb 2013 15:22:57 -0500
Message-Id: <1359750184-23408-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1359750184-23408-1-git-send-email-konrad.wilk@oracle.com>
References: <1359750184-23408-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We get:
drivers/xen/xen-selfballoon.c:577:134: warning: initialization from incompatible pointer type [enabled by default]

We actually do not need this function to be called
before tmem is loaded. So lets remove the subsys_init.

If tmem is built in as a module this is still OK as
xen_selfballoon_init ends up being exported and can
be called by the tmem module.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-selfballoon.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/xen/xen-selfballoon.c b/drivers/xen/xen-selfballoon.c
index 6965e9b..f2ef569 100644
--- a/drivers/xen/xen-selfballoon.c
+++ b/drivers/xen/xen-selfballoon.c
@@ -572,7 +572,3 @@ int xen_selfballoon_init(bool use_selfballooning, bool use_frontswap_selfshrink)
 	return 0;
 }
 EXPORT_SYMBOL(xen_selfballoon_init);
-
-#ifndef CONFIG_XEN_TMEM_MODULE
-subsys_initcall(xen_selfballoon_init);
-#endif
-- 
1.7.11.7

