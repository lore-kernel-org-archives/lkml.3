Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264Ab3CGSu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 13:50:58 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48614 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab3CGSu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 13:50:56 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] zcache/debug: compiler failure on PPC64 and revert commit.
Date: Thu,  7 Mar 2013 13:50:47 -0500
Message-Id: <1362682247-17379-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On PPC64 we get this:
In file included from drivers/staging/zcache/debug.c:2:
drivers/staging/zcache/debug.h: In function 'dec_zcache_obj_count':
drivers/staging/zcache/debug.h:16: error: implicit declaration of function 'BUG_ON'

This simple patch adds the appropiate header file to finish
the compile and reverts
"staging: zcache: disable ZCACHE_DEBUG due to build error"
(5db5a20a50cfd078c78b13a988f237cca81aedc5)

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/Kconfig | 1 -
 drivers/staging/zcache/debug.h | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
index ad47b4b..2da6cc4 100644
--- a/drivers/staging/zcache/Kconfig
+++ b/drivers/staging/zcache/Kconfig
@@ -13,7 +13,6 @@ config ZCACHE
 config ZCACHE_DEBUG
 	bool "Enable debug statistics"
 	depends on DEBUG_FS && ZCACHE
-	depends on BROKEN
 	default n
 	help
 	  This is used to provide an debugfs directory with counters of
diff --git a/drivers/staging/zcache/debug.h b/drivers/staging/zcache/debug.h
index eef67db..4bbe49b 100644
--- a/drivers/staging/zcache/debug.h
+++ b/drivers/staging/zcache/debug.h
@@ -1,3 +1,5 @@
+#include <linux/bug.h>
+
 #ifdef CONFIG_ZCACHE_DEBUG
 
 /* we try to keep these statistics SMP-consistent */
-- 
1.8.0.2

