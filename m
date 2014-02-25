Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaBYHlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:41:47 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:37239 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaBYHlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:41:45 -0500
Date: Tue, 25 Feb 2014 13:11:35 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com,
        josh@joshtriplett.org
Subject: [PATCH 2/8] lib: Mark function as static in lib/lru_cache.c
Message-ID: <616a0d7efd9e54541f9038f0816b97f2336e9e78.1393313946.git.rashika.kheria@gmail.com>
References: <7bf34999aea7f3d1441dc8fc344882a814da6e06.1393313946.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7bf34999aea7f3d1441dc8fc344882a814da6e06.1393313946.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in lib/lru_cache.c because it is not used
outside this file.

This eliminates the following warning in lib/lru_cache.c:
lib/lru_cache.c:172:6: warning: no previous prototype for ‘lc_free_by_index’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 lib/lru_cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/lru_cache.c b/lib/lru_cache.c
index 4a83ecd..6111cd1 100644
--- a/lib/lru_cache.c
+++ b/lib/lru_cache.c
@@ -169,7 +169,7 @@ out_fail:
 	return NULL;
 }
 
-void lc_free_by_index(struct lru_cache *lc, unsigned i)
+static void lc_free_by_index(struct lru_cache *lc, unsigned i)
 {
 	void *p = lc->lc_element[i];
 	WARN_ON(!p);
-- 
1.7.9.5

