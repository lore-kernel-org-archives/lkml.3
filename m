Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab3CTJYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:24:06 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:43766 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab3CTJYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:24:00 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 14/30] compat: embrace LINUX_BACKPORT() for v2.6.36
Date: Wed, 20 Mar 2013 02:22:39 -0700
Message-Id: <1363771375-31715-15-git-send-email-mcgrof@do-not-panic.com>
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
 compat/compat-2.6.36.c        |   32 +++++++++++++++---------------
 include/linux/compat-2.6.36.h |   43 ++++++++++++++++++++++-------------------
 2 files changed, 39 insertions(+), 36 deletions(-)

diff --git a/compat/compat-2.6.36.c b/compat/compat-2.6.36.c
index 72ada4a..2c65b43 100644
--- a/compat/compat-2.6.36.c
+++ b/compat/compat-2.6.36.c
@@ -34,7 +34,7 @@ static void __usb_unanchor_urb(struct urb *urb, struct usb_anchor *anchor)
  * This routine should not be called by a driver after its disconnect
  * method has returned.
  */
-void compat_usb_unlink_anchored_urbs(struct usb_anchor *anchor)
+void usb_unlink_anchored_urbs(struct usb_anchor *anchor)
 {
 	struct urb *victim;
 
@@ -43,7 +43,7 @@ void compat_usb_unlink_anchored_urbs(struct usb_anchor *anchor)
 		usb_put_urb(victim);
 	}
 }
-EXPORT_SYMBOL_GPL(compat_usb_unlink_anchored_urbs);
+EXPORT_SYMBOL_GPL(usb_unlink_anchored_urbs);
 
 /**
  * usb_get_from_anchor - get an anchor's oldest urb
@@ -52,7 +52,7 @@ EXPORT_SYMBOL_GPL(compat_usb_unlink_anchored_urbs);
  * this will take the oldest urb from an anchor,
  * unanchor and return it
  */
-struct urb *compat_usb_get_from_anchor(struct usb_anchor *anchor)
+struct urb *usb_get_from_anchor(struct usb_anchor *anchor)
 {
 	struct urb *victim;
 	unsigned long flags;
@@ -70,7 +70,7 @@ struct urb *compat_usb_get_from_anchor(struct usb_anchor *anchor)
 
 	return victim;
 }
-EXPORT_SYMBOL_GPL(compat_usb_get_from_anchor);
+EXPORT_SYMBOL_GPL(usb_get_from_anchor);
 
 /**
  * usb_scuttle_anchored_urbs - unanchor all an anchor's urbs
@@ -78,7 +78,7 @@ EXPORT_SYMBOL_GPL(compat_usb_get_from_anchor);
  *
  * use this to get rid of all an anchor's urbs
  */
-void compat_usb_scuttle_anchored_urbs(struct usb_anchor *anchor)
+void usb_scuttle_anchored_urbs(struct usb_anchor *anchor)
 {
 	struct urb *victim;
 	unsigned long flags;
@@ -91,7 +91,7 @@ void compat_usb_scuttle_anchored_urbs(struct usb_anchor *anchor)
 	}
 	spin_unlock_irqrestore(&anchor->lock, flags);
 }
-EXPORT_SYMBOL_GPL(compat_usb_scuttle_anchored_urbs);
+EXPORT_SYMBOL_GPL(usb_scuttle_anchored_urbs);
 
 #endif /* CONFIG_COMPAT_USB_URB_THREAD_FIX */
 
@@ -102,13 +102,13 @@ EXPORT_SYMBOL_GPL(system_wq);
 EXPORT_SYMBOL_GPL(system_long_wq);
 EXPORT_SYMBOL_GPL(system_nrt_wq);
 
-int compat_schedule_work(struct work_struct *work)
+int schedule_work(struct work_struct *work)
 {
 	return queue_work(system_wq, work);
 }
-EXPORT_SYMBOL_GPL(compat_schedule_work);
+EXPORT_SYMBOL_GPL(schedule_work);
 
-int compat_schedule_work_on(int cpu, struct work_struct *work)
+int schedule_work_on(int cpu, struct work_struct *work)
 {
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
 	return queue_work_on(cpu, system_wq, work);
@@ -116,25 +116,25 @@ int compat_schedule_work_on(int cpu, struct work_struct *work)
 	return queue_work(system_wq, work);
 #endif
 }
-EXPORT_SYMBOL_GPL(compat_schedule_work_on);
+EXPORT_SYMBOL_GPL(schedule_work_on);
 
