Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbaA1XdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:33:11 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:54705 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbaA1XdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:33:07 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/9] kernfs: add kernfs_open_file->priv
Date: Tue, 28 Jan 2014 18:32:49 -0500
Message-Id: <1390951971-15671-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390951971-15671-1-git-send-email-tj@kernel.org>
References: <1390951971-15671-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a private data field to be used by kernfs file operations.  This
generally makes sense and will be used by cgroup.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/kernfs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 47f5235..9ca0f09 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -146,6 +146,7 @@ struct kernfs_open_file {
 	/* published fields */
 	struct kernfs_node	*kn;
 	struct file		*file;
+	void			*priv;
 
 	/* private fields, do not use outside kernfs proper */
 	struct mutex		mutex;
-- 
1.8.5.3

