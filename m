Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaE0PEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:04:15 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:15914 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752590AbaE0PEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:04:12 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhsKAIKohFNXQwje/2dsb2JhbABZgwerKAQBAQEBAQEFAYM8lFCBDhd0glMvI4EaN4hGAdRxF4VViBlkHYQqBI8/ijSTJ4M6O4Ew
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Sage Weil <sage@inktank.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/ceph/export.c: add static to local function
Date: Tue, 27 May 2014 17:04:05 +0200
Message-Id: <1401203045-25202-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ceph_get_parent is only used in fs/ceph/export.c

Cc: Sage Weil <sage@inktank.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ceph/export.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index 00d6af6..8d7d782 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -169,7 +169,7 @@ static struct dentry *__get_parent(struct super_block *sb,
 	return dentry;
 }
 
-struct dentry *ceph_get_parent(struct dentry *child)
+static struct dentry *ceph_get_parent(struct dentry *child)
 {
 	/* don't re-export snaps */
 	if (ceph_snap(child->d_inode) != CEPH_NOSNAP)
-- 
1.8.4.5

