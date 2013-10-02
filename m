Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3JBObd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:31:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab3JBO3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:29:00 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Jan Kara <jack@suse.cz>, linux-fbdev@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: [PATCH 12/26] pvr2fb: Convert pvr2fb_write() to use get_user_pages_fast()
Date: Wed,  2 Oct 2013 16:27:53 +0200
Message-Id: <1380724087-13927-13-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380724087-13927-1-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: linux-fbdev@vger.kernel.org
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/video/pvr2fb.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/video/pvr2fb.c b/drivers/video/pvr2fb.c
index df07860563e6..31e1345a88a8 100644
--- a/drivers/video/pvr2fb.c
+++ b/drivers/video/pvr2fb.c
@@ -686,11 +686,7 @@ static ssize_t pvr2fb_write(struct fb_info *info, const char *buf,
 	if (!pages)
 		return -ENOMEM;
 
-	down_read(&current->mm->mmap_sem);
-	ret = get_user_pages(current, current->mm, (unsigned long)buf,
-			     nr_pages, WRITE, 0, pages, NULL);
-	up_read(&current->mm->mmap_sem);
-
+	ret = get_user_pages_fast((unsigned long)buf, nr_pages, WRITE, pages);
 	if (ret < nr_pages) {
 		nr_pages = ret;
 		ret = -EINVAL;
-- 
1.8.1.4

