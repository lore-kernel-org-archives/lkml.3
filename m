Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbaFMVYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 17:24:23 -0400
Received: from kanga.kvack.org ([205.233.56.17]:36956 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbaFMVYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 17:24:20 -0400
Date: Fri, 13 Jun 2014 17:24:19 -0400
From: Fabian Frederick <fabf@skynet.be>
To: torvalds@linux-foundation.org
Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] fs/aio.c: Remove ctx parameter in kiocb_cancel
Message-ID: <d52a8f9ead60338306c4f03e9ce575c5f23a4b65.1402694489.git.bcrl@kvack.org>
References: <cover.1402694489.git.bcrl@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1402694489.git.bcrl@kvack.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ctx is no longer used in kiocb_cancel since

57282d8fd74407 ("aio: Kill ki_users")

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
---
 fs/aio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 2adbb03..908006e 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -477,7 +477,7 @@ void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel)
 }
 EXPORT_SYMBOL(kiocb_set_cancel_fn);
 
-static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb)
+static int kiocb_cancel(struct kiocb *kiocb)
 {
 	kiocb_cancel_fn *old, *cancel;
 
@@ -538,7 +538,7 @@ static void free_ioctx_users(struct percpu_ref *ref)
 				       struct kiocb, ki_list);
 
 		list_del_init(&req->ki_list);
-		kiocb_cancel(ctx, req);
+		kiocb_cancel(req);
 	}
 
 	spin_unlock_irq(&ctx->ctx_lock);
@@ -1587,7 +1587,7 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 
 	kiocb = lookup_kiocb(ctx, iocb, key);
 	if (kiocb)
-		ret = kiocb_cancel(ctx, kiocb);
+		ret = kiocb_cancel(kiocb);
 	else
 		ret = -EINVAL;
 
-- 
1.8.2.1


-- 
"Thought is the essence of where you are now."
