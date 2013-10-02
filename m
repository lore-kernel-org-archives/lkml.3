Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab3JBOcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:32:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49020 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab3JBO27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:28:59 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Jan Kara <jack@suse.cz>,
        Naren Sankar <nsankar@broadcom.com>, Jarod Wilson <jarod@wilsonet.com>,
        Scott Davilla <davilla@4pi.com>, Manu Abraham <abraham.manu@gmail.com>
Subject: [PATCH 09/26] crystalhd: Convert crystalhd_map_dio() to use get_user_pages_fast()
Date: Wed,  2 Oct 2013 16:27:50 +0200
Message-Id: <1380724087-13927-10-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380724087-13927-1-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Naren Sankar <nsankar@broadcom.com>
CC: Jarod Wilson <jarod@wilsonet.com>
CC: Scott Davilla <davilla@4pi.com>
CC: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/staging/crystalhd/crystalhd_misc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_misc.c b/drivers/staging/crystalhd/crystalhd_misc.c
index 51f698052aff..f2d350985e46 100644
--- a/drivers/staging/crystalhd/crystalhd_misc.c
+++ b/drivers/staging/crystalhd/crystalhd_misc.c
@@ -751,10 +751,7 @@ enum BC_STATUS crystalhd_map_dio(struct crystalhd_adp *adp, void *ubuff,
 		}
 	}
 
-	down_read(&current->mm->mmap_sem);
-	res = get_user_pages(current, current->mm, uaddr, nr_pages, rw == READ,
-			     0, dio->pages, NULL);
-	up_read(&current->mm->mmap_sem);
+	res = get_user_pages_fast(uaddr, nr_pages, rw == READ, dio->pages);
 
 	/* Save for release..*/
 	dio->sig = crystalhd_dio_locked;
-- 
1.8.1.4

