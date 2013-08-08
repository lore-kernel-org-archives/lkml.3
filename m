Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965944Ab3HHPZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 11:25:48 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:43499 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965913Ab3HHPZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 11:25:13 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: rwheeler@redhat.com, avati@redhat.com, viro@ZenIV.linux.org.uk
Cc: bfoster@redhat.com, dhowells@redhat.com, eparis@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz
Subject: [PATCH 9/9] fuse: drop dentry on failed revalidate
Date: Thu,  8 Aug 2013 17:24:50 +0200
Message-Id: <1375975490-18673-10-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375975490-18673-1-git-send-email-miklos@szeredi.hu>
References: <1375975490-18673-1-git-send-email-miklos@szeredi.hu>
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

