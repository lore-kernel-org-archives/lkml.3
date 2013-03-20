Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934546Ab3CTJbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:31:21 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:40980 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933981Ab3CTJbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:31:17 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 08/30] compat: embrace LINUX_BACKPORT() for v2.6.29
Date: Wed, 20 Mar 2013 02:22:33 -0700
Message-Id: <1363771375-31715-9-git-send-email-mcgrof@do-not-panic.com>
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
 include/linux/compat-2.6.29.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/compat-2.6.29.h b/include/linux/compat-2.6.29.h
index 9ebc5d5..c8cf898 100644
--- a/include/linux/compat-2.6.29.h
+++ b/include/linux/compat-2.6.29.h
@@ -245,6 +245,7 @@ static inline int ndo_do_ioctl(struct net_device *dev,
 }
 
 
+#define netdev_attach_ops LINUX_BACKPORT(netdev_attach_ops)
 void netdev_attach_ops(struct net_device *dev,
 		       const struct net_device_ops *ops);
 
@@ -287,6 +288,7 @@ static inline struct net_device_stats *dev_get_stats(struct net_device *dev)
 
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23))
 #if defined(CONFIG_USB) || defined(CONFIG_USB_MODULE)
+#define usb_unpoison_anchored_urbs LINUX_BACKPORT(usb_unpoison_anchored_urbs)
 extern void usb_unpoison_anchored_urbs(struct usb_anchor *anchor);
 #endif /* CONFIG_USB */
 #endif
@@ -298,8 +300,11 @@ extern void usb_unpoison_anchored_urbs(struct usb_anchor *anchor);
 }							\
 )
 
+#define eth_mac_addr LINUX_BACKPORT(eth_mac_addr)
 extern int eth_mac_addr(struct net_device *dev, void *p);
+#define eth_change_mtu LINUX_BACKPORT(eth_change_mtu)
 extern int eth_change_mtu(struct net_device *dev, int new_mtu);
+#define eth_validate_addr LINUX_BACKPORT(eth_validate_addr)
 extern int eth_validate_addr(struct net_device *dev);
 
 #ifdef CONFIG_NET_NS
@@ -327,6 +332,7 @@ static inline struct net *read_pnet(struct net * const *pnet)
 
 #endif
 
+#define init_dummy_netdev LINUX_BACKPORT(init_dummy_netdev)
 extern int		init_dummy_netdev(struct net_device *dev);
 
 #else /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)) */
-- 
1.7.10.4

