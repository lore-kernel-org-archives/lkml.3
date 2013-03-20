Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965074Ab3CTJaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:30:14 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:44883 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab3CTJaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:30:11 -0400
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Mar 2013 05:30:10 EDT
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 22/30] compat: embrace LINUX_BACKPORT() for v3.4
Date: Wed, 20 Mar 2013 02:22:47 -0700
Message-Id: <1363771375-31715-23-git-send-email-mcgrof@do-not-panic.com>
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
 include/linux/compat-3.4.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/compat-3.4.h b/include/linux/compat-3.4.h
index fbd92a2..94d3bf7 100644
--- a/include/linux/compat-3.4.h
+++ b/include/linux/compat-3.4.h
@@ -51,9 +51,11 @@ static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
 #include <linux/skbuff.h>
 
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+#define i2c_bit_algo LINUX_BACKPORT(i2c_bit_algo)
 extern const struct i2c_algorithm i2c_bit_algo;
 #endif
 
+#define simple_open LINUX_BACKPORT(simple_open)
 extern int simple_open(struct inode *inode, struct file *file);
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28))
-- 
1.7.10.4

