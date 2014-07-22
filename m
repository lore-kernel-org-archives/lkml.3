Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527AbaGVW0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:26:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44860 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194AbaGVW0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:26:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Mason <clm@fb.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 071/116] Btrfs: fix double free in find_lock_delalloc_range
Date: Tue, 22 Jul 2014 15:21:22 -0700
Message-Id: <1406067727-19683-72-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@fb.com>

commit 7d78874273463a784759916fc3e0b4e2eb141c70 upstream.

We need to NULL the cached_state after freeing it, otherwise
we might free it again if find_delalloc_range doesn't find anything.

Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/btrfs/extent_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 125397e..0a800dc 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1595,6 +1595,7 @@ again:
 		 * shortening the size of the delalloc range we're searching
 		 */
 		free_extent_state(cached_state);
+		cached_state = NULL;
 		if (!loops) {
 			unsigned long offset = (*start) & (PAGE_CACHE_SIZE - 1);
 			max_bytes = PAGE_CACHE_SIZE - offset;
-- 
1.9.1

