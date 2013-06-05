Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab3FETYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 15:24:45 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:35051 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755354Ab3FETYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 15:24:44 -0400
Message-ID: <51AF9079.90304@semaphore.gr>
Date: Wed, 05 Jun 2013 22:24:41 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>
CC: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH linux-next] ext4: inode: Fix compiler warning
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following compiler warning:

fs/ext4/inode.c: In function ‘ext4_da_writepages’:
fs/ext4/inode.c:2212:6: warning: ‘err’ may be used uninitialized in this
function [-Wmaybe-uninitialized]
fs/ext4/inode.c:2155:6: note: ‘err’ was declared here

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 442c5d2..702428c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2152,7 +2152,7 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 {
 	struct inode *inode = mpd->inode;
 	struct ext4_map_blocks *map = &mpd->map;
-	int err;
+	int err = 0;
 	loff_t disksize;
 
 	mpd->io_submit.io_end->offset =
-- 
1.8.1.4

