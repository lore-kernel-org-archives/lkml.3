Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763678Ab3ECU4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:56:19 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:35042 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3ECU4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:56:18 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] staging: zcache: Fix incorrect module_param_array types
Date: Fri,  3 May 2013 22:56:15 +0200
Message-Id: <1367614575-30379-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/zcache/zcache-main.c: In function ‘__check_disable_cleancache’:
drivers/staging/zcache/zcache-main.c:1928: warning: return from incompatible pointer type
drivers/staging/zcache/zcache-main.c: In function ‘__check_disable_frontswap’:
drivers/staging/zcache/zcache-main.c:1929: warning: return from incompatible pointer type
drivers/staging/zcache/zcache-main.c: In function ‘__check_disable_frontswap_ignore_nonactive’:
drivers/staging/zcache/zcache-main.c:1933: warning: return from incompatible pointer type

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/staging/zcache/zcache-main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 522cb8e..dcceed2 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1922,15 +1922,15 @@ out:
 
 #ifdef CONFIG_ZCACHE_MODULE
 #ifdef CONFIG_RAMSTER
-module_param(ramster_enabled, int, S_IRUGO);
+module_param(ramster_enabled, bool, S_IRUGO);
 module_param(disable_frontswap_selfshrink, int, S_IRUGO);
 #endif
-module_param(disable_cleancache, int, S_IRUGO);
-module_param(disable_frontswap, int, S_IRUGO);
+module_param(disable_cleancache, bool, S_IRUGO);
+module_param(disable_frontswap, bool, S_IRUGO);
 #ifdef FRONTSWAP_HAS_EXCLUSIVE_GETS
 module_param(frontswap_has_exclusive_gets, bool, S_IRUGO);
 #endif
-module_param(disable_frontswap_ignore_nonactive, int, S_IRUGO);
+module_param(disable_frontswap_ignore_nonactive, bool, S_IRUGO);
 module_param(zcache_comp_name, charp, S_IRUGO);
 module_init(zcache_init);
 MODULE_LICENSE("GPL");
-- 
1.7.0.4