-int compat_schedule_delayed_work(struct delayed_work *dwork,
+int schedule_delayed_work(struct delayed_work *dwork,
                                  unsigned long delay)
 {
 	return queue_delayed_work(system_wq, dwork, delay);
 }
-EXPORT_SYMBOL_GPL(compat_schedule_delayed_work);
+EXPORT_SYMBOL_GPL(schedule_delayed_work);
 
-int compat_schedule_delayed_work_on(int cpu,
+int schedule_delayed_work_on(int cpu,
                                     struct delayed_work *dwork,
                                     unsigned long delay)
 {
 	return queue_delayed_work_on(cpu, system_wq, dwork, delay);
 }
-EXPORT_SYMBOL_GPL(compat_schedule_delayed_work_on);
+EXPORT_SYMBOL_GPL(schedule_delayed_work_on);
 
 #undef flush_scheduled_work
-void compat_flush_scheduled_work(void)
+void flush_scheduled_work(void)
 {
 	/*
 	 * It is debatable which one we should prioritize first, lets
@@ -144,7 +144,7 @@ void compat_flush_scheduled_work(void)
 	flush_workqueue(system_wq);
 	flush_scheduled_work();
 }
-EXPORT_SYMBOL_GPL(compat_flush_scheduled_work);
+EXPORT_SYMBOL_GPL(flush_scheduled_work);
 
 /**
  * work_busy - test whether a work is currently pending or running
diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index cd5e37c..b4d3761 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -25,13 +25,13 @@ struct va_format {
 #define device_rename(dev, new_name) device_rename(dev, (char *)new_name)
 
 #ifdef CONFIG_COMPAT_USB_URB_THREAD_FIX
-#define usb_scuttle_anchored_urbs(anchor)	compat_usb_scuttle_anchored_urbs(anchor)
-#define usb_get_from_anchor(anchor)	compat_usb_get_from_anchor(anchor)
-#define usb_unlink_anchored_urbs(anchor)	compat_usb_unlink_anchored_urbs(anchor)
+#define usb_scuttle_anchored_urbs LINUX_BACKPORT(usb_scuttle_anchored_urbs)
+#define usb_get_from_anchor LINUX_BACKPORT(usb_get_from_anchor)
+#define usb_unlink_anchored_urbs LINUX_BACKPORT(usb_unlink_anchored_urbs)
 
-extern void compat_usb_unlink_anchored_urbs(struct usb_anchor *anchor);
-extern struct urb *compat_usb_get_from_anchor(struct usb_anchor *anchor);
-extern void compat_usb_scuttle_anchored_urbs(struct usb_anchor *anchor);
+extern void usb_unlink_anchored_urbs(struct usb_anchor *anchor);
+extern struct urb *usb_get_from_anchor(struct usb_anchor *anchor);
+extern void usb_scuttle_anchored_urbs(struct usb_anchor *anchor);
 #endif
 
 /**
@@ -154,21 +154,29 @@ static inline void skb_tx_timestamp(struct sk_buff *skb)
  * item is never executed in parallel by multiple CPUs.  Queue
  * flushing might take relatively long.
  */
+#define system_wq LINUX_BACKPORT(system_wq)
 extern struct workqueue_struct *system_wq;
+#define system_long_wq LINUX_BACKPORT(system_long_wq)
 extern struct workqueue_struct *system_long_wq;
+#define system_nrt_wq LINUX_BACKPORT(system_nrt_wq)
 extern struct workqueue_struct *system_nrt_wq;
 
 void compat_system_workqueue_create(void);
 void compat_system_workqueue_destroy(void);
 
-int compat_schedule_work(struct work_struct *work);
-int compat_schedule_work_on(int cpu, struct work_struct *work);
-int compat_schedule_delayed_work(struct delayed_work *dwork,
-				 unsigned long delay);
-int compat_schedule_delayed_work_on(int cpu,
-				    struct delayed_work *dwork,
-				    unsigned long delay);
-void compat_flush_scheduled_work(void);
+#define schedule_work LINUX_BACKPORT(schedule_work)
+int schedule_work(struct work_struct *work);
+#define schedule_work_on LINUX_BACKPORT(schedule_work_on)
+int schedule_work_on(int cpu, struct work_struct *work);
+#define compat_schedule_delayed_work LINUX_BACKPORT(compat_schedule_delayed_work)
+int schedule_delayed_work(struct delayed_work *dwork,
+			  unsigned long delay);
+#define compat_schedule_delayed_work_on LINUX_BACKPORT(compat_schedule_delayed_work_on)
+int schedule_delayed_work_on(int cpu,
+			     struct delayed_work *dwork,
+			     unsigned long delay);
+#define flush_scheduled_work LINUX_BACKPORT(flush_scheduled_work)
+void flush_scheduled_work(void);
 
 enum {
 	/* bit mask for work_busy() return values */
@@ -176,14 +184,9 @@ enum {
 	WORK_BUSY_RUNNING       = 1 << 1,
 };
 
+#define work_busy LINUX_BACKPORT(work_busy)
 extern unsigned int work_busy(struct work_struct *work);
 
-#define schedule_work(work) compat_schedule_work(work)
-#define schedule_work_on(cpu, work) compat_schedule_work_on(cpu, work)
-#define schedule_delayed_work(dwork, delay) compat_schedule_delayed_work(dwork, delay)
-#define schedule_delayed_work_on(cpu, dwork, delay) compat_schedule_delayed_work_on(cpu, dwork, delay)
-#define flush_scheduled_work(a) compat_flush_scheduled_work(a)
-
 #define br_port_exists(dev)	(dev->br_port)
 
 #else
-- 
1.7.10.4

