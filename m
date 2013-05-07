Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843Ab3EGE0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:26:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448Ab3EGEZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:49 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Ilgvk6Jt14sA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=NSO84VvHef4A:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=lyTQiZhTPTvVCN06mPwA:9 a=hPjdaMEvmhQA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035856.347201060@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: [092/126] aio: fix possible invalid memory access when DEBUG is enabled
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0092-aio-fix-possible-invalid-memory-access-when-DEBUG-is.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Zhao Hongjiang <zhaohongjiang@huawei.com>

[ Upstream commit 91d80a84bbc8f28375cca7e65ec666577b4209ad ]

dprintk() shouldn't access @ring after it's unmapped.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/aio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 71f613c..ed762ae 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1027,9 +1027,9 @@ static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
 	spin_unlock(&info->ring_lock);
 
 out:
-	kunmap_atomic(ring);
 	dprintk("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
 		 (unsigned long)ring->head, (unsigned long)ring->tail);
+	kunmap_atomic(ring);
 	return ret;
 }
 
-- 
1.7.10.4


