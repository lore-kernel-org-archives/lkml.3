Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab3HMGdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:33:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab3HMGdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 12/60] ext4: fix retry handling in ext4_ext_truncate()
Date: Mon, 12 Aug 2013 23:33:39 -0700
Message-Id: <20130813063333.750424991@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 94eec0fc3520c759831763d866421b4d60b599b4 upstream.

We tested for ENOMEM instead of -ENOMEM.   Oops.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/extents.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4389,7 +4389,7 @@ void ext4_ext_truncate(handle_t *handle,
 retry:
 	err = ext4_es_remove_extent(inode, last_block,
 				    EXT_MAX_BLOCKS - last_block);
-	if (err == ENOMEM) {
+	if (err == -ENOMEM) {
 		cond_resched();
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
 		goto retry;


