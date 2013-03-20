Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934342Ab3CTJXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:23:31 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:60077 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933907Ab3CTJX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:23:28 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 06/30] compat: embrace LINUX_BACKPORT() for v2.6.27
Date: Wed, 20 Mar 2013 02:22:31 -0700
Message-Id: <1363771375-31715-7-git-send-email-mcgrof@do-not-panic.com>
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
 include/linux/compat-2.6.27.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/compat-2.6.27.h b/include/linux/compat-2.6.27.h
index 2eae9f2..b71a3b5 100644
--- a/include/linux/compat-2.6.27.h
+++ b/include/linux/compat-2.6.27.h
@@ -87,6 +87,7 @@ static inline bool qdisc_all_tx_empty(const struct net_device *dev)
 	return skb_queue_empty(&dev->qdisc->q);
 }
 
+#define pci_pme_capable LINUX_BACKPORT(pci_pme_capable)
 bool pci_pme_capable(struct pci_dev *dev, pci_power_t state);
 
 /*
@@ -207,7 +208,9 @@ static inline void list_splice_tail_init(struct list_head *list,
 }
 
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24))
+#define mmc_align_data_size LINUX_BACKPORT(mmc_align_data_size)
 extern unsigned int mmc_align_data_size(struct mmc_card *, unsigned int);
+#define sdio_align_size LINUX_BACKPORT(sdio_align_size)
 extern unsigned int sdio_align_size(struct sdio_func *func, unsigned int sz);
 #endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24) */
 
@@ -251,6 +254,8 @@ static inline void dma_sync_single_range_for_device(struct device *dev,
 
 #endif /* arm */
 
+#define debugfs_remove_recursive LINUX_BACKPORT(debugfs_remove_recursive)
+
 #if defined(CONFIG_DEBUG_FS)
 void debugfs_remove_recursive(struct dentry *dentry);
 #else
-- 
1.7.10.4

