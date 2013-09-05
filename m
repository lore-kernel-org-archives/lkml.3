Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935694Ab3IEJpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:45:54 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:56655 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935619Ab3IEJpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:45:00 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Anand Avati <avati@redhat.com>
Subject: [PATCH 11/11] fuse: drop dentry on failed revalidate
Date: Thu,  5 Sep 2013 11:44:44 +0200
Message-Id: <1378374284-1484-12-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
References: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anand Avati <avati@redhat.com>

Drop a subtree when we find that it has moved or been delated.  This can be
done as long as there are no submounts under this location.

If the directory was moved and we come across the same directory in a
future lookup it will be reconnected by d_materialise_unique().

Signed-off-by: Anand Avati <avati@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 25c6cfe..0e6961a 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -259,6 +259,8 @@ out:
 
 invalid:
 	ret = 0;
+	if (check_submounts_and_drop(entry) != 0)
+		ret = 1;
 	goto out;
 }
 
-- 
1.8.1.4

