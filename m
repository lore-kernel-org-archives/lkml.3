Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965364AbaGCJyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:54:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52094 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965048AbaGCJXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:23:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Mason <clm@fb.com>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 109/198] Btrfs: fix double free in find_lock_delalloc_range
Date: Thu,  3 Jul 2014 10:19:12 +0100
Message-Id: <1404379241-8590-110-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@fb.com>

commit 7d78874273463a784759916fc3e0b4e2eb141c70 upstream.

We need to NULL the cached_state after freeing it, otherwise
we might free it again if find_delalloc_range doesn't find anything.

Signed-off-by: Chris Mason <clm@fb.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/extent_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fe443fece851..6c80e0801e58 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1654,6 +1654,7 @@ again:
 		 * shortening the size of the delalloc range we're searching
 		 */
 		free_extent_state(cached_state);
+		cached_state = NULL;
 		if (!loops) {
 			unsigned long offset = (*start) & (PAGE_CACHE_SIZE - 1);
 			max_bytes = PAGE_CACHE_SIZE - offset;
-- 
1.9.1

