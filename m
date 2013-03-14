Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934427Ab3CNQLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 12:11:22 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:44638 "EHLO
	homiemail-a46.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964804Ab3CNQKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 12:10:15 -0400
From: Shea Levy <shea@shealevy.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Shea Levy <shea@shealevy.com>
Subject: [PATCH 2/2] vfs: statfs: A fs is r/o if the superblock is
Date: Thu, 14 Mar 2013 12:09:20 -0400
Message-Id: <1363277360-1947-3-git-send-email-shea@shealevy.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363277360-1947-1-git-send-email-shea@shealevy.com>
References: <1363277360-1947-1-git-send-email-shea@shealevy.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By calling mount(2) with MS_REMOUNT | MS_BIND on a non-bind readonly
mountpoint, it is possible to have a readonly mount without MNT_READONLY
in its mnt_flags. Currently, statfs will not set the ST_RDONLY flag in
f_flags for such a mount, even though for all intents and purposes it is
still readonly.

This patch makes vfs_statfs set ST_RDONLY in f_flags if mnt_sb->s_flags
contains MS_RDONLY.

Signed-off-by: Shea Levy <shea@shealevy.com>
---
 fs/statfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/statfs.c b/fs/statfs.c
index c219e733..c614087 100644
--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -37,6 +37,8 @@ static int flags_by_sb(int s_flags)
 		flags |= ST_SYNCHRONOUS;
 	if (s_flags & MS_MANDLOCK)
 		flags |= ST_MANDLOCK;
+	if (s_flags & MS_RDONLY)
+		flags |= ST_RDONLY;
 	return flags;
 }
 
-- 
1.8.1.3

