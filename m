Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738Ab3BZP5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 10:57:08 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:58595 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759688Ab3BZP5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 10:57:06 -0500
Message-ID: <512CDB4F.9050902@inktank.com>
Date: Tue, 26 Feb 2013 09:57:03 -0600
From: Alex Elder <elder@inktank.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: akpm@linux-foundation.org, paul.clements@us.sios.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] nbd: fix sparse warning
References: <512C335B.7010609@inktank.com>
In-Reply-To: <512C335B.7010609@inktank.com>
X-Forwarded-Message-Id: <512C335B.7010609@inktank.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just fixed this in "drivers/block/rbd.c" and I noticed that
"drivers/block/nbd.c" has the same problem.  Fix a warning
issued by sparse by adding some lockdep annotations
to indicate the queue lock gets dropped (because it's
held when do_nbd_request() is called) and re-acquired
within the function.

Signed-off-by: Alex Elder <elder@inktank.com>
---
 drivers/block/nbd.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/block/nbd.c
===================================================================
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -551,6 +551,7 @@ static int nbd_thread(void *data)
  */

 static void do_nbd_request(struct request_queue *q)
+		__releases(q->queue_lock) __acquires(q->queue_lock)
 {
 	struct request *req;
 	


