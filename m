Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab3CDDyP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:54:15 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33071 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756950Ab3CDDo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:28 -0500
Message-Id: <20130304033712.754098899@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:59 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Philipp Reisner <philipp.reisner@linbit.com>
Subject: [ 052/153] idr: idr_for_each_entry() macro
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Reisner <philipp.reisner@linbit.com>

commit 9749f30f1a387070e6e8351f35aeb829eacc3ab6 upstream.

Inspired by the list_for_each_entry() macro

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/idr.h |   11 +++++++++++
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


