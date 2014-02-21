Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbaBUKVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 05:21:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64925 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754868AbaBUKVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 05:21:43 -0500
X-IronPort-AV: E=Sophos;i="4.97,517,1389715200"; 
   d="scan'208";a="9575592"
Message-ID: <530726BB.1040308@cn.fujitsu.com>
Date: Fri, 21 Feb 2014 18:13:15 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>
CC: fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fs/direct-io: remove redundant comparison
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/21 18:19:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/21 18:19:28,
	Serialize complete at 2014/02/21 18:19:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of bio_get_nr_vecs() can not bigger than BIO_MAX_PAGES,
so we can remove redundant the comparison between nr_pages and
BIO_MAX_PAGES.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/direct-io.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 160a548..6e6bff3 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -664,7 +664,6 @@ static inline int dio_new_bio(struct dio *dio, struct dio_submit *sdio,
 		goto out;
 	sector = start_sector << (sdio->blkbits - 9);
 	nr_pages = min(sdio->pages_in_io, bio_get_nr_vecs(map_bh->b_bdev));
-	nr_pages = min(nr_pages, BIO_MAX_PAGES);
 	BUG_ON(nr_pages <= 0);
 	dio_bio_alloc(dio, sdio, map_bh->b_bdev, sector, nr_pages);
 	sdio->boundary = 0;
-- 
1.7.7

