Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaHORZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:25:13 -0400
Received: from kanga.kvack.org ([205.233.56.17]:34815 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbaHORZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:25:08 -0400
Date: Fri, 15 Aug 2014 13:25:07 -0400
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] aio: use the macro rather than the inline magic number
Message-ID: <8dc4379e17cddad7b2088a3f300ded50d2a6d493.1408122224.git.bcrl@kvack.org>
References: <cover.1408122224.git.bcrl@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1408122224.git.bcrl@kvack.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the inline magic number with the ready-made macro(AIO_RING_MAGIC),
just clean up.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
---
 fs/aio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 55e03a8..6fc6b98 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -201,7 +201,7 @@ static struct dentry *aio_mount(struct file_system_type *fs_type,
 	static const struct dentry_operations ops = {
 		.d_dname	= simple_dname,
 	};
-	return mount_pseudo(fs_type, "aio:", NULL, &ops, 0xa10a10a1);
+	return mount_pseudo(fs_type, "aio:", NULL, &ops, AIO_RING_MAGIC);
 }
 
 /* aio_setup
-- 
1.8.2.1


-- 
"Thought is the essence of where you are now."
