Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab3C0NOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:14:12 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44218 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3C0NJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:09:19 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, George Spelvin <linux@horizon.com>,
        Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 01/17] idr: document exit conditions on idr_for_each_entry better
Date: Wed, 27 Mar 2013 14:08:33 +0100
Message-Id: <1364389729-17559-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
References: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: George Spelvin <linux@horizon.com>

And some manual common subexpression elimination which may help the
compiler produce smaller code.

Signed-off-by: George Spelvin <linux@horizon.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 include/linux/idr.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 2640c7e..6ece058 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -122,11 +122,13 @@ static inline void *idr_find(struct idr *idr, int id)
  * @idp:     idr handle
  * @entry:   the type * to use as cursor
  * @id:      id entry's key
+ *
+ * @entry and @id do not need to be initialized before the loop, and
+ * after normal terminatinon @entry is left with the value NULL.  This
+ * is convenient for a "not found" value.
  */
-#define idr_for_each_entry(idp, entry, id)				\
-	for (id = 0, entry = (typeof(entry))idr_get_next((idp), &(id)); \
-	     entry != NULL;                                             \
-	     ++id, entry = (typeof(entry))idr_get_next((idp), &(id)))
+#define idr_for_each_entry(idp, entry, id)			\
+	for (id = 0; ((entry) = idr_get_next(idp, &(id))) != NULL; ++id)
 
 /*
  * Don't use the following functions.  These exist only to suppress
-- 
1.7.9.5

