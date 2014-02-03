Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbaBCTJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:09:31 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:41311 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbaBCTJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:09:29 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/10] kernfs: add kernfs_open_file->priv
Date: Mon,  3 Feb 2014 14:09:14 -0500
Message-Id: <1391454557-32376-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391454557-32376-1-git-send-email-tj@kernel.org>
References: <1391454557-32376-1-git-send-email-tj@kernel.org>
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

