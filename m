Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964892Ab3CTJYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:24:41 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:56489 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758046Ab3CTJYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:24:37 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 23/30] compat: embrace LINUX_BACKPORT() for v3.7
Date: Wed, 20 Mar 2013 02:22:48 -0700
Message-Id: <1363771375-31715-24-git-send-email-mcgrof@do-not-panic.com>
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
 include/linux/compat-3.7.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/compat-3.7.h b/include/linux/compat-3.7.h
index dd05e00..96662e3 100644
--- a/include/linux/compat-3.7.h
+++ b/include/linux/compat-3.7.h
@@ -45,6 +45,7 @@ static inline struct user_namespace *seq_user_ns(struct seq_file *seq)
 #define genl_info_snd_portid(__genl_info) (__genl_info->snd_pid)
 #define NETLINK_CB_PORTID(__skb) NETLINK_CB(cb->skb).pid
 
+#define mod_delayed_work LINUX_BACKPORT(mod_delayed_work)
 bool mod_delayed_work(struct workqueue_struct *wq, struct delayed_work *dwork,
 		      unsigned long delay);
 
@@ -55,12 +56,18 @@ bool mod_delayed_work(struct workqueue_struct *wq, struct delayed_work *dwork,
 #define tty_port_register_device(port, driver, index, device) \
 	tty_register_device(driver, index, device)
 
+#define pcie_capability_read_word LINUX_BACKPORT(pcie_capability_read_word)
 int pcie_capability_read_word(struct pci_dev *dev, int pos, u16 *val);
+#define pcie_capability_read_dword LINUX_BACKPORT(pcie_capability_read_dword)
 int pcie_capability_read_dword(struct pci_dev *dev, int pos, u32 *val);
+#define pcie_capability_write_word LINUX_BACKPORT(pcie_capability_write_word)
 int pcie_capability_write_word(struct pci_dev *dev, int pos, u16 val);
+#define pcie_capability_write_dword LINUX_BACKPORT(pcie_capability_write_dword)
 int pcie_capability_write_dword(struct pci_dev *dev, int pos, u32 val);
+#define pcie_capability_clear_and_set_word LINUX_BACKPORT(pcie_capability_clear_and_set_word)
 int pcie_capability_clear_and_set_word(struct pci_dev *dev, int pos,
 				       u16 clear, u16 set);
+#define pcie_capability_clear_and_set_dword LINUX_BACKPORT(pcie_capability_clear_and_set_dword)
 int pcie_capability_clear_and_set_dword(struct pci_dev *dev, int pos,
 					u32 clear, u32 set);
 
-- 
1.7.10.4

