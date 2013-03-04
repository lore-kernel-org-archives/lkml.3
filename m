Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898Ab3CDVGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:06:01 -0500
Received: from zimbra.linbit.com ([212.69.161.123]:50009 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758751Ab3CDVGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:06:00 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, akpm@linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ 052/153] idr: idr_for_each_entry() macro
Date: Mon, 04 Mar 2013 22:05:52 +0100
Message-ID: <1607973.Qpkavuy2AM@quad>
User-Agent: KMail/4.8.5 (Linux/3.2.0-35-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1362373013.3768.295.camel@deadeye.wl.decadent.org.uk>
References: <20130304033712.754098899@decadent.org.uk> <1362373013.3768.295.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure, here it is:
----------

From: Philipp Reisner <philipp.reisner@linbit.com>

commit 9749f30f1a387070e6e8351f35aeb829eacc3ab6 upstream.

Inspired by the list_for_each_entry() macro

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
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
+#define idr_for_each_entry(idp, entry, id)                             \
+       for (id = 0, entry = (typeof(entry))idr_get_next((idp), &(id)); \
+            entry != NULL;                                             \
+            ++id, entry = (typeof(entry))idr_get_next((idp), &(id)))
+
 #endif /* __IDR_H__ */

