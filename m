Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaFITER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 15:04:17 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:47344 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753752AbaFITEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 15:04:14 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuQNAELxlVNbslom/2dsb2JhbABZgw2sEgUBmRCBEhd1hDEvI4EaN4hGAcwIhV2JDx2EKwSPWopHk0WDPjs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/cachefiles/daemon.c: remove unnecessary tests on unsigned values
Date: Mon,  9 Jun 2014 21:02:54 +0200
Message-Id: <1402340574-15655-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

size_t and unsigned long values are never < 0

Cc: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/cachefiles/daemon.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cachefiles/daemon.c b/fs/cachefiles/daemon.c
index b078d30..ff43e5a 100644
--- a/fs/cachefiles/daemon.c
+++ b/fs/cachefiles/daemon.c
@@ -222,7 +222,7 @@ static ssize_t cachefiles_daemon_write(struct file *file,
 	if (test_bit(CACHEFILES_DEAD, &cache->flags))
 		return -EIO;
 
-	if (datalen < 0 || datalen > PAGE_SIZE - 1)
+	if (datalen > PAGE_SIZE - 1)
 		return -EOPNOTSUPP;
 
 	/* drag the command string into the kernel so we can parse it */
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
1.8.4.5

