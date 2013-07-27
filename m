Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab3G0HGk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 03:06:40 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:16218 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab3G0HGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 03:06:38 -0400
Message-ID: <51F3710B.3040304@huawei.com>
Date: Sat, 27 Jul 2013 15:04:43 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Dumazet <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] relay: fix timer madness v3
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed from v2:
mod timer interval changed from HZ/10 to jiffies + HZ/10,
as Dan Carpenter suggested.

This patch is based on -mm tree.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Dumazet <edumazet@google.com>
---
 kernel/relay.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index 87af4ce..42d6de3 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -342,7 +342,7 @@ static void wakeup_readers(unsigned long data)
 	/*
 	 * Stupid polling for now:
 	 */
-	mod_timer(&buf->timer, HZ / 10);
+	mod_timer(&buf->timer, jiffies + HZ / 10);
 }

 /**
@@ -360,7 +360,7 @@ static void __relay_reset(struct rchan_buf *buf, unsigned int init)
 		init_waitqueue_head(&buf->read_wait);
 		kref_init(&buf->kref);
 		setup_timer(&buf->timer, wakeup_readers, (unsigned long)buf);
-		mod_timer(&buf->timer, HZ / 10);
+		mod_timer(&buf->timer, jiffies + HZ / 10);
 	} else
 		del_timer_sync(&buf->timer);

-- 
1.7.9.7


