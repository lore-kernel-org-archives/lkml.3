Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab3LTMnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:43:23 -0500
Received: from mail09.linbit.com ([212.69.161.110]:38621 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab3LTMj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:39:28 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 02/26] idr: Add new function idr_is_empty()
Date: Fri, 20 Dec 2013 13:28:59 +0100
Message-Id: <1387542563-6833-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
References: <1387542563-6833-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 include/linux/idr.h |    1 +
 lib/idr.c           |   10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 871a213..9c95d21 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -85,6 +85,7 @@ void idr_remove(struct idr *idp, int id);
 void idr_free(struct idr *idp, int id);
 void idr_destroy(struct idr *idp);
 void idr_init(struct idr *idp);
+bool idr_is_empty(struct idr *idp);
 
 /**
  * idr_preload_end - end preload section started with idr_preload()
diff --git a/lib/idr.c b/lib/idr.c
index bfe4db4..1ba4956 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -869,6 +869,16 @@ void idr_init(struct idr *idp)
 }
 EXPORT_SYMBOL(idr_init);
 
+static int idr_has_entry(int id, void *p, void *data)
+{
+	return 1;
+}
+
+bool idr_is_empty(struct idr *idp)
+{
+	return !idr_for_each(idp, idr_has_entry, NULL);
+}
+EXPORT_SYMBOL(idr_is_empty);
 
 /**
  * DOC: IDA description
-- 
1.7.9.5

