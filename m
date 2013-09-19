Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab3ISQMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 12:12:37 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:34720 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3ISQLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 12:11:37 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: mpatlasov@parallels.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [PATCH 1/3] fuse: writepages: fix aggregation
Date: Thu, 19 Sep 2013 18:11:54 +0200
Message-Id: <1379607116-13382-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1379607116-13382-1-git-send-email-miklos@szeredi.hu>
References: <1379607116-13382-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Checking against tmp-page indexes is not very useful, and results in one
(or rarely two) page requests.  Which is not much of an improvement...

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index cc3a6c4..bf765cf 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1633,7 +1633,7 @@ static int fuse_writepages_fill(struct page *page,
 		BUG_ON(!req->num_pages);
 		if (req->num_pages == FUSE_MAX_PAGES_PER_REQ ||
 		    (req->num_pages + 1) * PAGE_CACHE_SIZE > fc->max_write ||
-		    req->pages[req->num_pages - 1]->index + 1 != page->index) {
+		    data->orig_pages[req->num_pages - 1]->index + 1 != page->index) {
 
 			fuse_writepages_send(data);
 			data->req = NULL;
-- 
1.8.1.4

