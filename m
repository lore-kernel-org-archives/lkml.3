Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab3BALFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 06:05:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044Ab3BAKoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:44:05 -0500
From: Lukas Czerner <lczerner@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
        Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 06/18] ocfs2: use ->invalidatepage() length argument
Date: Fri,  1 Feb 2013 11:43:32 +0100
Message-Id: <1359715424-32318-7-git-send-email-lczerner@redhat.com>
In-Reply-To: <1359715424-32318-1-git-send-email-lczerner@redhat.com>
References: <1359715424-32318-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->invalidatepage() aop now accepts range to invalidate so we can make
use of it in ocfs2_invalidatepage().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ocfs2/aops.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 1393114..d8c0076 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -608,8 +608,7 @@ static void ocfs2_invalidatepage(struct page *page, unsigned int offset,
 {
 	journal_t *journal = OCFS2_SB(page->mapping->host->i_sb)->journal->j_journal;
 
-	jbd2_journal_invalidatepage(journal, page, offset,
-				    PAGE_CACHE_SIZE - offset);
+	jbd2_journal_invalidatepage(journal, page, offset, length);
 }
 
 static int ocfs2_releasepage(struct page *page, gfp_t wait)
-- 
1.7.7.6

