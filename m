Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551AbaIRRi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 13:38:56 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:31054 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932146AbaIRRiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 13:38:55 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhUOAEcYG1RbsHJU/2dsb2JhbABggw2BKrUKCwUBcZsYgQsXAXmEMS8jgRo3iEIBsgmQR4YJiW4dhDUFnQyVSINgOy+CSgEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, David Howells <dhowells@redhat.com>,
        linux-cachefs@redhat.com
Subject: [PATCH 1/1] fs/cachefiles: fix sparse context imbalance warning
Date: Thu, 18 Sep 2014 19:38:47 +0200
Message-Id: <1411061927-8497-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotate cachefiles_uncache_page to avoid the following sparse warning:
fs/cachefiles/rdwr.c:972:20: warning: context imbalance in 'cachefiles_uncache_page' - unexpected unlock

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/cachefiles/rdwr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index 616db0e7..ee52f4c 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -953,6 +953,7 @@ int cachefiles_write_page(struct fscache_storage *op, struct page *page)
  * - cache withdrawal is prevented by the caller
  */
 void cachefiles_uncache_page(struct fscache_object *_object, struct page *page)
+	__releases(&object->fscache.cookie->lock)
 {
 	struct cachefiles_object *object;
 	struct cachefiles_cache *cache;
-- 
1.9.1

