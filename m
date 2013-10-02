Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab3JBOe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:34:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab3JBO26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:28:58 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Jan Kara <jack@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Allyn <mark.a.allyn@intel.com>,
        Jayant Mangalampalli <jayant.mangalampalli@intel.com>
Subject: [PATCH 11/26] sep: Convert sep_lock_user_pages() to get_user_pages_fast()
Date: Wed,  2 Oct 2013 16:27:52 +0200
Message-Id: <1380724087-13927-12-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380724087-13927-1-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Mark Allyn <mark.a.allyn@intel.com>
CC: Jayant Mangalampalli <jayant.mangalampalli@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/staging/sep/sep_main.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index 6a98a208bbf2..11f5b2117457 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -1263,13 +1263,8 @@ static int sep_lock_user_pages(struct sep_device *sep,
 	}
 
 	/* Convert the application virtual address into a set of physical */
-	down_read(&current->mm->mmap_sem);
-	result = get_user_pages(current, current->mm, app_virt_addr,
-		num_pages,
-		((in_out_flag == SEP_DRIVER_IN_FLAG) ? 0 : 1),
-		0, page_array, NULL);
-
-	up_read(&current->mm->mmap_sem);
+	result = get_user_pages_fast(app_virt_addr, num_pages,
+		((in_out_flag == SEP_DRIVER_IN_FLAG) ? 0 : 1), page_array);
 
 	/* Check the number of pages locked - if not all then exit with error */
 	if (result != num_pages) {
-- 
1.8.1.4

