Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbaDSToD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 15:44:03 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:38975 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751095AbaDSTnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 15:43:55 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuQJAF/RUlNXQ7Be/2dsb2JhbABYgwarSZligRsXdIJTExwjGIECJBOIRQHNR45ihD8BA45pigQBimqHZYMzOw
Date: Sat, 19 Apr 2014 21:43:52 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: viro <viro@zeniv.linux.org.uk>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/aio.c: Remove ctx parameter in kiocb_cancel
Message-Id: <20140419214352.c707e7e7cf9b977986c76320@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ctx is no longer used in kiocb_cancel since

57282d8fd74407 ("aio: Kill ki_users")

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/aio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 12a3de0e..b92fdee 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -472,7 +472,7 @@ void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel)
 }
 EXPORT_SYMBOL(kiocb_set_cancel_fn);
 
-static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb)
+static int kiocb_cancel(struct kiocb *kiocb)
 {
 	kiocb_cancel_fn *old, *cancel;
 
@@ -529,7 +529,7 @@ static void free_ioctx_users(struct percpu_ref *ref)
 				       struct kiocb, ki_list);
 
 		list_del_init(&req->ki_list);
-		kiocb_cancel(ctx, req);
+		kiocb_cancel(req);
 	}
 
 	spin_unlock_irq(&ctx->ctx_lock);
@@ -1559,7 +1559,7 @@ SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
 
 	kiocb = lookup_kiocb(ctx, iocb, key);
 	if (kiocb)
-		ret = kiocb_cancel(ctx, kiocb);
+		ret = kiocb_cancel(kiocb);
 	else
 		ret = -EINVAL;
 
-- 

