Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965285Ab3FTKH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:07:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43495 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965173Ab3FTKHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:07:25 -0400
X-IronPort-AV: E=Sophos;i="4.87,903,1363104000"; 
   d="scan'208";a="7614620"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: bcrl@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
        trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] aio: Fix wrong comment in aio_complete()
Date: Thu, 20 Jun 2013 18:10:21 +0800
Message-Id: <1371723023-4060-4-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1371723023-4060-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1371723023-4060-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/20 18:06:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/20 18:06:16,
	Serialize complete at 2013/06/20 18:06:16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ctx->ctx_lock should be ctx->completion_lock.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 fs/aio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 2bbcacf..e4a01fa 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -623,7 +623,7 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 
 	/*
 	 * Add a completion event to the ring buffer. Must be done holding
-	 * ctx->ctx_lock to prevent other code from messing with the tail
+	 * ctx->completion_lock to prevent other code from messing with the tail
 	 * pointer since we might be called from irq context.
 	 */
 	spin_lock_irqsave(&ctx->completion_lock, flags);
-- 
1.7.1

