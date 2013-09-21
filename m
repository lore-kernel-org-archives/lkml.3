Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab3IULdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 07:33:10 -0400
Received: from intranet.asianux.com ([58.214.24.6]:52245 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab3IULdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 07:33:09 -0400
X-Spam-Score: -101.7
Message-ID: <523D83B2.30906@asianux.com>
Date: Sat, 21 Sep 2013 19:32:02 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "dhowells@redhat.com" <dhowells@redhat.com>
CC: linux-cachefs@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs/cachefiles/daemon.c: remove the checking about "unsigned
 value whether less than zero".
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'datalen', 'fstop', and 'bstop' are all unsigned type which is never
less than zero. Although they can not cause real issue, it is still
better to remove them.

The related warning (allmodconfig for S5PV210, with "EXTRA_CFLAGS=-W"):

  fs/cachefiles/daemon.c:225:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
  fs/cachefiles/daemon.c:389:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
  fs/cachefiles/daemon.c:461:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 fs/cachefiles/daemon.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cachefiles/daemon.c b/fs/cachefiles/daemon.c
index 0a1467b..ff27e11 100644
--- a/fs/cachefiles/daemon.c
+++ b/fs/cachefiles/daemon.c
@@ -222,7 +222,7 @@ static ssize_t cachefiles_daemon_write(struct file *file,
 	if (test_bit(CACHEFILES_DEAD, &cache->flags))
 		return -EIO;
 
-	if (datalen < 0 || datalen > PAGE_SIZE - 1)
+	if (datalen > PAGE_SIZE - 1)
 		return -EOPNOTSUPP;
 
 	/* drag the command string into the kernel so we can parse it */
@@ -386,7 +386,7 @@ static int cachefiles_daemon_fstop(struct cachefiles_cache *cache, char *args)
 	if (args[0] != '%' || args[1] != '\0')
 		return -EINVAL;
 
-	if (fstop < 0 || fstop >= cache->fcull_percent)
+	if (fstop >= cache->fcull_percent)
 		return cachefiles_daemon_range_error(cache, args);
 
 	cache->fstop_percent = fstop;
@@ -458,7 +458,7 @@ static int cachefiles_daemon_bstop(struct cachefiles_cache *cache, char *args)
 	if (args[0] != '%' || args[1] != '\0')
 		return -EINVAL;
 
-	if (bstop < 0 || bstop >= cache->bcull_percent)
+	if (bstop >= cache->bcull_percent)
 		return cachefiles_daemon_range_error(cache, args);
 
 	cache->bstop_percent = bstop;
-- 
1.7.7.6
