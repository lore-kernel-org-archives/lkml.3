Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761714Ab3EFXtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:49:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932739Ab3EFW5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:57:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 56/63] ext4: fix online resizing for ext3-compat file systems
Date: Mon,  6 May 2013 15:56:34 -0700
Message-Id: <20130506225328.311473396@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225314.802167948@linuxfoundation.org>
References: <20130506225314.802167948@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit c5c72d814cf0f650010337c73638b25e6d14d2d4 upstream.

Commit fb0a387dcdc restricts block allocations for indirect-mapped
files to block groups less than s_blockfile_groups.  However, the
online resizing code wasn't setting s_blockfile_groups, so the newly
added block groups were not available for non-extent mapped files.

Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/resize.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1202,6 +1202,8 @@ static void ext4_update_super(struct sup
 
 	/* Update the global fs size fields */
 	sbi->s_groups_count += flex_gd->count;
+	sbi->s_blockfile_groups = min_t(ext4_group_t, sbi->s_groups_count,
+			(EXT4_MAX_BLOCK_FILE_PHYS / EXT4_BLOCKS_PER_GROUP(sb)));
 
 	/* Update the reserved block counts only once the new group is
 	 * active. */


