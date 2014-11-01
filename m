Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbaKANCJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 09:02:09 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:52613 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbaKANCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 09:02:08 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-cachefs@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs: cachefiles: remove useless code
Date: Sat,  1 Nov 2014 18:31:58 +0530
Message-Id: <1414846918-21238-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

removed a comparison of unsigned long integer to less than zero,
which will be always false.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 fs/cachefiles/daemon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cachefiles/daemon.c b/fs/cachefiles/daemon.c
index ce1b115..e5ee49f 100644
--- a/fs/cachefiles/daemon.c
+++ b/fs/cachefiles/daemon.c
@@ -385,7 +385,7 @@ static int cachefiles_daemon_fstop(struct cachefiles_cache *cache, char *args)
 	if (args[0] != '%' || args[1] != '\0')
 		return -EINVAL;
 
-	if (fstop < 0 || fstop >= cache->fcull_percent)
+	if (fstop >= cache->fcull_percent)
 		return cachefiles_daemon_range_error(cache, args);
 
 	cache->fstop_percent = fstop;
@@ -457,7 +457,7 @@ static int cachefiles_daemon_bstop(struct cachefiles_cache *cache, char *args)
 	if (args[0] != '%' || args[1] != '\0')
 		return -EINVAL;
 
-	if (bstop < 0 || bstop >= cache->bcull_percent)
+	if (bstop >= cache->bcull_percent)
 		return cachefiles_daemon_range_error(cache, args);
 
 	cache->bstop_percent = bstop;
-- 
1.8.1.2

