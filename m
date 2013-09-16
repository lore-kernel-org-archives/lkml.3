Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab3IPIwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:52:30 -0400
Received: from smtp-out-159.synserver.de ([212.40.185.159]:1061 "EHLO
	smtp-out-156.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756213Ab3IPIw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:52:29 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1519
From: Lars-Peter Clausen <lars@metafoo.de>
To: Andrew Morton <akpm@linux-foundation.org>,
        Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] kfifo: kfifo_copy_{to,from}_user: Fix copied bytes calculation
Date: Mon, 16 Sep 2013 10:53:51 +0200
Message-Id: <1379321631-3197-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'copied' and 'len' are in bytes, while 'ret' is in elements, so we need to
multiply 'ret' with the size of one element to get the correct result.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 lib/kfifo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/kfifo.c b/lib/kfifo.c
index 7b7f830..d79b9d2 100644
--- a/lib/kfifo.c
+++ b/lib/kfifo.c
@@ -215,7 +215,7 @@ static unsigned long kfifo_copy_from_user(struct __kfifo *fifo,
 	 * incrementing the fifo->in index counter
 	 */
 	smp_wmb();
-	*copied = len - ret;
+	*copied = len - ret * esize;
 	/* return the number of elements which are not copied */
 	return ret;
 }
@@ -275,7 +275,7 @@ static unsigned long kfifo_copy_to_user(struct __kfifo *fifo, void __user *to,
 	 * incrementing the fifo->out index counter
 	 */
 	smp_wmb();
-	*copied = len - ret;
+	*copied = len - ret * esize;
 	/* return the number of elements which are not copied */
 	return ret;
 }
-- 
1.8.0

