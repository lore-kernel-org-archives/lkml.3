Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934520Ab3CTJ3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:29:08 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:39013 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3CTJ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:29:04 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 02/30] compat: embrace LINUX_BACKPORT() for v2.6.23
Date: Wed, 20 Mar 2013 02:22:27 -0700
Message-Id: <1363771375-31715-3-git-send-email-mcgrof@do-not-panic.com>
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
 compat/compat-2.6.23.c        |    2 ++
 include/linux/compat-2.6.23.h |    3 +++
 2 files changed, 5 insertions(+)

diff --git a/compat/compat-2.6.23.c b/compat/compat-2.6.23.c
index bc49e98..1a76957 100644
--- a/compat/compat-2.6.23.c
+++ b/compat/compat-2.6.23.c
@@ -11,6 +11,7 @@
 #include <net/compat.h>
 
 /* On net/core/dev.c as of 2.6.24 */
+#define __dev_addr_delete LINUX_BACKPORT(__dev_addr_delete)
 int __dev_addr_delete(struct dev_addr_list **list, int *count,
                       void *addr, int alen, int glbl)
 {
@@ -40,6 +41,7 @@ EXPORT_SYMBOL_GPL(__dev_addr_delete);
 
 /* On net/core/dev.c as of 2.6.24. This is not yet used by mac80211 but
  * might as well add it */
+#define __dev_addr_add LINUX_BACKPORT(__dev_addr_add)
 int __dev_addr_add(struct dev_addr_list **list, int *count,
                    void *addr, int alen, int glbl)
 {
diff --git a/include/linux/compat-2.6.23.h b/include/linux/compat-2.6.23.h
index fbfb470..37cbc22 100644
--- a/include/linux/compat-2.6.23.h
+++ b/include/linux/compat-2.6.23.h
@@ -75,6 +75,8 @@ static inline void tcf_destroy_chain_compat(struct tcf_proto **fl)
 #define __dev_set_promiscuity dev_set_promiscuity
 
 /* Our own 2.6.22 port on compat.c */
+#define dev_mc_unsync LINUX_BACKPORT(dev_mc_unsync)
+#define dev_mc_sync LINUX_BACKPORT(dev_mc_sync)
 extern void	dev_mc_unsync(struct net_device *to, struct net_device *from);
 extern int	dev_mc_sync(struct net_device *to, struct net_device *from);
 
@@ -113,6 +115,7 @@ struct genl_multicast_group
 
 
 /* Added as of 2.6.23 */
+#define pci_try_set_mwi LINUX_BACKPORT(pci_try_set_mwi)
 int pci_try_set_mwi(struct pci_dev *dev);
 
 /* Added as of 2.6.23 */
-- 
1.7.10.4

