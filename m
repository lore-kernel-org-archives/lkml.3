Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab3EGOQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:16:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42147 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932573Ab3EGNkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:49 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Zhao Hongjiang <zhaohongjiang@huawei.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 026/118] aio: fix possible invalid memory access when DEBUG is enabled
Date: Tue,  7 May 2013 14:37:52 +0100
Message-Id: <1367933964-1564-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Hongjiang <zhaohongjiang@huawei.com>

commit 91d80a84bbc8f28375cca7e65ec666577b4209ad upstream.

dprintk() shouldn't access @ring after it's unmapped.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/aio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 55c4c76..cf8e5a7 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1094,9 +1094,9 @@ static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
 	spin_unlock(&info->ring_lock);
 
 out:
-	kunmap_atomic(ring);
 	dprintk("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
 		 (unsigned long)ring->head, (unsigned long)ring->tail);
+	kunmap_atomic(ring);
 	return ret;
 }
 
-- 
1.8.1.2

