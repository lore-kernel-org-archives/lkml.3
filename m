Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965156Ab3CTJc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:32:26 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:34533 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab3CTJcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:32:22 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 16/30] compat: embrace LINUX_BACKPORT() for v2.6.38
Date: Wed, 20 Mar 2013 02:22:41 -0700
Message-Id: <1363771375-31715-17-git-send-email-mcgrof@do-not-panic.com>
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
 compat/compat-2.6.38.c        |    8 ++++----
 include/linux/compat-2.6.38.h |    9 +++------
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/compat/compat-2.6.38.c b/compat/compat-2.6.38.c
index b546194..0074ac6 100644
--- a/compat/compat-2.6.38.c
+++ b/compat/compat-2.6.38.c
@@ -22,14 +22,14 @@
  *
  * Initialize the EWMA parameters for a given struct ewma @avg.
  */
-void compat_ewma_init(struct ewma *avg, unsigned long factor, unsigned long weight)
+void ewma_init(struct ewma *avg, unsigned long factor, unsigned long weight)
 {
 	WARN_ON(weight <= 1 || factor == 0);
 	avg->internal = 0;
 	avg->weight = weight;
 	avg->factor = factor;
 }
-EXPORT_SYMBOL_GPL(compat_ewma_init);
+EXPORT_SYMBOL_GPL(ewma_init);
 
 /**
  * ewma_add() - Exponentially weighted moving average (EWMA)
@@ -38,7 +38,7 @@ EXPORT_SYMBOL_GPL(compat_ewma_init);
  *
  * Add a sample to the average.
  */
-struct ewma *compat_ewma_add(struct ewma *avg, unsigned long val)
+struct ewma *ewma_add(struct ewma *avg, unsigned long val)
 {
 	avg->internal = avg->internal  ?
 		(((avg->internal * (avg->weight - 1)) +
@@ -46,5 +46,5 @@ struct ewma *compat_ewma_add(struct ewma *avg, unsigned long val)
 		(val * avg->factor);
 	return avg;
 }
-EXPORT_SYMBOL_GPL(compat_ewma_add);
+EXPORT_SYMBOL_GPL(ewma_add);
 
diff --git a/include/linux/compat-2.6.38.h b/include/linux/compat-2.6.38.h
index e936c42..58ec64e 100644
--- a/include/linux/compat-2.6.38.h
+++ b/include/linux/compat-2.6.38.h
@@ -66,17 +66,14 @@ struct ewma {
 	unsigned long weight;
 };
 
-/* mask ewma_init as RHEL6 backports this */
-#define ewma_init(a,b,c) compat_ewma_init(a,b,c)
-
+#define ewma_init LINUX_BACKPORT(ewma_init)
 extern void ewma_init(struct ewma *avg, unsigned long factor,
 		      unsigned long weight);
 
-/* mask ewma_add as RHEL6 backports this */
-#define ewma_add(a,b) compat_ewma_add(a,b)
-
+#define ewma_add LINUX_BACKPORT(ewma_add)
 extern struct ewma *ewma_add(struct ewma *avg, unsigned long val);
 
+#define ewma_read LINUX_BACKPORT(ewma_read)
 /**
  * ewma_read() - Get average value
  * @avg: Average structure
-- 
1.7.10.4

