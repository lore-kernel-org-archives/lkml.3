Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbaGOWYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:24:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53989 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaGOVcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:32:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Mason <clm@fb.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 112/198] Btrfs: fix double free in find_lock_delalloc_range
Date: Tue, 15 Jul 2014 14:29:42 -0700
Message-Id: <1405459868-15089-113-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

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
index ff43802..809bbe1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1644,6 +1644,7 @@ again:
 		 * shortening the size of the delalloc range we're searching
 		 */
 		free_extent_state(cached_state);
+		cached_state = NULL;
 		if (!loops) {
 			max_bytes = PAGE_CACHE_SIZE;
 			loops = 1;
-- 
1.9.1

