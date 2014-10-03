Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbaJCWNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:13:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757758AbaJCWNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:13:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.16 353/357] ext4: avoid trying to kfree an ERR_PTR pointer
Date: Fri,  3 Oct 2014 14:32:19 -0700
Message-Id: <20141003212944.061183410@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit a9cfcd63e8d206ce4235c355d857c4fbdf0f4587 upstream.

Thanks to Dan Carpenter for extending smatch to find bugs like this.
(This was found using a development version of smatch.)

Fixes: 36de928641ee48b2078d3fe9514242aaa2f92013
Reported-by: Dan Carpenter <dan.carpenter@oracle.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/namei.c  |    2 ++
 fs/ext4/resize.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3240,6 +3240,7 @@ static int ext4_rename(struct inode *old
 				 &new.de, &new.inlined);
 	if (IS_ERR(new.bh)) {
 		retval = PTR_ERR(new.bh);
+		new.bh = NULL;
 		goto end_rename;
 	}
 	if (new.bh) {
@@ -3386,6 +3387,7 @@ static int ext4_cross_rename(struct inod
 				 &new.de, &new.inlined);
 	if (IS_ERR(new.bh)) {
 		retval = PTR_ERR(new.bh);
+		new.bh = NULL;
 		goto end_rename;
 	}
 
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -575,6 +575,7 @@ handle_bb:
 		bh = bclean(handle, sb, block);
 		if (IS_ERR(bh)) {
 			err = PTR_ERR(bh);
+			bh = NULL;
 			goto out;
 		}
 		overhead = ext4_group_overhead_blocks(sb, group);
@@ -603,6 +604,7 @@ handle_ib:
 		bh = bclean(handle, sb, block);
 		if (IS_ERR(bh)) {
 			err = PTR_ERR(bh);
+			bh = NULL;
 			goto out;
 		}
 


