Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab3KTQjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:39:24 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:59662 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab3KTQjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:39:23 -0500
From: Dan Streetman <ddstreet@ieee.org>
To: linux-mm@kvack.org, Seth Jennings <sjennings@variantweb.net>
Cc: Dan Streetman <ddstreet@ieee.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>
Subject: [PATCH] mm/zswap: change params from hidden to ro
Date: Wed, 20 Nov 2013 11:38:42 -0500
Message-Id: <1384965522-5788-1-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "compressor" and "enabled" params are currently hidden,
this changes them to read-only, so userspace can tell if
zswap is enabled or not and see what compressor is in use.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index d93510c..36b268b 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -77,12 +77,12 @@ static u64 zswap_duplicate_entry;
 **********************************/
 /* Enable/disable zswap (disabled by default, fixed at boot for now) */
 static bool zswap_enabled __read_mostly;
-module_param_named(enabled, zswap_enabled, bool, 0);
+module_param_named(enabled, zswap_enabled, bool, 0444);
 
 /* Compressor to be used by zswap (fixed at boot for now) */
 #define ZSWAP_COMPRESSOR_DEFAULT "lzo"
 static char *zswap_compressor = ZSWAP_COMPRESSOR_DEFAULT;
-module_param_named(compressor, zswap_compressor, charp, 0);
+module_param_named(compressor, zswap_compressor, charp, 0444);
 
 /* The maximum percentage of memory that the compressed pool can occupy */
 static unsigned int zswap_max_pool_percent = 20;
-- 
1.8.3.1

