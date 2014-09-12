Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaILPxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 11:53:45 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:53104 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaILPxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 11:53:43 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seunghun Lee <waydi1@gmail.com>
Subject: [PATCH] vfs: remove redundant sanity check in do_mount
Date: Sat, 13 Sep 2014 00:53:32 +0900
Message-Id: <1410537212-3153-1-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In sys_mount, getname() checks dir_name.
So do_mount needn't check dir_name again.

Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 fs/namespace.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index bfd03c6..bf8a9af 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2553,11 +2553,6 @@ long do_mount(const char *dev_name, const char *dir_name,
 	if ((flags & MS_MGC_MSK) == MS_MGC_VAL)
 		flags &= ~MS_MGC_MSK;
 
-	/* Basic sanity checks */
-
-	if (!dir_name || !*dir_name || !memchr(dir_name, 0, PAGE_SIZE))
-		return -EINVAL;
-
 	if (data_page)
 		((char *)data_page)[PAGE_SIZE - 1] = 0;
 
-- 
1.7.9.5

