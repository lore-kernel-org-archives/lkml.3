Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab3CTJXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:23:51 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:58802 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab3CTJXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:23:48 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 11/30] compat: embrace LINUX_BACKPORT() for v2.6.33
Date: Wed, 20 Mar 2013 02:22:36 -0700
Message-Id: <1363771375-31715-12-git-send-email-mcgrof@do-not-panic.com>
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
 include/linux/compat-2.6.33.h |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index 307834a..c0be190 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -16,6 +16,8 @@
 #include <linux/firmware.h>
 #include <linux/input.h>
 
+#define usb_autopm_get_interface_no_resume LINUX_BACKPORT(usb_autopm_get_interface_no_resume)
+#define usb_autopm_put_interface_no_suspend LINUX_BACKPORT(usb_autopm_put_interface_no_suspend)
 #ifdef CONFIG_USB_SUSPEND
 extern void usb_autopm_get_interface_no_resume(struct usb_interface *intf);
 extern void usb_autopm_put_interface_no_suspend(struct usb_interface *intf);
@@ -31,29 +33,27 @@ static inline void usb_autopm_put_interface_no_suspend(struct usb_interface *int
 #endif /* CONFIG_USB_SUSPEND */
 
 #if defined(CONFIG_COMPAT_FIRMWARE_CLASS)
-#if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
-#define release_firmware compat_release_firmware
-#define request_firmware compat_request_firmware
-#define request_firmware_nowait compat_request_firmware_nowait
-#endif
+#define request_firmware_nowait LINUX_BACKPORT(request_firmware_nowait)
+#define request_firmware LINUX_BACKPORT(request_firmware)
+#define release_firmware LINUX_BACKPORT(release_firmware)
 
 #if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
-int compat_request_firmware(const struct firmware **fw, const char *name,
+int request_firmware(const struct firmware **fw, const char *name,
 		     struct device *device);
-int compat_request_firmware_nowait(
+int request_firmware_nowait(
 	struct module *module, int uevent,
 	const char *name, struct device *device, gfp_t gfp, void *context,
 	void (*cont)(const struct firmware *fw, void *context));
 
-void compat_release_firmware(const struct firmware *fw);
+void release_firmware(const struct firmware *fw);
 #else
-static inline int compat_request_firmware(const struct firmware **fw,
+static inline int request_firmware(const struct firmware **fw,
 				   const char *name,
 				   struct device *device)
 {
 	return -EINVAL;
 }
-static inline int compat_request_firmware_nowait(
+static inline int request_firmware_nowait(
 	struct module *module, int uevent,
 	const char *name, struct device *device, gfp_t gfp, void *context,
 	void (*cont)(const struct firmware *fw, void *context))
@@ -61,7 +61,7 @@ static inline int compat_request_firmware_nowait(
 	return -EINVAL;
 }
 
-static inline void compat_release_firmware(const struct firmware *fw)
+static inline void release_firmware(const struct firmware *fw)
 {
 }
 #endif
@@ -106,6 +106,7 @@ static inline struct sk_buff *netdev_alloc_skb_ip_align(struct net_device *dev,
 #define pcmcia_map_mem_page(a, b, c) pcmcia_map_mem_page(b, c)
 
 /* loop over CIS entries */
+#define pcmcia_loop_tuple LINUX_BACKPORT(pcmcia_loop_tuple)
 int pcmcia_loop_tuple(struct pcmcia_device *p_dev, cisdata_t code,
 		      int (*loop_tuple) (struct pcmcia_device *p_dev,
 					 tuple_t *tuple,
@@ -115,6 +116,7 @@ int pcmcia_loop_tuple(struct pcmcia_device *p_dev, cisdata_t code,
 #endif /* CONFIG_PCMCIA */
 
 /* loop over CIS entries */
+#define pccard_loop_tuple LINUX_BACKPORT(pccard_loop_tuple)
 int pccard_loop_tuple(struct pcmcia_socket *s, unsigned int function,
 		      cisdata_t code, cisparse_t *parse, void *priv_data,
 		      int (*loop_tuple) (tuple_t *tuple,
-- 
1.7.10.4

