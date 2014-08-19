Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaHSCpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 22:45:09 -0400
Received: from mail-yk0-f179.google.com ([209.85.160.179]:52834 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaHSCpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 22:45:07 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, thierry.reding@gmail.com, jonas.jensen@gmail.com,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH] fs: Initialize mountpoint list head in new_mountpoint()
Date: Mon, 18 Aug 2014 23:43:54 -0300
Message-Id: <1408416234-7923-1-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 2.1.0.rc2.234.ge4c5f60
In-Reply-To: <20140818153327.GA12278@ulmo>
References: <20140818153327.GA12278@ulmo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 89f7ca1af15bdfe7a6aed343032a84af2a69f736 makes next-20140818
to panic because mountpoint list head was not initialized.  Initializing
it with NULL fixes the problem.

commit 89f7ca1af15bdfe7a6aed343032a84af2a69f736
Author: Eric W. Biederman <ebiederman@twitter.com>
Date:   Sun Sep 22 19:37:01 2013 -0700

    vfs: Keep a list of mounts on a mount point

    To spot any possible problems call BUG if a mountpoint
        is put when it's list of mounts is not empty.

    AV: use hlist instead of list_head

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
---
 fs/namespace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 1a2bbef..1a00bac 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -736,6 +736,7 @@ static struct mountpoint *new_mountpoint(struct dentry *dentry)
 		return ERR_PTR(ret);
 	}
 
+	INIT_HLIST_HEAD(&mp->m_list);
 	mp->m_dentry = dentry;
 	mp->m_count = 1;
 	hlist_add_head(&mp->m_hash, chain);
-- 
2.1.0.rc2.234.ge4c5f60

