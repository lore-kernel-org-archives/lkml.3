Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaFGLJg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 07:09:36 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:55632 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752471AbaFGLJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 07:09:34 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmIOAGnyklNXQ3Uj/2dsb2JhbABZgw2sGggBAQUBmRCBAxd1hGAjgRo3iEYBtByZCReFXYkPHYQrBI9aikeLKIgdgz47
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Seth Jennings <sjennings@variantweb.net>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] mm/zswap.c: add __init to zswap_entry_cache_destroy
Date: Sat,  7 Jun 2014 13:08:34 +0200
Message-Id: <1402139314-5573-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zswap_entry_cache_destroy is only called by __init init_zswap

This patch also fixes function name
zswap_entry_cache_ s/destory/destroy

Cc: Seth Jennings <sjennings@variantweb.net>
Cc: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index aeaef0f..ab7fa0f 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -207,7 +207,7 @@ static int zswap_entry_cache_create(void)
 	return zswap_entry_cache == NULL;
 }
 
-static void zswap_entry_cache_destory(void)
+static void __init zswap_entry_cache_destroy(void)
 {
 	kmem_cache_destroy(zswap_entry_cache);
 }
@@ -926,7 +926,7 @@ static int __init init_zswap(void)
 pcpufail:
 	zswap_comp_exit();
 compfail:
-	zswap_entry_cache_destory();
+	zswap_entry_cache_destroy();
 cachefail:
 	zbud_destroy_pool(zswap_pool);
 error:
-- 
1.9.1

