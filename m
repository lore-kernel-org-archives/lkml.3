Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbaGHTVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:21:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54301 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755741AbaGHTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Chris Mason" <clm@fb.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.166011291@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 071/125] Btrfs: fix double free in find_lock_delalloc_range
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@fb.com>

commit 7d78874273463a784759916fc3e0b4e2eb141c70 upstream.

We need to NULL the cached_state after freeing it, otherwise
we might free it again if find_delalloc_range doesn't find anything.

Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/extent_io.c | 1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1523,6 +1523,7 @@ again:
 		 * shortening the size of the delalloc range we're searching
 		 */
 		free_extent_state(cached_state);
+		cached_state = NULL;
 		if (!loops) {
 			unsigned long offset = (*start) & (PAGE_CACHE_SIZE - 1);
 			max_bytes = PAGE_CACHE_SIZE - offset;

