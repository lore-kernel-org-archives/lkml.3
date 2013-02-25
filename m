Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab3BYWWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:22:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599Ab3BYWUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:20:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [ 51/58] GFS2: Get a block reservation before resizing a file
Date: Mon, 25 Feb 2013 14:19:47 -0800
Message-Id: <20130225221647.137610334@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130225221636.018756060@linuxfoundation.org>
References: <20130225221636.018756060@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Peterson <rpeterso@redhat.com>

commit d2b47cfb26fe06002b8011707baac71a9ae8166f upstream.

This patch allocates a block reservation structure before growing
or shrinking a file. Without this structure, the grow or shink code
can reference the bad pointer.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/bmap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1240,6 +1240,10 @@ int gfs2_setattr_size(struct inode *inod
 
 	inode_dio_wait(inode);
 
+	ret = gfs2_rs_alloc(GFS2_I(inode));
+	if (ret)
+		return ret;
+
 	oldsize = inode->i_size;
 	if (newsize >= oldsize)
 		return do_grow(inode, newsize);


