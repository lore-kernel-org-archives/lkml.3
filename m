Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab3ENQh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:37:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab3ENQh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:37:56 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        hughd@google.com, lczerner@redhat.com
Subject: [PATCH v4 06/20] ocfs2: use ->invalidatepage() length argument
Date: Tue, 14 May 2013 18:37:20 +0200
Message-Id: <1368549454-8930-7-git-send-email-lczerner@redhat.com>
In-Reply-To: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->invalidatepage() aop now accepts range to invalidate so we can make
use of it in ocfs2_invalidatepage().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Joel Becker <jlbec@evilplan.org>
---
 fs/ocfs2/aops.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 7c47755..79736a2 100644
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

