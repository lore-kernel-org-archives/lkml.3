Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab3EaVWC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 17:22:02 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36345 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757163Ab3EaVVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 17:21:48 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: <linux-kernel@vger.kernel.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCH 2/3] remoteproc/omap: fix a sparse warning
Date: Fri, 31 May 2013 16:16:16 -0500
Message-ID: <1370034976-29599-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a sparse warning in the omap remoteproc code
when OMAP_REMOTEPROC is disabled.

include/linux/platform_data/remoteproc-omap.h:76:13: warning: symbol 'omap_rproc_reserve_cma' was not declared. Should it be static?

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 include/linux/platform_data/remoteproc-omap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/platform_data/remoteproc-omap.h b/include/linux/platform_data/remoteproc-omap.h
index 3c1c644..bfbd12b 100644
--- a/include/linux/platform_data/remoteproc-omap.h
+++ b/include/linux/platform_data/remoteproc-omap.h
@@ -50,7 +50,7 @@ void __init omap_rproc_reserve_cma(void);
 
 #else
 
-void __init omap_rproc_reserve_cma(void)
+static inline void __init omap_rproc_reserve_cma(void)
 {
 }
 
-- 
1.8.2

