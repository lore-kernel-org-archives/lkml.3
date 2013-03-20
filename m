Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934446Ab3CTJXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:23:37 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:54041 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933907Ab3CTJXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:23:32 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 07/30] compat: embrace LINUX_BACKPORT() for v2.6.28
Date: Wed, 20 Mar 2013 02:22:32 -0700
Message-Id: <1363771375-31715-8-git-send-email-mcgrof@do-not-panic.com>
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
 include/linux/compat-2.6.28.h |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/compat-2.6.28.h b/include/linux/compat-2.6.28.h
index 97f2066..3b5f3ea 100644
--- a/include/linux/compat-2.6.28.h
+++ b/include/linux/compat-2.6.28.h
@@ -38,6 +38,7 @@ struct hid_device_id {
 #include <linux/pci_regs.h>
 #include <linux/platform_device.h>
 
+#define platform_device_register_data LINUX_BACKPORT(platform_device_register_data)
 extern struct platform_device *platform_device_register_data(struct device *,
 		const char *, int, const void *, size_t);
 
@@ -83,6 +84,7 @@ typedef u32 phys_addr_t;
 
 /* From : include/pcmcia/ds.h */
 /* loop CIS entries for valid configuration */
+#define pcmcia_loop_config LINUX_BACKPORT(pcmcia_loop_config)
 int pcmcia_loop_config(struct pcmcia_device *p_dev,
 		       int	(*conf_check)	(struct pcmcia_device *p_dev,
 						 cistpl_cftable_entry_t *cfg,
@@ -98,19 +100,24 @@ int pcmcia_loop_config(struct pcmcia_device *p_dev,
 
 #if defined(CONFIG_USB) || defined(CONFIG_USB_MODULE)
 #if 0
+#define usb_poison_urb LINUX_BACKPORT(usb_poison_urb)
 extern void usb_poison_urb(struct urb *urb);
 #endif
+#define usb_unpoison_urb LINUX_BACKPORT(usb_unpoison_urb)
 extern void usb_unpoison_urb(struct urb *urb);
 
 #if 0
+#define usb_poison_anchored_urbs LINUX_BACKPORT(usb_poison_anchored_urbs)
 extern void usb_poison_anchored_urbs(struct usb_anchor *anchor);
 #endif
 
+#define usb_anchor_empty LINUX_BACKPORT(usb_anchor_empty)
 extern int usb_anchor_empty(struct usb_anchor *anchor);
 #endif /* CONFIG_USB */
 #endif
 
 
+#define pci_ioremap_bar LINUX_BACKPORT(pci_ioremap_bar)
 void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar);
 
 /**
@@ -266,11 +273,7 @@ static inline void skb_queue_splice_tail(const struct sk_buff_head *list,
 
 #endif
 
-/* openSuse includes round_jiffies_up in it's kernel 2.6.27.
- * This is needed to prevent conflicts with the openSuse definition.
- */
-#define round_jiffies_up backport_round_jiffies_up
-
+#define round_jiffies_up LINUX_BACKPORT(round_jiffies_up)
 unsigned long round_jiffies_up(unsigned long j);
 
 extern void v2_6_28_skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page,
@@ -279,9 +282,11 @@ extern void v2_6_28_skb_add_rx_frag(struct sk_buff *skb, int i, struct page *pag
 #define wake_up_interruptible_poll(x, m)			\
 	__wake_up(x, TASK_INTERRUPTIBLE, 1, (void *) (m))
 
+#define n_tty_ioctl_helper LINUX_BACKPORT(n_tty_ioctl_helper)
 extern int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 		       unsigned int cmd, unsigned long arg);
 
+#define pci_wake_from_d3 LINUX_BACKPORT(pci_wake_from_d3)
 int pci_wake_from_d3(struct pci_dev *dev, bool enable);
 
 #define alloc_workqueue(name, flags, max_active) __create_workqueue(name, flags, max_active)
-- 
1.7.10.4

