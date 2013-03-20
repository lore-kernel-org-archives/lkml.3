Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab3CTJ1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:27:22 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:38273 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab3CTJYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:24:17 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 18/30] compat: embrace LINUX_BACKPORT() for v3.0
Date: Wed, 20 Mar 2013 02:22:43 -0700
Message-Id: <1363771375-31715-19-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
References: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

1   2.6.24              [  OK  ]
2   2.6.25              [  OK  ]
3   2.6.26              [  OK  ]
4   2.6.27              [  OK  ]
5   2.6.28              [  OK  ]
6   2.6.29              [  OK  ]
7   2.6.30              [  OK  ]
8   2.6.31              [  OK  ]
9   2.6.32              [  OK  ]
10  2.6.33              [  OK  ]
11  2.6.34              [  OK  ]
12  2.6.35              [  OK  ]
13  2.6.36              [  OK  ]
14  2.6.37              [  OK  ]
15  2.6.38              [  OK  ]
16  2.6.39              [  OK  ]
17  3.0.65              [  OK  ]
18  3.1.10              [  OK  ]
19  3.2.38              [  OK  ]
20  3.3.8               [  OK  ]
21  3.4.32              [  OK  ]
22  3.5.7               [  OK  ]
23  3.6.11              [  OK  ]
24  3.7.9               [  OK  ]
25  3.8.0               [  OK  ]
26  3.9-rc1             [  OK  ]

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/linux/compat-3.0.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/compat-3.0.h b/include/linux/compat-3.0.h
index ba25846..7fcd763 100644
--- a/include/linux/compat-3.0.h
+++ b/include/linux/compat-3.0.h
@@ -23,10 +23,12 @@
  *
  * First part is in compat-3.0.c.
  */
+#define shmem_read_mapping_page_gfp LINUX_BACKPORT(shmem_read_mapping_page_gfp)
 extern struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
 						pgoff_t index, gfp_t gfp);
 
 
+#define shmem_read_mapping_page LINUX_BACKPORT(shmem_read_mapping_page)
 static inline struct page *shmem_read_mapping_page(
                                struct address_space *mapping, pgoff_t index)
 {
@@ -77,6 +79,7 @@ struct bcma_device_id {
 #define BCMA_ANY_CLASS		0xFF
 #endif /* BCMA_CORE */
 
+#define mac_pton LINUX_BACKPORT(mac_pton)
 int mac_pton(const char *s, u8 *mac);
 
 int __must_check kstrtoull_from_user(const char __user *s, size_t count, unsigned int base, unsigned long long *res);
-- 
1.7.10.4

