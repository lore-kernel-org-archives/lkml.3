Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614Ab3LKL3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:29:33 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:36626 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3LKL3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:29:31 -0500
Message-ID: <52A84C8E.5090209@gmail.com>
Date: Wed, 11 Dec 2013 19:29:18 +0800
From: Younger Liu <younger.liucn@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: joern@logfs.org, prasadjoshi.linux@gmail.com, logfs@logfs.org,
        kernel <linux-kernel@vger.kernel.org>,
        fs-devel <linux-fsdevel@vger.kernel.org>, liuyiyang@hisense.com
Subject: [RESENT PATCH] logfs: Check for the return value after calling find_or_create_page()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Younger Liu <liuyiyang@hisense.com>

  In get_mapping_page(), after calling find_or_create_page(),
the return value should be checked.

  This patch has been provided:
http://www.spinics.net/lists/linux-fsdevel/msg66948.html
but not been applied now.

Signed-off-by: Younger Liu <liuyiyang@hisense.com>
Cc: Younger Liu <younger.liucn@gmail.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Reviewed-by: Prasad Joshi <prasadjoshi.linux@gmail.com>
---
 fs/logfs/segment.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/logfs/segment.c b/fs/logfs/segment.c
index d448a77..7f9b096 100644
--- a/fs/logfs/segment.c
+++ b/fs/logfs/segment.c
@@ -62,7 +62,8 @@ static struct page *get_mapping_page(struct
super_block *sb, pgoff_t index,
 		page = read_cache_page(mapping, index, filler, sb);
 	else {
 		page = find_or_create_page(mapping, index, GFP_NOFS);
-		unlock_page(page);
+		if (page)
+			unlock_page(page);
 	}
 	return page;
 }
-- 
1.7.9.5

