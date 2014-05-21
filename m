Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaEUJs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:48:27 -0400
Received: from mail.aswsp.com ([193.34.35.150]:27996 "EHLO mail.aswsp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbaEUJsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:48:25 -0400
From: Victor Lambret <victor.lambret.ext@parrot.com>
To: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Victor Lambret <victor.lambret.ext@parrot.com>
Subject: [PATCH] videobuf2-core: remove duplicated code
Date: Wed, 21 May 2014 11:48:43 +0200
Message-ID: <1400665723-21695-1-git-send-email-victor.lambret.ext@parrot.com>
X-Mailer: git-send-email 2.0.0.rc2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [46.218.109.88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated test of buffer presence at streamon

Signed-off-by: Victor Lambret <victor.lambret.ext@parrot.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index f9059bb..b731b66 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2067,10 +2067,6 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 		return -EINVAL;
 	}
 
-	if (!q->num_buffers) {
-		dprintk(1, "streamon: no buffers have been allocated\n");
-		return -EINVAL;
-	}
 	if (q->num_buffers < q->min_buffers_needed) {
 		dprintk(1, "streamon: need at least %u allocated buffers\n",
 				q->min_buffers_needed);
-- 
2.0.0.rc2

