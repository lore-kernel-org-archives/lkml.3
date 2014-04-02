Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877AbaDBR6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:58:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:52251 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932851AbaDBR56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:57:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,781,1389772800"; 
   d="scan'208";a="485893460"
From: David Cohen <david.a.cohen@linux.intel.com>
To: akpm@linux-foundation.org, LinoSanfilippo@gmx.de
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-janitors@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH] fsnotify: trivial cleanup
Date: Wed,  2 Apr 2014 10:17:55 -0700
Message-Id: <1396459075-25014-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not initialize private_destroy_list twice.
list_replace_init() already takes care of initializing private_destroy_list.
We don't need to initialize it with LIST_HEAD() beforehand.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 fs/notify/mark.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 923fe4a5f503..d90deaa08e78 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -340,7 +340,7 @@ void fsnotify_init_mark(struct fsnotify_mark *mark,
 static int fsnotify_mark_destroy(void *ignored)
 {
 	struct fsnotify_mark *mark, *next;
-	LIST_HEAD(private_destroy_list);
+	struct list_head private_destroy_list;
 
 	for (;;) {
 		spin_lock(&destroy_lock);
-- 
1.9.0

