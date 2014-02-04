Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964948AbaBDXLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:11:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932645AbaBDVAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:00:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH 3.4 36/37] Btrfs: handle EAGAIN case properly in btrfs_drop_snapshot()
Date: Tue,  4 Feb 2014 13:01:12 -0800
Message-Id: <20140204210057.027963475@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210055.992134150@linuxfoundation.org>
References: <20140204210055.992134150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

commit 90515e7f5d7d24cbb2a4038a3f1b5cfa2921aa17 upstream.

We may return early in btrfs_drop_snapshot(), we shouldn't
call btrfs_std_err() for this case, fix it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7033,7 +7033,7 @@ out:
 	 */
 	if (root_dropped == false)
 		btrfs_add_dead_root(root);
-	if (err)
+	if (err && err != -EAGAIN)
 		btrfs_std_error(root->fs_info, err);
 	return err;
 }


