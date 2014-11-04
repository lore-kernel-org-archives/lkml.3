Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaKDL7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:59:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44340 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbaKDL60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:58:26 -0500
From: Jan Kara <jack@suse.cz>
To: axboe@kernel.dk
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] block: Expand a bit documentation about elevator_allow_merge_fn
Date: Tue,  4 Nov 2014 12:52:41 +0100
Message-Id: <1415101961-18443-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Explain that two requests can be merged without
elevator_allow_merge_fn() being called.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 Documentation/block/biodoc.txt | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

So in the end my discussion about request merging with the customer concluded
similarly as ours wrt CFQ. It may be an issue but it happens rarely enough
that it probably isn't worth an extra hook. I'm just sending a doc update
because the fact that elevator_allow_merge_fn isn't called for all merges
is somewhat surprising.

diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index 2101e718670d..82a0b0d8f4f3 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -946,7 +946,11 @@ elevator_allow_merge_fn		called whenever the block layer determines
 				request safely. The io scheduler may still
 				want to stop a merge at this point if it
 				results in some sort of conflict internally,
-				this hook allows it to do that.
+				this hook allows it to do that. Note however
+				that two *requests* can still be merged at later
+				time. Currently io scheduler has no way to
+				prevent that. It can only learn about the fact
+				from elevator_merge_req_fn callback.
 
 elevator_dispatch_fn*		fills the dispatch queue with ready requests.
 				I/O schedulers are free to postpone requests by
-- 
1.8.1.4

