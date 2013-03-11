Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab3CKWyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 18:54:41 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:44944 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab3CKWyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 18:54:40 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH] fuse: Fix build after change to synchronize with library
Date: Mon, 11 Mar 2013 15:54:16 -0700
Message-Id: <1363042456-8895-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.8.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__linux__ is not always defined so check __KERNEL__ as well.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 include/uapi/linux/fuse.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 4c43b44..fc5d400 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -95,7 +95,7 @@
 #ifndef _LINUX_FUSE_H
 #define _LINUX_FUSE_H
 
-#ifdef __linux__
+#if defined(__KERNEL__) || defined(__linux__)
 #include <linux/types.h>
 #else
 #include <stdint.h>
-- 
1.8.1.3

