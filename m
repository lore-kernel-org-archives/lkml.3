Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934833Ab3IDOGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:06:41 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:59756 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934755Ab3IDOF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:05:58 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: rwheeler@redhat.com, avati@redhat.com, viro@ZenIV.linux.org.uk
Cc: bfoster@redhat.com, dhowells@redhat.com, eparis@redhat.com,
        raven@themaw.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz
Subject: [PATCH 10/10] fuse: drop dentry on failed revalidate
Date: Wed,  4 Sep 2013 16:05:56 +0200
Message-Id: <1378303556-7220-11-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378303556-7220-1-git-send-email-miklos@szeredi.hu>
References: <1378303556-7220-1-git-send-email-miklos@szeredi.hu>
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

