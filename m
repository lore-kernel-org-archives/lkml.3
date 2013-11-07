Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab3KHADk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:03:40 -0500
Received: from dmz-mailsec-scanner-8.mit.edu ([18.7.68.37]:46257 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753584Ab3KHADb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:03:31 -0500
X-AuditID: 12074425-b7fc88e000004601-e6-527c2926d772
Date: Thu, 7 Nov 2013 18:58:28 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] random: fix comment on proc_do_uuid
Message-ID: <20131107235828.GE16018@ringworld.MIT.EDU>
References: <cover.1383868558.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1383868558.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsUixG6noqumWRNkcHG3jMXlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4Mo41nWMreAHV8XhjRtYGxjvcXQxcnJICJhI7Ji1hQXCFpO4cG89
	WxcjF4eQwGwmie2zZrGDJIQENjBKzO4PhUj8ZJSYfOUFI0iCRUBF4tuMuWwgNpuAgsSP+euY
	QWwRAWWJVTM3MYHYzEDxX/c2sYLYwgJWErOOvQIbyitgJrFrxT5miAUGEj+nv2WBiAtKnJz5
	hAWiV0vixr+XQHM4gGxpieX/wI7mFDCUaG++AjZSFOiEKSe3sU1gFJyFpHsWku5ZCN0LGJlX
	Mcqm5Fbp5iZm5hSnJusWJyfm5aUW6Vro5WaW6KWmlG5iBIepi+oOxgmHlA4xCnAwKvHwFlyo
	DhJiTSwrrsw9xCjJwaQkyjtRvSZIiC8pP6UyI7E4I76oNCe1+BCjBAezkgjvM0WgHG9KYmVV
	alE+TEqag0VJnPcWh32QkEB6YklqdmpqQWoRTFaGg0NJgvcDyFDBotT01Iq0zJwShDQTByfI
	cB6g4bIaIMOLCxJzizPTIfKnGBWlxHm/gzQLgCQySvPgemFp5BWjONArwrwqIO08wBQE1/0K
	aDAT0OCQX5Ugg0sSEVJSDYzieiLeK+OKn8zRXbJSd/dz1VPPwi8tM7m++O6cbY3qpWWSFU6T
	mk4+XZGkov6iTudHztJ1L7d23NBgcNISZN21e2lT+/Yj7ff7WadMzt0otyjjyoInHw8F1n9e
	mNvyYsKLfTeO7WWTPZ9ZU6R/QEzJpcbOp4njKc8Oy1mbKssyY16fPFD67egpJZbijERDLeai
	4kQA9jEgj/4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's only one function here now, as uuid_strategy is long gone.
Also make the bit about "If accesses via ..." clearer.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index ef3e15b..a89ba74 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1370,13 +1370,13 @@ static int max_write_thresh = INPUT_POOL_WORDS * 32;
 static char sysctl_bootid[16];
 
 /*
- * These functions is used to return both the bootid UUID, and random
+ * This function is used to return both the bootid UUID, and random
  * UUID.  The difference is in whether table->data is NULL; if it is,
  * then a new UUID is generated and returned to the user.
  *
- * If the user accesses this via the proc interface, it will be returned
- * as an ASCII string in the standard UUID format.  If accesses via the
- * sysctl system call, it is returned as 16 bytes of binary data.
+ * If the user accesses this via the proc interface, the UUID will be
+ * returned as an ASCII string in the standard UUID format; if via the
+ * sysctl system call, as 16 bytes of binary data.
  */
 static int proc_do_uuid(struct ctl_table *table, int write,
 			void __user *buffer, size_t *lenp, loff_t *ppos)
-- 
1.8.3.2

