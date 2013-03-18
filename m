Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148Ab3CRCwH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 22:52:07 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:1055 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab3CRCwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 22:52:02 -0400
Message-ID: <51468146.30204@huawei.com>
Date: Mon, 18 Mar 2013 10:51:50 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH 1/2] relay: remove unused function argument actor
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently argument actor is never used in relay reading path,
so remote it.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/relay.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index 01ab081..d21006c 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1099,8 +1099,7 @@ static size_t relay_file_read_end_pos(struct rchan_buf *buf,
 static int subbuf_read_actor(size_t read_start,
 			     struct rchan_buf *buf,
 			     size_t avail,
-			     read_descriptor_t *desc,
-			     read_actor_t actor)
+			     read_descriptor_t *desc)
 {
 	void *from;
 	int ret = 0;
@@ -1121,15 +1120,13 @@ static int subbuf_read_actor(size_t read_start,
 typedef int (*subbuf_actor_t) (size_t read_start,
 			       struct rchan_buf *buf,
 			       size_t avail,
-			       read_descriptor_t *desc,
-			       read_actor_t actor);
+			       read_descriptor_t *desc);

 /*
  *	relay_file_read_subbufs - read count bytes, bridging subbuf boundaries
  */
 static ssize_t relay_file_read_subbufs(struct file *filp, loff_t *ppos,
 					subbuf_actor_t subbuf_actor,
-					read_actor_t actor,
 					read_descriptor_t *desc)
 {
 	struct rchan_buf *buf = filp->private_data;
@@ -1150,7 +1147,7 @@ static ssize_t relay_file_read_subbufs(struct file *filp, loff_t *ppos,
 			break;

 		avail = min(desc->count, avail);
-		ret = subbuf_actor(read_start, buf, avail, desc, actor);
+		ret = subbuf_actor(read_start, buf, avail, desc);
 		if (desc->error < 0)
 			break;

@@ -1174,8 +1171,7 @@ static ssize_t relay_file_read(struct file *filp,
 	desc.count = count;
 	desc.arg.buf = buffer;
 	desc.error = 0;
-	return relay_file_read_subbufs(filp, ppos, subbuf_read_actor,
-				       NULL, &desc);
+	return relay_file_read_subbufs(filp, ppos, subbuf_read_actor, &desc);
 }

 static void relay_consume_bytes(struct rchan_buf *rbuf, int bytes_consumed)
-- 
1.7.9.7


