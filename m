Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab3APP7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:59:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35752 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030Ab3APP7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:59:12 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 028/222] ext4: init pagevec in ext4_da_block_invalidatepages
Date: Wed, 16 Jan 2013 13:53:48 -0200
Message-Id: <1358351822-7675-29-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit 66bea92c69477a75a5d37b9bfed5773c92a3c4b4 upstream.

ext4_da_block_invalidatepages is missing a pagevec_init(),
which means that pvec->cold contains random garbage.

This affects whether the page goes to the front or
back of the LRU when ->cold makes it to
free_hot_cold_page()

Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ext4/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9e9aed3..75f537f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1491,6 +1491,8 @@ static void ext4_da_block_invalidatepages(struct mpage_da_data *mpd)
 
 	index = mpd->first_page;
 	end   = mpd->next_page - 1;
+
+	pagevec_init(&pvec, 0);
 	while (index <= end) {
 		nr_pages = pagevec_lookup(&pvec, mapping, index, PAGEVEC_SIZE);
 		if (nr_pages == 0)
-- 
1.7.9.5

