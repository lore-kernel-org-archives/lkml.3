Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab3JBOfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:35:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48992 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab3JBO26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:28:58 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Jan Kara <jack@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 08/26] ced1401: Convert driver to use get_user_pages_fast()
Date: Wed,  2 Oct 2013 16:27:49 +0200
Message-Id: <1380724087-13927-9-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380724087-13927-1-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/staging/ced1401/ced_ioc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/ced1401/ced_ioc.c b/drivers/staging/ced1401/ced_ioc.c
index 2dbaf39e2fc2..62efd74b8c04 100644
--- a/drivers/staging/ced1401/ced_ioc.c
+++ b/drivers/staging/ced1401/ced_ioc.c
@@ -692,10 +692,7 @@ static int SetArea(DEVICE_EXTENSION *pdx, int nArea, char __user *puBuf,
 		__func__, puBuf, dwLength, bCircular);
 
 	/*  To pin down user pages we must first acquire the mapping semaphore. */
-	down_read(&current->mm->mmap_sem);	/*  get memory map semaphore */
-	nPages = get_user_pages(current, current->mm, ulStart, len, 1, 0,
-				pPages, NULL);
-	up_read(&current->mm->mmap_sem);	/*  release the semaphore */
+	nPages = get_user_pages_fast(ulStart, len, 1, pPages);
 	dev_dbg(&pdx->interface->dev, "%s nPages = %d", __func__, nPages);
 
 	if (nPages > 0) {		/*  if we succeeded */
-- 
1.8.1.4

