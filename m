Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab3CTJcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:32:05 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:55015 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab3CTJcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:32:02 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 13/30] compat: embrace LINUX_BACKPORT() for v2.6.35
Date: Wed, 20 Mar 2013 02:22:38 -0700
Message-Id: <1363771375-31715-14-git-send-email-mcgrof@do-not-panic.com>
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
 compat/compat-2.6.35.c        |    4 ++--
 include/linux/compat-2.6.35.h |    7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/compat/compat-2.6.35.c b/compat/compat-2.6.35.c
index 646afa2..20fee85 100644
--- a/compat/compat-2.6.35.c
+++ b/compat/compat-2.6.35.c
@@ -61,7 +61,7 @@ EXPORT_SYMBOL_GPL(netif_set_real_num_tx_queues);
  * hex_to_bin() converts one hex digit to its actual value or -1 in case of bad
  * input.
  */
-int compat_hex_to_bin(char ch)
+int hex_to_bin(char ch)
 {
 	if ((ch >= '0') && (ch <= '9'))
 		return ch - '0';
@@ -70,7 +70,7 @@ int compat_hex_to_bin(char ch)
 		return ch - 'a' + 10;
 	return -1;
 }
-EXPORT_SYMBOL_GPL(compat_hex_to_bin);
+EXPORT_SYMBOL_GPL(hex_to_bin);
 
 /**
  * noop_llseek - No Operation Performed llseek implementation
diff --git a/include/linux/compat-2.6.35.h b/include/linux/compat-2.6.35.h
index 82b4dea..99968bf 100644
--- a/include/linux/compat-2.6.35.h
+++ b/include/linux/compat-2.6.35.h
@@ -45,6 +45,7 @@ static inline void qdisc_reset_all_tx_gt(struct net_device *dev, unsigned int i)
 }
 #endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)) */
 
+#define netif_set_real_num_tx_queues LINUX_BACKPORT(netif_set_real_num_tx_queues)
 extern int netif_set_real_num_tx_queues(struct net_device *dev,
 					unsigned int txq);
 
@@ -68,11 +69,10 @@ static inline wait_queue_head_t *sk_sleep(struct sock *sk)
 
 #define sdio_writeb_readb(func, write_byte, addr, err_ret) sdio_readb(func, addr, err_ret)
 
-/* mask hex_to_bin as RHEL6 backports this */
-#define hex_to_bin(a) compat_hex_to_bin(a)
-
+#define hex_to_bin LINUX_BACKPORT(hex_to_bin)
 int hex_to_bin(char ch);
 
+#define noop_llseek LINUX_BACKPORT(noop_llseek)
 extern loff_t noop_llseek(struct file *file, loff_t offset, int origin);
 
 #define pm_qos_request(_qos) pm_qos_requirement(_qos)
@@ -88,6 +88,7 @@ usb_pipe_endpoint(struct usb_device *dev, unsigned int pipe)
 	return eps[usb_pipeendpoint(pipe)];
 }
 
+#define simple_write_to_buffer LINUX_BACKPORT(simple_write_to_buffer)
 extern ssize_t simple_write_to_buffer(void *to, size_t available, loff_t *ppos,
 		const void __user *from, size_t count);
 
-- 
1.7.10.4

