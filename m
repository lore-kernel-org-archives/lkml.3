Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857Ab3CTJYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:24:21 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:47624 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758046Ab3CTJYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:24:05 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 15/30] compat: embrace LINUX_BACKPORT() for v2.6.37
Date: Wed, 20 Mar 2013 02:22:40 -0700
Message-Id: <1363771375-31715-16-git-send-email-mcgrof@do-not-panic.com>
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
 compat/compat-2.6.37.c        |    4 ++--
 include/linux/compat-2.6.37.h |    5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/compat/compat-2.6.37.c b/compat/compat-2.6.37.c
index 24b267a..9f722a6 100644
--- a/compat/compat-2.6.37.c
+++ b/compat/compat-2.6.37.c
@@ -345,7 +345,7 @@ EXPORT_SYMBOL_GPL(compat_led_classdev_unregister);
  *	For tight control over page level allocator and protection flags
  *	use __vmalloc() instead.
  */
-void *compat_vzalloc(unsigned long size)
+void *vzalloc(unsigned long size)
 {
 	void *buf;
 	buf = vmalloc(size);
@@ -353,6 +353,6 @@ void *compat_vzalloc(unsigned long size)
 		memset(buf, 0, size);
 	return buf;
 }
-EXPORT_SYMBOL_GPL(compat_vzalloc);
+EXPORT_SYMBOL_GPL(vzalloc);
 
 #endif
diff --git a/include/linux/compat-2.6.37.h b/include/linux/compat-2.6.37.h
index c1d45af..317ae6f 100644
--- a/include/linux/compat-2.6.37.h
+++ b/include/linux/compat-2.6.37.h
@@ -41,6 +41,7 @@ static inline int proto_ports_offset(int proto)
 
 #define SDIO_CLASS_BT_AMP	0x09	/* Type-A Bluetooth AMP interface */
 
+#define net_ns_type_operations LINUX_BACKPORT(net_ns_type_operations)
 extern struct kobj_ns_type_operations net_ns_type_operations;
 
 /* mask skb_checksum_none_assert as RHEL6 backports this */
@@ -144,9 +145,7 @@ extern void compat_led_brightness_set(struct led_classdev *led_cdev,
 
 #define netdev_refcnt_read(a) atomic_read(&a->refcnt)
 
-/* mask vzalloc as RHEL6 backports this */
-#define vzalloc(a) compat_vzalloc(a)
-
+#define vzalloc LINUX_BACKPORT(vzalloc)
 extern void *vzalloc(unsigned long size);
 
 #define rtnl_dereference(p)                                     \
-- 
1.7.10.4

