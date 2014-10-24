Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011AbaJXWiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:38:52 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62021 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbaJXWiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:38:50 -0400
Date: Fri, 24 Oct 2014 15:38:46 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Jan-Benedict Glaw <jbglaw@lug-owl.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: vsxxxaa - fix code dropping bytes from queue
Message-ID: <20141024223846.GA1914@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe the intent of the code was to drop oldest bytes from the queue,
not the latest if we drop one byte and both latest and some oldest of we
are dropping more than one.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/mouse/vsxxxaa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/mouse/vsxxxaa.c b/drivers/input/mouse/vsxxxaa.c
index 3829823..abd4944 100644
--- a/drivers/input/mouse/vsxxxaa.c
+++ b/drivers/input/mouse/vsxxxaa.c
@@ -128,7 +128,7 @@ static void vsxxxaa_drop_bytes(struct vsxxxaa *mouse, int num)
 	if (num >= mouse->count) {
 		mouse->count = 0;
 	} else {
-		memmove(mouse->buf, mouse->buf + num - 1, BUFLEN - num);
+		memmove(mouse->buf, mouse->buf + num, BUFLEN - num);
 		mouse->count -= num;
 	}
 }
-- 
2.1.0.rc2.206.gedb03e5


-- 
Dmitry
