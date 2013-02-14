Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515Ab3BNDHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:07:25 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19984 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab3BNDFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:05:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        dan.magenheimer@oracle.com, gregkh@linuxfoundation.org
Cc: sjenning@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 01/16] zcache: s/int/bool/ on the various options.
Date: Wed, 13 Feb 2013 22:04:51 -0500
Message-Id: <1360811106-2679-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
References: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are so many, but this allows us to at least have them
right in as bool.

[v1: Rebase on ramster->zcache move]
[v2: Rebase on staging/zcache: Fix/improve zcache writeback code, tie to a config option]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/zcache-main.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 4456ab4..5daa0be 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -34,9 +34,9 @@
 #include "zbud.h"
 #include "ramster.h"
 #ifdef CONFIG_RAMSTER
-static int ramster_enabled;
+static bool ramster_enabled __read_mostly;
 #else
-#define ramster_enabled 0
+#define ramster_enabled false
 #endif
 
 #ifndef __PG_WAS_ACTIVE
@@ -62,11 +62,11 @@ static inline void frontswap_tmem_exclusive_gets(bool b)
 /* enable (or fix code) when Seth's patches are accepted upstream */
 #define zcache_writeback_enabled 0
 
-static int zcache_enabled __read_mostly;
-static int disable_cleancache __read_mostly;
-static int disable_frontswap __read_mostly;
-static int disable_frontswap_ignore_nonactive __read_mostly;
-static int disable_cleancache_ignore_nonactive __read_mostly;
+static bool zcache_enabled __read_mostly;
+static bool disable_cleancache __read_mostly;
+static bool disable_frontswap __read_mostly;
+static bool disable_frontswap_ignore_nonactive __read_mostly;
+static bool disable_cleancache_ignore_nonactive __read_mostly;
 static char *namestr __read_mostly = "zcache";
 
 #define ZCACHE_GFP_MASK \
@@ -1840,16 +1840,16 @@ struct frontswap_ops zcache_frontswap_register_ops(void)
 
 static int __init enable_zcache(char *s)
 {
-	zcache_enabled = 1;
+	zcache_enabled = true;
 	return 1;
 }
 __setup("zcache", enable_zcache);
 
 static int __init enable_ramster(char *s)
 {
-	zcache_enabled = 1;
+	zcache_enabled = true;
 #ifdef CONFIG_RAMSTER
-	ramster_enabled = 1;
+	ramster_enabled = true;
 #endif
 	return 1;
 }
@@ -1859,7 +1859,7 @@ __setup("ramster", enable_ramster);
 
 static int __init no_cleancache(char *s)
 {
-	disable_cleancache = 1;
+	disable_cleancache = true;
 	return 1;
 }
 
@@ -1867,7 +1867,7 @@ __setup("nocleancache", no_cleancache);
 
 static int __init no_frontswap(char *s)
 {
-	disable_frontswap = 1;
+	disable_frontswap = true;
 	return 1;
 }
 
@@ -1883,7 +1883,7 @@ __setup("nofrontswapexclusivegets", no_frontswap_exclusive_gets);
 
 static int __init no_frontswap_ignore_nonactive(char *s)
 {
-	disable_frontswap_ignore_nonactive = 1;
+	disable_frontswap_ignore_nonactive = true;
 	return 1;
 }
 
@@ -1891,7 +1891,7 @@ __setup("nofrontswapignorenonactive", no_frontswap_ignore_nonactive);
 
 static int __init no_cleancache_ignore_nonactive(char *s)
 {
-	disable_cleancache_ignore_nonactive = 1;
+	disable_cleancache_ignore_nonactive = true;
 	return 1;
 }
 
@@ -1900,7 +1900,7 @@ __setup("nocleancacheignorenonactive", no_cleancache_ignore_nonactive);
 static int __init enable_zcache_compressor(char *s)
 {
 	strncpy(zcache_comp_name, s, ZCACHE_COMP_NAME_SZ);
-	zcache_enabled = 1;
+	zcache_enabled = true;
 	return 1;
 }
 __setup("zcache=", enable_zcache_compressor);
-- 
1.8.0.2

