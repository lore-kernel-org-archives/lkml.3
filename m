Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab3IXGSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 02:18:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57633 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3IXGS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 02:18:29 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Cc: axboe@kernel.dk, Kent Overstreet <kmo@daterainc.com>,
        stable@vger.kernel.org
Subject: [PATCH 02/11] bcache: Fix a dumb journal discard bug
Date: Mon, 23 Sep 2013 23:17:27 -0700
Message-Id: <1380003456-19938-3-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
References: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That switch statement was obviously wrong, leading to some sort of weird
spinning on rare occasion with discards enabled...

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v3.10
---
 drivers/md/bcache/journal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index ba95ab8..c0017ca 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -428,7 +428,7 @@ static void do_journal_discard(struct cache *ca)
 		return;
 	}
 
-	switch (atomic_read(&ja->discard_in_flight) == DISCARD_IN_FLIGHT) {
+	switch (atomic_read(&ja->discard_in_flight)) {
 	case DISCARD_IN_FLIGHT:
 		return;
 
-- 
1.8.4.rc3

