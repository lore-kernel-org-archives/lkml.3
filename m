Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab3DYKCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 06:02:42 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:42212 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab3DYKCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 06:02:40 -0400
Message-ID: <5178FF2D.2000203@huawei.com>
Date: Thu, 25 Apr 2013 18:02:21 +0800
From: Zhao Hongjiang <zhaohongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: <viro@zeniv.linux.org.uk>
CC: <bcrl@kvack.org>, <linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] aio: dprintks in aio_read_evt were referencing aio_ring after
 kunmap_atomic
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.200]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
Cc: stable@vger.kernel.org
---

linux-next use pr_debug instead of dprintk, and fix the issue.

---
 fs/aio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 3f941f2..1dc8786 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1029,9 +1029,9 @@ static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
 	spin_unlock(&info->ring_lock);
 
 out:
-	kunmap_atomic(ring);
 	dprintk("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
 		 (unsigned long)ring->head, (unsigned long)ring->tail);
+	kunmap_atomic(ring);
 	return ret;
 }
 
-- 
1.7.1

