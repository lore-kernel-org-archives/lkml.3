Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaBJKmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:42:01 -0500
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:62089 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752351AbaBJKl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:41:59 -0500
Date: Mon, 10 Feb 2014 12:41:55 +0200
From: Rakesh Pandit <rakesh@tuxera.com>
To: <viro@zeniv.linux.org.uk>
CC: <bcrl@kvack.org>, <hch@lst.de>, <linux-fsdevel@vger.kernel.org>,
        <linux-aio@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] aio: remove unused parameter 'ctx' from kiocb_cancel
Message-ID: <20140210104154.GA2270@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [194.100.106.164]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not used since commit 57282d8fd.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/aio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 062a5f6..d3d55dc 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -471,7 +471,7 @@ void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel)
 }
 EXPORT_SYMBOL(kiocb_set_cancel_fn);
 
-static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb)
+static int kiocb_cancel(struct kiocb *kiocb)
 {
 	kiocb_cancel_fn *old, *cancel;
 
@@ -528,7 +528,7 @@ static void free_ioctx_users(struct percpu_ref *ref)
 				       struct kiocb, ki_list);
 
 		list_del_init(&req->ki_list);
-		kiocb_cancel(ctx, req);
+		kiocb_cancel(req);
 	}
 
 	spin_unlock_irq(&ctx->ctx_lock);
@@ -1545,7 +1545,7 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 
 	kiocb = lookup_kiocb(ctx, iocb, key);
 	if (kiocb)
-		ret = kiocb_cancel(ctx, kiocb);
+		ret = kiocb_cancel(kiocb);
 	else
 		ret = -EINVAL;
 
-- 
1.8.3.1

