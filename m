Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491Ab3EQWYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:24:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab3EQVhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [ 017/102] dm cache: fix error return code in cache_create
Date: Fri, 17 May 2013 14:35:32 -0700
Message-Id: <20130517213246.162265402@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit fa4d683af3693863bec761e2761a07e4c1351f86 upstream.

Return -ENOMEM if memory allocation fails in cache_create
instead of 0 (to avoid NULL pointer dereference).

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-cache-target.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1971,6 +1971,7 @@ static int cache_create(struct cache_arg
 	atomic_set(&cache->nr_migrations, 0);
 	init_waitqueue_head(&cache->migration_wait);
 
+	r = -ENOMEM;
 	cache->nr_dirty = 0;
 	cache->dirty_bitset = alloc_bitset(from_cblock(cache->cache_size));
 	if (!cache->dirty_bitset) {


