Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934815AbaDJDWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:22:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934637AbaDJDVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:21:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>, Li Zefan <lizefan@huawei.com>,
        Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH 3.4 009/134] idr: idr_for_each_entry() macro
Date: Wed,  9 Apr 2014 20:22:05 -0700
Message-Id: <20140410032300.937951682@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Reisner <philipp.reisner@linbit.com>

commit 9749f30f1a387070e6e8351f35aeb829eacc3ab6 upstream.

Inspired by the list_for_each_entry() macro

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/idr.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -152,4 +152,15 @@ void ida_simple_remove(struct ida *ida,
 
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


