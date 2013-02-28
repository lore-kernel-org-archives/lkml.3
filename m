Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab3B1Orl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:47:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42074 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076Ab3B1Org (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:47:36 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 045/139] idr: idr_for_each_entry() macro
Date: Thu, 28 Feb 2013 14:43:15 +0000
Message-Id: <1362062689-2567-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Reisner <philipp.reisner@linbit.com>

commit 9749f30f1a387070e6e8351f35aeb829eacc3ab6 upstream.

Inspired by the list_for_each_entry() macro

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/idr.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 255491c..52a9da2 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -152,4 +152,15 @@ void ida_simple_remove(struct ida *ida, unsigned int id);
 
 void __init idr_init_cache(void);
 
+/**
+ * idr_for_each_entry - iterate over an idr's elements of a given type
+ * @idp:     idr handle
+ * @entry:   the type * to use as cursor
+ * @id:      id entry's key
+ */
+#define idr_for_each_entry(idp, entry, id)				\
+	for (id = 0, entry = (typeof(entry))idr_get_next((idp), &(id)); \
+	     entry != NULL;                                             \
+	     ++id, entry = (typeof(entry))idr_get_next((idp), &(id)))
+
 #endif /* __IDR_H__ */
-- 
1.8.1.2

