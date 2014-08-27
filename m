Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935348AbaH0Pvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:51:32 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:21158 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935001AbaH0Pv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:51:29 -0400
Subject: [PATCH 2/2] block: include func name in __get_request prints
To: axboe@kernel.dk, webbnh@hp.com, linux-kernel@vger.kernel.org,
        relliott@beardog.cce.hp.com, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, elliott@hp.com, scameron@beardog.cce.hp.com
From: Robert Elliott <elliott@hp.com>
Date: Wed, 27 Aug 2014 10:50:36 -0500
Message-ID: <20140827155036.32075.20577.stgit@beardog.cce.hp.com>
In-Reply-To: <20140827154628.32075.3821.stgit@beardog.cce.hp.com>
References: <20140827154628.32075.3821.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In __get_request calls to printk_ratelimited, include the function name so
the callbacks suppressed message matches the messages that are printed,
and add "dev" before the device name so it matches other block layer
messages.

Signed-off-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Webb Scales <webbnh@hp.com>
---
 block/blk-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9c5a5b9..204cbd3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1065,8 +1065,8 @@ fail_elvpriv:
 	 * shouldn't stall IO.  Treat this request as !elvpriv.  This will
 	 * disturb iosched and blkcg but weird is bettern than dead.
 	 */
-	printk_ratelimited(KERN_WARNING "%s: request aux data allocation failed, iosched may be disturbed\n",
-			   dev_name(q->backing_dev_info.dev));
+	printk_ratelimited(KERN_WARNING "%s: dev %s: request aux data allocation failed, iosched may be disturbed\n",
+			   __func__, dev_name(q->backing_dev_info.dev));
 
 	rq->cmd_flags &= ~REQ_ELVPRIV;
 	rq->elv.icq = NULL;

