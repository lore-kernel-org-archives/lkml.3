Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab3JJVme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:42:34 -0400
Received: from libra.uberspace.de ([95.143.172.171]:60090 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757376Ab3JJVls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:41:48 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Beyer <mail@beyermatthias.de>
Subject: [PATCH 4/6] drivers: usb: core: devio.c: Coding style fixes
Date: Thu, 10 Oct 2013 23:41:30 +0200
Message-Id: <1381441292-6145-5-git-send-email-mail@beyermatthias.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381441292-6145-1-git-send-email-mail@beyermatthias.de>
References: <1381441292-6145-1-git-send-email-mail@beyermatthias.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whitespace fixes, including:

- Whitespace after if-keyword
- Spaces to Tabs

Other coding style fixes:

- Added braces for if-else blocks where missing

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
---
 drivers/usb/core/devio.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 71dc5d7..8aca6b93 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1222,7 +1222,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 		return -ENOENT;
 
 	u = 0;
-	switch(uurb->type) {
+	switch (uurb->type) {
 	case USBDEVFS_URB_TYPE_CONTROL:
 		if (!usb_endpoint_xfer_control(&ep->desc))
 			return -EINVAL;
@@ -1636,32 +1636,32 @@ static int proc_reapurbnonblock(struct dev_state *ps, void __user *arg)
 static int proc_control_compat(struct dev_state *ps,
 				struct usbdevfs_ctrltransfer32 __user *p32)
 {
-        struct usbdevfs_ctrltransfer __user *p;
-        __u32 udata;
-        p = compat_alloc_user_space(sizeof(*p));
-        if (copy_in_user(p, p32, (sizeof(*p32) - sizeof(compat_caddr_t))) ||
-            get_user(udata, &p32->data) ||
+	struct usbdevfs_ctrltransfer __user *p;
+	__u32 udata;
+	p = compat_alloc_user_space(sizeof(*p));
+	if (copy_in_user(p, p32, (sizeof(*p32) - sizeof(compat_caddr_t))) ||
+	    get_user(udata, &p32->data) ||
 	    put_user(compat_ptr(udata), &p->data))
 		return -EFAULT;
-        return proc_control(ps, p);
+	return proc_control(ps, p);
 }
 
 static int proc_bulk_compat(struct dev_state *ps,
 			struct usbdevfs_bulktransfer32 __user *p32)
 {
-        struct usbdevfs_bulktransfer __user *p;
-        compat_uint_t n;
-        compat_caddr_t addr;
+	struct usbdevfs_bulktransfer __user *p;
+	compat_uint_t n;
+	compat_caddr_t addr;
 
-        p = compat_alloc_user_space(sizeof(*p));
+	p = compat_alloc_user_space(sizeof(*p));
 
-        if (get_user(n, &p32->ep) || put_user(n, &p->ep) ||
-            get_user(n, &p32->len) || put_user(n, &p->len) ||
-            get_user(n, &p32->timeout) || put_user(n, &p->timeout) ||
-            get_user(addr, &p32->data) || put_user(compat_ptr(addr), &p->data))
-                return -EFAULT;
+	if (get_user(n, &p32->ep) || put_user(n, &p->ep) ||
+	    get_user(n, &p32->len) || put_user(n, &p->len) ||
+	    get_user(n, &p32->timeout) || put_user(n, &p->timeout) ||
+	    get_user(addr, &p32->data) || put_user(compat_ptr(addr), &p->data))
+		return -EFAULT;
 
-        return proc_bulk(ps, p);
+	return proc_bulk(ps, p);
 }
 static int proc_disconnectsignal_compat(struct dev_state *ps, void __user *arg)
 {
@@ -1838,9 +1838,10 @@ static int proc_ioctl(struct dev_state *ps, struct usbdevfs_ioctl *ctl)
 		return -ENODEV;
 	}
 
-	if (ps->dev->state != USB_STATE_CONFIGURED)
+	if (ps->dev->state != USB_STATE_CONFIGURED) {
 		retval = -EHOSTUNREACH;
-	else if (!(intf = usb_ifnum_to_if(ps->dev, ctl->ifno)))
+	}
+	else if (!(intf = usb_ifnum_to_if(ps->dev, ctl->ifno))) {
 		retval = -EINVAL;
 	else switch (ctl->ioctl_code) {
 
-- 
1.8.4

