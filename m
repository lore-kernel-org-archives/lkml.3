Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbaCRUM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:12:56 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:47238 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258AbaCRUMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:12:12 -0400
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tulinizer@gmail.com, stern@rowland.harvard.edu, mail@beyermatthias.de,
        hdegoede@redhat.com, f.manzan@gmail.com, kurt@garloff.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        firefly@lists.rosedu.org, andy.grover@gmail.com,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 2/3] usbip: move usbip kernel code out of staging
Date: Tue, 18 Mar 2014 22:11:22 +0200
Message-Id: <1395173483-27542-3-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1395173483-27542-1-git-send-email-valentina.manea.m@gmail.com>
References: <1395173483-27542-1-git-send-email-valentina.manea.m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At this point, USB/IP kernel code is fully functional
and can be moved out of staging.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 drivers/staging/Kconfig                  |    2 -
 drivers/staging/Makefile                 |    1 -
 drivers/staging/usbip/Kconfig            |   45 --
 drivers/staging/usbip/Makefile           |   10 -
 drivers/staging/usbip/README             |    7 -
 drivers/staging/usbip/stub.h             |  113 ---
 drivers/staging/usbip/stub_dev.c         |  524 --------------
 drivers/staging/usbip/stub_main.c        |  339 ---------
 drivers/staging/usbip/stub_rx.c          |  595 ---------------
 drivers/staging/usbip/stub_tx.c          |  397 ----------
 drivers/staging/usbip/uapi/usbip.h       |   26 -
 drivers/staging/usbip/usbip_common.c     |  803 --------------------
 drivers/staging/usbip/usbip_common.h     |  334 ---------
 drivers/staging/usbip/usbip_event.c      |  128 ----
 drivers/staging/usbip/usbip_protocol.txt |  358 ---------
 drivers/staging/usbip/vhci.h             |  129 ----
 drivers/staging/usbip/vhci_hcd.c         | 1168 ------------------------------
 drivers/staging/usbip/vhci_rx.c          |  270 -------
 drivers/staging/usbip/vhci_sysfs.c       |  252 -------
 drivers/staging/usbip/vhci_tx.c          |  224 ------
 drivers/usb/Kconfig                      |    2 +
 drivers/usb/Makefile                     |    2 +
 drivers/usb/usbip/Kconfig                |   45 ++
 drivers/usb/usbip/Makefile               |   10 +
 drivers/usb/usbip/README                 |    7 +
 drivers/usb/usbip/stub.h                 |  113 +++
 drivers/usb/usbip/stub_dev.c             |  524 ++++++++++++++
 drivers/usb/usbip/stub_main.c            |  339 +++++++++
 drivers/usb/usbip/stub_rx.c              |  595 +++++++++++++++
 drivers/usb/usbip/stub_tx.c              |  397 ++++++++++
 drivers/usb/usbip/usbip_common.c         |  803 ++++++++++++++++++++
 drivers/usb/usbip/usbip_common.h         |  334 +++++++++
 drivers/usb/usbip/usbip_event.c          |  128 ++++
 drivers/usb/usbip/usbip_protocol.txt     |  358 +++++++++
 drivers/usb/usbip/vhci.h                 |  129 ++++
 drivers/usb/usbip/vhci_hcd.c             | 1168 ++++++++++++++++++++++++++++++
 drivers/usb/usbip/vhci_rx.c              |  270 +++++++
 drivers/usb/usbip/vhci_sysfs.c           |  252 +++++++
 drivers/usb/usbip/vhci_tx.c              |  224 ++++++
 include/uapi/linux/usbip.h               |   26 +
 40 files changed, 5726 insertions(+), 5725 deletions(-)
 delete mode 100644 drivers/staging/usbip/Kconfig
 delete mode 100644 drivers/staging/usbip/Makefile
 delete mode 100644 drivers/staging/usbip/README
 delete mode 100644 drivers/staging/usbip/stub.h
 delete mode 100644 drivers/staging/usbip/stub_dev.c
 delete mode 100644 drivers/staging/usbip/stub_main.c
 delete mode 100644 drivers/staging/usbip/stub_rx.c
 delete mode 100644 drivers/staging/usbip/stub_tx.c
 delete mode 100644 drivers/staging/usbip/uapi/usbip.h
 delete mode 100644 drivers/staging/usbip/usbip_common.c
 delete mode 100644 drivers/staging/usbip/usbip_common.h
 delete mode 100644 drivers/staging/usbip/usbip_event.c
 delete mode 100644 drivers/staging/usbip/usbip_protocol.txt
 delete mode 100644 drivers/staging/usbip/vhci.h
 delete mode 100644 drivers/staging/usbip/vhci_hcd.c
 delete mode 100644 drivers/staging/usbip/vhci_rx.c
 delete mode 100644 drivers/staging/usbip/vhci_sysfs.c
 delete mode 100644 drivers/staging/usbip/vhci_tx.c
 create mode 100644 drivers/usb/usbip/Kconfig
 create mode 100644 drivers/usb/usbip/Makefile
 create mode 100644 drivers/usb/usbip/README
 create mode 100644 drivers/usb/usbip/stub.h
 create mode 100644 drivers/usb/usbip/stub_dev.c
 create mode 100644 drivers/usb/usbip/stub_main.c
 create mode 100644 drivers/usb/usbip/stub_rx.c
 create mode 100644 drivers/usb/usbip/stub_tx.c
 create mode 100644 drivers/usb/usbip/usbip_common.c
 create mode 100644 drivers/usb/usbip/usbip_common.h
 create mode 100644 drivers/usb/usbip/usbip_event.c
 create mode 100644 drivers/usb/usbip/usbip_protocol.txt
 create mode 100644 drivers/usb/usbip/vhci.h
 create mode 100644 drivers/usb/usbip/vhci_hcd.c
 create mode 100644 drivers/usb/usbip/vhci_rx.c
 create mode 100644 drivers/usb/usbip/vhci_sysfs.c
 create mode 100644 drivers/usb/usbip/vhci_tx.c
 create mode 100644 include/uapi/linux/usbip.h

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 47cf175..eec9c63 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -28,8 +28,6 @@ source "drivers/staging/et131x/Kconfig"
 
 source "drivers/staging/slicoss/Kconfig"
 
-source "drivers/staging/usbip/Kconfig"
-
 source "drivers/staging/winbond/Kconfig"
 
 source "drivers/staging/wlan-ng/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index d12f618..6afcdfd 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -6,7 +6,6 @@ obj-$(CONFIG_STAGING)		+= staging.o
 obj-y				+= media/
 obj-$(CONFIG_ET131X)		+= et131x/
 obj-$(CONFIG_SLICOSS)		+= slicoss/
-obj-$(CONFIG_USBIP_CORE)	+= usbip/
 obj-$(CONFIG_W35UND)		+= winbond/
 obj-$(CONFIG_PRISM2_USB)	+= wlan-ng/
 obj-$(CONFIG_COMEDI)		+= comedi/
diff --git a/drivers/staging/usbip/Kconfig b/drivers/staging/usbip/Kconfig
deleted file mode 100644
index 8860009..0000000
--- a/drivers/staging/usbip/Kconfig
+++ /dev/null
@@ -1,45 +0,0 @@
-config USBIP_CORE
-	tristate "USB/IP support"
-	depends on USB && NET
-	default N
-	---help---
-	  This enables pushing USB packets over IP to allow remote
-	  machines direct access to USB devices. It provides the
-	  USB/IP core that is required by both drivers.
-
-	  For more details, and to get the userspace utility
-	  programs, please see <http://usbip.sourceforge.net/>.
-
-	  To compile this as a module, choose M here: the module will
-	  be called usbip-core.
-
-	  If unsure, say N.
-
-config USBIP_VHCI_HCD
-	tristate "VHCI hcd"
-	depends on USBIP_CORE
-	default N
-	---help---
-	  This enables the USB/IP virtual host controller driver,
-	  which is run on the remote machine.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called vhci-hcd.
-
-config USBIP_HOST
-	tristate "Host driver"
-	depends on USBIP_CORE
-	default N
-	---help---
-	  This enables the USB/IP host driver, which is run on the
-	  machine that is sharing the USB devices.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called usbip-host.
-
-config USBIP_DEBUG
-	bool "Debug messages for USB/IP"
-	depends on USBIP_CORE
-	default N
-	---help---
-	  This enables the debug messages from the USB/IP drivers.
diff --git a/drivers/staging/usbip/Makefile b/drivers/staging/usbip/Makefile
deleted file mode 100644
index 9ecd615..0000000
--- a/drivers/staging/usbip/Makefile
+++ /dev/null
@@ -1,10 +0,0 @@
-ccflags-$(CONFIG_USBIP_DEBUG) := -DDEBUG
-
-obj-$(CONFIG_USBIP_CORE) += usbip-core.o
-usbip-core-y := usbip_common.o usbip_event.o
-
-obj-$(CONFIG_USBIP_VHCI_HCD) += vhci-hcd.o
-vhci-hcd-y := vhci_sysfs.o vhci_tx.o vhci_rx.o vhci_hcd.o
-
-obj-$(CONFIG_USBIP_HOST) += usbip-host.o
-usbip-host-y := stub_dev.o stub_main.o stub_rx.o stub_tx.o
diff --git a/drivers/staging/usbip/README b/drivers/staging/usbip/README
deleted file mode 100644
index 41a2cf2..0000000
--- a/drivers/staging/usbip/README
+++ /dev/null
@@ -1,7 +0,0 @@
-TODO:
-	- more discussion about the protocol
-	- testing
-	- review of the userspace interface
-	- document the protocol
-
-Please send patches for this code to Greg Kroah-Hartman <greg@kroah.com>
diff --git a/drivers/staging/usbip/stub.h b/drivers/staging/usbip/stub.h
deleted file mode 100644
index 266e2b0..0000000
--- a/drivers/staging/usbip/stub.h
+++ /dev/null
@@ -1,113 +0,0 @@
-/*
- * Copyright (C) 2003-2008 Takahiro Hirofuchi
- *
- * This is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
- * USA.
- */
-
-#ifndef __USBIP_STUB_H
-#define __USBIP_STUB_H
-
-#include <linux/list.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/types.h>
-#include <linux/usb.h>
-#include <linux/wait.h>
-
-#define STUB_BUSID_OTHER 0
-#define STUB_BUSID_REMOV 1
-#define STUB_BUSID_ADDED 2
-#define STUB_BUSID_ALLOC 3
-
-struct stub_device {
-	struct usb_interface *interface;
-	struct usb_device *udev;
-
-	struct usbip_device ud;
-	__u32 devid;
-
-	/*
-	 * stub_priv preserves private data of each urb.
-	 * It is allocated as stub_priv_cache and assigned to urb->context.
-	 *
-	 * stub_priv is always linked to any one of 3 lists;
-	 *	priv_init: linked to this until the comletion of a urb.
-	 *	priv_tx  : linked to this after the completion of a urb.
-	 *	priv_free: linked to this after the sending of the result.
-	 *
-	 * Any of these list operations should be locked by priv_lock.
-	 */
-	spinlock_t priv_lock;
-	struct list_head priv_init;
-	struct list_head priv_tx;
-	struct list_head priv_free;
-
-	/* see comments for unlinking in stub_rx.c */
-	struct list_head unlink_tx;
-	struct list_head unlink_free;
-
-	wait_queue_head_t tx_waitq;
-};
-
-/* private data into urb->priv */
-struct stub_priv {
-	unsigned long seqnum;
-	struct list_head list;
-	struct stub_device *sdev;
-	struct urb *urb;
-
-	int unlinking;
-};
-
-struct stub_unlink {
-	unsigned long seqnum;
-	struct list_head list;
-	__u32 status;
-};
-
-/* same as SYSFS_BUS_ID_SIZE */
-#define BUSID_SIZE 32
-
-struct bus_id_priv {
-	char name[BUSID_SIZE];
-	char status;
-	int interf_count;
-	struct stub_device *sdev;
-	struct usb_device *udev;
-	char shutdown_busid;
-};
-
-/* stub_priv is allocated from stub_priv_cache */
-extern struct kmem_cache *stub_priv_cache;
-
-/* stub_dev.c */
-extern struct usb_device_driver stub_driver;
-
-/* stub_main.c */
-struct bus_id_priv *get_busid_priv(const char *busid);
-int del_match_busid(char *busid);
-void stub_device_cleanup_urbs(struct stub_device *sdev);
-
-/* stub_rx.c */
-int stub_rx_loop(void *data);
-
-/* stub_tx.c */
-void stub_enqueue_ret_unlink(struct stub_device *sdev, __u32 seqnum,
-			     __u32 status);
-void stub_complete(struct urb *urb);
-int stub_tx_loop(void *data);
-
-#endif /* __USBIP_STUB_H */
diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
deleted file mode 100644
index 773d8ca..0000000
--- a/drivers/staging/usbip/stub_dev.c
+++ /dev/null
@@ -1,524 +0,0 @@
-/*
- * Copyright (C) 2003-2008 Takahiro Hirofuchi
- *
- * This is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
- * USA.
- */
-
-#include <linux/device.h>
-#include <linux/file.h>
-#include <linux/kthread.h>
-#include <linux/module.h>
-
-#include "usbip_common.h"
-#include "stub.h"
-
-/*
- * Define device IDs here if you want to explicitly limit exportable devices.
- * In most cases, wildcard matching will be okay because driver binding can be
- * changed dynamically by a userland program.
- */
-static struct usb_device_id stub_table[] = {
-#if 0
-	/* just an example */
-	{ USB_DEVICE(0x05ac, 0x0301) },   /* Mac 1 button mouse */
-	{ USB_DEVICE(0x0430, 0x0009) },   /* Plat Home Keyboard */
-	{ USB_DEVICE(0x059b, 0x0001) },   /* Iomega USB Zip 100 */
-	{ USB_DEVICE(0x04b3, 0x4427) },   /* IBM USB CD-ROM */
-	{ USB_DEVICE(0x05a9, 0xa511) },   /* LifeView USB cam */
-	{ USB_DEVICE(0x55aa, 0x0201) },   /* Imation card reader */
-	{ USB_DEVICE(0x046d, 0x0870) },   /* Qcam Express(QV-30) */
-	{ USB_DEVICE(0x04bb, 0x0101) },   /* IO-DATA HD 120GB */
-	{ USB_DEVICE(0x04bb, 0x0904) },   /* IO-DATA USB-ET/TX */
-	{ USB_DEVICE(0x04bb, 0x0201) },   /* IO-DATA USB-ET/TX */
-	{ USB_DEVICE(0x08bb, 0x2702) },   /* ONKYO USB Speaker */
-	{ USB_DEVICE(0x046d, 0x08b2) },   /* Logicool Qcam 4000 Pro */
-#endif
-	/* magic for wild card */
-	{ .driver_info = 1 },
-	{ 0, }                                     /* Terminating entry */
-};
-MODULE_DEVICE_TABLE(usb, stub_table);
-
-/*
- * usbip_status shows the status of usbip-host as long as this driver is bound
- * to the target device.
- */
-static ssize_t usbip_status_show(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	struct stub_device *sdev = dev_get_drvdata(dev);
-	int status;
-
-	if (!sdev) {
-		dev_err(dev, "sdev is null\n");
-		return -ENODEV;
-	}
-
-	spin_lock_irq(&sdev->ud.lock);
-	status = sdev->ud.status;
-	spin_unlock_irq(&sdev->ud.lock);
-
-	return snprintf(buf, PAGE_SIZE, "%d\n", status);
-}
-static DEVICE_ATTR_RO(usbip_status);
-
-/*
- * usbip_sockfd gets a socket descriptor of an established TCP connection that
- * is used to transfer usbip requests by kernel threads. -1 is a magic number
- * by which usbip connection is finished.
- */
-static ssize_t store_sockfd(struct device *dev, struct device_attribute *attr,
-			    const char *buf, size_t count)
-{
-	struct stub_device *sdev = dev_get_drvdata(dev);
-	int sockfd = 0;
-	struct socket *socket;
-	ssize_t err = -EINVAL;
-	int rv;
-
-	if (!sdev) {
-		dev_err(dev, "sdev is null\n");
-		return -ENODEV;
-	}
-
-	rv = sscanf(buf, "%d", &sockfd);
-	if (rv != 1)
-		return -EINVAL;
-
-	if (sockfd != -1) {
-		dev_info(dev, "stub up\n");
-
-		spin_lock_irq(&sdev->ud.lock);
-
-		if (sdev->ud.status != SDEV_ST_AVAILABLE) {
-			dev_err(dev, "not ready\n");
-			goto err;
-		}
-
-		socket = sockfd_to_socket(sockfd);
-		if (!socket)
-			goto err;
-
-		sdev->ud.tcp_socket = socket;
-
-		spin_unlock_irq(&sdev->ud.lock);
-
-		sdev->ud.tcp_rx = kthread_get_run(stub_rx_loop, &sdev->ud,
-						  "stub_rx");
-		sdev->ud.tcp_tx = kthread_get_run(stub_tx_loop, &sdev->ud,
-						  "stub_tx");
-
-		spin_lock_irq(&sdev->ud.lock);
-		sdev->ud.status = SDEV_ST_USED;
-		spin_unlock_irq(&sdev->ud.lock);
-
-	} else {
-		dev_info(dev, "stub down\n");
-
-		spin_lock_irq(&sdev->ud.lock);
-		if (sdev->ud.status != SDEV_ST_USED)
-			goto err;
-
-		spin_unlock_irq(&sdev->ud.lock);
-
-		usbip_event_add(&sdev->ud, SDEV_EVENT_DOWN);
-	}
-
-	return count;
-
-err:
-	spin_unlock_irq(&sdev->ud.lock);
-	return err;
-}
-static DEVICE_ATTR(usbip_sockfd, S_IWUSR, NULL, store_sockfd);
-
-static int stub_add_files(struct device *dev)
-{
-	int err = 0;
-
-	err = device_create_file(dev, &dev_attr_usbip_status);
-	if (err)
-		goto err_status;
-
-	err = device_create_file(dev, &dev_attr_usbip_sockfd);
-	if (err)
-		goto err_sockfd;
-
-	err = device_create_file(dev, &dev_attr_usbip_debug);
-	if (err)
-		goto err_debug;
-
-	return 0;
-
-err_debug:
-	device_remove_file(dev, &dev_attr_usbip_sockfd);
-err_sockfd:
-	device_remove_file(dev, &dev_attr_usbip_status);
-err_status:
-	return err;
-}
-
-static void stub_remove_files(struct device *dev)
-{
-	device_remove_file(dev, &dev_attr_usbip_status);
-	device_remove_file(dev, &dev_attr_usbip_sockfd);
-	device_remove_file(dev, &dev_attr_usbip_debug);
-}
-
-static void stub_shutdown_connection(struct usbip_device *ud)
-{
-	struct stub_device *sdev = container_of(ud, struct stub_device, ud);
-
-	/*
-	 * When removing an exported device, kernel panic sometimes occurred
-	 * and then EIP was sk_wait_data of stub_rx thread. Is this because
-	 * sk_wait_data returned though stub_rx thread was already finished by
-	 * step 1?
-	 */
-	if (ud->tcp_socket) {
-		dev_dbg(&sdev->udev->dev, "shutdown tcp_socket %p\n",
-			ud->tcp_socket);
-		kernel_sock_shutdown(ud->tcp_socket, SHUT_RDWR);
-	}
-
-	/* 1. stop threads */
-	if (ud->tcp_rx) {
-		kthread_stop_put(ud->tcp_rx);
-		ud->tcp_rx = NULL;
-	}
-	if (ud->tcp_tx) {
-		kthread_stop_put(ud->tcp_tx);
-		ud->tcp_tx = NULL;
-	}
-
-	/*
-	 * 2. close the socket
-	 *
-	 * tcp_socket is freed after threads are killed so that usbip_xmit does
-	 * not touch NULL socket.
-	 */
-	if (ud->tcp_socket) {
-		fput(ud->tcp_socket->file);
-		ud->tcp_socket = NULL;
-	}
-
-	/* 3. free used data */
-	stub_device_cleanup_urbs(sdev);
-
-	/* 4. free stub_unlink */
-	{
-		unsigned long flags;
-		struct stub_unlink *unlink, *tmp;
-
-		spin_lock_irqsave(&sdev->priv_lock, flags);
-		list_for_each_entry_safe(unlink, tmp, &sdev->unlink_tx, list) {
-			list_del(&unlink->list);
-			kfree(unlink);
-		}
-		list_for_each_entry_safe(unlink, tmp, &sdev->unlink_free,
-					 list) {
-			list_del(&unlink->list);
-			kfree(unlink);
-		}
-		spin_unlock_irqrestore(&sdev->priv_lock, flags);
-	}
-}
-
-static void stub_device_reset(struct usbip_device *ud)
-{
-	struct stub_device *sdev = container_of(ud, struct stub_device, ud);
-	struct usb_device *udev = sdev->udev;
-	int ret;
-
-	dev_dbg(&udev->dev, "device reset");
-
-	ret = usb_lock_device_for_reset(udev, sdev->interface);
-	if (ret < 0) {
-		dev_err(&udev->dev, "lock for reset\n");
-		spin_lock_irq(&ud->lock);
-		ud->status = SDEV_ST_ERROR;
-		spin_unlock_irq(&ud->lock);
-		return;
-	}
-
-	/* try to reset the device */
-	ret = usb_reset_device(udev);
-	usb_unlock_device(udev);
-
-	spin_lock_irq(&ud->lock);
-	if (ret) {
-		dev_err(&udev->dev, "device reset\n");
-		ud->status = SDEV_ST_ERROR;
-	} else {
-		dev_info(&udev->dev, "device reset\n");
-		ud->status = SDEV_ST_AVAILABLE;
-	}
-	spin_unlock_irq(&ud->lock);
-}
-
-static void stub_device_unusable(struct usbip_device *ud)
-{
-	spin_lock_irq(&ud->lock);
-	ud->status = SDEV_ST_ERROR;
-	spin_unlock_irq(&ud->lock);
-}
-
-/**
- * stub_device_alloc - allocate a new stub_device struct
- * @interface: usb_interface of a new device
- *
- * Allocates and initializes a new stub_device struct.
- */
-static struct stub_device *stub_device_alloc(struct usb_device *udev)
-{
-	struct stub_device *sdev;
-	int busnum = udev->bus->busnum;
-	int devnum = udev->devnum;
-
-	dev_dbg(&udev->dev, "allocating stub device");
-
-	/* yes, it's a new device */
-	sdev = kzalloc(sizeof(struct stub_device), GFP_KERNEL);
-	if (!sdev)
-		return NULL;
-
-	sdev->udev = usb_get_dev(udev);
-
-	/*
-	 * devid is defined with devnum when this driver is first allocated.
-	 * devnum may change later if a device is reset. However, devid never
-	 * changes during a usbip connection.
-	 */
-	sdev->devid		= (busnum << 16) | devnum;
-	sdev->ud.side		= USBIP_STUB;
-	sdev->ud.status		= SDEV_ST_AVAILABLE;
-	spin_lock_init(&sdev->ud.lock);
-	sdev->ud.tcp_socket	= NULL;
-
-	INIT_LIST_HEAD(&sdev->priv_init);
-	INIT_LIST_HEAD(&sdev->priv_tx);
-	INIT_LIST_HEAD(&sdev->priv_free);
-	INIT_LIST_HEAD(&sdev->unlink_free);
-	INIT_LIST_HEAD(&sdev->unlink_tx);
-	spin_lock_init(&sdev->priv_lock);
-
-	init_waitqueue_head(&sdev->tx_waitq);
-
-	sdev->ud.eh_ops.shutdown = stub_shutdown_connection;
-	sdev->ud.eh_ops.reset    = stub_device_reset;
-	sdev->ud.eh_ops.unusable = stub_device_unusable;
-
-	usbip_start_eh(&sdev->ud);
-
-	dev_dbg(&udev->dev, "register new device\n");
-
-	return sdev;
-}
-
-static void stub_device_free(struct stub_device *sdev)
-{
-	kfree(sdev);
-}
-
-static int stub_probe(struct usb_device *udev)
-{
-	struct stub_device *sdev = NULL;
-	const char *udev_busid = dev_name(&udev->dev);
-	int err = 0;
-	struct bus_id_priv *busid_priv;
-	int rc;
-
-	dev_dbg(&udev->dev, "Enter\n");
-
-	/* check we should claim or not by busid_table */
-	busid_priv = get_busid_priv(udev_busid);
-	if (!busid_priv || (busid_priv->status == STUB_BUSID_REMOV) ||
-	    (busid_priv->status == STUB_BUSID_OTHER)) {
-		dev_info(&udev->dev,
-			"%s is not in match_busid table... skip!\n",
-			udev_busid);
-
-		/*
-		 * Return value should be ENODEV or ENOXIO to continue trying
-		 * other matched drivers by the driver core.
-		 * See driver_probe_device() in driver/base/dd.c
-		 */
-		return -ENODEV;
-	}
-
-	if (udev->descriptor.bDeviceClass == USB_CLASS_HUB) {
-		dev_dbg(&udev->dev, "%s is a usb hub device... skip!\n",
-			 udev_busid);
-		return -ENODEV;
-	}
-
-	if (!strcmp(udev->bus->bus_name, "vhci_hcd")) {
-		dev_dbg(&udev->dev,
-			"%s is attached on vhci_hcd... skip!\n",
-			udev_busid);
-
-		return -ENODEV;
-	}
-
-	/* ok, this is my device */
-	sdev = stub_device_alloc(udev);
-	if (!sdev)
-		return -ENOMEM;
-
-	dev_info(&udev->dev,
-		"usbip-host: register new device (bus %u dev %u)\n",
-		udev->bus->busnum, udev->devnum);
-
-	busid_priv->shutdown_busid = 0;
-
-	/* set private data to usb_device */
-	dev_set_drvdata(&udev->dev, sdev);
-	busid_priv->sdev = sdev;
-	busid_priv->udev = udev;
-
-	/*
-	 * Claim this hub port.
-	 * It doesn't matter what value we pass as owner
-	 * (struct dev_state) as long as it is unique.
-	 */
-	rc = usb_hub_claim_port(udev->parent, udev->portnum,
-			(struct usb_dev_state *) udev);
-	if (rc) {
-		dev_dbg(&udev->dev, "unable to claim port\n");
-		return rc;
-	}
-
-	err = stub_add_files(&udev->dev);
-	if (err) {
-		dev_err(&udev->dev, "stub_add_files for %s\n", udev_busid);
-		dev_set_drvdata(&udev->dev, NULL);
-		usb_put_dev(udev);
-		kthread_stop_put(sdev->ud.eh);
-
-		busid_priv->sdev = NULL;
-		stub_device_free(sdev);
-		return err;
-	}
-	busid_priv->status = STUB_BUSID_ALLOC;
-
-	return 0;
-}
-
-static void shutdown_busid(struct bus_id_priv *busid_priv)
-{
-	if (busid_priv->sdev && !busid_priv->shutdown_busid) {
-		busid_priv->shutdown_busid = 1;
-		usbip_event_add(&busid_priv->sdev->ud, SDEV_EVENT_REMOVED);
-
-		/* wait for the stop of the event handler */
-		usbip_stop_eh(&busid_priv->sdev->ud);
-	}
-}
-
-/*
- * called in usb_disconnect() or usb_deregister()
- * but only if actconfig(active configuration) exists
- */
-static void stub_disconnect(struct usb_device *udev)
-{
-	struct stub_device *sdev;
-	const char *udev_busid = dev_name(&udev->dev);
-	struct bus_id_priv *busid_priv;
-	int rc;
-
-	dev_dbg(&udev->dev, "Enter\n");
-
-	busid_priv = get_busid_priv(udev_busid);
-	if (!busid_priv) {
-		BUG();
-		return;
-	}
-
-	sdev = dev_get_drvdata(&udev->dev);
-
-	/* get stub_device */
-	if (!sdev) {
-		dev_err(&udev->dev, "could not get device");
-		return;
-	}
-
-	dev_set_drvdata(&udev->dev, NULL);
-
-	/*
-	 * NOTE: rx/tx threads are invoked for each usb_device.
-	 */
-	stub_remove_files(&udev->dev);
-
-	/* release port */
-	rc = usb_hub_release_port(udev->parent, udev->portnum,
-				  (struct usb_dev_state *) udev);
-	if (rc) {
-		dev_dbg(&udev->dev, "unable to release port\n");
-		return;
-	}
-
-	/* If usb reset is called from event handler */
-	if (busid_priv->sdev->ud.eh == current)
-		return;
-
-	/* shutdown the current connection */
-	shutdown_busid(busid_priv);
-
-	usb_put_dev(sdev->udev);
-
-	/* free sdev */
-	busid_priv->sdev = NULL;
-	stub_device_free(sdev);
-
-	if (busid_priv->status == STUB_BUSID_ALLOC) {
-		busid_priv->status = STUB_BUSID_ADDED;
-	} else {
-		busid_priv->status = STUB_BUSID_OTHER;
-		del_match_busid((char *)udev_busid);
-	}
-}
-
-#ifdef CONFIG_PM
-
-/* These functions need usb_port_suspend and usb_port_resume,
- * which reside in drivers/usb/core/usb.h. Skip for now. */
-
-static int stub_suspend(struct usb_device *udev, pm_message_t message)
-{
-	dev_dbg(&udev->dev, "stub_suspend\n");
-
-	return 0;
-}
-
-static int stub_resume(struct usb_device *udev, pm_message_t message)
-{
-	dev_dbg(&udev->dev, "stub_resume\n");
-
-	return 0;
-}
-
-#endif	/* CONFIG_PM */
-
-struct usb_device_driver stub_driver = {
-	.name		= "usbip-host",
-	.probe		= stub_probe,
-	.disconnect	= stub_disconnect,
-#ifdef CONFIG_PM
-	.suspend	= stub_suspend,
-	.resume		= stub_resume,
-#endif
-	.supports_autosuspend	=	0,
-};
diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
deleted file mode 100644
index 9c5832a..0000000
--- a/drivers/staging/usbip/stub_main.c
+++ /dev/null
@@ -1,339 +0,0 @@
-/*
- * Copyright (C) 2003-2008 Takahiro Hirofuchi
- *
- * This is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
- * USA.
- */
-
-#include <linux/string.h>
-#include <linux/module.h>
-#include <linux/device.h>
-
-#include "usbip_common.h"
-#include "stub.h"
-
-#define DRIVER_AUTHOR "Takahiro Hirofuchi"
-#define DRIVER_DESC "USB/IP Host Driver"
-
-struct kmem_cache *stub_priv_cache;
-/*
- * busid_tables defines matching busids that usbip can grab. A user can change
- * dynamically what device is locally used and what device is exported to a
- * remote host.
- */
-#define MAX_BUSID 16
-static struct bus_id_priv busid_table[MAX_BUSID];
-static spinlock_t busid_table_lock;
-
-static void init_busid_table(void)
-{
-	/*
-	 * This also sets the bus_table[i].status to
-	 * STUB_BUSID_OTHER, which is 0.
-	 */
-	memset(busid_table, 0, sizeof(busid_table));
-
-	spin_lock_init(&busid_table_lock);
-}
-
-/*
- * Find the index of the busid by name.
- * Must be called with busid_table_lock held.
- */
-static int get_busid_idx(const char *busid)
-{
-	int i;
-	int idx = -1;
-
-	for (i = 0; i < MAX_BUSID; i++)
-		if (busid_table[i].name[0])
-			if (!strncmp(busid_table[i].name, busid, BUSID_SIZE)) {
-				idx = i;
-				break;
-			}
-	return idx;
-}
-
-struct bus_id_priv *get_busid_priv(const char *busid)
-{
-	int idx;
-	struct bus_id_priv *bid = NULL;
-
-	spin_lock(&busid_table_lock);
-	idx = get_busid_idx(busid);
-	if (idx >= 0)
-		bid = &(busid_table[idx]);
-	spin_unlock(&busid_table_lock);
-
-	return bid;
-}
-
-static int add_match_busid(char *busid)
-{
-	int i;
-	int ret = -1;
-
-	spin_lock(&busid_table_lock);
-	/* already registered? */
-	if (get_busid_idx(busid) >= 0) {
-		ret = 0;
-		goto out;
-	}
-
-	for (i = 0; i < MAX_BUSID; i++)
-		if (!busid_table[i].name[0]) {
-			strncpy(busid_table[i].name, busid, BUSID_SIZE);
-			if ((busid_table[i].status != STUB_BUSID_ALLOC) &&
-			    (busid_table[i].status != STUB_BUSID_REMOV))
-				busid_table[i].status = STUB_BUSID_ADDED;
-			ret = 0;
-			break;
-		}
-
-out:
-	spin_unlock(&busid_table_lock);
-
-	return ret;
-}
-
-int del_match_busid(char *busid)
-{
-	int idx;
-	int ret = -1;
-
-	spin_lock(&busid_table_lock);
-	idx = get_busid_idx(busid);
-	if (idx < 0)
-		goto out;
-
-	/* found */
-	ret = 0;
-
-	if (busid_table[idx].status == STUB_BUSID_OTHER)
-		memset(busid_table[idx].name, 0, BUSID_SIZE);
-
-	if ((busid_table[idx].status != STUB_BUSID_OTHER) &&
-	    (busid_table[idx].status != STUB_BUSID_ADDED))
-		busid_table[idx].status = STUB_BUSID_REMOV;
-
-out:
-	spin_unlock(&busid_table_lock);
-
-	return ret;
-}
-
-static ssize_t show_match_busid(struct device_driver *drv, char *buf)
-{
-	int i;
-	char *out = buf;
-
-	spin_lock(&busid_table_lock);
-	for (i = 0; i < MAX_BUSID; i++)
-		if (busid_table[i].name[0])
-			out += sprintf(out, "%s ", busid_table[i].name);
-	spin_unlock(&busid_table_lock);
-	out += sprintf(out, "\n");
-
-	return out - buf;
-}
-
-static ssize_t store_match_busid(struct device_driver *dev, const char *buf,
-				 size_t count)
-{
-	int len;
-	char busid[BUSID_SIZE];
-
-	if (count < 5)
-		return -EINVAL;
-
-	/* strnlen() does not include \0 */
-	len = strnlen(buf + 4, BUSID_SIZE);
-
-	/* busid needs to include \0 termination */
-	if (!(len < BUSID_SIZE))
-		return -EINVAL;
-
-	strncpy(busid, buf + 4, BUSID_SIZE);
-
-	if (!strncmp(buf, "add ", 4)) {
-		if (add_match_busid(busid) < 0)
-			return -ENOMEM;
-
-		pr_debug("add busid %s\n", busid);
-		return count;
-	}
-
-	if (!strncmp(buf, "del ", 4)) {
-		if (del_match_busid(busid) < 0)
-			return -ENODEV;
-
-		pr_debug("del busid %s\n", busid);
-		return count;
-	}
-
-	return -EINVAL;
-}
-static DRIVER_ATTR(match_busid, S_IRUSR | S_IWUSR, show_match_busid,
-		   store_match_busid);
-
-static ssize_t rebind_store(struct device_driver *dev, const char *buf,
-				 size_t count)
-{
-	int ret;
-	int len;
-	struct bus_id_priv *bid;
-
-	/* buf length should be less that BUSID_SIZE */
-	len = strnlen(buf, BUSID_SIZE);
-
-	if (!(len < BUSID_SIZE))
-		return -EINVAL;
-
-	bid = get_busid_priv(buf);
-	if (!bid)
-		return -ENODEV;
-
-	ret = device_attach(&bid->udev->dev);
-	if (ret < 0) {
-		dev_err(&bid->udev->dev, "rebind failed\n");
-		return ret;
-	}
-
-	return count;
-}
-
-static DRIVER_ATTR_WO(rebind);
-
-static struct stub_priv *stub_priv_pop_from_listhead(struct list_head *listhead)
-{
-	struct stub_priv *priv, *tmp;
-
-	list_for_each_entry_safe(priv, tmp, listhead, list) {
-		list_del(&priv->list);
-		return priv;
-	}
-
-	return NULL;
-}
-
-static struct stub_priv *stub_priv_pop(struct stub_device *sdev)
-{
-	unsigned long flags;
-	struct stub_priv *priv;
-
-	spin_lock_irqsave(&sdev->priv_lock, flags);
-
-	priv = stub_priv_pop_from_listhead(&sdev->priv_init);
-	if (priv)
-		goto done;
-
-	priv = stub_priv_pop_from_listhead(&sdev->priv_tx);
-	if (priv)
-		goto done;
-
-	priv = stub_priv_pop_from_listhead(&sdev->priv_free);
-
-done:
-	spin_unlock_irqrestore(&sdev->priv_lock, flags);
-
-	return priv;
-}
-
-void stub_device_cleanup_urbs(struct stub_device *sdev)
-{
-	struct stub_priv *priv;
-	struct urb *urb;
-
-	dev_dbg(&sdev->udev->dev, "free sdev %p\n", sdev);
-
-	while ((priv = stub_priv_pop(sdev))) {
-		urb = priv->urb;
-		dev_dbg(&sdev->udev->dev, "free urb %p\n", urb);
-		usb_kill_urb(urb);
-
-		kmem_cache_free(stub_priv_cache, priv);
-
-		kfree(urb->transfer_buffer);
-		kfree(urb->setup_packet);
-		usb_free_urb(urb);
-	}
-}
-
-static int __init usbip_host_init(void)
-{
-	int ret;
-
-	init_busid_table();
-
-	stub_priv_cache = KMEM_CACHE(stub_priv, SLAB_HWCACHE_ALIGN);
-	if (!stub_priv_cache) {
-		pr_err("kmem_cache_create failed\n");
-		return -ENOMEM;
-	}
-
-	ret = usb_register_device_driver(&stub_driver, THIS_MODULE);
-	if (ret) {
-		pr_err("usb_register failed %d\n", ret);
-		goto err_usb_register;
-	}
-
-	ret = driver_create_file(&stub_driver.drvwrap.driver,
-				 &driver_attr_match_busid);
-	if (ret) {
-		pr_err("driver_create_file failed\n");
-		goto err_create_file;
-	}
-
-	ret = driver_create_file(&stub_driver.drvwrap.driver,
-				 &driver_attr_rebind);
-	if (ret) {
-		pr_err("driver_create_file failed\n");
-		goto err_create_file;
-	}
-
-	pr_info(DRIVER_DESC " v" USBIP_VERSION "\n");
-	return ret;
-
-err_create_file:
-	usb_deregister_device_driver(&stub_driver);
-err_usb_register:
-	kmem_cache_destroy(stub_priv_cache);
-	return ret;
-}
-
-static void __exit usbip_host_exit(void)
-{
-	driver_remove_file(&stub_driver.drvwrap.driver,
-			   &driver_attr_match_busid);
-
-	driver_remove_file(&stub_driver.drvwrap.driver,
-			   &driver_attr_rebind);
-
-	/*
-	 * deregister() calls stub_disconnect() for all devices. Device
-	 * specific data is cleared in stub_disconnect().
-	 */
-	usb_deregister_device_driver(&stub_driver);
-
-	kmem_cache_destroy(stub_priv_cache);
-}
-
-module_init(usbip_host_init);
-module_exit(usbip_host_exit);
-
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
-MODULE_LICENSE("GPL");
-MODULE_VERSION(USBIP_VERSION);
diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_rx.c
deleted file mode 100644
index e0b6d6b..0000000
--- a/drivers/staging/usbip/stub_rx.c
+++ /dev/null
@@ -1,595 +0,0 @@
-/*
- * Copyright (C) 2003-2008 Takahiro Hirofuchi
- *
- * This is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
- * USA.
- */
-
-#include <asm/byteorder.h>
-#include <linux/kthread.h>
-#include <linux/usb.h>
-#include <linux/usb/hcd.h>
-
-#include "usbip_common.h"
-#include "stub.h"
-
-static int is_clear_halt_cmd(struct urb *urb)
-{
-	struct usb_ctrlrequest *req;
-
-	req = (struct usb_ctrlrequest *) urb->setup_packet;
-
-	 return (req->bRequest == USB_REQ_CLEAR_FEATURE) &&
-		 (req->bRequestType == USB_RECIP_ENDPOINT) &&
-		 (req->wValue == USB_ENDPOINT_HALT);
-}
-
-static int is_set_interface_cmd(struct urb *urb)
-{
-	struct usb_ctrlrequest *req;
-
-	req = (struct usb_ctrlrequest *) urb->setup_packet;
-
-	return (req->bRequest == USB_REQ_SET_INTERFACE) &&
-		(req->bRequestType == USB_RECIP_INTERFACE);
-}
-
-static int is_set_configuration_cmd(struct urb *urb)
-{
-	struct usb_ctrlrequest *req;
-
-	req = (struct usb_ctrlrequest *) urb->setup_packet;
-
-	return (req->bRequest == USB_REQ_SET_CONFIGURATION) &&
-		(req->bRequestType == USB_RECIP_DEVICE);
-}
-
-static int is_reset_device_cmd(struct urb *urb)
-{
-	struct usb_ctrlrequest *req;
-	__u16 value;
-	__u16 index;
-
-	req = (struct usb_ctrlrequest *) urb->setup_packet;
-	value = le16_to_cpu(req->wValue);
-	index = le16_to_cpu(req->wIndex);
-
-	if ((req->bRequest == USB_REQ_SET_FEATURE) &&
-	    (req->bRequestType == USB_RT_PORT) &&
-	    (value == USB_PORT_FEAT_RESET)) {
-		usbip_dbg_stub_rx("reset_device_cmd, port %u\n", index);
-		return 1;
-	} else
-		return 0;
-}
-
-static int tweak_clear_halt_cmd(struct urb *urb)
-{
-	struct usb_ctrlrequest *req;
-	int target_endp;
-	int target_dir;
-	int target_pipe;
-	int ret;
-
-	req = (struct usb_ctrlrequest *) urb->setup_packet;
-
-	/*
-	 * The stalled endpoint is specified in the wIndex value. The endpoint
-	 * of the urb is the target of this clear_halt request (i.e., control
-	 * endpoint).
-	 */
-	target_endp = le16_to_cpu(req->wIndex) & 0x000f;
-
-	/* the stalled endpoint direction is IN or OUT?. USB_DIR_IN is 0x80.  */
-	target_dir = le16_to_cpu(req->wIndex) & 0x0080;
-
-	if (target_dir)
-		target_pipe = usb_rcvctrlpipe(urb->dev, target_endp);
-	else
-		target_pipe = usb_sndctrlpipe(urb->dev, target_endp);
-
-	ret = usb_clear_halt(urb->dev, target_pipe);
-	if (ret < 0)
-		dev_err(&urb->dev->dev,
-			"usb_clear_halt error: devnum %d endp %d ret %d\n",
-			urb->dev->devnum, target_endp, ret);
-	else
-		dev_info(&urb->dev->dev,
-			 "usb_clear_halt done: devnum %d endp %d\n",
-			 urb->dev->devnum, target_endp);
-
-	return ret;
-}
-
-static int tweak_set_interface_cmd(struct urb *urb)
-{
-	struct usb_ctrlrequest *req;
-	__u16 alternate;
-	__u16 interface;
-	int ret;
-
-	req = (struct usb_ctrlrequest *) urb->setup_packet;
-	alternate = le16_to_cpu(req->wValue);
-	interface = le16_to_cpu(req->wIndex);
-
-	usbip_dbg_stub_rx("set_interface: inf %u alt %u\n",
-			  interface, alternate);
-
-	ret = usb_set_interface(urb->dev, interface, alternate);
-	if (ret < 0)
-		dev_err(&urb->dev->dev,
-			"usb_set_interface error: inf %u alt %u ret %d\n",
-			interface, alternate, ret);
-	else
-		dev_info(&urb->dev->dev,
-			"usb_set_interface done: inf %u alt %u\n",
-			interface, alternate);
-
-	return ret;
-}
-
-static int tweak_set_configuration_cmd(struct urb *urb)
-{
-	struct stub_priv *priv = (struct stub_priv *) urb->context;
-	struct stub_device *sdev = priv->sdev;
-	struct usb_ctrlrequest *req;
-	__u16 config;
-	int err;
-
-	req = (struct usb_ctrlrequest *) urb->setup_packet;
-	config = le16_to_cpu(req->wValue);
-
-	err = usb_set_configuration(sdev->udev, config);
-	if (err && err != -ENODEV)
-		dev_err(&sdev->udev->dev, "can't set config #%d, error %d\n",
-			config, err);
-	return 0;
-}
-
-static int tweak_reset_device_cmd(struct urb *urb)
-{
-	struct stub_priv *priv = (struct stub_priv *) urb->context;
-	struct stub_device *sdev = priv->sdev;
-
-	dev_info(&urb->dev->dev, "usb_queue_reset_device\n");
-
-	/*
-	 * With the implementation of pre_reset and post_reset the driver no
-	 * longer unbinds. This allows the use of synchronous reset.
-	 */
-
-	if (usb_lock_device_for_reset(sdev->udev, sdev->interface) < 0) {
-		dev_err(&urb->dev->dev, "could not obtain lock to reset device\n");
-		return 0;
-	}
-	usb_reset_device(sdev->udev);
-	usb_unlock_device(sdev->udev);
-
-	return 0;
-}
-
-/*
- * clear_halt, set_interface, and set_configuration require special tricks.
- */
-static void tweak_special_requests(struct urb *urb)
-{
-	if (!urb || !urb->setup_packet)
-		return;
-
-	if (usb_pipetype(urb->pipe) != PIPE_CONTROL)
-		return;
-
-	if (is_clear_halt_cmd(urb))
-		/* tweak clear_halt */
-		 tweak_clear_halt_cmd(urb);
-
-	else if (is_set_interface_cmd(urb))
-		/* tweak set_interface */
-		tweak_set_interface_cmd(urb);
-
-	else if (is_set_configuration_cmd(urb))
-		/* tweak set_configuration */
-		tweak_set_configuration_cmd(urb);
-
-	else if (is_reset_device_cmd(urb))
-		tweak_reset_device_cmd(urb);
-	else
-		usbip_dbg_stub_rx("no need to tweak\n");
-}
-
-/*
- * stub_recv_unlink() unlinks the URB by a call to usb_unlink_urb().
- * By unlinking the urb asynchronously, stub_rx can continuously
- * process coming urbs.  Even if the urb is unlinked, its completion
- * handler will be called and stub_tx will send a return pdu.
- *
- * See also comments about unlinking strategy in vhci_hcd.c.
- */
-static int stub_recv_cmd_unlink(struct stub_device *sdev,
-				struct usbip_header *pdu)
-{
-	int ret;
-	unsigned long flags;
-	struct stub_priv *priv;
-
-	spin_lock_irqsave(&sdev->priv_lock, flags);
-
-	list_for_each_entry(priv, &sdev->priv_init, list) {
-		if (priv->seqnum != pdu->u.cmd_unlink.seqnum)
-			continue;
-
-		dev_info(&priv->urb->dev->dev, "unlink urb %p\n",
-			 priv->urb);
-
-		/*
-		 * This matched urb is not completed yet (i.e., be in
-		 * flight in usb hcd hardware/driver). Now we are
-		 * cancelling it. The unlinking flag means that we are
-		 * now not going to return the normal result pdu of a
-		 * submission request, but going to return a result pdu
-		 * of the unlink request.
-		 */
-		priv->unlinking = 1;
-
-		/*
-		 * In the case that unlinking flag is on, prev->seqnum
-		 * is changed from the seqnum of the cancelling urb to
-		 * the seqnum of the unlink request. This will be used
-		 * to make the result pdu of the unlink request.
-		 */
-		priv->seqnum = pdu->base.seqnum;
-
-		spin_unlock_irqrestore(&sdev->priv_lock, flags);
-
-		/*
-		 * usb_unlink_urb() is now out of spinlocking to avoid
-		 * spinlock recursion since stub_complete() is
-		 * sometimes called in this context but not in the
-		 * interrupt context.  If stub_complete() is executed
-		 * before we call usb_unlink_urb(), usb_unlink_urb()
-		 * will return an error value. In this case, stub_tx
-		 * will return the result pdu of this unlink request
-		 * though submission is completed and actual unlinking
-		 * is not executed. OK?
-		 */
-		/* In the above case, urb->status is not -ECONNRESET,
-		 * so a driver in a client host will know the failure
-		 * of the unlink request ?
-		 */
-		ret = usb_unlink_urb(priv->urb);
-		if (ret != -EINPROGRESS)
-			dev_err(&priv->urb->dev->dev,
-				"failed to unlink a urb %p, ret %d\n",
-				priv->urb, ret);
-
-		return 0;
-	}
-
-	usbip_dbg_stub_rx("seqnum %d is not pending\n",
-			  pdu->u.cmd_unlink.seqnum);
-
-	/*
-	 * The urb of the unlink target is not found in priv_init queue. It was
-	 * already completed and its results is/was going to be sent by a
-	 * CMD_RET pdu. In this case, usb_unlink_urb() is not needed. We only
-	 * return the completeness of this unlink request to vhci_hcd.
-	 */
-	stub_enqueue_ret_unlink(sdev, pdu->base.seqnum, 0);
-
-	spin_unlock_irqrestore(&sdev->priv_lock, flags);
-
-	return 0;
-}
-
-static int valid_request(struct stub_device *sdev, struct usbip_header *pdu)
-{
-	struct usbip_device *ud = &sdev->ud;
-	int valid = 0;
-
-	if (pdu->base.devid == sdev->devid) {
-		spin_lock_irq(&ud->lock);
-		if (ud->status == SDEV_ST_USED) {
-			/* A request is valid. */
-			valid = 1;
-		}
-		spin_unlock_irq(&ud->lock);
-	}
-
-	return valid;
-}
-
-static struct stub_priv *stub_priv_alloc(struct stub_device *sdev,
-					 struct usbip_header *pdu)
-{
-	struct stub_priv *priv;
-	struct usbip_device *ud = &sdev->ud;
-	unsigned long flags;
-
-	spin_lock_irqsave(&sdev->priv_lock, flags);
-
-	priv = kmem_cache_zalloc(stub_priv_cache, GFP_ATOMIC);
-	if (!priv) {
-		dev_err(&sdev->interface->dev, "alloc stub_priv\n");
-		spin_unlock_irqrestore(&sdev->priv_lock, flags);
-		usbip_event_add(ud, SDEV_EVENT_ERROR_MALLOC);
-		return NULL;
-	}
-
-	priv->seqnum = pdu->base.seqnum;
-	priv->sdev = sdev;
-
-	/*
-	 * After a stub_priv is linked to a list_head,
-	 * our error handler can free allocated data.
-	 */
-	list_add_tail(&priv->list, &sdev->priv_init);
-
-	spin_unlock_irqrestore(&sdev->priv_lock, flags);
-
-	return priv;
-}
-
-static int get_pipe(struct stub_device *sdev, int epnum, int dir)
-{
-	struct usb_device *udev = sdev->udev;
-	struct usb_host_endpoint *ep;
-	struct usb_endpoint_descriptor *epd = NULL;
-
-	if (dir == USBIP_DIR_IN)
-		ep = udev->ep_in[epnum & 0x7f];
-	else
-		ep = udev->ep_out[epnum & 0x7f];
-	if (!ep) {
-		dev_err(&sdev->interface->dev, "no such endpoint?, %d\n",
-			epnum);
-		BUG();
-	}
-
-	epd = &ep->desc;
-	if (usb_endpoint_xfer_control(epd)) {
-		if (dir == USBIP_DIR_OUT)
-			return usb_sndctrlpipe(udev, epnum);
-		else
-			return usb_rcvctrlpipe(udev, epnum);
-	}
-
-	if (usb_endpoint_xfer_bulk(epd)) {
-		if (dir == USBIP_DIR_OUT)
-			return usb_sndbulkpipe(udev, epnum);
-		else
-			return usb_rcvbulkpipe(udev, epnum);
-	}
-
-	if (usb_endpoint_xfer_int(epd)) {
-		if (dir == USBIP_DIR_OUT)
-			return usb_sndintpipe(udev, epnum);
-		else
-			return usb_rcvintpipe(udev, epnum);
-	}
-
-	if (usb_endpoint_xfer_isoc(epd)) {
-		if (dir == USBIP_DIR_OUT)
-			return usb_sndisocpipe(udev, epnum);
-		else
-			return usb_rcvisocpipe(udev, epnum);
-	}
-
-	/* NOT REACHED */
-	dev_err(&sdev->interface->dev, "get pipe, epnum %d\n", epnum);
-	return 0;
-}
-
-static void masking_bogus_flags(struct urb *urb)
-{
-	int				xfertype;
-	struct usb_device		*dev;
-	struct usb_host_endpoint	*ep;
-	int				is_out;
-	unsigned int	allowed;
-
-	if (!urb || urb->hcpriv || !urb->complete)
-		return;
-	dev = urb->dev;
-	if ((!dev) || (dev->state < USB_STATE_UNAUTHENTICATED))
-		return;
-
-	ep = (usb_pipein(urb->pipe) ? dev->ep_in : dev->ep_out)
-		[usb_pipeendpoint(urb->pipe)];
-	if (!ep)
-		return;
-
-	xfertype = usb_endpoint_type(&ep->desc);
-	if (xfertype == USB_ENDPOINT_XFER_CONTROL) {
-		struct usb_ctrlrequest *setup =
-			(struct usb_ctrlrequest *) urb->setup_packet;
-
-		if (!setup)
-			return;
-		is_out = !(setup->bRequestType & USB_DIR_IN) ||
-			!setup->wLength;
-	} else {
-		is_out = usb_endpoint_dir_out(&ep->desc);
-	}
-
-	/* enforce simple/standard policy */
-	allowed = (URB_NO_TRANSFER_DMA_MAP | URB_NO_INTERRUPT |
-		   URB_DIR_MASK | URB_FREE_BUFFER);
-	switch (xfertype) {
-	case USB_ENDPOINT_XFER_BULK:
-		if (is_out)
-			allowed |= URB_ZERO_PACKET;
-		/* FALLTHROUGH */
-	case USB_ENDPOINT_XFER_CONTROL:
-		allowed |= URB_NO_FSBR;	/* only affects UHCI */
-		/* FALLTHROUGH */
-	default:			/* all non-iso endpoints */
-		if (!is_out)
-			allowed |= URB_SHORT_NOT_OK;
-		break;
-	case USB_ENDPOINT_XFER_ISOC:
-		allowed |= URB_ISO_ASAP;
-		break;
-	}
-	urb->transfer_flags &= allowed;
-}
-
-static void stub_recv_cmd_submit(struct stub_device *sdev,
-				 struct usbip_header *pdu)
-{
-	int ret;
-	struct stub_priv *priv;
-	struct usbip_device *ud = &sdev->ud;
-	struct usb_device *udev = sdev->udev;
-	int pipe = get_pipe(sdev, pdu->base.ep, pdu->base.direction);
-
-	priv = stub_priv_alloc(sdev, pdu);
-	if (!priv)
-		return;
-
-	/* setup a urb */
-	if (usb_pipeisoc(pipe))
-		priv->urb = usb_alloc_urb(pdu->u.cmd_submit.number_of_packets,
-					  GFP_KERNEL);
-	else
-		priv->urb = usb_alloc_urb(0, GFP_KERNEL);
-
-	if (!priv->urb) {
-		dev_err(&sdev->interface->dev, "malloc urb\n");
-		usbip_event_add(ud, SDEV_EVENT_ERROR_MALLOC);
-		return;
-	}
-
-	/* allocate urb transfer buffer, if needed */
-	if (pdu->u.cmd_submit.transfer_buffer_length > 0) {
-		priv->urb->transfer_buffer =
-			kzalloc(pdu->u.cmd_submit.transfer_buffer_length,
-				GFP_KERNEL);
-		if (!priv->urb->transfer_buffer) {
-			usbip_event_add(ud, SDEV_EVENT_ERROR_MALLOC);
-			return;
-		}
-	}
-
-	/* copy urb setup packet */
-	priv->urb->setup_packet = kmemdup(&pdu->u.cmd_submit.setup, 8,
-					  GFP_KERNEL);
-	if (!priv->urb->setup_packet) {
-		dev_err(&sdev->interface->dev, "allocate setup_packet\n");
-		usbip_event_add(ud, SDEV_EVENT_ERROR_MALLOC);
-		return;
-	}
-
-	/* set other members from the base header of pdu */
-	priv->urb->context                = (void *) priv;
-	priv->urb->dev                    = udev;
-	priv->urb->pipe                   = pipe;
-	priv->urb->complete               = stub_complete;
-
-	usbip_pack_pdu(pdu, priv->urb, USBIP_CMD_SUBMIT, 0);
-
-
-	if (usbip_recv_xbuff(ud, priv->urb) < 0)
-		return;
-
-	if (usbip_recv_iso(ud, priv->urb) < 0)
-		return;
-
-	/* no need to submit an intercepted request, but harmless? */
-	tweak_special_requests(priv->urb);
-
-	masking_bogus_flags(priv->urb);
-	/* urb is now ready to submit */
-	ret = usb_submit_urb(priv->urb, GFP_KERNEL);
-
-	if (ret == 0)
-		usbip_dbg_stub_rx("submit urb ok, seqnum %u\n",
-				  pdu->base.seqnum);
-	else {
-		dev_err(&sdev->interface->dev, "submit_urb error, %d\n", ret);
-		usbip_dump_header(pdu);
-		usbip_dump_urb(priv->urb);
-
-		/*
-		 * Pessimistic.
-		 * This connection will be discarded.
-		 */
-		usbip_event_add(ud, SDEV_EVENT_ERROR_SUBMIT);
-	}
-
-	usbip_dbg_stub_rx("Leave\n");
-	return;
-}
-
-/* recv a pdu */
-static void stub_rx_pdu(struct usbip_device *ud)
-{
-	int ret;
-	struct usbip_header pdu;
-	struct stub_device *sdev = container_of(ud, struct stub_device, ud);
-	struct device *dev = &sdev->udev->dev;
-
-	usbip_dbg_stub_rx("Enter\n");
-
-	memset(&pdu, 0, sizeof(pdu));
-
-	/* receive a pdu header */
-	ret = usbip_recv(ud->tcp_socket, &pdu, sizeof(pdu));
-	if (ret != sizeof(pdu)) {
-		dev_err(dev, "recv a header, %d\n", ret);
-		usbip_event_add(ud, SDEV_EVENT_ERROR_TCP);
-		return;
-	}
-
-	usbip_header_correct_endian(&pdu, 0);
-
-	if (usbip_dbg_flag_stub_rx)
-		usbip_dump_header(&pdu);
-
-	if (!valid_request(sdev, &pdu)) {
-		dev_err(dev, "recv invalid request\n");
-		usbip_event_add(ud, SDEV_EVENT_ERROR_TCP);
-		return;
-	}
-
-	switch (pdu.base.command) {
-	case USBIP_CMD_UNLINK:
-		stub_recv_cmd_unlink(sdev, &pdu);
-		break;
-
-	case USBIP_CMD_SUBMIT:
-		stub_recv_cmd_submit(sdev, &pdu);
-		break;
-
-	default:
-		/* NOTREACHED */
-		dev_err(dev, "unknown pdu\n");
-		usbip_event_add(ud, SDEV_EVENT_ERROR_TCP);
-		break;
-	}
-}
-
-int stub_rx_loop(void *data)
-{
-	struct usbip_device *ud = data;
-
-	while (!kthread_should_stop()) {
-		if (usbip_event_happened(ud))
-			break;
-
-		stub_rx_pdu(ud);
-	}
-
-	return 0;
-}
diff --git a/drivers/staging/usbip/stub_tx.c b/drivers/staging/usbip/stub_tx.c
deleted file mode 100644
index cd5326a..0000000
--- a/drivers/staging/usbip/stub_tx.c
+++ /dev/null
@@ -1,397 +0,0 @@
-/*
- * Copyright (C) 2003-2008 Takahiro Hirofuchi
- *
- * This is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
- * USA.
- */
-
-#include <linux/kthread.h>
-#include <linux/socket.h>
-
-#include "usbip_common.h"
-#include "stub.h"
-
-static void stub_free_priv_and_urb(struct stub_priv *priv)
-{
-	struct urb *urb = priv->urb;
-
-	kfree(urb->setup_packet);
-	kfree(urb->transfer_buffer);
-	list_del(&priv->list);
-	kmem_cache_free(stub_priv_cache, priv);
-	usb_free_urb(urb);
-}
-
-/* be in spin_lock_irqsave(&sdev->priv_lock, flags) */
-void stub_enqueue_ret_unlink(struct stub_device *sdev, __u32 seqnum,
-			     __u32 status)
-{
-	struct stub_unlink *unlink;
-
-	unlink = kzalloc(sizeof(struct stub_unlink), GFP_ATOMIC);
-	if (!unlink) {
-		usbip_event_add(&sdev->ud, VDEV_EVENT_ERROR_MALLOC);
-		return;
-	}
-
-	unlink->seqnum = seqnum;
-	unlink->status = status;
-
-	list_add_tail(&unlink->list, &sdev->unlink_tx);
-}
-
-/**
- * stub_complete - completion handler of a usbip urb
- * @urb: pointer to the urb completed
- *
- * When a urb has completed, the USB core driver calls this function mostly in
- * the interrupt context. To return the result of a urb, the completed urb is
- * linked to the pending list of returning.
- *
- */
-void stub_complete(struct urb *urb)
-{
-	struct stub_priv *priv = (struct stub_priv *) urb->context;
-	struct stub_device *sdev = priv->sdev;
-	unsigned long flags;
-
-	usbip_dbg_stub_tx("complete! status %d\n", urb->status);
-
-	switch (urb->status) {
-	case 0:
-		/* OK */
-		break;
-	case -ENOENT:
-		dev_info(&urb->dev->dev, "stopped by a call to usb_kill_urb() "
-			 "because of cleaning up a virtual connection\n");
-		return;
-	case -ECONNRESET:
-		dev_info(&urb->dev->dev, "unlinked by a call to "
-			 "usb_unlink_urb()\n");
-		break;
-	case -EPIPE:
-		dev_info(&urb->dev->dev, "endpoint %d is stalled\n",
-			 usb_pipeendpoint(urb->pipe));
-		break;
-	case -ESHUTDOWN:
-		dev_info(&urb->dev->dev, "device removed?\n");
-		break;
-	default:
-		dev_info(&urb->dev->dev, "urb completion with non-zero status "
-			 "%d\n", urb->status);
-		break;
-	}
-
-	/* link a urb to the queue of tx. */
-	spin_lock_irqsave(&sdev->priv_lock, flags);
-	if (priv->unlinking) {
-		stub_enqueue_ret_unlink(sdev, priv->seqnum, urb->status);
-		stub_free_priv_and_urb(priv);
-	} else {
-		list_move_tail(&priv->list, &sdev->priv_tx);
-	}
-	spin_unlock_irqrestore(&sdev->priv_lock, flags);
-
-	/* wake up tx_thread */
-	wake_up(&sdev->tx_waitq);
-}
-
-static inline void setup_base_pdu(struct usbip_header_basic *base,
-				  __u32 command, __u32 seqnum)
-{
-	base->command	= command;
-	base->seqnum	= seqnum;
-	base->devid	= 0;
-	base->ep	= 0;
-	base->direction = 0;
-}
-
-static void setup_ret_submit_pdu(struct usbip_header *rpdu, struct urb *urb)
-{
-	struct stub_priv *priv = (struct stub_priv *) urb->context;
-
-	setup_base_pdu(&rpdu->base, USBIP_RET_SUBMIT, priv->seqnum);
-	usbip_pack_pdu(rpdu, urb, USBIP_RET_SUBMIT, 1);
-}
-
-static void setup_ret_unlink_pdu(struct usbip_header *rpdu,
-				 struct stub_unlink *unlink)
-{
-	setup_base_pdu(&rpdu->base, USBIP_RET_UNLINK, unlink->seqnum);
-	rpdu->u.ret_unlink.status = unlink->status;
-}
-
-static struct stub_priv *dequeue_from_priv_tx(struct stub_device *sdev)
-{
-	unsigned long flags;
-	struct stub_priv *priv, *tmp;
-
-	spin_lock_irqsave(&sdev->priv_lock, flags);
-
-	list_for_each_entry_safe(priv, tmp, &sdev->priv_tx, list) {
-		list_move_tail(&priv->list, &sdev->priv_free);
-		spin_unlock_irqrestore(&sdev->priv_lock, flags);
-		return priv;
-	}
-
-	spin_unlock_irqrestore(&sdev->priv_lock, flags);
-
-	return NULL;
-}
-
-static int stub_send_ret_submit(struct stub_device *sdev)
-{
-	unsigned long flags;
-	struct stub_priv *priv, *tmp;
-
-	struct msghdr msg;
-	size_t txsize;
-
-	size_t total_size = 0;
-
-	while ((priv = dequeue_from_priv_tx(sdev)) != NULL) {
-		int ret;
-		struct urb *urb = priv->urb;
-		struct usbip_header pdu_header;
-		struct usbip_iso_packet_descriptor *iso_buffer = NULL;
-		struct kvec *iov = NULL;
-		int iovnum = 0;
-
-		txsize = 0;
-		memset(&pdu_header, 0, sizeof(pdu_header));
-		memset(&msg, 0, sizeof(msg));
-
-		if (usb_pipetype(urb->pipe) == PIPE_ISOCHRONOUS)
-			iovnum = 2 + urb->number_of_packets;
-		else
-			iovnum = 2;
-
-		iov = kzalloc(iovnum * sizeof(struct kvec), GFP_KERNEL);
-
-		if (!iov) {
-			usbip_event_add(&sdev->ud, SDEV_EVENT_ERROR_MALLOC);
-			return -1;
-		}
-
-		iovnum = 0;
-
-		/* 1. setup usbip_header */
-		setup_ret_submit_pdu(&pdu_header, urb);
-		usbip_dbg_stub_tx("setup txdata seqnum: %d urb: %p\n",
-				  pdu_header.base.seqnum, urb);
-		usbip_header_correct_endian(&pdu_header, 1);
-
-		iov[iovnum].iov_base = &pdu_header;
-		iov[iovnum].iov_len  = sizeof(pdu_header);
-		iovnum++;
-		txsize += sizeof(pdu_header);
-
-		/* 2. setup transfer buffer */
-		if (usb_pipein(urb->pipe) &&
-		    usb_pipetype(urb->pipe) != PIPE_ISOCHRONOUS &&
-		    urb->actual_length > 0) {
-			iov[iovnum].iov_base = urb->transfer_buffer;
-			iov[iovnum].iov_len  = urb->actual_length;
-			iovnum++;
-			txsize += urb->actual_length;
-		} else if (usb_pipein(urb->pipe) &&
-			   usb_pipetype(urb->pipe) == PIPE_ISOCHRONOUS) {
-			/*
-			 * For isochronous packets: actual length is the sum of
-			 * the actual length of the individual, packets, but as
-			 * the packet offsets are not changed there will be
-			 * padding between the packets. To optimally use the
-			 * bandwidth the padding is not transmitted.
-			 */
-
-			int i;
-			for (i = 0; i < urb->number_of_packets; i++) {
-				iov[iovnum].iov_base = urb->transfer_buffer +
-					urb->iso_frame_desc[i].offset;
-				iov[iovnum].iov_len =
-					urb->iso_frame_desc[i].actual_length;
-				iovnum++;
-				txsize += urb->iso_frame_desc[i].actual_length;
-			}
-
-			if (txsize != sizeof(pdu_header) + urb->actual_length) {
-				dev_err(&sdev->interface->dev,
-					"actual length of urb %d does not "
-					"match iso packet sizes %zu\n",
-					urb->actual_length,
-					txsize-sizeof(pdu_header));
-				kfree(iov);
-				usbip_event_add(&sdev->ud,
-						SDEV_EVENT_ERROR_TCP);
-			   return -1;
-			}
-		}
-
-		/* 3. setup iso_packet_descriptor */
-		if (usb_pipetype(urb->pipe) == PIPE_ISOCHRONOUS) {
-			ssize_t len = 0;
-
-			iso_buffer = usbip_alloc_iso_desc_pdu(urb, &len);
-			if (!iso_buffer) {
-				usbip_event_add(&sdev->ud,
-						SDEV_EVENT_ERROR_MALLOC);
-				kfree(iov);
-				return -1;
-			}
-
-			iov[iovnum].iov_base = iso_buffer;
-			iov[iovnum].iov_len  = len;
-			txsize += len;
-			iovnum++;
-		}
-
-		ret = kernel_sendmsg(sdev->ud.tcp_socket, &msg,
-						iov,  iovnum, txsize);
-		if (ret != txsize) {
-			dev_err(&sdev->interface->dev,
-				"sendmsg failed!, retval %d for %zd\n",
-				ret, txsize);
-			kfree(iov);
-			kfree(iso_buffer);
-			usbip_event_add(&sdev->ud, SDEV_EVENT_ERROR_TCP);
-			return -1;
-		}
-
-		kfree(iov);
-		kfree(iso_buffer);
-
-		total_size += txsize;
-	}
-
-	spin_lock_irqsave(&sdev->priv_lock, flags);
-	list_for_each_entry_safe(priv, tmp, &sdev->priv_free, list) {
-		stub_free_priv_and_urb(priv);
-	}
-	spin_unlock_irqrestore(&sdev->priv_lock, flags);
-
-	return total_size;
-}
-
-static struct stub_unlink *dequeue_from_unlink_tx(struct stub_device *sdev)
-{
-	unsigned long flags;
-	struct stub_unlink *unlink, *tmp;
-
-	spin_lock_irqsave(&sdev->priv_lock, flags);
-
-	list_for_each_entry_safe(unlink, tmp, &sdev->unlink_tx, list) {
-		list_move_tail(&unlink->list, &sdev->unlink_free);
-		spin_unlock_irqrestore(&sdev->priv_lock, flags);
-		return unlink;
-	}
-
-	spin_unlock_irqrestore(&sdev->priv_lock, flags);
-
-	return NULL;
-}
-
-static int stub_send_ret_unlink(struct stub_device *sdev)
-{
-	unsigned long flags;
-	struct stub_unlink *unlink, *tmp;
-
-	struct msghdr msg;
-	struct kvec iov[1];
-	size_t txsize;
-
-	size_t total_size = 0;
-
-	while ((unlink = dequeue_from_unlink_tx(sdev)) != NULL) {
-		int ret;
-		struct usbip_header pdu_header;
-
-		txsize = 0;
-		memset(&pdu_header, 0, sizeof(pdu_header));
-		memset(&msg, 0, sizeof(msg));
-		memset(&iov, 0, sizeof(iov));
-
-		usbip_dbg_stub_tx("setup ret unlink %lu\n", unlink->seqnum);
-
-		/* 1. setup usbip_header */
-		setup_ret_unlink_pdu(&pdu_header, unlink);
-		usbip_header_correct_endian(&pdu_header, 1);
-
-		iov[0].iov_base = &pdu_header;
-		iov[0].iov_len  = sizeof(pdu_header);
-		txsize += sizeof(pdu_header);
-
-		ret = kernel_sendmsg(sdev->ud.tcp_socket, &msg, iov,
-				     1, txsize);
-		if (ret != txsize) {
-			dev_err(&sdev->interface->dev,
-				"sendmsg failed!, retval %d for %zd\n",
-				ret, txsize);
-			usbip_event_add(&sdev->ud, SDEV_EVENT_ERROR_TCP);
-			return -1;
-		}
-
-		usbip_dbg_stub_tx("send txdata\n");
-		total_size += txsize;
-	}
-
-	spin_lock_irqsave(&sdev->priv_lock, flags);
-
-	list_for_each_entry_safe(unlink, tmp, &sdev->unlink_free, list) {
-		list_del(&unlink->list);
-		kfree(unlink);
-	}
-
-	spin_unlock_irqrestore(&sdev->priv_lock, flags);
-
-	return total_size;
-}
-
-int stub_tx_loop(void *data)
-{
-	struct usbip_device *ud = data;
-	struct stub_device *sdev = container_of(ud, struct stub_device, ud);
-
-	while (!kthread_should_stop()) {
-		if (usbip_event_happened(ud))
-			break;
-
-		/*
-		 * send_ret_submit comes earlier than send_ret_unlink.  stub_rx
-		 * looks at only priv_init queue. If the completion of a URB is
-		 * earlier than the receive of CMD_UNLINK, priv is moved to
-		 * priv_tx queue and stub_rx does not find the target priv. In
-		 * this case, vhci_rx receives the result of the submit request
-		 * and then receives the result of the unlink request. The
-		 * result of the submit is given back to the usbcore as the
-		 * completion of the unlink request. The request of the
-		 * unlink is ignored. This is ok because a driver who calls
-		 * usb_unlink_urb() understands the unlink was too late by
-		 * getting the status of the given-backed URB which has the
-		 * status of usb_submit_urb().
-		 */
-		if (stub_send_ret_submit(sdev) < 0)
-			break;
-
-		if (stub_send_ret_unlink(sdev) < 0)
-			break;
-
-		wait_event_interruptible(sdev->tx_waitq,
-					 (!list_empty(&sdev->priv_tx) ||
-					  !list_empty(&sdev->unlink_tx) ||
-					  kthread_should_stop()));
-	}
-
-	return 0;
-}
diff --git a/drivers/staging/usbip/uapi/usbip.h b/drivers/staging/usbip/uapi/usbip.h
deleted file mode 100644
index fa5db30..0000000
--- a/drivers/staging/usbip/uapi/usbip.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/*
- *	usbip.h
- *
- *	USBIP uapi defines and function prototypes etc.
-*/
-
-#ifndef _UAPI_LINUX_USBIP_H
-#define _UAPI_LINUX_USBIP_H
-
-/* usbip device status - exported in usbip device sysfs status */
-enum usbip_device_status {
-	/* sdev is available. */
-	SDEV_ST_AVAILABLE = 0x01,
-	/* sdev is now used. */
-	SDEV_ST_USED,
-	/* sdev is unusable because of a fatal error. */
-	SDEV_ST_ERROR,
-
-	/* vdev does not connect a remote device. */
-	VDEV_ST_NULL,
-	/* vdev is used, but the USB address is not assigned yet */
-	VDEV_ST_NOTASSIGNED,
-	VDEV_ST_USED,
-	VDEV_ST_ERROR
-};
-#endif /* _UAPI_LINUX_USBIP_H */
diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
deleted file mode 100644
index 2a11233..0000000
--- a/drivers/staging/usbip/usbip_common.c
+++ /dev/null
@@ -1,803 +0,0 @@
-/*
- * Copyright (C) 2003-2008 Takahiro Hirofuchi
- *
- * This is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
- * USA.
- */
-
-#include <asm/byteorder.h>
-#include <linux/file.h>
-#include <linux/fs.h>
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/stat.h>
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <net/sock.h>
-
-#include "usbip_common.h"
-
-#define DRIVER_AUTHOR "Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>"
-#define DRIVER_DESC "USB/IP Core"
-
-#ifdef CONFIG_USBIP_DEBUG
-unsigned long usbip_debug_flag = 0xffffffff;
-#else
-unsigned long usbip_debug_flag;
-#endif
-EXPORT_SYMBOL_GPL(usbip_debug_flag);
-module_param(usbip_debug_flag, ulong, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(usbip_debug_flag, "debug flags (defined in usbip_common.h)");
-
-/* FIXME */
-struct device_attribute dev_attr_usbip_debug;
-EXPORT_SYMBOL_GPL(dev_attr_usbip_debug);
-
-static ssize_t usbip_debug_show(struct device *dev,
-				struct device_attribute *attr, char *buf)
-{
-	return sprintf(buf, "%lx\n", usbip_debug_flag);
-}
-
-static ssize_t usbip_debug_store(struct device *dev,
-				 struct device_attribute *attr, const char *buf,
-				 size_t count)
-{
-	if (sscanf(buf, "%lx", &usbip_debug_flag) != 1)
-		return -EINVAL;
-	return count;
-}
-DEVICE_ATTR_RW(usbip_debug);
-
-static void usbip_dump_buffer(char *buff, int bufflen)
-{
-	print_hex_dump(KERN_DEBUG, "usbip-core", DUMP_PREFIX_OFFSET, 16, 4,
-		       buff, bufflen, false);
-}
-
-static void usbip_dump_pipe(unsigned int p)
-{
-	unsigned char type = usb_pipetype(p);
-	unsigned char ep   = usb_pipeendpoint(p);
-	unsigned char dev  = usb_pipedevice(p);
-	unsigned char dir  = usb_pipein(p);
-
-	pr_debug("dev(%d) ep(%d) [%s] ", dev, ep, dir ? "IN" : "OUT");
-
-	switch (type) {
-	case PIPE_ISOCHRONOUS:
-		pr_debug("ISO\n");
-		break;
-	case PIPE_INTERRUPT:
-		pr_debug("INT\n");
-		break;
-	case PIPE_CONTROL:
-		pr_debug("CTRL\n");
-		break;
-	case PIPE_BULK:
-		pr_debug("BULK\n");
-		break;
-	default:
-		pr_debug("ERR\n");
-		break;
-	}
-}
-
-static void usbip_dump_usb_device(struct usb_device *udev)
-{
-	struct device *dev = &udev->dev;
-	int i;
-
-	dev_dbg(dev, "       devnum(%d) devpath(%s) usb speed(%s)",
-		udev->devnum, udev->devpath, usb_speed_string(udev->speed));
-
-	pr_debug("tt %p, ttport %d\n", udev->tt, udev->ttport);
-
-	dev_dbg(dev, "                    ");
-	for (i = 0; i < 16; i++)
-		pr_debug(" %2u", i);
-	pr_debug("\n");
-
-	dev_dbg(dev, "       toggle0(IN) :");
-	for (i = 0; i < 16; i++)
-		pr_debug(" %2u", (udev->toggle[0] & (1 << i)) ? 1 : 0);
-	pr_debug("\n");
-
-	dev_dbg(dev, "       toggle1(OUT):");
-	for (i = 0; i < 16; i++)
-		pr_debug(" %2u", (udev->toggle[1] & (1 << i)) ? 1 : 0);
-	pr_debug("\n");
-
-	dev_dbg(dev, "       epmaxp_in   :");
-	for (i = 0; i < 16; i++) {
-		if (udev->ep_in[i])
-			pr_debug(" %2u",
-			    le16_to_cpu(udev->ep_in[i]->desc.wMaxPacketSize));
-	}
-	pr_debug("\n");
-
-	dev_dbg(dev, "       epmaxp_out  :");
-	for (i = 0; i < 16; i++) {
-		if (udev->ep_out[i])
-			pr_debug(" %2u",
-			    le16_to_cpu(udev->ep_out[i]->desc.wMaxPacketSize));
-	}
-	pr_debug("\n");
-
-	dev_dbg(dev, "parent %p, bus %p\n", udev->parent, udev->bus);
-
-	dev_dbg(dev,
-		"descriptor %p, config %p, actconfig %p, rawdescriptors %p\n",
-		&udev->descriptor, udev->config,
-		udev->actconfig, udev->rawdescriptors);
-
-	dev_dbg(dev, "have_langid %d, string_langid %d\n",
-		udev->have_langid, udev->string_langid);
-
-	dev_dbg(dev, "maxchild %d\n", udev->maxchild);
-}
-
-static void usbip_dump_request_type(__u8 rt)
-{
-	switch (rt & USB_RECIP_MASK) {
-	case USB_RECIP_DEVICE:
-		pr_debug("DEVICE");
-		break;
-	case USB_RECIP_INTERFACE:
-		pr_debug("INTERF");
-		break;
-	case USB_RECIP_ENDPOINT:
-		pr_debug("ENDPOI");
-		break;
-	case USB_RECIP_OTHER:
-		pr_debug("OTHER ");
-		break;
-	default:
-		pr_debug("------");
-		break;
-	}
-}
-
-static void usbip_dump_usb_ctrlrequest(struct usb_ctrlrequest *cmd)
-{
-	if (!cmd) {
-		pr_debug("       : null pointer\n");
-		return;
-	}
-
-	pr_debug("       ");
-	pr_debug("bRequestType(%02X) bRequest(%02X) wValue(%04X) wIndex(%04X) "
-		 "wLength(%04X) ", cmd->bRequestType, cmd->bRequest,
-		 cmd->wValue, cmd->wIndex, cmd->wLength);
-	pr_debug("\n       ");
-
-	if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_STANDARD) {
-		pr_debug("STANDARD ");
-		switch (cmd->bRequest) {
-		case USB_REQ_GET_STATUS:
-			pr_debug("GET_STATUS\n");
-			break;
-		case USB_REQ_CLEAR_FEATURE:
-			pr_debug("CLEAR_FEAT\n");
-			break;
-		case USB_REQ_SET_FEATURE:
-			pr_debug("SET_FEAT\n");
-			break;
-		case USB_REQ_SET_ADDRESS:
-			pr_debug("SET_ADDRRS\n");
-			break;
-		case USB_REQ_GET_DESCRIPTOR:
-			pr_debug("GET_DESCRI\n");
-			break;
-		case USB_REQ_SET_DESCRIPTOR:
-			pr_debug("SET_DESCRI\n");
-			break;
-		case USB_REQ_GET_CONFIGURATION:
-			pr_debug("GET_CONFIG\n");
-			break;
-		case USB_REQ_SET_CONFIGURATION:
-			pr_debug("SET_CONFIG\n");
-			break;
-		case USB_REQ_GET_INTERFACE:
-			pr_debug("GET_INTERF\n");
-			break;
-		case USB_REQ_SET_INTERFACE:
-			pr_debug("SET_INTERF\n");
-			break;
-		case USB_REQ_SYNCH_FRAME:
-			pr_debug("SYNC_FRAME\n");
-			break;
-		default:
-			pr_debug("REQ(%02X)\n", cmd->bRequest);
-			break;
-		}
-		usbip_dump_request_type(cmd->bRequestType);
-	} else if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_CLASS) {
-		pr_debug("CLASS\n");
-	} else if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_VENDOR) {
-		pr_debug("VENDOR\n");
-	} else if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_RESERVED) {
-		pr_debug("RESERVED\n");
-	}
-}
-
-void usbip_dump_urb(struct urb *urb)
-{
-	struct device *dev;
-
-	if (!urb) {
-		pr_debug("urb: null pointer!!\n");
-		return;
-	}
-
-	if (!urb->dev) {
-		pr_debug("urb->dev: null pointer!!\n");
-		return;
-	}
-
-	dev = &urb->dev->dev;
-
-	dev_dbg(dev, "   urb                   :%p\n", urb);
-	dev_dbg(dev, "   dev                   :%p\n", urb->dev);
-
-	usbip_dump_usb_device(urb->dev);
-
-	dev_dbg(dev, "   pipe                  :%08x ", urb->pipe);
-
-	usbip_dump_pipe(urb->pipe);
-
-	dev_dbg(dev, "   status                :%d\n", urb->status);
-	dev_dbg(dev, "   transfer_flags        :%08X\n", urb->transfer_flags);
-	dev_dbg(dev, "   transfer_buffer       :%p\n", urb->transfer_buffer);
-	dev_dbg(dev, "   transfer_buffer_length:%d\n",
-						urb->transfer_buffer_length);
-	dev_dbg(dev, "   actual_length         :%d\n", urb->actual_length);
-	dev_dbg(dev, "   setup_packet          :%p\n", urb->setup_packet);
-
-	if (urb->setup_packet && usb_pipetype(urb->pipe) == PIPE_CONTROL)
-		usbip_dump_usb_ctrlrequest(
-			(struct usb_ctrlrequest *)urb->setup_packet);
-
-	dev_dbg(dev, "   start_frame           :%d\n", urb->start_frame);
-	dev_dbg(dev, "   number_of_packets     :%d\n", urb->number_of_packets);
-	dev_dbg(dev, "   interval              :%d\n", urb->interval);
-	dev_dbg(dev, "   error_count           :%d\n", urb->error_count);
-	dev_dbg(dev, "   context               :%p\n", urb->context);
-	dev_dbg(dev, "   complete              :%p\n", urb->complete);
-}
-EXPORT_SYMBOL_GPL(usbip_dump_urb);
-
-void usbip_dump_header(struct usbip_header *pdu)
-{
-	pr_debug("BASE: cmd %u seq %u devid %u dir %u ep %u\n",
-		 pdu->base.command,
-		 pdu->base.seqnum,
-		 pdu->base.devid,
-		 pdu->base.direction,
-		 pdu->base.ep);
-
-	switch (pdu->base.command) {
-	case USBIP_CMD_SUBMIT:
-		pr_debug("USBIP_CMD_SUBMIT: "
-			 "x_flags %u x_len %u sf %u #p %d iv %d\n",
-			 pdu->u.cmd_submit.transfer_flags,
-			 pdu->u.cmd_submit.transfer_buffer_length,
-			 pdu->u.cmd_submit.start_frame,
-			 pdu->u.cmd_submit.number_of_packets,
-			 pdu->u.cmd_submit.interval);
-		break;
-	case USBIP_CMD_UNLINK:
-		pr_debug("USBIP_CMD_UNLINK: seq %u\n",
-			 pdu->u.cmd_unlink.seqnum);
-		break;
-	case USBIP_RET_SUBMIT:
-		pr_debug("USBIP_RET_SUBMIT: st %d al %u sf %d #p %d ec %d\n",
-			 pdu->u.ret_submit.status,
-			 pdu->u.ret_submit.actual_length,
-			 pdu->u.ret_submit.start_frame,
-			 pdu->u.ret_submit.number_of_packets,
-			 pdu->u.ret_submit.error_count);
-		break;
-	case USBIP_RET_UNLINK:
-		pr_debug("USBIP_RET_UNLINK: status %d\n",
-			 pdu->u.ret_unlink.status);
-		break;
-	default:
-		/* NOT REACHED */
-		pr_err("unknown command\n");
-		break;
-	}
-}
-EXPORT_SYMBOL_GPL(usbip_dump_header);
-
-/* Receive data over TCP/IP. */
-int usbip_recv(struct socket *sock, void *buf, int size)
-{
-	int result;
-	struct msghdr msg;
-	struct kvec iov;
-	int total = 0;
-
-	/* for blocks of if (usbip_dbg_flag_xmit) */
-	char *bp = buf;
-	int osize = size;
-
-	usbip_dbg_xmit("enter\n");
-
-	if (!sock || !buf || !size) {
-		pr_err("invalid arg, sock %p buff %p size %d\n", sock, buf,
-		       size);
-		return -EINVAL;
-	}
-
-	do {
-		sock->sk->sk_allocation = GFP_NOIO;
-		iov.iov_base    = buf;
-		iov.iov_len     = size;
-		msg.msg_name    = NULL;
-		msg.msg_namelen = 0;
-		msg.msg_control = NULL;
-		msg.msg_controllen = 0;
-		msg.msg_flags      = MSG_NOSIGNAL;
-
-		result = kernel_recvmsg(sock, &msg, &iov, 1, size, MSG_WAITALL);
-		if (result <= 0) {
-			pr_debug("receive sock %p buf %p size %u ret %d total %d\n",
-				 sock, buf, size, result, total);
-			goto err;
-		}
-
-		size -= result;
-		buf += result;
-		total += result;
-	} while (size > 0);
-
-	if (usbip_dbg_flag_xmit) {
-		if (!in_interrupt())
-			pr_debug("%-10s:", current->comm);
-		else
-			pr_debug("interrupt  :");
-
-		pr_debug("receiving....\n");
-		usbip_dump_buffer(bp, osize);
-		pr_debug("received, osize %d ret %d size %d total %d\n",
-			 osize, result, size, total);
-	}
-
-	return total;
-
-err:
-	return result;
-}
-EXPORT_SYMBOL_GPL(usbip_recv);
-
-struct socket *sockfd_to_socket(unsigned int sockfd)
-{
-	struct socket *socket;
-	struct file *file;
-	struct inode *inode;
-
-	file = fget(sockfd);
-	if (!file) {
-		pr_err("invalid sockfd\n");
-		return NULL;
-	}
-
-	inode = file_inode(file);
-
-	if (!inode || !S_ISSOCK(inode->i_mode)) {
-		fput(file);
-		return NULL;
-	}
-
-	socket = SOCKET_I(inode);
-
-	return socket;
-}
-EXPORT_SYMBOL_GPL(sockfd_to_socket);
-
-/* there may be more cases to tweak the flags. */
-static unsigned int tweak_transfer_flags(unsigned int flags)
-{
-	flags &= ~URB_NO_TRANSFER_DMA_MAP;
-	return flags;
-}
-
-static void usbip_pack_cmd_submit(struct usbip_header *pdu, struct urb *urb,
-				  int pack)
-{
-	struct usbip_header_cmd_submit *spdu = &pdu->u.cmd_submit;
-
-	/*
-	 * Some members are not still implemented in usbip. I hope this issue
-	 * will be discussed when usbip is ported to other operating systems.
-	 */
-	if (pack) {
-		spdu->transfer_flags =
-			tweak_transfer_flags(urb->transfer_flags);
-		spdu->transfer_buffer_length	= urb->transfer_buffer_length;
-		spdu->start_frame		= urb->start_frame;
-		spdu->number_of_packets		= urb->number_of_packets;
-		spdu->interval			= urb->interval;
-	} else  {
-		urb->transfer_flags         = spdu->transfer_flags;
-		urb->transfer_buffer_length = spdu->transfer_buffer_length;
-		urb->start_frame            = spdu->start_frame;
-		urb->number_of_packets      = spdu->number_of_packets;
-		urb->interval               = spdu->interval;
-	}
-}
-
-static void usbip_pack_ret_submit(struct usbip_header *pdu, struct urb *urb,
-				  int pack)
-{
-	struct usbip_header_ret_submit *rpdu = &pdu->u.ret_submit;
-
-	if (pack) {
-		rpdu->status		= urb->status;
-		rpdu->actual_length	= urb->actual_length;
-		rpdu->start_frame	= urb->start_frame;
-		rpdu->number_of_packets = urb->number_of_packets;
-		rpdu->error_count	= urb->error_count;
-	} else {
-		urb->status		= rpdu->status;
-		urb->actual_length	= rpdu->actual_length;
-		urb->start_frame	= rpdu->start_frame;
-		urb->number_of_packets = rpdu->number_of_packets;
-		urb->error_count	= rpdu->error_count;
-	}
-}
-
-void usbip_pack_pdu(struct usbip_header *pdu, struct urb *urb, int cmd,
-		    int pack)
-{
-	switch (cmd) {
-	case USBIP_CMD_SUBMIT:
-		usbip_pack_cmd_submit(pdu, urb, pack);
-		break;
-	case USBIP_RET_SUBMIT:
-		usbip_pack_ret_submit(pdu, urb, pack);
-		break;
-	default:
-		/* NOT REACHED */
-		pr_err("unknown command\n");
-		break;
-	}
-}
-EXPORT_SYMBOL_GPL(usbip_pack_pdu);
-
-static void correct_endian_basic(struct usbip_header_basic *base, int send)
-{
-	if (send) {
-		base->command	= cpu_to_be32(base->command);
-		base->seqnum	= cpu_to_be32(base->seqnum);
-		base->devid	= cpu_to_be32(base->devid);
-		base->direction	= cpu_to_be32(base->direction);
-		base->ep	= cpu_to_be32(base->ep);
-	} else {
-		base->command	= be32_to_cpu(base->command);
-		base->seqnum	= be32_to_cpu(base->seqnum);
-		base->devid	= be32_to_cpu(base->devid);
-		base->direction	= be32_to_cpu(base->direction);
-		base->ep	= be32_to_cpu(base->ep);
-	}
-}
-
-static void correct_endian_cmd_submit(struct usbip_header_cmd_submit *pdu,
-				      int send)
-{
-	if (send) {
-		pdu->transfer_flags = cpu_to_be32(pdu->transfer_flags);
-
-		cpu_to_be32s(&pdu->transfer_buffer_length);
-		cpu_to_be32s(&pdu->start_frame);
-		cpu_to_be32s(&pdu->number_of_packets);
-		cpu_to_be32s(&pdu->interval);
-	} else {
-		pdu->transfer_flags = be32_to_cpu(pdu->transfer_flags);
-
-		be32_to_cpus(&pdu->transfer_buffer_length);
-		be32_to_cpus(&pdu->start_frame);
-		be32_to_cpus(&pdu->number_of_packets);
-		be32_to_cpus(&pdu->interval);
-	}
-}
-
-static void correct_endian_ret_submit(struct usbip_header_ret_submit *pdu,
-				      int send)
-{
-	if (send) {
-		cpu_to_be32s(&pdu->status);
-		cpu_to_be32s(&pdu->actual_length);
-		cpu_to_be32s(&pdu->start_frame);
-		cpu_to_be32s(&pdu->number_of_packets);
-		cpu_to_be32s(&pdu->error_count);
-	} else {
-		be32_to_cpus(&pdu->status);
-		be32_to_cpus(&pdu->actual_length);
-		be32_to_cpus(&pdu->start_frame);
-		be32_to_cpus(&pdu->number_of_packets);
-		be32_to_cpus(&pdu->error_count);
-	}
-}
-
-static void correct_endian_cmd_unlink(struct usbip_header_cmd_unlink *pdu,
-				      int send)
-{
-	if (send)
-		pdu->seqnum = cpu_to_be32(pdu->seqnum);
-	else
-		pdu->seqnum = be32_to_cpu(pdu->seqnum);
-}
-
-static void correct_endian_ret_unlink(struct usbip_header_ret_unlink *pdu,
-				      int send)
-{
-	if (send)
-		cpu_to_be32s(&pdu->status);
-	else
-		be32_to_cpus(&pdu->status);
-}
-
-void usbip_header_correct_endian(struct usbip_header *pdu, int send)
-{
-	__u32 cmd = 0;
-
-	if (send)
-		cmd = pdu->base.command;
-
-	correct_endian_basic(&pdu->base, send);
-
-	if (!send)
-		cmd = pdu->base.command;
-
-	switch (cmd) {
-	case USBIP_CMD_SUBMIT:
-		correct_endian_cmd_submit(&pdu->u.cmd_submit, send);
-		break;
-	case USBIP_RET_SUBMIT:
-		correct_endian_ret_submit(&pdu->u.ret_submit, send);
-		break;
-	case USBIP_CMD_UNLINK:
-		correct_endian_cmd_unlink(&pdu->u.cmd_unlink, send);
-		break;
-	case USBIP_RET_UNLINK:
-		correct_endian_ret_unlink(&pdu->u.ret_unlink, send);
-		break;
-	default:
-		/* NOT REACHED */
-		pr_err("unknown command\n");
-		break;
-	}
-}
-EXPORT_SYMBOL_GPL(usbip_header_correct_endian);
-
-static void usbip_iso_packet_correct_endian(
-		struct usbip_iso_packet_descriptor *iso, int send)
-{
-	/* does not need all members. but copy all simply. */
-	if (send) {
-		iso->offset	= cpu_to_be32(iso->offset);
-		iso->length	= cpu_to_be32(iso->length);
-		iso->status	= cpu_to_be32(iso->status);
-		iso->actual_length = cpu_to_be32(iso->actual_length);
-	} else {
-		iso->offset	= be32_to_cpu(iso->offset);
-		iso->length	= be32_to_cpu(iso->length);
-		iso->status	= be32_to_cpu(iso->status);
-		iso->actual_length = be32_to_cpu(iso->actual_length);
-	}
-}
-
-static void usbip_pack_iso(struct usbip_iso_packet_descriptor *iso,
-			   struct usb_iso_packet_descriptor *uiso, int pack)
-{
-	if (pack) {
-		iso->offset		= uiso->offset;
-		iso->length		= uiso->length;
-		iso->status		= uiso->status;
-		iso->actual_length	= uiso->actual_length;
-	} else {
-		uiso->offset		= iso->offset;
-		uiso->length		= iso->length;
-		uiso->status		= iso->status;
-		uiso->actual_length	= iso->actual_length;
-	}
-}
-
-/* must free buffer */
-struct usbip_iso_packet_descriptor*
-usbip_alloc_iso_desc_pdu(struct urb *urb, ssize_t *bufflen)
-{
-	struct usbip_iso_packet_descriptor *iso;
-	int np = urb->number_of_packets;
-	ssize_t size = np * sizeof(*iso);
-	int i;
-
-	iso = kzalloc(size, GFP_KERNEL);
-	if (!iso)
-		return NULL;
-
-	for (i = 0; i < np; i++) {
-		usbip_pack_iso(&iso[i], &urb->iso_frame_desc[i], 1);
-		usbip_iso_packet_correct_endian(&iso[i], 1);
-	}
-
-	*bufflen = size;
-
-	return iso;
-}
-EXPORT_SYMBOL_GPL(usbip_alloc_iso_desc_pdu);
-
-/* some members of urb must be substituted before. */
-int usbip_recv_iso(struct usbip_device *ud, struct urb *urb)
-{
-	void *buff;
-	struct usbip_iso_packet_descriptor *iso;
-	int np = urb->number_of_packets;
-	int size = np * sizeof(*iso);
-	int i;
-	int ret;
-	int total_length = 0;
-
-	if (!usb_pipeisoc(urb->pipe))
-		return 0;
-
-	/* my Bluetooth dongle gets ISO URBs which are np = 0 */
-	if (np == 0)
-		return 0;
-
-	buff = kzalloc(size, GFP_KERNEL);
-	if (!buff)
-		return -ENOMEM;
-
-	ret = usbip_recv(ud->tcp_socket, buff, size);
-	if (ret != size) {
-		dev_err(&urb->dev->dev, "recv iso_frame_descriptor, %d\n",
-			ret);
-		kfree(buff);
-
-		if (ud->side == USBIP_STUB)
-			usbip_event_add(ud, SDEV_EVENT_ERROR_TCP);
-		else
-			usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
-
-		return -EPIPE;
-	}
-
-	iso = (struct usbip_iso_packet_descriptor *) buff;
-	for (i = 0; i < np; i++) {
-		usbip_iso_packet_correct_endian(&iso[i], 0);
-		usbip_pack_iso(&iso[i], &urb->iso_frame_desc[i], 0);
-		total_length += urb->iso_frame_desc[i].actual_length;
-	}
-
-	kfree(buff);
-
-	if (total_length != urb->actual_length) {
-		dev_err(&urb->dev->dev,
-			"total length of iso packets %d not equal to actual "
-			"length of buffer %d\n",
-			total_length, urb->actual_length);
-
-		if (ud->side == USBIP_STUB)
-			usbip_event_add(ud, SDEV_EVENT_ERROR_TCP);
-		else
-			usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
-
-		return -EPIPE;
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(usbip_recv_iso);
-
-/*
- * This functions restores the padding which was removed for optimizing
- * the bandwidth during transfer over tcp/ip
- *
- * buffer and iso packets need to be stored and be in propeper endian in urb
- * before calling this function
- */
-void usbip_pad_iso(struct usbip_device *ud, struct urb *urb)
-{
-	int np = urb->number_of_packets;
-	int i;
-	int actualoffset = urb->actual_length;
-
-	if (!usb_pipeisoc(urb->pipe))
-		return;
-
-	/* if no packets or length of data is 0, then nothing to unpack */
-	if (np == 0 || urb->actual_length == 0)
-		return;
-
-	/*
-	 * if actual_length is transfer_buffer_length then no padding is
-	 * present.
-	 */
-	if (urb->actual_length == urb->transfer_buffer_length)
-		return;
-
-	/*
-	 * loop over all packets from last to first (to prevent overwritting
-	 * memory when padding) and move them into the proper place
-	 */
-	for (i = np-1; i > 0; i--) {
-		actualoffset -= urb->iso_frame_desc[i].actual_length;
-		memmove(urb->transfer_buffer + urb->iso_frame_desc[i].offset,
-			urb->transfer_buffer + actualoffset,
-			urb->iso_frame_desc[i].actual_length);
-	}
-}
-EXPORT_SYMBOL_GPL(usbip_pad_iso);
-
-/* some members of urb must be substituted before. */
-int usbip_recv_xbuff(struct usbip_device *ud, struct urb *urb)
-{
-	int ret;
-	int size;
-
-	if (ud->side == USBIP_STUB) {
-		/* the direction of urb must be OUT. */
-		if (usb_pipein(urb->pipe))
-			return 0;
-
-		size = urb->transfer_buffer_length;
-	} else {
-		/* the direction of urb must be IN. */
-		if (usb_pipeout(urb->pipe))
-			return 0;
-
-		size = urb->actual_length;
-	}
-
-	/* no need to recv xbuff */
-	if (!(size > 0))
-		return 0;
-
-	ret = usbip_recv(ud->tcp_socket, urb->transfer_buffer, size);
-	if (ret != size) {
-		dev_err(&urb->dev->dev, "recv xbuf, %d\n", ret);
-		if (ud->side == USBIP_STUB) {
-			usbip_event_add(ud, SDEV_EVENT_ERROR_TCP);
-		} else {
-			usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
-			return -EPIPE;
-		}
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(usbip_recv_xbuff);
-
-static int __init usbip_core_init(void)
-{
-	pr_info(DRIVER_DESC " v" USBIP_VERSION "\n");
-	return 0;
-}
-
-static void __exit usbip_core_exit(void)
-{
-	return;
-}
-
-module_init(usbip_core_init);
-module_exit(usbip_core_exit);
-
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
-MODULE_LICENSE("GPL");
-MODULE_VERSION(USBIP_VERSION);
diff --git a/drivers/staging/usbip/usbip_common.h b/drivers/staging/usbip/usbip_common.h
deleted file mode 100644
index 732fb63..0000000
--- a/drivers/staging/usbip/usbip_common.h
+++ /dev/null
@@ -1,334 +0,0 @@
-/*
- * Copyright (C) 2003-2008 Takahiro Hirofuchi
- *
- * This is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
- * USA.
- */
-
-#ifndef __USBIP_COMMON_H
-#define __USBIP_COMMON_H
-
-#include <linux/compiler.h>
-#include <linux/device.h>
-#include <linux/interrupt.h>
-#include <linux/net.h>
-#include <linux/printk.h>
-#include <linux/spinlock.h>
-#include <linux/types.h>
-#include <linux/usb.h>
-#include <linux/wait.h>
-#include "uapi/usbip.h"
-
-#define USBIP_VERSION "1.0.0"
-
-#undef pr_fmt
-
-#ifdef DEBUG
-#define pr_fmt(fmt)     KBUILD_MODNAME ": %s:%d: " fmt, __func__, __LINE__
-#else
-#define pr_fmt(fmt)     KBUILD_MODNAME ": " fmt
-#endif
-
-enum {
-	usbip_debug_xmit	= (1 << 0),
-	usbip_debug_sysfs	= (1 << 1),
-	usbip_debug_urb		= (1 << 2),
-	usbip_debug_eh		= (1 << 3),
-
-	usbip_debug_stub_cmp	= (1 << 8),
-	usbip_debug_stub_dev	= (1 << 9),
-	usbip_debug_stub_rx	= (1 << 10),
-	usbip_debug_stub_tx	= (1 << 11),
-
-	usbip_debug_vhci_rh	= (1 << 8),
-	usbip_debug_vhci_hc	= (1 << 9),
-	usbip_debug_vhci_rx	= (1 << 10),
-	usbip_debug_vhci_tx	= (1 << 11),
-	usbip_debug_vhci_sysfs  = (1 << 12)
-};
-
-#define usbip_dbg_flag_xmit	(usbip_debug_flag & usbip_debug_xmit)
-#define usbip_dbg_flag_vhci_rh	(usbip_debug_flag & usbip_debug_vhci_rh)
-#define usbip_dbg_flag_vhci_hc	(usbip_debug_flag & usbip_debug_vhci_hc)
-#define usbip_dbg_flag_vhci_rx	(usbip_debug_flag & usbip_debug_vhci_rx)
-#define usbip_dbg_flag_vhci_tx	(usbip_debug_flag & usbip_debug_vhci_tx)
-#define usbip_dbg_flag_stub_rx	(usbip_debug_flag & usbip_debug_stub_rx)
-#define usbip_dbg_flag_stub_tx	(usbip_debug_flag & usbip_debug_stub_tx)
-#define usbip_dbg_flag_vhci_sysfs  (usbip_debug_flag & usbip_debug_vhci_sysfs)
-
-extern unsigned long usbip_debug_flag;
-extern struct device_attribute dev_attr_usbip_debug;
-
-#define usbip_dbg_with_flag(flag, fmt, args...)		\
-	do {						\
-		if (flag & usbip_debug_flag)		\
-			pr_debug(fmt, ##args);		\
-	} while (0)
-
-#define usbip_dbg_sysfs(fmt, args...) \
-	usbip_dbg_with_flag(usbip_debug_sysfs, fmt , ##args)
-#define usbip_dbg_xmit(fmt, args...) \
-	usbip_dbg_with_flag(usbip_debug_xmit, fmt , ##args)
-#define usbip_dbg_urb(fmt, args...) \
-	usbip_dbg_with_flag(usbip_debug_urb, fmt , ##args)
-#define usbip_dbg_eh(fmt, args...) \
-	usbip_dbg_with_flag(usbip_debug_eh, fmt , ##args)
-
-#define usbip_dbg_vhci_rh(fmt, args...)	\
-	usbip_dbg_with_flag(usbip_debug_vhci_rh, fmt , ##args)
-#define usbip_dbg_vhci_hc(fmt, args...)	\
-	usbip_dbg_with_flag(usbip_debug_vhci_hc, fmt , ##args)
-#define usbip_dbg_vhci_rx(fmt, args...)	\
-	usbip_dbg_with_flag(usbip_debug_vhci_rx, fmt , ##args)
-#define usbip_dbg_vhci_tx(fmt, args...)	\
-	usbip_dbg_with_flag(usbip_debug_vhci_tx, fmt , ##args)
-#define usbip_dbg_vhci_sysfs(fmt, args...) \
-	usbip_dbg_with_flag(usbip_debug_vhci_sysfs, fmt , ##args)
-
-#define usbip_dbg_stub_cmp(fmt, args...) \
-	usbip_dbg_with_flag(usbip_debug_stub_cmp, fmt , ##args)
-#define usbip_dbg_stub_rx(fmt, args...) \
-	usbip_dbg_with_flag(usbip_debug_stub_rx, fmt , ##args)
-#define usbip_dbg_stub_tx(fmt, args...) \
-	usbip_dbg_with_flag(usbip_debug_stub_tx, fmt , ##args)
-
-/*
- * USB/IP request headers
- *
- * Each request is transferred across the network to its counterpart, which
- * facilitates the normal USB communication. The values contained in the headers
- * are basically the same as in a URB. Currently, four request types are
- * defined:
- *
- *  - USBIP_CMD_SUBMIT: a USB request block, corresponds to usb_submit_urb()
- *    (client to server)
- *
- *  - USBIP_RET_SUBMIT: the result of USBIP_CMD_SUBMIT
- *    (server to client)
- *
- *  - USBIP_CMD_UNLINK: an unlink request of a pending USBIP_CMD_SUBMIT,
- *    corresponds to usb_unlink_urb()
- *    (client to server)
- *
- *  - USBIP_RET_UNLINK: the result of USBIP_CMD_UNLINK
- *    (server to client)
- *
- */
-#define USBIP_CMD_SUBMIT	0x0001
-#define USBIP_CMD_UNLINK	0x0002
-#define USBIP_RET_SUBMIT	0x0003
-#define USBIP_RET_UNLINK	0x0004
-
-#define USBIP_DIR_OUT	0x00
-#define USBIP_DIR_IN	0x01
-
-/**
- * struct usbip_header_basic - data pertinent to every request
- * @command: the usbip request type
- * @seqnum: sequential number that identifies requests; incremented per
- *	    connection
- * @devid: specifies a remote USB device uniquely instead of busnum and devnum;
- *	   in the stub driver, this value is ((busnum << 16) | devnum)
- * @direction: direction of the transfer
- * @ep: endpoint number
- */
-struct usbip_header_basic {
-	__u32 command;
-	__u32 seqnum;
-	__u32 devid;
-	__u32 direction;
-	__u32 ep;
-} __packed;
-
-/**
- * struct usbip_header_cmd_submit - USBIP_CMD_SUBMIT packet header
- * @transfer_flags: URB flags
- * @transfer_buffer_length: the data size for (in) or (out) transfer
- * @start_frame: initial frame for isochronous or interrupt transfers
- * @number_of_packets: number of isochronous packets
- * @interval: maximum time for the request on the server-side host controller
- * @setup: setup data for a control request
- */
-struct usbip_header_cmd_submit {
-	__u32 transfer_flags;
-	__s32 transfer_buffer_length;
-
-	/* it is difficult for usbip to sync frames (reserved only?) */
-	__s32 start_frame;
-	__s32 number_of_packets;
-	__s32 interval;
-
-	unsigned char setup[8];
-} __packed;
-
-/**
- * struct usbip_header_ret_submit - USBIP_RET_SUBMIT packet header
- * @status: return status of a non-iso request
- * @actual_length: number of bytes transferred
- * @start_frame: initial frame for isochronous or interrupt transfers
- * @number_of_packets: number of isochronous packets
- * @error_count: number of errors for isochronous transfers
- */
-struct usbip_header_ret_submit {
-	__s32 status;
-	__s32 actual_length;
-	__s32 start_frame;
-	__s32 number_of_packets;
-	__s32 error_count;
-} __packed;
-
-/**
- * struct usbip_header_cmd_unlink - USBIP_CMD_UNLINK packet header
- * @seqnum: the URB seqnum to unlink
- */
-struct usbip_header_cmd_unlink {
-	__u32 seqnum;
-} __packed;
-
-/**
- * struct usbip_header_ret_unlink - USBIP_RET_UNLINK packet header
- * @status: return status of the request
- */
-struct usbip_header_ret_unlink {
-	__s32 status;
-} __packed;
-
-/**
- * struct usbip_header - common header for all usbip packets
- * @base: the basic header
- * @u: packet type dependent header
- */
-struct usbip_header {
-	struct usbip_header_basic base;
-
-	union {
-		struct usbip_header_cmd_submit	cmd_submit;
-		struct usbip_header_ret_submit	ret_submit;
-		struct usbip_header_cmd_unlink	cmd_unlink;
-		struct usbip_header_ret_unlink	ret_unlink;
-	} u;
-} __packed;
-
-/*
- * This is the same as usb_iso_packet_descriptor but packed for pdu.
- */
-struct usbip_iso_packet_descriptor {
-	__u32 offset;
-	__u32 length;			/* expected length */
-	__u32 actual_length;
-	__u32 status;
-} __packed;
-
-enum usbip_side {
-	USBIP_VHCI,
-	USBIP_STUB,
-};
-
-/* event handler */
-#define USBIP_EH_SHUTDOWN	(1 << 0)
-#define USBIP_EH_BYE		(1 << 1)
-#define USBIP_EH_RESET		(1 << 2)
-#define USBIP_EH_UNUSABLE	(1 << 3)
-
-#define SDEV_EVENT_REMOVED   (USBIP_EH_SHUTDOWN | USBIP_EH_RESET | USBIP_EH_BYE)
-#define	SDEV_EVENT_DOWN		(USBIP_EH_SHUTDOWN | USBIP_EH_RESET)
-#define	SDEV_EVENT_ERROR_TCP	(USBIP_EH_SHUTDOWN | USBIP_EH_RESET)
-#define	SDEV_EVENT_ERROR_SUBMIT	(USBIP_EH_SHUTDOWN | USBIP_EH_RESET)
-#define	SDEV_EVENT_ERROR_MALLOC	(USBIP_EH_SHUTDOWN | USBIP_EH_UNUSABLE)
-
-#define	VDEV_EVENT_REMOVED	(USBIP_EH_SHUTDOWN | USBIP_EH_BYE)
-#define	VDEV_EVENT_DOWN		(USBIP_EH_SHUTDOWN | USBIP_EH_RESET)
-#define	VDEV_EVENT_ERROR_TCP	(USBIP_EH_SHUTDOWN | USBIP_EH_RESET)
-#define	VDEV_EVENT_ERROR_MALLOC	(USBIP_EH_SHUTDOWN | USBIP_EH_UNUSABLE)
-
-/* a common structure for stub_device and vhci_device */
-struct usbip_device {
-	enum usbip_side side;
-	enum usbip_device_status status;
-
-	/* lock for status */
-	spinlock_t lock;
-
-	struct socket *tcp_socket;
-
-	struct task_struct *tcp_rx;
-	struct task_struct *tcp_tx;
-
-	unsigned long event;
-	struct task_struct *eh;
-	wait_queue_head_t eh_waitq;
-
-	struct eh_ops {
-		void (*shutdown)(struct usbip_device *);
-		void (*reset)(struct usbip_device *);
-		void (*unusable)(struct usbip_device *);
-	} eh_ops;
-};
-
-#define kthread_get_run(threadfn, data, namefmt, ...)			   \
-({									   \
-	struct task_struct *__k						   \
-		= kthread_create(threadfn, data, namefmt, ## __VA_ARGS__); \
-	if (!IS_ERR(__k)) {						   \
-		get_task_struct(__k);					   \
-		wake_up_process(__k);					   \
-	}								   \
-	__k;								   \
-})
-
-#define kthread_stop_put(k)		\
-	do {				\
-		kthread_stop(k);	\
-		put_task_struct(k);	\
-	} while (0)
-
-/* usbip_common.c */
-void usbip_dump_urb(struct urb *purb);
-void usbip_dump_header(struct usbip_header *pdu);
-
-int usbip_recv(struct socket *sock, void *buf, int size);
-struct socket *sockfd_to_socket(unsigned int sockfd);
-
-void usbip_pack_pdu(struct usbip_header *pdu, struct urb *urb, int cmd,
-		    int pack);
-void usbip_header_correct_endian(struct usbip_header *pdu, int send);
-
-struct usbip_iso_packet_descriptor*
-usbip_alloc_iso_desc_pdu(struct urb *urb, ssize_t *bufflen);
-
-/* some members of urb must be substituted before. */
-int usbip_recv_iso(struct usbip_device *ud, struct urb *urb);
-void usbip_pad_iso(struct usbip_device *ud, struct urb *urb);
-int usbip_recv_xbuff(struct usbip_device *ud, struct urb *urb);
-
-/* usbip_event.c */
-int usbip_start_eh(struct usbip_device *ud);
-void usbip_stop_eh(struct usbip_device *ud);
-void usbip_event_add(struct usbip_device *ud, unsigned long event);
-int usbip_event_happened(struct usbip_device *ud);
-
-static inline int interface_to_busnum(struct usb_interface *interface)
-{
-	struct usb_device *udev = interface_to_usbdev(interface);
-	return udev->bus->busnum;
-}
-
-static inline int interface_to_devnum(struct usb_interface *interface)
-{
-	struct usb_device *udev = interface_to_usbdev(interface);
-	return udev->devnum;
-}
-
-#endif /* __USBIP_COMMON_H */
diff --git a/drivers/staging/usbip/usbip_event.c b/drivers/staging/usbip/usbip_event.c
deleted file mode 100644
index 64933b9..0000000
--- a/drivers/staging/usbip/usbip_event.c
+++ /dev/null
@@ -1,128 +0,0 @@
-/*
- * Copyright (C) 2003-2008 Takahiro Hirofuchi
- *
- * This is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
- * USA.
- */
-
-#include <linux/kthread.h>
-#include <linux/export.h>
-
-#include "usbip_common.h"
-
-static int event_handler(struct usbip_device *ud)
-{
-	usbip_dbg_eh("enter\n");
-
-	/*
-	 * Events are handled by only this thread.
-	 */
-	while (usbip_event_happened(ud)) {
-		usbip_dbg_eh("pending event %lx\n", ud->event);
-
-		/*
-		 * NOTE: shutdown must come first.
-		 * Shutdown the device.
-		 */
-		if (ud->event & USBIP_EH_SHUTDOWN) {
-			ud->eh_ops.shutdown(ud);
-			ud->event &= ~USBIP_EH_SHUTDOWN;
-		}
-
-		/* Reset the device. */
-		if (ud->event & USBIP_EH_RESET) {
-			ud->eh_ops.reset(ud);
-			ud->event &= ~USBIP_EH_RESET;
-		}
-
-		/* Mark the device as unusable. */
-		if (ud->event & USBIP_EH_UNUSABLE) {
-			ud->eh_ops.unusable(ud);
-			ud->event &= ~USBIP_EH_UNUSABLE;
-		}
-
-		/* Stop the error handler. */
-		if (ud->event & USBIP_EH_BYE)
-			return -1;
-	}
-
-	return 0;
-}
-
-static int event_handler_loop(void *data)
-{
-	struct usbip_device *ud = data;
-
-	while (!kthread_should_stop()) {
-		wait_event_interruptible(ud->eh_waitq,
-					 usbip_event_happened(ud) ||
-					 kthread_should_stop());
-		usbip_dbg_eh("wakeup\n");
-
-		if (event_handler(ud) < 0)
-			break;
-	}
-
-	return 0;
-}
-
-int usbip_start_eh(struct usbip_device *ud)
-{
-	init_waitqueue_head(&ud->eh_waitq);
-	ud->event = 0;
-
-	ud->eh = kthread_run(event_handler_loop, ud, "usbip_eh");
-	if (IS_ERR(ud->eh)) {
-		pr_warn("Unable to start control thread\n");
-		return PTR_ERR(ud->eh);
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(usbip_start_eh);
-
-void usbip_stop_eh(struct usbip_device *ud)
-{
-	if (ud->eh == current)
-		return; /* do not wait for myself */
-
-	kthread_stop(ud->eh);
-	usbip_dbg_eh("usbip_eh has finished\n");
-}
-EXPORT_SYMBOL_GPL(usbip_stop_eh);
-
-void usbip_event_add(struct usbip_device *ud, unsigned long event)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&ud->lock, flags);
-	ud->event |= event;
-	wake_up(&ud->eh_waitq);
-	spin_unlock_irqrestore(&ud->lock, flags);
-}
-EXPORT_SYMBOL_GPL(usbip_event_add);
-
-int usbip_event_happened(struct usbip_device *ud)
-{
-	int happened = 0;
-
-	spin_lock(&ud->lock);
-	if (ud->event != 0)
-		happened = 1;
-	spin_unlock(&ud->lock);
-
-	return happened;
-}
-EXPORT_SYMBOL_GPL(usbip_event_happened);
diff --git a/drivers/staging/usbip/usbip_protocol.txt b/drivers/staging/usbip/usbip_protocol.txt
deleted file mode 100644
index 16b6fe2..0000000
--- a/drivers/staging/usbip/usbip_protocol.txt
+++ /dev/null
@@ -1,358 +0,0 @@
-PRELIMINARY DRAFT, MAY CONTAIN MISTAKES!
-28 Jun 2011
-
-The USB/IP protocol follows a server/client architecture. The server exports the
-USB devices and the clients imports them. The device driver for the exported
-USB device runs on the client machine.
-
-The client may ask for the list of the exported USB devices. To get the list the
-client opens a TCP/IP connection towards the server, and sends an OP_REQ_DEVLIST
-packet on top of the TCP/IP connection (so the actual OP_REQ_DEVLIST may be sent
-in one or more pieces at the low level transport layer). The server sends back
-the OP_REP_DEVLIST packet which lists the exported USB devices. Finally the
-TCP/IP connection is closed.
-
- virtual host controller                                 usb host
-      "client"                                           "server"
-  (imports USB devices)                             (exports USB devices)
-          |                                                 |
-          |                  OP_REQ_DEVLIST                 |
-          | ----------------------------------------------> |
-          |                                                 |
-          |                  OP_REP_DEVLIST                 |
-          | <---------------------------------------------- |
-          |                                                 |
-
-Once the client knows the list of exported USB devices it may decide to use one
-of them. First the client opens a TCP/IP connection towards the server and
-sends an OP_REQ_IMPORT packet. The server replies with OP_REP_IMPORT. If the
-import was successful the TCP/IP connection remains open and will be used
-to transfer the URB traffic between the client and the server. The client may
-send two types of packets: the USBIP_CMD_SUBMIT to submit an URB, and
-USBIP_CMD_UNLINK to unlink a previously submitted URB. The answers of the
-server may be USBIP_RET_SUBMIT and USBIP_RET_UNLINK respectively.
-
- virtual host controller                                 usb host
-      "client"                                           "server"
-  (imports USB devices)                             (exports USB devices)
-          |                                                 |
-          |                  OP_REQ_IMPORT                  |
-          | ----------------------------------------------> |
-          |                                                 |
-          |                  OP_REP_IMPORT                  |
-          | <---------------------------------------------- |
-          |                                                 |
-          |                                                 |
-          |            USBIP_CMD_SUBMIT(seqnum = n)         |
-          | ----------------------------------------------> |
-          |                                                 |
-          |            USBIP_RET_SUBMIT(seqnum = n)         |
-          | <---------------------------------------------- |
-          |                        .                        |
-          |                        :                        |
-          |                                                 |
-          |            USBIP_CMD_SUBMIT(seqnum = m)         |
-          | ----------------------------------------------> |
-          |                                                 |
-          |            USBIP_CMD_SUBMIT(seqnum = m+1)       |
-          | ----------------------------------------------> |
-          |                                                 |
-          |            USBIP_CMD_SUBMIT(seqnum = m+2)       |
-          | ----------------------------------------------> |
-          |                                                 |
-          |            USBIP_RET_SUBMIT(seqnum = m)         |
-          | <---------------------------------------------- |
-          |                                                 |
-          |            USBIP_CMD_SUBMIT(seqnum = m+3)       |
-          | ----------------------------------------------> |
-          |                                                 |
-          |            USBIP_RET_SUBMIT(seqnum = m+1)       |
-          | <---------------------------------------------- |
-          |                                                 |
-          |            USBIP_CMD_SUBMIT(seqnum = m+4)       |
-          | ----------------------------------------------> |
-          |                                                 |
-          |            USBIP_RET_SUBMIT(seqnum = m+2)       |
-          | <---------------------------------------------- |
-          |                        .                        |
-          |                        :                        |
-          |                                                 |
-          |               USBIP_CMD_UNLINK                  |
-          | ----------------------------------------------> |
-          |                                                 |
-          |               USBIP_RET_UNLINK                  |
-          | <---------------------------------------------- |
-          |                                                 |
-
-The fields are in network (big endian) byte order meaning that the most significant
-byte (MSB) is stored at the lowest address.
-
-
-OP_REQ_DEVLIST: Retrieve the list of exported USB devices.
-
- Offset    | Length | Value      | Description
------------+--------+------------+---------------------------------------------------
- 0         | 2      | 0x0100     | Binary-coded decimal USBIP version number: v1.0.0
------------+--------+------------+---------------------------------------------------
- 2         | 2      | 0x8005     | Command code: Retrieve the list of exported USB
-           |        |            |   devices.
------------+--------+------------+---------------------------------------------------
- 4         | 4      | 0x00000000 | Status: unused, shall be set to 0
-
-OP_REP_DEVLIST: Reply with the list of exported USB devices.
-
- Offset    | Length | Value      | Description
------------+--------+------------+---------------------------------------------------
- 0         | 2      | 0x0100     | Binary-coded decimal USBIP version number: v1.0.0.
------------+--------+------------+---------------------------------------------------
- 2         | 2      | 0x0005     | Reply code: The list of exported USB devices.
------------+--------+------------+---------------------------------------------------
- 4         | 4      | 0x00000000 | Status: 0 for OK
------------+--------+------------+---------------------------------------------------
- 8         | 4      | n          | Number of exported devices: 0 means no exported
-           |        |            |   devices.
------------+--------+------------+---------------------------------------------------
- 0x0C      |        |            | From now on the exported n devices are described,
-           |        |            |   if any. If no devices are exported the message
-           |        |            |   ends with the previous "number of exported
-           |        |            |   devices" field.
------------+--------+------------+---------------------------------------------------
-           | 256    |            | path: Path of the device on the host exporting the
-           |        |            |   USB device, string closed with zero byte, e.g.
-           |        |            |   "/sys/devices/pci0000:00/0000:00:1d.1/usb3/3-2"
-           |        |            |   The unused bytes shall be filled with zero
-           |        |            |   bytes.
------------+--------+------------+---------------------------------------------------
- 0x10C     | 32     |            | busid: Bus ID of the exported device, string
-           |        |            |   closed with zero byte, e.g. "3-2". The unused
-           |        |            |   bytes shall be filled with zero bytes.
------------+--------+------------+---------------------------------------------------
- 0x12C     | 4      |            | busnum
------------+--------+------------+---------------------------------------------------
- 0x130     | 4      |            | devnum
------------+--------+------------+---------------------------------------------------
- 0x134     | 4      |            | speed
------------+--------+------------+---------------------------------------------------
- 0x138     | 2      |            | idVendor
------------+--------+------------+---------------------------------------------------
- 0x13A     | 2      |            | idProduct
------------+--------+------------+---------------------------------------------------
- 0x13C     | 2      |            | bcdDevice
------------+--------+------------+---------------------------------------------------
- 0x13E     | 1      |            | bDeviceClass
------------+--------+------------+---------------------------------------------------
- 0x13F     | 1      |            | bDeviceSubClass
------------+--------+------------+---------------------------------------------------
- 0x140     | 1      |            | bDeviceProtocol
------------+--------+------------+---------------------------------------------------
- 0x141     | 1      |            | bConfigurationValue
------------+--------+------------+---------------------------------------------------
- 0x142     | 1      |            | bNumConfigurations
------------+--------+------------+---------------------------------------------------
- 0x143     | 1      |            | bNumInterfaces
------------+--------+------------+---------------------------------------------------
- 0x144     |        | m_0        | From now on each interface is described, all
-           |        |            |   together bNumInterfaces times, with the
-           |        |            |   the following 4 fields:
------------+--------+------------+---------------------------------------------------
-           | 1      |            | bInterfaceClass
------------+--------+------------+---------------------------------------------------
- 0x145     | 1      |            | bInterfaceSubClass
------------+--------+------------+---------------------------------------------------
- 0x146     | 1      |            | bInterfaceProtocol
------------+--------+------------+---------------------------------------------------
- 0x147     | 1      |            | padding byte for alignment, shall be set to zero
------------+--------+------------+---------------------------------------------------
- 0xC +     |        |            | The second exported USB device starts at i=1
- i*0x138 + |        |            | with the busid field.
- m_(i-1)*4 |        |            |
-
-OP_REQ_IMPORT: Request to import (attach) a remote USB device.
-
- Offset    | Length | Value      | Description
------------+--------+------------+---------------------------------------------------
- 0         | 2      | 0x0100     | Binary-coded decimal USBIP version number: v1.0.0
------------+--------+------------+---------------------------------------------------
- 2         | 2      | 0x8003     | Command code: import a remote USB device.
------------+--------+------------+---------------------------------------------------
- 4         | 4      | 0x00000000 | Status: unused, shall be set to 0
------------+--------+------------+---------------------------------------------------
- 8         | 32     |            | busid: the busid of the exported device on the
-           |        |            |   remote host. The possible values are taken
-           |        |            |   from the message field OP_REP_DEVLIST.busid.
-           |        |            |   A string closed with zero, the unused bytes
-           |        |            |   shall be filled with zeros.
------------+--------+------------+---------------------------------------------------
-
-OP_REP_IMPORT: Reply to import (attach) a remote USB device.
-
- Offset    | Length | Value      | Description
------------+--------+------------+---------------------------------------------------
- 0         | 2      | 0x0100     | Binary-coded decimal USBIP version number: v1.0.0
------------+--------+------------+---------------------------------------------------
- 2         | 2      | 0x0003     | Reply code: Reply to import.
------------+--------+------------+---------------------------------------------------
- 4         | 4      | 0x00000000 | Status: 0 for OK
-           |        |            |         1 for error
------------+--------+------------+---------------------------------------------------
- 8         |        |            | From now on comes the details of the imported
-           |        |            |   device, if the previous status field was OK (0),
-           |        |            |   otherwise the reply ends with the status field.
------------+--------+------------+---------------------------------------------------
-           | 256    |            | path: Path of the device on the host exporting the
-           |        |            |   USB device, string closed with zero byte, e.g.
-           |        |            |   "/sys/devices/pci0000:00/0000:00:1d.1/usb3/3-2"
-           |        |            |   The unused bytes shall be filled with zero
-           |        |            |   bytes.
------------+--------+------------+---------------------------------------------------
- 0x108     | 32     |            | busid: Bus ID of the exported device, string
-           |        |            |   closed with zero byte, e.g. "3-2". The unused
-           |        |            |   bytes shall be filled with zero bytes.
------------+--------+------------+---------------------------------------------------
- 0x128     | 4      |            | busnum
------------+--------+------------+---------------------------------------------------
- 0x12C     | 4      |            | devnum
------------+--------+------------+---------------------------------------------------
- 0x130     | 4      |            | speed
------------+--------+------------+---------------------------------------------------
- 0x134     | 2      |            | idVendor
------------+--------+------------+---------------------------------------------------
- 0x136     | 2      |            | idProduct
------------+--------+------------+---------------------------------------------------
- 0x138     | 2      |            | bcdDevice
------------+--------+------------+---------------------------------------------------
- 0x139     | 1      |            | bDeviceClass
------------+--------+------------+---------------------------------------------------
- 0x13A     | 1      |            | bDeviceSubClass
------------+--------+------------+---------------------------------------------------
- 0x13B     | 1      |            | bDeviceProtocol
------------+--------+------------+---------------------------------------------------
- 0x13C     | 1      |            | bConfigurationValue
------------+--------+------------+---------------------------------------------------
- 0x13D     | 1      |            | bNumConfigurations
------------+--------+------------+---------------------------------------------------
- 0x13E     | 1      |            | bNumInterfaces
-
-USBIP_CMD_SUBMIT: Submit an URB
-
- Offset    | Length | Value      | Description
------------+--------+------------+---------------------------------------------------
- 0         | 4      | 0x00000001 | command: Submit an URB
------------+--------+------------+---------------------------------------------------
- 4         | 4      |            | seqnum: the sequence number of the URB to submit
------------+--------+------------+---------------------------------------------------
- 8         | 4      |            | devid
------------+--------+------------+---------------------------------------------------
- 0xC       | 4      |            | direction: 0: USBIP_DIR_OUT
-           |        |            |            1: USBIP_DIR_IN
------------+--------+------------+---------------------------------------------------
- 0x10      | 4      |            | ep: endpoint number, possible values are: 0...15
------------+--------+------------+---------------------------------------------------
- 0x14      | 4      |            | transfer_flags: possible values depend on the
-           |        |            |   URB transfer type, see below
------------+--------+------------+---------------------------------------------------
- 0x18      | 4      |            | transfer_buffer_length
------------+--------+------------+---------------------------------------------------
- 0x1C      | 4      |            | start_frame: specify the selected frame to
-           |        |            |   transmit an ISO frame, ignored if URB_ISO_ASAP
-           |        |            |   is specified at transfer_flags
------------+--------+------------+---------------------------------------------------
- 0x20      | 4      |            | number_of_packets: number of ISO packets
------------+--------+------------+---------------------------------------------------
- 0x24      | 4      |            | interval: maximum time for the request on the
-           |        |            |   server-side host controller
------------+--------+------------+---------------------------------------------------
- 0x28      | 8      |            | setup: data bytes for USB setup, filled with
-           |        |            |   zeros if not used
------------+--------+------------+---------------------------------------------------
- 0x30      |        |            | URB data. For ISO transfers the padding between
-           |        |            |   each ISO packets is not transmitted.
-
-
-  Allowed transfer_flags  | value      | control | interrupt | bulk     | isochronous
- -------------------------+------------+---------+-----------+----------+-------------
-  URB_SHORT_NOT_OK        | 0x00000001 | only in | only in   | only in  | no
-  URB_ISO_ASAP            | 0x00000002 | no      | no        | no       | yes
-  URB_NO_TRANSFER_DMA_MAP | 0x00000004 | yes     | yes       | yes      | yes
-  URB_NO_FSBR             | 0x00000020 | yes     | no        | no       | no
-  URB_ZERO_PACKET         | 0x00000040 | no      | no        | only out | no
-  URB_NO_INTERRUPT        | 0x00000080 | yes     | yes       | yes      | yes
-  URB_FREE_BUFFER         | 0x00000100 | yes     | yes       | yes      | yes
-  URB_DIR_MASK            | 0x00000200 | yes     | yes       | yes      | yes
-
-
-USBIP_RET_SUBMIT: Reply for submitting an URB
-
- Offset    | Length | Value      | Description
------------+--------+------------+---------------------------------------------------
- 0         | 4      | 0x00000003 | command
------------+--------+------------+---------------------------------------------------
- 4         | 4      |            | seqnum: URB sequence number
------------+--------+------------+---------------------------------------------------
- 8         | 4      |            | devid
------------+--------+------------+---------------------------------------------------
- 0xC       | 4      |            | direction: 0: USBIP_DIR_OUT
-           |        |            |            1: USBIP_DIR_IN
------------+--------+------------+---------------------------------------------------
- 0x10      | 4      |            | ep: endpoint number
------------+--------+------------+---------------------------------------------------
- 0x14      | 4      |            | status: zero for successful URB transaction,
-           |        |            |   otherwise some kind of error happened.
------------+--------+------------+---------------------------------------------------
- 0x18      | 4      | n          | actual_length: number of URB data bytes
------------+--------+------------+---------------------------------------------------
- 0x1C      | 4      |            | start_frame: for an ISO frame the actually
-           |        |            |   selected frame for transmit.
------------+--------+------------+---------------------------------------------------
- 0x20      | 4      |            | number_of_packets
------------+--------+------------+---------------------------------------------------
- 0x24      | 4      |            | error_count
------------+--------+------------+---------------------------------------------------
- 0x28      | 8      |            | setup: data bytes for USB setup, filled with
-           |        |            |   zeros if not used
------------+--------+------------+---------------------------------------------------
- 0x30      | n      |            | URB data bytes. For ISO transfers the padding
-           |        |            |   between each ISO packets is not transmitted.
-
-USBIP_CMD_UNLINK: Unlink an URB
-
- Offset    | Length | Value      | Description
------------+--------+------------+---------------------------------------------------
- 0         | 4      | 0x00000002 | command: URB unlink command
------------+--------+------------+---------------------------------------------------
- 4         | 4      |            | seqnum: URB sequence number to unlink: FIXME: is this so?
------------+--------+------------+---------------------------------------------------
- 8         | 4      |            | devid
------------+--------+------------+---------------------------------------------------
- 0xC       | 4      |            | direction: 0: USBIP_DIR_OUT
-           |        |            |            1: USBIP_DIR_IN
------------+--------+------------+---------------------------------------------------
- 0x10      | 4      |            | ep: endpoint number: zero
------------+--------+------------+---------------------------------------------------
- 0x14      | 4      |            | seqnum: the URB sequence number given previously
-           |        |            |   at USBIP_CMD_SUBMIT.seqnum field
------------+--------+------------+---------------------------------------------------
- 0x30      | n      |            | URB data bytes. For ISO transfers the padding
-           |        |            |   between each ISO packets is not transmitted.
-
-USBIP_RET_UNLINK: Reply for URB unlink
-
- Offset    | Length | Value      | Description
------------+--------+------------+---------------------------------------------------
- 0         | 4      | 0x00000004 | command: reply for the URB unlink command
------------+--------+------------+---------------------------------------------------
- 4         | 4      |            | seqnum: the unlinked URB sequence number
------------+--------+------------+---------------------------------------------------
- 8         | 4      |            | devid
------------+--------+------------+---------------------------------------------------
- 0xC       | 4      |            | direction: 0: USBIP_DIR_OUT
-           |        |            |            1: USBIP_DIR_IN
------------+--------+------------+---------------------------------------------------
- 0x10      | 4      |            | ep: endpoint number
------------+--------+------------+---------------------------------------------------
- 0x14      | 4      |            | status: This is the value contained in the
-           |        |            |   urb->status in the URB completition handler.
-           |        |            |   FIXME: a better explanation needed.
------------+--------+------------+---------------------------------------------------
- 0x30      | n      |            | URB data bytes. For ISO transfers the padding
-           |        |            |   between each ISO packets is not transmitted.
diff --git a/drivers/staging/usbip/vhci.h b/drivers/staging/usbip/vhci.h
deleted file mode 100644
index a863a98..0000000
--- a/drivers/staging/usbip/vhci.h
+++ /dev/null
@@ -1,129 +0,0 @@
-/*
- * Copyright (C) 2003-2008 Takahiro Hirofuchi
- *
- * This is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- */
-
-#ifndef __USBIP_VHCI_H
-#define __USBIP_VHCI_H
-
-#include <linux/device.h>
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <linux/sysfs.h>
-#include <linux/types.h>
-#include <linux/usb.h>
-#include <linux/usb/hcd.h>
-#include <linux/wait.h>
-
-struct vhci_device {
-	struct usb_device *udev;
-
-	/*
-	 * devid specifies a remote usb device uniquely instead
-	 * of combination of busnum and devnum.
-	 */
-	__u32 devid;
-
-	/* speed of a remote device */
-	enum usb_device_speed speed;
-
-	/* vhci root-hub port to which this device is attached */
-	__u32 rhport;
-
-	struct usbip_device ud;
-
-	/* lock for the below link lists */
-	spinlock_t priv_lock;
-
-	/* vhci_priv is linked to one of them. */
-	struct list_head priv_tx;
-	struct list_head priv_rx;
-
-	/* vhci_unlink is linked to one of them */
-	struct list_head unlink_tx;
-	struct list_head unlink_rx;
-
-	/* vhci_tx thread sleeps for this queue */
-	wait_queue_head_t waitq_tx;
-};
-
-/* urb->hcpriv, use container_of() */
-struct vhci_priv {
-	unsigned long seqnum;
-	struct list_head list;
-
-	struct vhci_device *vdev;
-	struct urb *urb;
-};
-
-struct vhci_unlink {
-	/* seqnum of this request */
-	unsigned long seqnum;
-
-	struct list_head list;
-
-	/* seqnum of the unlink target */
-	unsigned long unlink_seqnum;
-};
-
-/* Number of supported ports. Value has an upperbound of USB_MAXCHILDREN */
-#define VHCI_NPORTS 8
-
-/* for usb_bus.hcpriv */
-struct vhci_hcd {
-	spinlock_t lock;
-
-	u32 port_status[VHCI_NPORTS];
-
-	unsigned resuming:1;
-	unsigned long re_timeout;
-
-	atomic_t seqnum;
-
-	/*
-	 * NOTE:
-	 * wIndex shows the port number and begins from 1.
-	 * But, the index of this array begins from 0.
-	 */
-	struct vhci_device vdev[VHCI_NPORTS];
-};
-
-extern struct vhci_hcd *the_controller;
-extern const struct attribute_group dev_attr_group;
-
-/* vhci_hcd.c */
-void rh_port_connect(int rhport, enum usb_device_speed speed);
-
-/* vhci_rx.c */
-struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev, __u32 seqnum);
-int vhci_rx_loop(void *data);
-
-/* vhci_tx.c */
-int vhci_tx_loop(void *data);
-
-static inline struct vhci_device *port_to_vdev(__u32 port)
-{
-	return &the_controller->vdev[port];
-}
-
-static inline struct vhci_hcd *hcd_to_vhci(struct usb_hcd *hcd)
-{
-	return (struct vhci_hcd *) (hcd->hcd_priv);
-}
-
-static inline struct usb_hcd *vhci_to_hcd(struct vhci_hcd *vhci)
-{
-	return container_of((void *) vhci, struct usb_hcd, hcd_priv);
-}
-
-static inline struct device *vhci_dev(struct vhci_hcd *vhci)
-{
-	return vhci_to_hcd(vhci)->self.controller;
-}
-
-#endif /* __USBIP_VHCI_H */
diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
deleted file mode 100644
index adb6201..0000000
--- a/drivers/staging/usbip/vhci_hcd.c
+++ /dev/null
@@ -1,1168 +0,0 @@
-/*
- * Copyright (C) 2003-2008 Takahiro Hirofuchi
- *
- * This is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
- * USA.
- */
-
-#include <linux/init.h>
-#include <linux/file.h>
-#include <linux/kernel.h>
-#include <linux/kthread.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/slab.h>
-
-#include "usbip_common.h"
-#include "vhci.h"
-
-#define DRIVER_AUTHOR "Takahiro Hirofuchi"
-#define DRIVER_DESC "USB/IP 'Virtual' Host Controller (VHCI) Driver"
-
-/*
- * TODO
- *	- update root hub emulation
- *	- move the emulation code to userland ?
- *		porting to other operating systems
- *		minimize kernel code
- *	- add suspend/resume code
- *	- clean up everything
- */
-
-/* See usb gadget dummy hcd */
-
-static int vhci_hub_status(struct usb_hcd *hcd, char *buff);
-static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
-			    u16 wIndex, char *buff, u16 wLength);
-static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
-			    gfp_t mem_flags);
-static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status);
-static int vhci_start(struct usb_hcd *vhci_hcd);
-static void vhci_stop(struct usb_hcd *hcd);
-static int vhci_get_frame_number(struct usb_hcd *hcd);
-
-static const char driver_name[] = "vhci_hcd";
-static const char driver_desc[] = "USB/IP Virtual Host Controller";
-
-struct vhci_hcd *the_controller;
-
-static const char * const bit_desc[] = {
-	"CONNECTION",		/*0*/
-	"ENABLE",		/*1*/
-	"SUSPEND",		/*2*/
-	"OVER_CURRENT",		/*3*/
-	"RESET",		/*4*/
-	"R5",			/*5*/
-	"R6",			/*6*/
-	"R7",			/*7*/
-	"POWER",		/*8*/
-	"LOWSPEED",		/*9*/
-	"HIGHSPEED",		/*10*/
-	"PORT_TEST",		/*11*/
-	"INDICATOR",		/*12*/
-	"R13",			/*13*/
-	"R14",			/*14*/
-	"R15",			/*15*/
-	"C_CONNECTION",		/*16*/
-	"C_ENABLE",		/*17*/
-	"C_SUSPEND",		/*18*/
-	"C_OVER_CURRENT",	/*19*/
-	"C_RESET",		/*20*/
-	"R21",			/*21*/
-	"R22",			/*22*/
-	"R23",			/*23*/
-	"R24",			/*24*/
-	"R25",			/*25*/
-	"R26",			/*26*/
-	"R27",			/*27*/
-	"R28",			/*28*/
-	"R29",			/*29*/
-	"R30",			/*30*/
-	"R31",			/*31*/
-};
-
-static void dump_port_status_diff(u32 prev_status, u32 new_status)
-{
-	int i = 0;
-	u32 bit = 1;
-
-	pr_debug("status prev -> new: %08x -> %08x\n", prev_status, new_status);
-	while (bit) {
-		u32 prev = prev_status & bit;
-		u32 new = new_status & bit;
-		char change;
-
-		if (!prev && new)
-			change = '+';
-		else if (prev && !new)
-			change = '-';
-		else
-			change = ' ';
-
-		if (prev || new)
-			pr_debug(" %c%s\n", change, bit_desc[i]);
-		bit <<= 1;
-		i++;
-	}
-	pr_debug("\n");
-}
-
-void rh_port_connect(int rhport, enum usb_device_speed speed)
-{
-	usbip_dbg_vhci_rh("rh_port_connect %d\n", rhport);
-
-	spin_lock(&the_controller->lock);
-
-	the_controller->port_status[rhport] |= USB_PORT_STAT_CONNECTION
-		| (1 << USB_PORT_FEAT_C_CONNECTION);
-
-	switch (speed) {
-	case USB_SPEED_HIGH:
-		the_controller->port_status[rhport] |= USB_PORT_STAT_HIGH_SPEED;
-		break;
-	case USB_SPEED_LOW:
-		the_controller->port_status[rhport] |= USB_PORT_STAT_LOW_SPEED;
-		break;
-	default:
-		break;
-	}
-
-	spin_unlock(&the_controller->lock);
-
-	usb_hcd_poll_rh_status(vhci_to_hcd(the_controller));
-}
-
-static void rh_port_disconnect(int rhport)
-{
-	usbip_dbg_vhci_rh("rh_port_disconnect %d\n", rhport);
-
-	spin_lock(&the_controller->lock);
-
-	the_controller->port_status[rhport] &= ~USB_PORT_STAT_CONNECTION;
-	the_controller->port_status[rhport] |=
-					(1 << USB_PORT_FEAT_C_CONNECTION);
-
-	spin_unlock(&the_controller->lock);
-	usb_hcd_poll_rh_status(vhci_to_hcd(the_controller));
-}
-
-#define PORT_C_MASK				\
-	((USB_PORT_STAT_C_CONNECTION		\
-	  | USB_PORT_STAT_C_ENABLE		\
-	  | USB_PORT_STAT_C_SUSPEND		\
-	  | USB_PORT_STAT_C_OVERCURRENT		\
-	  | USB_PORT_STAT_C_RESET) << 16)
-
-/*
- * Returns 0 if the status hasn't changed, or the number of bytes in buf.
- * Ports are 0-indexed from the HCD point of view,
- * and 1-indexed from the USB core pointer of view.
- *
- * @buf: a bitmap to show which port status has been changed.
- *  bit  0: reserved
- *  bit  1: the status of port 0 has been changed.
- *  bit  2: the status of port 1 has been changed.
- *  ...
- */
-static int vhci_hub_status(struct usb_hcd *hcd, char *buf)
-{
-	struct vhci_hcd	*vhci;
-	int		retval;
-	int		rhport;
-	int		changed = 0;
-
-	retval = DIV_ROUND_UP(VHCI_NPORTS + 1, 8);
-	memset(buf, 0, retval);
-
-	vhci = hcd_to_vhci(hcd);
-
-	spin_lock(&vhci->lock);
-	if (!HCD_HW_ACCESSIBLE(hcd)) {
-		usbip_dbg_vhci_rh("hw accessible flag not on?\n");
-		goto done;
-	}
-
-	/* check pseudo status register for each port */
-	for (rhport = 0; rhport < VHCI_NPORTS; rhport++) {
-		if ((vhci->port_status[rhport] & PORT_C_MASK)) {
-			/* The status of a port has been changed, */
-			usbip_dbg_vhci_rh("port %d status changed\n", rhport);
-
-			buf[(rhport + 1) / 8] |= 1 << (rhport + 1) % 8;
-			changed = 1;
-		}
-	}
-
-	if ((hcd->state == HC_STATE_SUSPENDED) && (changed == 1))
-		usb_hcd_resume_root_hub(hcd);
-
-done:
-	spin_unlock(&vhci->lock);
-	return changed ? retval : 0;
-}
-
-static inline void hub_descriptor(struct usb_hub_descriptor *desc)
-{
-	memset(desc, 0, sizeof(*desc));
-	desc->bDescriptorType = 0x29;
-	desc->bDescLength = 9;
-	desc->wHubCharacteristics = (__constant_cpu_to_le16(0x0001));
-	desc->bNbrPorts = VHCI_NPORTS;
-	desc->u.hs.DeviceRemovable[0] = 0xff;
-	desc->u.hs.DeviceRemovable[1] = 0xff;
-}
-
-static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
-			    u16 wIndex, char *buf, u16 wLength)
-{
-	struct vhci_hcd	*dum;
-	int             retval = 0;
-	int		rhport;
-
-	u32 prev_port_status[VHCI_NPORTS];
-
-	if (!HCD_HW_ACCESSIBLE(hcd))
-		return -ETIMEDOUT;
-
-	/*
-	 * NOTE:
-	 * wIndex shows the port number and begins from 1.
-	 */
-	usbip_dbg_vhci_rh("typeReq %x wValue %x wIndex %x\n", typeReq, wValue,
-			  wIndex);
-	if (wIndex > VHCI_NPORTS)
-		pr_err("invalid port number %d\n", wIndex);
-	rhport = ((__u8)(wIndex & 0x00ff)) - 1;
-
-	dum = hcd_to_vhci(hcd);
-
-	spin_lock(&dum->lock);
-
-	/* store old status and compare now and old later */
-	if (usbip_dbg_flag_vhci_rh) {
-		memcpy(prev_port_status, dum->port_status,
-			sizeof(prev_port_status));
-	}
-
-	switch (typeReq) {
-	case ClearHubFeature:
-		usbip_dbg_vhci_rh(" ClearHubFeature\n");
-		break;
-	case ClearPortFeature:
-		switch (wValue) {
-		case USB_PORT_FEAT_SUSPEND:
-			if (dum->port_status[rhport] & USB_PORT_STAT_SUSPEND) {
-				/* 20msec signaling */
-				dum->resuming = 1;
-				dum->re_timeout =
-					jiffies + msecs_to_jiffies(20);
-			}
-			break;
-		case USB_PORT_FEAT_POWER:
-			usbip_dbg_vhci_rh(" ClearPortFeature: "
-					  "USB_PORT_FEAT_POWER\n");
-			dum->port_status[rhport] = 0;
-			dum->resuming = 0;
-			break;
-		case USB_PORT_FEAT_C_RESET:
-			usbip_dbg_vhci_rh(" ClearPortFeature: "
-					  "USB_PORT_FEAT_C_RESET\n");
-			switch (dum->vdev[rhport].speed) {
-			case USB_SPEED_HIGH:
-				dum->port_status[rhport] |=
-					USB_PORT_STAT_HIGH_SPEED;
-				break;
-			case USB_SPEED_LOW:
-				dum->port_status[rhport] |=
-					USB_PORT_STAT_LOW_SPEED;
-				break;
-			default:
-				break;
-			}
-		default:
-			usbip_dbg_vhci_rh(" ClearPortFeature: default %x\n",
-					  wValue);
-			dum->port_status[rhport] &= ~(1 << wValue);
-			break;
-		}
-		break;
-	case GetHubDescriptor:
-		usbip_dbg_vhci_rh(" GetHubDescriptor\n");
-		hub_descriptor((struct usb_hub_descriptor *) buf);
-		break;
-	case GetHubStatus:
-		usbip_dbg_vhci_rh(" GetHubStatus\n");
-		*(__le32 *) buf = __constant_cpu_to_le32(0);
-		break;
-	case GetPortStatus:
-		usbip_dbg_vhci_rh(" GetPortStatus port %x\n", wIndex);
-		if (wIndex > VHCI_NPORTS || wIndex < 1) {
-			pr_err("invalid port number %d\n", wIndex);
-			retval = -EPIPE;
-		}
-
-		/* we do not care about resume. */
-
-		/* whoever resets or resumes must GetPortStatus to
-		 * complete it!!
-		 */
-		if (dum->resuming && time_after(jiffies, dum->re_timeout)) {
-			dum->port_status[rhport] |=
-				(1 << USB_PORT_FEAT_C_SUSPEND);
-			dum->port_status[rhport] &=
-				~(1 << USB_PORT_FEAT_SUSPEND);
-			dum->resuming = 0;
-			dum->re_timeout = 0;
-		}
-
-		if ((dum->port_status[rhport] & (1 << USB_PORT_FEAT_RESET)) !=
-		    0 && time_after(jiffies, dum->re_timeout)) {
-			dum->port_status[rhport] |=
-				(1 << USB_PORT_FEAT_C_RESET);
-			dum->port_status[rhport] &=
-				~(1 << USB_PORT_FEAT_RESET);
-			dum->re_timeout = 0;
-
-			if (dum->vdev[rhport].ud.status ==
-			    VDEV_ST_NOTASSIGNED) {
-				usbip_dbg_vhci_rh(" enable rhport %d "
-						  "(status %u)\n",
-						  rhport,
-						  dum->vdev[rhport].ud.status);
-				dum->port_status[rhport] |=
-					USB_PORT_STAT_ENABLE;
-			}
-		}
-		((__le16 *) buf)[0] = cpu_to_le16(dum->port_status[rhport]);
-		((__le16 *) buf)[1] = cpu_to_le16(dum->port_status[rhport] >> 16);
-
-		usbip_dbg_vhci_rh(" GetPortStatus bye %x %x\n", ((u16 *)buf)[0],
-				  ((u16 *)buf)[1]);
-		break;
-	case SetHubFeature:
-		usbip_dbg_vhci_rh(" SetHubFeature\n");
-		retval = -EPIPE;
-		break;
-	case SetPortFeature:
-		switch (wValue) {
-		case USB_PORT_FEAT_SUSPEND:
-			usbip_dbg_vhci_rh(" SetPortFeature: "
-					  "USB_PORT_FEAT_SUSPEND\n");
-			break;
-		case USB_PORT_FEAT_RESET:
-			usbip_dbg_vhci_rh(" SetPortFeature: "
-					  "USB_PORT_FEAT_RESET\n");
-			/* if it's already running, disconnect first */
-			if (dum->port_status[rhport] & USB_PORT_STAT_ENABLE) {
-				dum->port_status[rhport] &=
-					~(USB_PORT_STAT_ENABLE |
-					  USB_PORT_STAT_LOW_SPEED |
-					  USB_PORT_STAT_HIGH_SPEED);
-				/* FIXME test that code path! */
-			}
-			/* 50msec reset signaling */
-			dum->re_timeout = jiffies + msecs_to_jiffies(50);
-
-			/* FALLTHROUGH */
-		default:
-			usbip_dbg_vhci_rh(" SetPortFeature: default %d\n",
-					  wValue);
-			dum->port_status[rhport] |= (1 << wValue);
-			break;
-		}
-		break;
-
-	default:
-		pr_err("default: no such request\n");
-
-		/* "protocol stall" on error */
-		retval = -EPIPE;
-	}
-
-	if (usbip_dbg_flag_vhci_rh) {
-		pr_debug("port %d\n", rhport);
-		/* Only dump valid port status */
-		if (rhport >= 0) {
-			dump_port_status_diff(prev_port_status[rhport],
-					      dum->port_status[rhport]);
-		}
-	}
-	usbip_dbg_vhci_rh(" bye\n");
-
-	spin_unlock(&dum->lock);
-
-	return retval;
-}
-
-static struct vhci_device *get_vdev(struct usb_device *udev)
-{
-	int i;
-
-	if (!udev)
-		return NULL;
-
-	for (i = 0; i < VHCI_NPORTS; i++)
-		if (the_controller->vdev[i].udev == udev)
-			return port_to_vdev(i);
-
-	return NULL;
-}
-
-static void vhci_tx_urb(struct urb *urb)
-{
-	struct vhci_device *vdev = get_vdev(urb->dev);
-	struct vhci_priv *priv;
-
-	if (!vdev) {
-		pr_err("could not get virtual device");
-		return;
-	}
-
-	priv = kzalloc(sizeof(struct vhci_priv), GFP_ATOMIC);
-	if (!priv) {
-		usbip_event_add(&vdev->ud, VDEV_EVENT_ERROR_MALLOC);
-		return;
-	}
-
-	spin_lock(&vdev->priv_lock);
-
-	priv->seqnum = atomic_inc_return(&the_controller->seqnum);
-	if (priv->seqnum == 0xffff)
-		dev_info(&urb->dev->dev, "seqnum max\n");
-
-	priv->vdev = vdev;
-	priv->urb = urb;
-
-	urb->hcpriv = (void *) priv;
-
-	list_add_tail(&priv->list, &vdev->priv_tx);
-
-	wake_up(&vdev->waitq_tx);
-	spin_unlock(&vdev->priv_lock);
-}
-
-static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
-			    gfp_t mem_flags)
-{
-	struct device *dev = &urb->dev->dev;
-	int ret = 0;
-	struct vhci_device *vdev;
-
-	usbip_dbg_vhci_hc("enter, usb_hcd %p urb %p mem_flags %d\n",
-			  hcd, urb, mem_flags);
-
-	/* patch to usb_sg_init() is in 2.5.60 */
-	BUG_ON(!urb->transfer_buffer && urb->transfer_buffer_length);
-
-	spin_lock(&the_controller->lock);
-
-	if (urb->status != -EINPROGRESS) {
-		dev_err(dev, "URB already unlinked!, status %d\n", urb->status);
-		spin_unlock(&the_controller->lock);
-		return urb->status;
-	}
-
-	vdev = port_to_vdev(urb->dev->portnum-1);
-
-	/* refuse enqueue for dead connection */
-	spin_lock(&vdev->ud.lock);
-	if (vdev->ud.status == VDEV_ST_NULL ||
-	    vdev->ud.status == VDEV_ST_ERROR) {
-		dev_err(dev, "enqueue for inactive port %d\n", vdev->rhport);
-		spin_unlock(&vdev->ud.lock);
-		spin_unlock(&the_controller->lock);
-		return -ENODEV;
-	}
-	spin_unlock(&vdev->ud.lock);
-
-	ret = usb_hcd_link_urb_to_ep(hcd, urb);
-	if (ret)
-		goto no_need_unlink;
-
-	/*
-	 * The enumeration process is as follows;
-	 *
-	 *  1. Get_Descriptor request to DevAddrs(0) EndPoint(0)
-	 *     to get max packet length of default pipe
-	 *
-	 *  2. Set_Address request to DevAddr(0) EndPoint(0)
-	 *
-	 */
-	if (usb_pipedevice(urb->pipe) == 0) {
-		__u8 type = usb_pipetype(urb->pipe);
-		struct usb_ctrlrequest *ctrlreq =
-			(struct usb_ctrlrequest *) urb->setup_packet;
-
-		if (type != PIPE_CONTROL || !ctrlreq) {
-			dev_err(dev, "invalid request to devnum 0\n");
-			ret = -EINVAL;
-			goto no_need_xmit;
-		}
-
-		switch (ctrlreq->bRequest) {
-		case USB_REQ_SET_ADDRESS:
-			/* set_address may come when a device is reset */
-			dev_info(dev, "SetAddress Request (%d) to port %d\n",
-				 ctrlreq->wValue, vdev->rhport);
-
-			if (vdev->udev)
-				usb_put_dev(vdev->udev);
-			vdev->udev = usb_get_dev(urb->dev);
-
-			spin_lock(&vdev->ud.lock);
-			vdev->ud.status = VDEV_ST_USED;
-			spin_unlock(&vdev->ud.lock);
-
-			if (urb->status == -EINPROGRESS) {
-				/* This request is successfully completed. */
-				/* If not -EINPROGRESS, possibly unlinked. */
-				urb->status = 0;
-			}
-
-			goto no_need_xmit;
-
-		case USB_REQ_GET_DESCRIPTOR:
-			if (ctrlreq->wValue == cpu_to_le16(USB_DT_DEVICE << 8))
-				usbip_dbg_vhci_hc("Not yet?: "
-						  "Get_Descriptor to device 0 "
-						  "(get max pipe size)\n");
-
-			if (vdev->udev)
-				usb_put_dev(vdev->udev);
-			vdev->udev = usb_get_dev(urb->dev);
-			goto out;
-
-		default:
-			/* NOT REACHED */
-			dev_err(dev, "invalid request to devnum 0 bRequest %u, "
-				"wValue %u\n", ctrlreq->bRequest,
-				ctrlreq->wValue);
-			ret =  -EINVAL;
-			goto no_need_xmit;
-		}
-
-	}
-
-out:
-	vhci_tx_urb(urb);
-	spin_unlock(&the_controller->lock);
-
-	return 0;
-
-no_need_xmit:
-	usb_hcd_unlink_urb_from_ep(hcd, urb);
-no_need_unlink:
-	spin_unlock(&the_controller->lock);
-	usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb, urb->status);
-	return ret;
-}
-
-/*
- * vhci_rx gives back the urb after receiving the reply of the urb.  If an
- * unlink pdu is sent or not, vhci_rx receives a normal return pdu and gives
- * back its urb. For the driver unlinking the urb, the content of the urb is
- * not important, but the calling to its completion handler is important; the
- * completion of unlinking is notified by the completion handler.
- *
- *
- * CLIENT SIDE
- *
- * - When vhci_hcd receives RET_SUBMIT,
- *
- *	- case 1a). the urb of the pdu is not unlinking.
- *		- normal case
- *		=> just give back the urb
- *
- *	- case 1b). the urb of the pdu is unlinking.
- *		- usbip.ko will return a reply of the unlinking request.
- *		=> give back the urb now and go to case 2b).
- *
- * - When vhci_hcd receives RET_UNLINK,
- *
- *	- case 2a). a submit request is still pending in vhci_hcd.
- *		- urb was really pending in usbip.ko and urb_unlink_urb() was
- *		  completed there.
- *		=> free a pending submit request
- *		=> notify unlink completeness by giving back the urb
- *
- *	- case 2b). a submit request is *not* pending in vhci_hcd.
- *		- urb was already given back to the core driver.
- *		=> do not give back the urb
- *
- *
- * SERVER SIDE
- *
- * - When usbip receives CMD_UNLINK,
- *
- *	- case 3a). the urb of the unlink request is now in submission.
- *		=> do usb_unlink_urb().
- *		=> after the unlink is completed, send RET_UNLINK.
- *
- *	- case 3b). the urb of the unlink request is not in submission.
- *		- may be already completed or never be received
- *		=> send RET_UNLINK
- *
- */
-static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
-{
-	struct vhci_priv *priv;
-	struct vhci_device *vdev;
-
-	pr_info("dequeue a urb %p\n", urb);
-
-	spin_lock(&the_controller->lock);
-
-	priv = urb->hcpriv;
-	if (!priv) {
-		/* URB was never linked! or will be soon given back by
-		 * vhci_rx. */
-		spin_unlock(&the_controller->lock);
-		return 0;
-	}
-
-	{
-		int ret = 0;
-		ret = usb_hcd_check_unlink_urb(hcd, urb, status);
-		if (ret) {
-			spin_unlock(&the_controller->lock);
-			return ret;
-		}
-	}
-
-	 /* send unlink request here? */
-	vdev = priv->vdev;
-
-	if (!vdev->ud.tcp_socket) {
-		/* tcp connection is closed */
-		spin_lock(&vdev->priv_lock);
-
-		pr_info("device %p seems to be disconnected\n", vdev);
-		list_del(&priv->list);
-		kfree(priv);
-		urb->hcpriv = NULL;
-
-		spin_unlock(&vdev->priv_lock);
-
-		/*
-		 * If tcp connection is alive, we have sent CMD_UNLINK.
-		 * vhci_rx will receive RET_UNLINK and give back the URB.
-		 * Otherwise, we give back it here.
-		 */
-		pr_info("gives back urb %p\n", urb);
-
-		usb_hcd_unlink_urb_from_ep(hcd, urb);
-
-		spin_unlock(&the_controller->lock);
-		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb,
-				     urb->status);
-		spin_lock(&the_controller->lock);
-
-	} else {
-		/* tcp connection is alive */
-		struct vhci_unlink *unlink;
-
-		spin_lock(&vdev->priv_lock);
-
-		/* setup CMD_UNLINK pdu */
-		unlink = kzalloc(sizeof(struct vhci_unlink), GFP_ATOMIC);
-		if (!unlink) {
-			spin_unlock(&vdev->priv_lock);
-			spin_unlock(&the_controller->lock);
-			usbip_event_add(&vdev->ud, VDEV_EVENT_ERROR_MALLOC);
-			return -ENOMEM;
-		}
-
-		unlink->seqnum = atomic_inc_return(&the_controller->seqnum);
-		if (unlink->seqnum == 0xffff)
-			pr_info("seqnum max\n");
-
-		unlink->unlink_seqnum = priv->seqnum;
-
-		pr_info("device %p seems to be still connected\n", vdev);
-
-		/* send cmd_unlink and try to cancel the pending URB in the
-		 * peer */
-		list_add_tail(&unlink->list, &vdev->unlink_tx);
-		wake_up(&vdev->waitq_tx);
-
-		spin_unlock(&vdev->priv_lock);
-	}
-
-	spin_unlock(&the_controller->lock);
-
-	usbip_dbg_vhci_hc("leave\n");
-	return 0;
-}
-
-static void vhci_device_unlink_cleanup(struct vhci_device *vdev)
-{
-	struct vhci_unlink *unlink, *tmp;
-
-	spin_lock(&the_controller->lock);
-	spin_lock(&vdev->priv_lock);
-
-	list_for_each_entry_safe(unlink, tmp, &vdev->unlink_tx, list) {
-		pr_info("unlink cleanup tx %lu\n", unlink->unlink_seqnum);
-		list_del(&unlink->list);
-		kfree(unlink);
-	}
-
-	while (!list_empty(&vdev->unlink_rx)) {
-		struct urb *urb;
-
-		unlink = list_first_entry(&vdev->unlink_rx, struct vhci_unlink,
-			list);
-
-		/* give back URB of unanswered unlink request */
-		pr_info("unlink cleanup rx %lu\n", unlink->unlink_seqnum);
-
-		urb = pickup_urb_and_free_priv(vdev, unlink->unlink_seqnum);
-		if (!urb) {
-			pr_info("the urb (seqnum %lu) was already given back\n",
-				unlink->unlink_seqnum);
-			list_del(&unlink->list);
-			kfree(unlink);
-			continue;
-		}
-
-		urb->status = -ENODEV;
-
-		usb_hcd_unlink_urb_from_ep(vhci_to_hcd(the_controller), urb);
-
-		list_del(&unlink->list);
-
-		spin_unlock(&vdev->priv_lock);
-		spin_unlock(&the_controller->lock);
-
-		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb,
-				     urb->status);
-
-		spin_lock(&the_controller->lock);
-		spin_lock(&vdev->priv_lock);
-
-		kfree(unlink);
-	}
-
-	spin_unlock(&vdev->priv_lock);
-	spin_unlock(&the_controller->lock);
-}
-
-/*
- * The important thing is that only one context begins cleanup.
- * This is why error handling and cleanup become simple.
- * We do not want to consider race condition as possible.
- */
-static void vhci_shutdown_connection(struct usbip_device *ud)
-{
-	struct vhci_device *vdev = container_of(ud, struct vhci_device, ud);
-
-	/* need this? see stub_dev.c */
-	if (ud->tcp_socket) {
-		pr_debug("shutdown tcp_socket %p\n", ud->tcp_socket);
-		kernel_sock_shutdown(ud->tcp_socket, SHUT_RDWR);
-	}
-
-	/* kill threads related to this sdev */
-	if (vdev->ud.tcp_rx) {
-		kthread_stop_put(vdev->ud.tcp_rx);
-		vdev->ud.tcp_rx = NULL;
-	}
-	if (vdev->ud.tcp_tx) {
-		kthread_stop_put(vdev->ud.tcp_tx);
-		vdev->ud.tcp_tx = NULL;
-	}
-	pr_info("stop threads\n");
-
-	/* active connection is closed */
-	if (vdev->ud.tcp_socket) {
-		fput(vdev->ud.tcp_socket->file);
-		vdev->ud.tcp_socket = NULL;
-	}
-	pr_info("release socket\n");
-
-	vhci_device_unlink_cleanup(vdev);
-
-	/*
-	 * rh_port_disconnect() is a trigger of ...
-	 *   usb_disable_device():
-	 *	disable all the endpoints for a USB device.
-	 *   usb_disable_endpoint():
-	 *	disable endpoints. pending urbs are unlinked(dequeued).
-	 *
-	 * NOTE: After calling rh_port_disconnect(), the USB device drivers of a
-	 * detached device should release used urbs in a cleanup function (i.e.
-	 * xxx_disconnect()). Therefore, vhci_hcd does not need to release
-	 * pushed urbs and their private data in this function.
-	 *
-	 * NOTE: vhci_dequeue() must be considered carefully. When shutting down
-	 * a connection, vhci_shutdown_connection() expects vhci_dequeue()
-	 * gives back pushed urbs and frees their private data by request of
-	 * the cleanup function of a USB driver. When unlinking a urb with an
-	 * active connection, vhci_dequeue() does not give back the urb which
-	 * is actually given back by vhci_rx after receiving its return pdu.
-	 *
-	 */
-	rh_port_disconnect(vdev->rhport);
-
-	pr_info("disconnect device\n");
-}
-
-
-static void vhci_device_reset(struct usbip_device *ud)
-{
-	struct vhci_device *vdev = container_of(ud, struct vhci_device, ud);
-
-	spin_lock(&ud->lock);
-
-	vdev->speed  = 0;
-	vdev->devid  = 0;
-
-	if (vdev->udev)
-		usb_put_dev(vdev->udev);
-	vdev->udev = NULL;
-
-	if (ud->tcp_socket) {
-		fput(ud->tcp_socket->file);
-		ud->tcp_socket = NULL;
-	}
-	ud->status = VDEV_ST_NULL;
-
-	spin_unlock(&ud->lock);
-}
-
-static void vhci_device_unusable(struct usbip_device *ud)
-{
-	spin_lock(&ud->lock);
-	ud->status = VDEV_ST_ERROR;
-	spin_unlock(&ud->lock);
-}
-
-static void vhci_device_init(struct vhci_device *vdev)
-{
-	memset(vdev, 0, sizeof(*vdev));
-
-	vdev->ud.side   = USBIP_VHCI;
-	vdev->ud.status = VDEV_ST_NULL;
-	spin_lock_init(&vdev->ud.lock);
-
-	INIT_LIST_HEAD(&vdev->priv_rx);
-	INIT_LIST_HEAD(&vdev->priv_tx);
-	INIT_LIST_HEAD(&vdev->unlink_tx);
-	INIT_LIST_HEAD(&vdev->unlink_rx);
-	spin_lock_init(&vdev->priv_lock);
-
-	init_waitqueue_head(&vdev->waitq_tx);
-
-	vdev->ud.eh_ops.shutdown = vhci_shutdown_connection;
-	vdev->ud.eh_ops.reset = vhci_device_reset;
-	vdev->ud.eh_ops.unusable = vhci_device_unusable;
-
-	usbip_start_eh(&vdev->ud);
-}
-
-static int vhci_start(struct usb_hcd *hcd)
-{
-	struct vhci_hcd *vhci = hcd_to_vhci(hcd);
-	int rhport;
-	int err = 0;
-
-	usbip_dbg_vhci_hc("enter vhci_start\n");
-
-	/* initialize private data of usb_hcd */
-
-	for (rhport = 0; rhport < VHCI_NPORTS; rhport++) {
-		struct vhci_device *vdev = &vhci->vdev[rhport];
-		vhci_device_init(vdev);
-		vdev->rhport = rhport;
-	}
-
-	atomic_set(&vhci->seqnum, 0);
-	spin_lock_init(&vhci->lock);
-
-	hcd->power_budget = 0; /* no limit */
-	hcd->uses_new_polling = 1;
-
-	/* vhci_hcd is now ready to be controlled through sysfs */
-	err = sysfs_create_group(&vhci_dev(vhci)->kobj, &dev_attr_group);
-	if (err) {
-		pr_err("create sysfs files\n");
-		return err;
-	}
-
-	return 0;
-}
-
-static void vhci_stop(struct usb_hcd *hcd)
-{
-	struct vhci_hcd *vhci = hcd_to_vhci(hcd);
-	int rhport = 0;
-
-	usbip_dbg_vhci_hc("stop VHCI controller\n");
-
-	/* 1. remove the userland interface of vhci_hcd */
-	sysfs_remove_group(&vhci_dev(vhci)->kobj, &dev_attr_group);
-
-	/* 2. shutdown all the ports of vhci_hcd */
-	for (rhport = 0; rhport < VHCI_NPORTS; rhport++) {
-		struct vhci_device *vdev = &vhci->vdev[rhport];
-
-		usbip_event_add(&vdev->ud, VDEV_EVENT_REMOVED);
-		usbip_stop_eh(&vdev->ud);
-	}
-}
-
-static int vhci_get_frame_number(struct usb_hcd *hcd)
-{
-	pr_err("Not yet implemented\n");
-	return 0;
-}
-
-#ifdef CONFIG_PM
-
-/* FIXME: suspend/resume */
-static int vhci_bus_suspend(struct usb_hcd *hcd)
-{
-	struct vhci_hcd *vhci = hcd_to_vhci(hcd);
-
-	dev_dbg(&hcd->self.root_hub->dev, "%s\n", __func__);
-
-	spin_lock(&vhci->lock);
-	hcd->state = HC_STATE_SUSPENDED;
-	spin_unlock(&vhci->lock);
-
-	return 0;
-}
-
-static int vhci_bus_resume(struct usb_hcd *hcd)
-{
-	struct vhci_hcd *vhci = hcd_to_vhci(hcd);
-	int rc = 0;
-
-	dev_dbg(&hcd->self.root_hub->dev, "%s\n", __func__);
-
-	spin_lock(&vhci->lock);
-	if (!HCD_HW_ACCESSIBLE(hcd))
-		rc = -ESHUTDOWN;
-	else
-		hcd->state = HC_STATE_RUNNING;
-	spin_unlock(&vhci->lock);
-
-	return rc;
-}
-
-#else
-
-#define vhci_bus_suspend      NULL
-#define vhci_bus_resume       NULL
-#endif
-
-static struct hc_driver vhci_hc_driver = {
-	.description	= driver_name,
-	.product_desc	= driver_desc,
-	.hcd_priv_size	= sizeof(struct vhci_hcd),
-
-	.flags		= HCD_USB2,
-
-	.start		= vhci_start,
-	.stop		= vhci_stop,
-
-	.urb_enqueue	= vhci_urb_enqueue,
-	.urb_dequeue	= vhci_urb_dequeue,
-
-	.get_frame_number = vhci_get_frame_number,
-
-	.hub_status_data = vhci_hub_status,
-	.hub_control    = vhci_hub_control,
-	.bus_suspend	= vhci_bus_suspend,
-	.bus_resume	= vhci_bus_resume,
-};
-
-static int vhci_hcd_probe(struct platform_device *pdev)
-{
-	struct usb_hcd		*hcd;
-	int			ret;
-
-	usbip_dbg_vhci_hc("name %s id %d\n", pdev->name, pdev->id);
-
-	/*
-	 * Allocate and initialize hcd.
-	 * Our private data is also allocated automatically.
-	 */
-	hcd = usb_create_hcd(&vhci_hc_driver, &pdev->dev, dev_name(&pdev->dev));
-	if (!hcd) {
-		pr_err("create hcd failed\n");
-		return -ENOMEM;
-	}
-	hcd->has_tt = 1;
-
-	/* this is private data for vhci_hcd */
-	the_controller = hcd_to_vhci(hcd);
-
-	/*
-	 * Finish generic HCD structure initialization and register.
-	 * Call the driver's reset() and start() routines.
-	 */
-	ret = usb_add_hcd(hcd, 0, 0);
-	if (ret != 0) {
-		pr_err("usb_add_hcd failed %d\n", ret);
-		usb_put_hcd(hcd);
-		the_controller = NULL;
-		return ret;
-	}
-
-	usbip_dbg_vhci_hc("bye\n");
-	return 0;
-}
-
-static int vhci_hcd_remove(struct platform_device *pdev)
-{
-	struct usb_hcd	*hcd;
-
-	hcd = platform_get_drvdata(pdev);
-	if (!hcd)
-		return 0;
-
-	/*
-	 * Disconnects the root hub,
-	 * then reverses the effects of usb_add_hcd(),
-	 * invoking the HCD's stop() methods.
-	 */
-	usb_remove_hcd(hcd);
-	usb_put_hcd(hcd);
-	the_controller = NULL;
-
-	return 0;
-}
-
-#ifdef CONFIG_PM
-
-/* what should happen for USB/IP under suspend/resume? */
-static int vhci_hcd_suspend(struct platform_device *pdev, pm_message_t state)
-{
-	struct usb_hcd *hcd;
-	int rhport = 0;
-	int connected = 0;
-	int ret = 0;
-
-	hcd = platform_get_drvdata(pdev);
-
-	spin_lock(&the_controller->lock);
-
-	for (rhport = 0; rhport < VHCI_NPORTS; rhport++)
-		if (the_controller->port_status[rhport] &
-		    USB_PORT_STAT_CONNECTION)
-			connected += 1;
-
-	spin_unlock(&the_controller->lock);
-
-	if (connected > 0) {
-		dev_info(&pdev->dev, "We have %d active connection%s. Do not "
-			 "suspend.\n", connected, (connected == 1 ? "" : "s"));
-		ret =  -EBUSY;
-	} else {
-		dev_info(&pdev->dev, "suspend vhci_hcd");
-		clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
-	}
-
-	return ret;
-}
-
-static int vhci_hcd_resume(struct platform_device *pdev)
-{
-	struct usb_hcd *hcd;
-
-	dev_dbg(&pdev->dev, "%s\n", __func__);
-
-	hcd = platform_get_drvdata(pdev);
-	set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
-	usb_hcd_poll_rh_status(hcd);
-
-	return 0;
-}
-
-#else
-
-#define vhci_hcd_suspend	NULL
-#define vhci_hcd_resume		NULL
-
-#endif
-
-static struct platform_driver vhci_driver = {
-	.probe	= vhci_hcd_probe,
-	.remove	= vhci_hcd_remove,
-	.suspend = vhci_hcd_suspend,
-	.resume	= vhci_hcd_resume,
-	.driver	= {
-		.name = driver_name,
-		.owner = THIS_MODULE,
-	},
-};
-
-/*
- * The VHCI 'device' is 'virtual'; not a real plug&play hardware.
- * We need to add this virtual device as a platform device arbitrarily:
- *	1. platform_device_register()
- */
-static void the_pdev_release(struct device *dev)
-{
-	return;
-}
-
-static struct platform_device the_pdev = {
-	/* should be the same name as driver_name */
-	.name = driver_name,
-	.id = -1,
-	.dev = {
-		.release = the_pdev_release,
-	},
-};
-
-static int __init vhci_hcd_init(void)
-{
-	int ret;
-
-	if (usb_disabled())
-		return -ENODEV;
-
-	ret = platform_driver_register(&vhci_driver);
-	if (ret)
-		goto err_driver_register;
-
-	ret = platform_device_register(&the_pdev);
-	if (ret)
-		goto err_platform_device_register;
-
-	pr_info(DRIVER_DESC " v" USBIP_VERSION "\n");
-	return ret;
-
-err_platform_device_register:
-	platform_driver_unregister(&vhci_driver);
-err_driver_register:
-	return ret;
-}
-
-static void __exit vhci_hcd_exit(void)
-{
-	platform_device_unregister(&the_pdev);
-	platform_driver_unregister(&vhci_driver);
-}
-
-module_init(vhci_hcd_init);
-module_exit(vhci_hcd_exit);
-
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
-MODULE_LICENSE("GPL");
-MODULE_VERSION(USBIP_VERSION);
diff --git a/drivers/staging/usbip/vhci_rx.c b/drivers/staging/usbip/vhci_rx.c
deleted file mode 100644
index d07fcb5..0000000
--- a/drivers/staging/usbip/vhci_rx.c
+++ /dev/null
@@ -1,270 +0,0 @@
-/*
- * Copyright (C) 2003-2008 Takahiro Hirofuchi
- *
- * This is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
- * USA.
- */
-
-#include <linux/kthread.h>
-#include <linux/slab.h>
-
-#include "usbip_common.h"
-#include "vhci.h"
-
-/* get URB from transmitted urb queue. caller must hold vdev->priv_lock */
-struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev, __u32 seqnum)
-{
-	struct vhci_priv *priv, *tmp;
-	struct urb *urb = NULL;
-	int status;
-
-	list_for_each_entry_safe(priv, tmp, &vdev->priv_rx, list) {
-		if (priv->seqnum != seqnum)
-			continue;
-
-		urb = priv->urb;
-		status = urb->status;
-
-		usbip_dbg_vhci_rx("find urb %p vurb %p seqnum %u\n",
-				urb, priv, seqnum);
-
-		switch (status) {
-		case -ENOENT:
-			/* fall through */
-		case -ECONNRESET:
-			dev_info(&urb->dev->dev,
-				 "urb %p was unlinked %ssynchronuously.\n", urb,
-				 status == -ENOENT ? "" : "a");
-			break;
-		case -EINPROGRESS:
-			/* no info output */
-			break;
-		default:
-			dev_info(&urb->dev->dev,
-				 "urb %p may be in a error, status %d\n", urb,
-				 status);
-		}
-
-		list_del(&priv->list);
-		kfree(priv);
-		urb->hcpriv = NULL;
-
-		break;
-	}
-
-	return urb;
-}
-
-static void vhci_recv_ret_submit(struct vhci_device *vdev,
-				 struct usbip_header *pdu)
-{
-	struct usbip_device *ud = &vdev->ud;
-	struct urb *urb;
-
-	spin_lock(&vdev->priv_lock);
-	urb = pickup_urb_and_free_priv(vdev, pdu->base.seqnum);
-	spin_unlock(&vdev->priv_lock);
-
-	if (!urb) {
-		pr_err("cannot find a urb of seqnum %u\n", pdu->base.seqnum);
-		pr_info("max seqnum %d\n",
-			atomic_read(&the_controller->seqnum));
-		usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
-		return;
-	}
-
-	/* unpack the pdu to a urb */
-	usbip_pack_pdu(pdu, urb, USBIP_RET_SUBMIT, 0);
-
-	/* recv transfer buffer */
-	if (usbip_recv_xbuff(ud, urb) < 0)
-		return;
-
-	/* recv iso_packet_descriptor */
-	if (usbip_recv_iso(ud, urb) < 0)
-		return;
-
-	/* restore the padding in iso packets */
-	usbip_pad_iso(ud, urb);
-
-	if (usbip_dbg_flag_vhci_rx)
-		usbip_dump_urb(urb);
-
-	usbip_dbg_vhci_rx("now giveback urb %p\n", urb);
-
-	spin_lock(&the_controller->lock);
-	usb_hcd_unlink_urb_from_ep(vhci_to_hcd(the_controller), urb);
-	spin_unlock(&the_controller->lock);
-
-	usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb, urb->status);
-
-	usbip_dbg_vhci_rx("Leave\n");
-
-	return;
-}
-
-static struct vhci_unlink *dequeue_pending_unlink(struct vhci_device *vdev,
-						  struct usbip_header *pdu)
-{
-	struct vhci_unlink *unlink, *tmp;
-
-	spin_lock(&vdev->priv_lock);
-
-	list_for_each_entry_safe(unlink, tmp, &vdev->unlink_rx, list) {
-		pr_info("unlink->seqnum %lu\n", unlink->seqnum);
-		if (unlink->seqnum == pdu->base.seqnum) {
-			usbip_dbg_vhci_rx("found pending unlink, %lu\n",
-					  unlink->seqnum);
-			list_del(&unlink->list);
-
-			spin_unlock(&vdev->priv_lock);
-			return unlink;
-		}
-	}
-
-	spin_unlock(&vdev->priv_lock);
-
-	return NULL;
-}
-
-static void vhci_recv_ret_unlink(struct vhci_device *vdev,
-				 struct usbip_header *pdu)
-{
-	struct vhci_unlink *unlink;
-	struct urb *urb;
-
-	usbip_dump_header(pdu);
-
-	unlink = dequeue_pending_unlink(vdev, pdu);
-	if (!unlink) {
-		pr_info("cannot find the pending unlink %u\n",
-			pdu->base.seqnum);
-		return;
-	}
-
-	spin_lock(&vdev->priv_lock);
-	urb = pickup_urb_and_free_priv(vdev, unlink->unlink_seqnum);
-	spin_unlock(&vdev->priv_lock);
-
-	if (!urb) {
-		/*
-		 * I get the result of a unlink request. But, it seems that I
-		 * already received the result of its submit result and gave
-		 * back the URB.
-		 */
-		pr_info("the urb (seqnum %d) was already given back\n",
-			pdu->base.seqnum);
-	} else {
-		usbip_dbg_vhci_rx("now giveback urb %p\n", urb);
-
-		/* If unlink is successful, status is -ECONNRESET */
-		urb->status = pdu->u.ret_unlink.status;
-		pr_info("urb->status %d\n", urb->status);
-
-		spin_lock(&the_controller->lock);
-		usb_hcd_unlink_urb_from_ep(vhci_to_hcd(the_controller), urb);
-		spin_unlock(&the_controller->lock);
-
-		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb,
-				     urb->status);
-	}
-
-	kfree(unlink);
-}
-
-static int vhci_priv_tx_empty(struct vhci_device *vdev)
-{
-	int empty = 0;
-
-	spin_lock(&vdev->priv_lock);
-	empty = list_empty(&vdev->priv_rx);
-	spin_unlock(&vdev->priv_lock);
-
-	return empty;
-}
-
-/* recv a pdu */
-static void vhci_rx_pdu(struct usbip_device *ud)
-{
-	int ret;
-	struct usbip_header pdu;
-	struct vhci_device *vdev = container_of(ud, struct vhci_device, ud);
-
-	usbip_dbg_vhci_rx("Enter\n");
-
-	memset(&pdu, 0, sizeof(pdu));
-
-	/* receive a pdu header */
-	ret = usbip_recv(ud->tcp_socket, &pdu, sizeof(pdu));
-	if (ret < 0) {
-		if (ret == -ECONNRESET)
-			pr_info("connection reset by peer\n");
-		else if (ret == -EAGAIN) {
-			/* ignore if connection was idle */
-			if (vhci_priv_tx_empty(vdev))
-				return;
-			pr_info("connection timed out with pending urbs\n");
-		} else if (ret != -ERESTARTSYS)
-			pr_info("xmit failed %d\n", ret);
-
-		usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
-		return;
-	}
-	if (ret == 0) {
-		pr_info("connection closed");
-		usbip_event_add(ud, VDEV_EVENT_DOWN);
-		return;
-	}
-	if (ret != sizeof(pdu)) {
-		pr_err("received pdu size is %d, should be %d\n", ret,
-		       (unsigned int)sizeof(pdu));
-		usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
-		return;
-	}
-
-	usbip_header_correct_endian(&pdu, 0);
-
-	if (usbip_dbg_flag_vhci_rx)
-		usbip_dump_header(&pdu);
-
-	switch (pdu.base.command) {
-	case USBIP_RET_SUBMIT:
-		vhci_recv_ret_submit(vdev, &pdu);
-		break;
-	case USBIP_RET_UNLINK:
-		vhci_recv_ret_unlink(vdev, &pdu);
-		break;
-	default:
-		/* NOT REACHED */
-		pr_err("unknown pdu %u\n", pdu.base.command);
-		usbip_dump_header(&pdu);
-		usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
-		break;
-	}
-}
-
-int vhci_rx_loop(void *data)
-{
-	struct usbip_device *ud = data;
-
-	while (!kthread_should_stop()) {
-		if (usbip_event_happened(ud))
-			break;
-
-		vhci_rx_pdu(ud);
-	}
-
-	return 0;
-}
diff --git a/drivers/staging/usbip/vhci_sysfs.c b/drivers/staging/usbip/vhci_sysfs.c
deleted file mode 100644
index 82dd49f..0000000
--- a/drivers/staging/usbip/vhci_sysfs.c
+++ /dev/null
@@ -1,252 +0,0 @@
-/*
- * Copyright (C) 2003-2008 Takahiro Hirofuchi
- *
- * This is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
- * USA.
- */
-
-#include <linux/kthread.h>
-#include <linux/file.h>
-#include <linux/net.h>
-
-#include "usbip_common.h"
-#include "vhci.h"
-
-/* TODO: refine locking ?*/
-
-/* Sysfs entry to show port status */
-static ssize_t status_show(struct device *dev, struct device_attribute *attr,
-			   char *out)
-{
-	char *s = out;
-	int i = 0;
-
-	BUG_ON(!the_controller || !out);
-
-	spin_lock(&the_controller->lock);
-
-	/*
-	 * output example:
-	 * prt sta spd dev socket           local_busid
-	 * 000 004 000 000         c5a7bb80 1-2.3
-	 * 001 004 000 000         d8cee980 2-3.4
-	 *
-	 * IP address can be retrieved from a socket pointer address by looking
-	 * up /proc/net/{tcp,tcp6}. Also, a userland program may remember a
-	 * port number and its peer IP address.
-	 */
-	out += sprintf(out, "prt sta spd bus dev socket           "
-		       "local_busid\n");
-
-	for (i = 0; i < VHCI_NPORTS; i++) {
-		struct vhci_device *vdev = port_to_vdev(i);
-
-		spin_lock(&vdev->ud.lock);
-		out += sprintf(out, "%03u %03u ", i, vdev->ud.status);
-
-		if (vdev->ud.status == VDEV_ST_USED) {
-			out += sprintf(out, "%03u %08x ",
-				       vdev->speed, vdev->devid);
-			out += sprintf(out, "%16p ", vdev->ud.tcp_socket);
-			out += sprintf(out, "%s", dev_name(&vdev->udev->dev));
-
-		} else {
-			out += sprintf(out, "000 000 000 0000000000000000 0-0");
-		}
-
-		out += sprintf(out, "\n");
-		spin_unlock(&vdev->ud.lock);
-	}
-
-	spin_unlock(&the_controller->lock);
-
-	return out - s;
-}
-static DEVICE_ATTR_RO(status);
-
-/* Sysfs entry to shutdown a virtual connection */
-static int vhci_port_disconnect(__u32 rhport)
-{
-	struct vhci_device *vdev;
-
-	usbip_dbg_vhci_sysfs("enter\n");
-
-	/* lock */
-	spin_lock(&the_controller->lock);
-
-	vdev = port_to_vdev(rhport);
-
-	spin_lock(&vdev->ud.lock);
-	if (vdev->ud.status == VDEV_ST_NULL) {
-		pr_err("not connected %d\n", vdev->ud.status);
-
-		/* unlock */
-		spin_unlock(&vdev->ud.lock);
-		spin_unlock(&the_controller->lock);
-
-		return -EINVAL;
-	}
-
-	/* unlock */
-	spin_unlock(&vdev->ud.lock);
-	spin_unlock(&the_controller->lock);
-
-	usbip_event_add(&vdev->ud, VDEV_EVENT_DOWN);
-
-	return 0;
-}
-
-static ssize_t store_detach(struct device *dev, struct device_attribute *attr,
-			    const char *buf, size_t count)
-{
-	int err;
-	__u32 rhport = 0;
-
-	if (sscanf(buf, "%u", &rhport) != 1)
-		return -EINVAL;
-
-	/* check rhport */
-	if (rhport >= VHCI_NPORTS) {
-		dev_err(dev, "invalid port %u\n", rhport);
-		return -EINVAL;
-	}
-
-	err = vhci_port_disconnect(rhport);
-	if (err < 0)
-		return -EINVAL;
-
-	usbip_dbg_vhci_sysfs("Leave\n");
-
-	return count;
-}
-static DEVICE_ATTR(detach, S_IWUSR, NULL, store_detach);
-
-/* Sysfs entry to establish a virtual connection */
-static int valid_args(__u32 rhport, enum usb_device_speed speed)
-{
-	/* check rhport */
-	if (rhport >= VHCI_NPORTS) {
-		pr_err("port %u\n", rhport);
-		return -EINVAL;
-	}
-
-	/* check speed */
-	switch (speed) {
-	case USB_SPEED_LOW:
-	case USB_SPEED_FULL:
-	case USB_SPEED_HIGH:
-	case USB_SPEED_WIRELESS:
-		break;
-	default:
-		pr_err("Failed attach request for unsupported USB speed: %s\n",
-			usb_speed_string(speed));
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-/*
- * To start a new USB/IP attachment, a userland program needs to setup a TCP
- * connection and then write its socket descriptor with remote device
- * information into this sysfs file.
- *
- * A remote device is virtually attached to the root-hub port of @rhport with
- * @speed. @devid is embedded into a request to specify the remote device in a
- * server host.
- *
- * write() returns 0 on success, else negative errno.
- */
-static ssize_t store_attach(struct device *dev, struct device_attribute *attr,
-			    const char *buf, size_t count)
-{
-	struct vhci_device *vdev;
-	struct socket *socket;
-	int sockfd = 0;
-	__u32 rhport = 0, devid = 0, speed = 0;
-
-	/*
-	 * @rhport: port number of vhci_hcd
-	 * @sockfd: socket descriptor of an established TCP connection
-	 * @devid: unique device identifier in a remote host
-	 * @speed: usb device speed in a remote host
-	 */
-	if (sscanf(buf, "%u %u %u %u", &rhport, &sockfd, &devid, &speed) != 1)
-		return -EINVAL;
-
-	usbip_dbg_vhci_sysfs("rhport(%u) sockfd(%u) devid(%u) speed(%u)\n",
-			     rhport, sockfd, devid, speed);
-
-	/* check received parameters */
-	if (valid_args(rhport, speed) < 0)
-		return -EINVAL;
-
-	/* Extract socket from fd. */
-	/* The correct way to clean this up is to fput(socket->file). */
-	socket = sockfd_to_socket(sockfd);
-	if (!socket)
-		return -EINVAL;
-
-	/* now need lock until setting vdev status as used */
-
-	/* begin a lock */
-	spin_lock(&the_controller->lock);
-	vdev = port_to_vdev(rhport);
-	spin_lock(&vdev->ud.lock);
-
-	if (vdev->ud.status != VDEV_ST_NULL) {
-		/* end of the lock */
-		spin_unlock(&vdev->ud.lock);
-		spin_unlock(&the_controller->lock);
-
-		fput(socket->file);
-
-		dev_err(dev, "port %d already used\n", rhport);
-		return -EINVAL;
-	}
-
-	dev_info(dev,
-		 "rhport(%u) sockfd(%d) devid(%u) speed(%u) speed_str(%s)\n",
-		 rhport, sockfd, devid, speed, usb_speed_string(speed));
-
-	vdev->devid         = devid;
-	vdev->speed         = speed;
-	vdev->ud.tcp_socket = socket;
-	vdev->ud.status     = VDEV_ST_NOTASSIGNED;
-
-	spin_unlock(&vdev->ud.lock);
-	spin_unlock(&the_controller->lock);
-	/* end the lock */
-
-	vdev->ud.tcp_rx = kthread_get_run(vhci_rx_loop, &vdev->ud, "vhci_rx");
-	vdev->ud.tcp_tx = kthread_get_run(vhci_tx_loop, &vdev->ud, "vhci_tx");
-
-	rh_port_connect(rhport, speed);
-
-	return count;
-}
-static DEVICE_ATTR(attach, S_IWUSR, NULL, store_attach);
-
-static struct attribute *dev_attrs[] = {
-	&dev_attr_status.attr,
-	&dev_attr_detach.attr,
-	&dev_attr_attach.attr,
-	&dev_attr_usbip_debug.attr,
-	NULL,
-};
-
-const struct attribute_group dev_attr_group = {
-	.attrs = dev_attrs,
-};
diff --git a/drivers/staging/usbip/vhci_tx.c b/drivers/staging/usbip/vhci_tx.c
deleted file mode 100644
index 409fd99..0000000
--- a/drivers/staging/usbip/vhci_tx.c
+++ /dev/null
@@ -1,224 +0,0 @@
-/*
- * Copyright (C) 2003-2008 Takahiro Hirofuchi
- *
- * This is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
- * USA.
- */
-
-#include <linux/kthread.h>
-#include <linux/slab.h>
-
-#include "usbip_common.h"
-#include "vhci.h"
-
-static void setup_cmd_submit_pdu(struct usbip_header *pdup,  struct urb *urb)
-{
-	struct vhci_priv *priv = ((struct vhci_priv *)urb->hcpriv);
-	struct vhci_device *vdev = priv->vdev;
-
-	usbip_dbg_vhci_tx("URB, local devnum %u, remote devid %u\n",
-			  usb_pipedevice(urb->pipe), vdev->devid);
-
-	pdup->base.command   = USBIP_CMD_SUBMIT;
-	pdup->base.seqnum    = priv->seqnum;
-	pdup->base.devid     = vdev->devid;
-	pdup->base.direction = usb_pipein(urb->pipe) ?
-		USBIP_DIR_IN : USBIP_DIR_OUT;
-	pdup->base.ep	     = usb_pipeendpoint(urb->pipe);
-
-	usbip_pack_pdu(pdup, urb, USBIP_CMD_SUBMIT, 1);
-
-	if (urb->setup_packet)
-		memcpy(pdup->u.cmd_submit.setup, urb->setup_packet, 8);
-}
-
-static struct vhci_priv *dequeue_from_priv_tx(struct vhci_device *vdev)
-{
-	struct vhci_priv *priv, *tmp;
-
-	spin_lock(&vdev->priv_lock);
-
-	list_for_each_entry_safe(priv, tmp, &vdev->priv_tx, list) {
-		list_move_tail(&priv->list, &vdev->priv_rx);
-		spin_unlock(&vdev->priv_lock);
-		return priv;
-	}
-
-	spin_unlock(&vdev->priv_lock);
-
-	return NULL;
-}
-
-static int vhci_send_cmd_submit(struct vhci_device *vdev)
-{
-	struct vhci_priv *priv = NULL;
-
-	struct msghdr msg;
-	struct kvec iov[3];
-	size_t txsize;
-
-	size_t total_size = 0;
-
-	while ((priv = dequeue_from_priv_tx(vdev)) != NULL) {
-		int ret;
-		struct urb *urb = priv->urb;
-		struct usbip_header pdu_header;
-		struct usbip_iso_packet_descriptor *iso_buffer = NULL;
-
-		txsize = 0;
-		memset(&pdu_header, 0, sizeof(pdu_header));
-		memset(&msg, 0, sizeof(msg));
-		memset(&iov, 0, sizeof(iov));
-
-		usbip_dbg_vhci_tx("setup txdata urb %p\n", urb);
-
-		/* 1. setup usbip_header */
-		setup_cmd_submit_pdu(&pdu_header, urb);
-		usbip_header_correct_endian(&pdu_header, 1);
-
-		iov[0].iov_base = &pdu_header;
-		iov[0].iov_len  = sizeof(pdu_header);
-		txsize += sizeof(pdu_header);
-
-		/* 2. setup transfer buffer */
-		if (!usb_pipein(urb->pipe) && urb->transfer_buffer_length > 0) {
-			iov[1].iov_base = urb->transfer_buffer;
-			iov[1].iov_len  = urb->transfer_buffer_length;
-			txsize += urb->transfer_buffer_length;
-		}
-
-		/* 3. setup iso_packet_descriptor */
-		if (usb_pipetype(urb->pipe) == PIPE_ISOCHRONOUS) {
-			ssize_t len = 0;
-
-			iso_buffer = usbip_alloc_iso_desc_pdu(urb, &len);
-			if (!iso_buffer) {
-				usbip_event_add(&vdev->ud,
-						SDEV_EVENT_ERROR_MALLOC);
-				return -1;
-			}
-
-			iov[2].iov_base = iso_buffer;
-			iov[2].iov_len  = len;
-			txsize += len;
-		}
-
-		ret = kernel_sendmsg(vdev->ud.tcp_socket, &msg, iov, 3, txsize);
-		if (ret != txsize) {
-			pr_err("sendmsg failed!, ret=%d for %zd\n", ret,
-			       txsize);
-			kfree(iso_buffer);
-			usbip_event_add(&vdev->ud, VDEV_EVENT_ERROR_TCP);
-			return -1;
-		}
-
-		kfree(iso_buffer);
-		usbip_dbg_vhci_tx("send txdata\n");
-
-		total_size += txsize;
-	}
-
-	return total_size;
-}
-
-static struct vhci_unlink *dequeue_from_unlink_tx(struct vhci_device *vdev)
-{
-	struct vhci_unlink *unlink, *tmp;
-
-	spin_lock(&vdev->priv_lock);
-
-	list_for_each_entry_safe(unlink, tmp, &vdev->unlink_tx, list) {
-		list_move_tail(&unlink->list, &vdev->unlink_rx);
-		spin_unlock(&vdev->priv_lock);
-		return unlink;
-	}
-
-	spin_unlock(&vdev->priv_lock);
-
-	return NULL;
-}
-
-static int vhci_send_cmd_unlink(struct vhci_device *vdev)
-{
-	struct vhci_unlink *unlink = NULL;
-
-	struct msghdr msg;
-	struct kvec iov[3];
-	size_t txsize;
-
-	size_t total_size = 0;
-
-	while ((unlink = dequeue_from_unlink_tx(vdev)) != NULL) {
-		int ret;
-		struct usbip_header pdu_header;
-
-		txsize = 0;
-		memset(&pdu_header, 0, sizeof(pdu_header));
-		memset(&msg, 0, sizeof(msg));
-		memset(&iov, 0, sizeof(iov));
-
-		usbip_dbg_vhci_tx("setup cmd unlink, %lu\n", unlink->seqnum);
-
-		/* 1. setup usbip_header */
-		pdu_header.base.command = USBIP_CMD_UNLINK;
-		pdu_header.base.seqnum  = unlink->seqnum;
-		pdu_header.base.devid	= vdev->devid;
-		pdu_header.base.ep	= 0;
-		pdu_header.u.cmd_unlink.seqnum = unlink->unlink_seqnum;
-
-		usbip_header_correct_endian(&pdu_header, 1);
-
-		iov[0].iov_base = &pdu_header;
-		iov[0].iov_len  = sizeof(pdu_header);
-		txsize += sizeof(pdu_header);
-
-		ret = kernel_sendmsg(vdev->ud.tcp_socket, &msg, iov, 1, txsize);
-		if (ret != txsize) {
-			pr_err("sendmsg failed!, ret=%d for %zd\n", ret,
-			       txsize);
-			usbip_event_add(&vdev->ud, VDEV_EVENT_ERROR_TCP);
-			return -1;
-		}
-
-		usbip_dbg_vhci_tx("send txdata\n");
-
-		total_size += txsize;
-	}
-
-	return total_size;
-}
-
-int vhci_tx_loop(void *data)
-{
-	struct usbip_device *ud = data;
-	struct vhci_device *vdev = container_of(ud, struct vhci_device, ud);
-
-	while (!kthread_should_stop()) {
-		if (vhci_send_cmd_submit(vdev) < 0)
-			break;
-
-		if (vhci_send_cmd_unlink(vdev) < 0)
-			break;
-
-		wait_event_interruptible(vdev->waitq_tx,
-					 (!list_empty(&vdev->priv_tx) ||
-					  !list_empty(&vdev->unlink_tx) ||
-					  kthread_should_stop()));
-
-		usbip_dbg_vhci_tx("pending urbs ?, now wake up\n");
-	}
-
-	return 0;
-}
diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index 2e6b832..735d2ea 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -151,6 +151,8 @@ source "drivers/usb/misc/Kconfig"
 
 source "drivers/usb/atm/Kconfig"
 
+source "drivers/usb/usbip/Kconfig"
+
 endif # USB
 
 source "drivers/usb/phy/Kconfig"
diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
index 1ae2bf3..884b605 100644
--- a/drivers/usb/Makefile
+++ b/drivers/usb/Makefile
@@ -59,3 +59,5 @@ obj-$(CONFIG_USB_RENESAS_USBHS)	+= renesas_usbhs/
 obj-$(CONFIG_USB_GADGET)	+= gadget/
 
 obj-$(CONFIG_USB_COMMON)	+= usb-common.o
+
+obj-$(CONFIG_USBIP_CORE)	+= usbip/
diff --git a/drivers/usb/usbip/Kconfig b/drivers/usb/usbip/Kconfig
new file mode 100644
index 0000000..8860009
--- /dev/null
+++ b/drivers/usb/usbip/Kconfig
@@ -0,0 +1,45 @@
+config USBIP_CORE
+	tristate "USB/IP support"
+	depends on USB && NET
+	default N
+	---help---
+	  This enables pushing USB packets over IP to allow remote
+	  machines direct access to USB devices. It provides the
+	  USB/IP core that is required by both drivers.
+
+	  For more details, and to get the userspace utility
+	  programs, please see <http://usbip.sourceforge.net/>.
+
+	  To compile this as a module, choose M here: the module will
+	  be called usbip-core.
+
+	  If unsure, say N.
+
+config USBIP_VHCI_HCD
+	tristate "VHCI hcd"
+	depends on USBIP_CORE
+	default N
+	---help---
+	  This enables the USB/IP virtual host controller driver,
+	  which is run on the remote machine.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called vhci-hcd.
+
+config USBIP_HOST
+	tristate "Host driver"
+	depends on USBIP_CORE
+	default N
+	---help---
+	  This enables the USB/IP host driver, which is run on the
+	  machine that is sharing the USB devices.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called usbip-host.
+
+config USBIP_DEBUG
+	bool "Debug messages for USB/IP"
+	depends on USBIP_CORE
+	default N
+	---help---
+	  This enables the debug messages from the USB/IP drivers.
diff --git a/drivers/usb/usbip/Makefile b/drivers/usb/usbip/Makefile
new file mode 100644
index 0000000..9ecd615
--- /dev/null
+++ b/drivers/usb/usbip/Makefile
@@ -0,0 +1,10 @@
+ccflags-$(CONFIG_USBIP_DEBUG) := -DDEBUG
+
+obj-$(CONFIG_USBIP_CORE) += usbip-core.o
+usbip-core-y := usbip_common.o usbip_event.o
+
+obj-$(CONFIG_USBIP_VHCI_HCD) += vhci-hcd.o
+vhci-hcd-y := vhci_sysfs.o vhci_tx.o vhci_rx.o vhci_hcd.o
+
+obj-$(CONFIG_USBIP_HOST) += usbip-host.o
+usbip-host-y := stub_dev.o stub_main.o stub_rx.o stub_tx.o
diff --git a/drivers/usb/usbip/README b/drivers/usb/usbip/README
new file mode 100644
index 0000000..41a2cf2
--- /dev/null
+++ b/drivers/usb/usbip/README
@@ -0,0 +1,7 @@
+TODO:
+	- more discussion about the protocol
+	- testing
+	- review of the userspace interface
+	- document the protocol
+
+Please send patches for this code to Greg Kroah-Hartman <greg@kroah.com>
diff --git a/drivers/usb/usbip/stub.h b/drivers/usb/usbip/stub.h
new file mode 100644
index 0000000..266e2b0
--- /dev/null
+++ b/drivers/usb/usbip/stub.h
@@ -0,0 +1,113 @@
+/*
+ * Copyright (C) 2003-2008 Takahiro Hirofuchi
+ *
+ * This is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
+ * USA.
+ */
+
+#ifndef __USBIP_STUB_H
+#define __USBIP_STUB_H
+
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/usb.h>
+#include <linux/wait.h>
+
+#define STUB_BUSID_OTHER 0
+#define STUB_BUSID_REMOV 1
+#define STUB_BUSID_ADDED 2
+#define STUB_BUSID_ALLOC 3
+
+struct stub_device {
+	struct usb_interface *interface;
+	struct usb_device *udev;
+
+	struct usbip_device ud;
+	__u32 devid;
+
+	/*
+	 * stub_priv preserves private data of each urb.
+	 * It is allocated as stub_priv_cache and assigned to urb->context.
+	 *
+	 * stub_priv is always linked to any one of 3 lists;
+	 *	priv_init: linked to this until the comletion of a urb.
+	 *	priv_tx  : linked to this after the completion of a urb.
+	 *	priv_free: linked to this after the sending of the result.
+	 *
+	 * Any of these list operations should be locked by priv_lock.
+	 */
+	spinlock_t priv_lock;
+	struct list_head priv_init;
+	struct list_head priv_tx;
+	struct list_head priv_free;
+
+	/* see comments for unlinking in stub_rx.c */
+	struct list_head unlink_tx;
+	struct list_head unlink_free;
+
+	wait_queue_head_t tx_waitq;
+};
+
+/* private data into urb->priv */
+struct stub_priv {
+	unsigned long seqnum;
+	struct list_head list;
+	struct stub_device *sdev;
+	struct urb *urb;
+
+	int unlinking;
+};
+
+struct stub_unlink {
+	unsigned long seqnum;
+	struct list_head list;
+	__u32 status;
+};
+
+/* same as SYSFS_BUS_ID_SIZE */
+#define BUSID_SIZE 32
+
+struct bus_id_priv {
+	char name[BUSID_SIZE];
+	char status;
+	int interf_count;
+	struct stub_device *sdev;
+	struct usb_device *udev;
+	char shutdown_busid;
+};
+
+/* stub_priv is allocated from stub_priv_cache */
+extern struct kmem_cache *stub_priv_cache;
+
+/* stub_dev.c */
+extern struct usb_device_driver stub_driver;
+
+/* stub_main.c */
+struct bus_id_priv *get_busid_priv(const char *busid);
+int del_match_busid(char *busid);
+void stub_device_cleanup_urbs(struct stub_device *sdev);
+
+/* stub_rx.c */
+int stub_rx_loop(void *data);
+
+/* stub_tx.c */
+void stub_enqueue_ret_unlink(struct stub_device *sdev, __u32 seqnum,
+			     __u32 status);
+void stub_complete(struct urb *urb);
+int stub_tx_loop(void *data);
+
+#endif /* __USBIP_STUB_H */
diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
new file mode 100644
index 0000000..773d8ca
--- /dev/null
+++ b/drivers/usb/usbip/stub_dev.c
@@ -0,0 +1,524 @@
+/*
+ * Copyright (C) 2003-2008 Takahiro Hirofuchi
+ *
+ * This is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
+ * USA.
+ */
+
+#include <linux/device.h>
+#include <linux/file.h>
+#include <linux/kthread.h>
+#include <linux/module.h>
+
+#include "usbip_common.h"
+#include "stub.h"
+
+/*
+ * Define device IDs here if you want to explicitly limit exportable devices.
+ * In most cases, wildcard matching will be okay because driver binding can be
+ * changed dynamically by a userland program.
+ */
+static struct usb_device_id stub_table[] = {
+#if 0
+	/* just an example */
+	{ USB_DEVICE(0x05ac, 0x0301) },   /* Mac 1 button mouse */
+	{ USB_DEVICE(0x0430, 0x0009) },   /* Plat Home Keyboard */
+	{ USB_DEVICE(0x059b, 0x0001) },   /* Iomega USB Zip 100 */
+	{ USB_DEVICE(0x04b3, 0x4427) },   /* IBM USB CD-ROM */
+	{ USB_DEVICE(0x05a9, 0xa511) },   /* LifeView USB cam */
+	{ USB_DEVICE(0x55aa, 0x0201) },   /* Imation card reader */
+	{ USB_DEVICE(0x046d, 0x0870) },   /* Qcam Express(QV-30) */
+	{ USB_DEVICE(0x04bb, 0x0101) },   /* IO-DATA HD 120GB */
+	{ USB_DEVICE(0x04bb, 0x0904) },   /* IO-DATA USB-ET/TX */
+	{ USB_DEVICE(0x04bb, 0x0201) },   /* IO-DATA USB-ET/TX */
+	{ USB_DEVICE(0x08bb, 0x2702) },   /* ONKYO USB Speaker */
+	{ USB_DEVICE(0x046d, 0x08b2) },   /* Logicool Qcam 4000 Pro */
+#endif
+	/* magic for wild card */
+	{ .driver_info = 1 },
+	{ 0, }                                     /* Terminating entry */
+};
+MODULE_DEVICE_TABLE(usb, stub_table);
+
+/*
+ * usbip_status shows the status of usbip-host as long as this driver is bound
+ * to the target device.
+ */
+static ssize_t usbip_status_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct stub_device *sdev = dev_get_drvdata(dev);
+	int status;
+
+	if (!sdev) {
+		dev_err(dev, "sdev is null\n");
+		return -ENODEV;
+	}
+
+	spin_lock_irq(&sdev->ud.lock);
+	status = sdev->ud.status;
+	spin_unlock_irq(&sdev->ud.lock);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", status);
+}
+static DEVICE_ATTR_RO(usbip_status);
+
+/*
+ * usbip_sockfd gets a socket descriptor of an established TCP connection that
+ * is used to transfer usbip requests by kernel threads. -1 is a magic number
+ * by which usbip connection is finished.
+ */
+static ssize_t store_sockfd(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct stub_device *sdev = dev_get_drvdata(dev);
+	int sockfd = 0;
+	struct socket *socket;
+	ssize_t err = -EINVAL;
+	int rv;
+
+	if (!sdev) {
+		dev_err(dev, "sdev is null\n");
+		return -ENODEV;
+	}
+
+	rv = sscanf(buf, "%d", &sockfd);
+	if (rv != 1)
+		return -EINVAL;
+
+	if (sockfd != -1) {
+		dev_info(dev, "stub up\n");
+
+		spin_lock_irq(&sdev->ud.lock);
+
+		if (sdev->ud.status != SDEV_ST_AVAILABLE) {
+			dev_err(dev, "not ready\n");
+			goto err;
+		}
+
+		socket = sockfd_to_socket(sockfd);
+		if (!socket)
+			goto err;
+
+		sdev->ud.tcp_socket = socket;
+
+		spin_unlock_irq(&sdev->ud.lock);
+
+		sdev->ud.tcp_rx = kthread_get_run(stub_rx_loop, &sdev->ud,
+						  "stub_rx");
+		sdev->ud.tcp_tx = kthread_get_run(stub_tx_loop, &sdev->ud,
+						  "stub_tx");
+
+		spin_lock_irq(&sdev->ud.lock);
+		sdev->ud.status = SDEV_ST_USED;
+		spin_unlock_irq(&sdev->ud.lock);
+
+	} else {
+		dev_info(dev, "stub down\n");
+
+		spin_lock_irq(&sdev->ud.lock);
+		if (sdev->ud.status != SDEV_ST_USED)
+			goto err;
+
+		spin_unlock_irq(&sdev->ud.lock);
+
+		usbip_event_add(&sdev->ud, SDEV_EVENT_DOWN);
+	}
+
+	return count;
+
+err:
+	spin_unlock_irq(&sdev->ud.lock);
+	return err;
+}
+static DEVICE_ATTR(usbip_sockfd, S_IWUSR, NULL, store_sockfd);
+
+static int stub_add_files(struct device *dev)
+{
+	int err = 0;
+
+	err = device_create_file(dev, &dev_attr_usbip_status);
+	if (err)
+		goto err_status;
+
+	err = device_create_file(dev, &dev_attr_usbip_sockfd);
+	if (err)
+		goto err_sockfd;
+
+	err = device_create_file(dev, &dev_attr_usbip_debug);
+	if (err)
+		goto err_debug;
+
+	return 0;
+
+err_debug:
+	device_remove_file(dev, &dev_attr_usbip_sockfd);
+err_sockfd:
+	device_remove_file(dev, &dev_attr_usbip_status);
+err_status:
+	return err;
+}
+
+static void stub_remove_files(struct device *dev)
+{
+	device_remove_file(dev, &dev_attr_usbip_status);
+	device_remove_file(dev, &dev_attr_usbip_sockfd);
+	device_remove_file(dev, &dev_attr_usbip_debug);
+}
+
+static void stub_shutdown_connection(struct usbip_device *ud)
+{
+	struct stub_device *sdev = container_of(ud, struct stub_device, ud);
+
+	/*
+	 * When removing an exported device, kernel panic sometimes occurred
+	 * and then EIP was sk_wait_data of stub_rx thread. Is this because
+	 * sk_wait_data returned though stub_rx thread was already finished by
+	 * step 1?
+	 */
+	if (ud->tcp_socket) {
+		dev_dbg(&sdev->udev->dev, "shutdown tcp_socket %p\n",
+			ud->tcp_socket);
+		kernel_sock_shutdown(ud->tcp_socket, SHUT_RDWR);
+	}
+
+	/* 1. stop threads */
+	if (ud->tcp_rx) {
+		kthread_stop_put(ud->tcp_rx);
+		ud->tcp_rx = NULL;
+	}
+	if (ud->tcp_tx) {
+		kthread_stop_put(ud->tcp_tx);
+		ud->tcp_tx = NULL;
+	}
+
+	/*
+	 * 2. close the socket
+	 *
+	 * tcp_socket is freed after threads are killed so that usbip_xmit does
+	 * not touch NULL socket.
+	 */
+	if (ud->tcp_socket) {
+		fput(ud->tcp_socket->file);
+		ud->tcp_socket = NULL;
+	}
+
+	/* 3. free used data */
+	stub_device_cleanup_urbs(sdev);
+
+	/* 4. free stub_unlink */
+	{
+		unsigned long flags;
+		struct stub_unlink *unlink, *tmp;
+
+		spin_lock_irqsave(&sdev->priv_lock, flags);
+		list_for_each_entry_safe(unlink, tmp, &sdev->unlink_tx, list) {
+			list_del(&unlink->list);
+			kfree(unlink);
+		}
+		list_for_each_entry_safe(unlink, tmp, &sdev->unlink_free,
+					 list) {
+			list_del(&unlink->list);
+			kfree(unlink);
+		}
+		spin_unlock_irqrestore(&sdev->priv_lock, flags);
+	}
+}
+
+static void stub_device_reset(struct usbip_device *ud)
+{
+	struct stub_device *sdev = container_of(ud, struct stub_device, ud);
+	struct usb_device *udev = sdev->udev;
+	int ret;
+
+	dev_dbg(&udev->dev, "device reset");
+
+	ret = usb_lock_device_for_reset(udev, sdev->interface);
+	if (ret < 0) {
+		dev_err(&udev->dev, "lock for reset\n");
+		spin_lock_irq(&ud->lock);
+		ud->status = SDEV_ST_ERROR;
+		spin_unlock_irq(&ud->lock);
+		return;
+	}
+
+	/* try to reset the device */
+	ret = usb_reset_device(udev);
+	usb_unlock_device(udev);
+
+	spin_lock_irq(&ud->lock);
+	if (ret) {
+		dev_err(&udev->dev, "device reset\n");
+		ud->status = SDEV_ST_ERROR;
+	} else {
+		dev_info(&udev->dev, "device reset\n");
+		ud->status = SDEV_ST_AVAILABLE;
+	}
+	spin_unlock_irq(&ud->lock);
+}
+
+static void stub_device_unusable(struct usbip_device *ud)
+{
+	spin_lock_irq(&ud->lock);
+	ud->status = SDEV_ST_ERROR;
+	spin_unlock_irq(&ud->lock);
+}
+
+/**
+ * stub_device_alloc - allocate a new stub_device struct
+ * @interface: usb_interface of a new device
+ *
+ * Allocates and initializes a new stub_device struct.
+ */
+static struct stub_device *stub_device_alloc(struct usb_device *udev)
+{
+	struct stub_device *sdev;
+	int busnum = udev->bus->busnum;
+	int devnum = udev->devnum;
+
+	dev_dbg(&udev->dev, "allocating stub device");
+
+	/* yes, it's a new device */
+	sdev = kzalloc(sizeof(struct stub_device), GFP_KERNEL);
+	if (!sdev)
+		return NULL;
+
+	sdev->udev = usb_get_dev(udev);
+
+	/*
+	 * devid is defined with devnum when this driver is first allocated.
+	 * devnum may change later if a device is reset. However, devid never
+	 * changes during a usbip connection.
+	 */
+	sdev->devid		= (busnum << 16) | devnum;
+	sdev->ud.side		= USBIP_STUB;
+	sdev->ud.status		= SDEV_ST_AVAILABLE;
+	spin_lock_init(&sdev->ud.lock);
+	sdev->ud.tcp_socket	= NULL;
+
+	INIT_LIST_HEAD(&sdev->priv_init);
+	INIT_LIST_HEAD(&sdev->priv_tx);
+	INIT_LIST_HEAD(&sdev->priv_free);
+	INIT_LIST_HEAD(&sdev->unlink_free);
+	INIT_LIST_HEAD(&sdev->unlink_tx);
+	spin_lock_init(&sdev->priv_lock);
+
+	init_waitqueue_head(&sdev->tx_waitq);
+
+	sdev->ud.eh_ops.shutdown = stub_shutdown_connection;
+	sdev->ud.eh_ops.reset    = stub_device_reset;
+	sdev->ud.eh_ops.unusable = stub_device_unusable;
+
+	usbip_start_eh(&sdev->ud);
+
+	dev_dbg(&udev->dev, "register new device\n");
+
+	return sdev;
+}
+
+static void stub_device_free(struct stub_device *sdev)
+{
+	kfree(sdev);
+}
+
+static int stub_probe(struct usb_device *udev)
+{
+	struct stub_device *sdev = NULL;
+	const char *udev_busid = dev_name(&udev->dev);
+	int err = 0;
+	struct bus_id_priv *busid_priv;
+	int rc;
+
+	dev_dbg(&udev->dev, "Enter\n");
+
+	/* check we should claim or not by busid_table */
+	busid_priv = get_busid_priv(udev_busid);
+	if (!busid_priv || (busid_priv->status == STUB_BUSID_REMOV) ||
+	    (busid_priv->status == STUB_BUSID_OTHER)) {
+		dev_info(&udev->dev,
+			"%s is not in match_busid table... skip!\n",
+			udev_busid);
+
+		/*
+		 * Return value should be ENODEV or ENOXIO to continue trying
+		 * other matched drivers by the driver core.
+		 * See driver_probe_device() in driver/base/dd.c
+		 */
+		return -ENODEV;
+	}
+
+	if (udev->descriptor.bDeviceClass == USB_CLASS_HUB) {
+		dev_dbg(&udev->dev, "%s is a usb hub device... skip!\n",
+			 udev_busid);
+		return -ENODEV;
+	}
+
+	if (!strcmp(udev->bus->bus_name, "vhci_hcd")) {
+		dev_dbg(&udev->dev,
+			"%s is attached on vhci_hcd... skip!\n",
+			udev_busid);
+
+		return -ENODEV;
+	}
+
+	/* ok, this is my device */
+	sdev = stub_device_alloc(udev);
+	if (!sdev)
+		return -ENOMEM;
+
+	dev_info(&udev->dev,
+		"usbip-host: register new device (bus %u dev %u)\n",
+		udev->bus->busnum, udev->devnum);
+
+	busid_priv->shutdown_busid = 0;
+
+	/* set private data to usb_device */
+	dev_set_drvdata(&udev->dev, sdev);
+	busid_priv->sdev = sdev;
+	busid_priv->udev = udev;
+
+	/*
+	 * Claim this hub port.
+	 * It doesn't matter what value we pass as owner
+	 * (struct dev_state) as long as it is unique.
+	 */
+	rc = usb_hub_claim_port(udev->parent, udev->portnum,
+			(struct usb_dev_state *) udev);
+	if (rc) {
+		dev_dbg(&udev->dev, "unable to claim port\n");
+		return rc;
+	}
+
+	err = stub_add_files(&udev->dev);
+	if (err) {
+		dev_err(&udev->dev, "stub_add_files for %s\n", udev_busid);
+		dev_set_drvdata(&udev->dev, NULL);
+		usb_put_dev(udev);
+		kthread_stop_put(sdev->ud.eh);
+
+		busid_priv->sdev = NULL;
+		stub_device_free(sdev);
+		return err;
+	}
+	busid_priv->status = STUB_BUSID_ALLOC;
+
+	return 0;
+}
+
+static void shutdown_busid(struct bus_id_priv *busid_priv)
+{
+	if (busid_priv->sdev && !busid_priv->shutdown_busid) {
+		busid_priv->shutdown_busid = 1;
+		usbip_event_add(&busid_priv->sdev->ud, SDEV_EVENT_REMOVED);
+
+		/* wait for the stop of the event handler */
+		usbip_stop_eh(&busid_priv->sdev->ud);
+	}
+}
+
+/*
+ * called in usb_disconnect() or usb_deregister()
+ * but only if actconfig(active configuration) exists
+ */
+static void stub_disconnect(struct usb_device *udev)
+{
+	struct stub_device *sdev;
+	const char *udev_busid = dev_name(&udev->dev);
+	struct bus_id_priv *busid_priv;
+	int rc;
+
+	dev_dbg(&udev->dev, "Enter\n");
+
+	busid_priv = get_busid_priv(udev_busid);
+	if (!busid_priv) {
+		BUG();
+		return;
+	}
+
+	sdev = dev_get_drvdata(&udev->dev);
+
+	/* get stub_device */
+	if (!sdev) {
+		dev_err(&udev->dev, "could not get device");
+		return;
+	}
+
+	dev_set_drvdata(&udev->dev, NULL);
+
+	/*
+	 * NOTE: rx/tx threads are invoked for each usb_device.
+	 */
+	stub_remove_files(&udev->dev);
+
+	/* release port */
+	rc = usb_hub_release_port(udev->parent, udev->portnum,
+				  (struct usb_dev_state *) udev);
+	if (rc) {
+		dev_dbg(&udev->dev, "unable to release port\n");
+		return;
+	}
+
+	/* If usb reset is called from event handler */
+	if (busid_priv->sdev->ud.eh == current)
+		return;
+
+	/* shutdown the current connection */
+	shutdown_busid(busid_priv);
+
+	usb_put_dev(sdev->udev);
+
+	/* free sdev */
+	busid_priv->sdev = NULL;
+	stub_device_free(sdev);
+
+	if (busid_priv->status == STUB_BUSID_ALLOC) {
+		busid_priv->status = STUB_BUSID_ADDED;
+	} else {
+		busid_priv->status = STUB_BUSID_OTHER;
+		del_match_busid((char *)udev_busid);
+	}
+}
+
+#ifdef CONFIG_PM
+
+/* These functions need usb_port_suspend and usb_port_resume,
+ * which reside in drivers/usb/core/usb.h. Skip for now. */
+
+static int stub_suspend(struct usb_device *udev, pm_message_t message)
+{
+	dev_dbg(&udev->dev, "stub_suspend\n");
+
+	return 0;
+}
+
+static int stub_resume(struct usb_device *udev, pm_message_t message)
+{
+	dev_dbg(&udev->dev, "stub_resume\n");
+
+	return 0;
+}
+
+#endif	/* CONFIG_PM */
+
+struct usb_device_driver stub_driver = {
+	.name		= "usbip-host",
+	.probe		= stub_probe,
+	.disconnect	= stub_disconnect,
+#ifdef CONFIG_PM
+	.suspend	= stub_suspend,
+	.resume		= stub_resume,
+#endif
+	.supports_autosuspend	=	0,
+};
diff --git a/drivers/usb/usbip/stub_main.c b/drivers/usb/usbip/stub_main.c
new file mode 100644
index 0000000..9c5832a
--- /dev/null
+++ b/drivers/usb/usbip/stub_main.c
@@ -0,0 +1,339 @@
+/*
+ * Copyright (C) 2003-2008 Takahiro Hirofuchi
+ *
+ * This is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
+ * USA.
+ */
+
+#include <linux/string.h>
+#include <linux/module.h>
+#include <linux/device.h>
+
+#include "usbip_common.h"
+#include "stub.h"
+
+#define DRIVER_AUTHOR "Takahiro Hirofuchi"
+#define DRIVER_DESC "USB/IP Host Driver"
+
+struct kmem_cache *stub_priv_cache;
+/*
+ * busid_tables defines matching busids that usbip can grab. A user can change
+ * dynamically what device is locally used and what device is exported to a
+ * remote host.
+ */
+#define MAX_BUSID 16
+static struct bus_id_priv busid_table[MAX_BUSID];
+static spinlock_t busid_table_lock;
+
+static void init_busid_table(void)
+{
+	/*
+	 * This also sets the bus_table[i].status to
+	 * STUB_BUSID_OTHER, which is 0.
+	 */
+	memset(busid_table, 0, sizeof(busid_table));
+
+	spin_lock_init(&busid_table_lock);
+}
+
+/*
+ * Find the index of the busid by name.
+ * Must be called with busid_table_lock held.
+ */
+static int get_busid_idx(const char *busid)
+{
+	int i;
+	int idx = -1;
+
+	for (i = 0; i < MAX_BUSID; i++)
+		if (busid_table[i].name[0])
+			if (!strncmp(busid_table[i].name, busid, BUSID_SIZE)) {
+				idx = i;
+				break;
+			}
+	return idx;
+}
+
+struct bus_id_priv *get_busid_priv(const char *busid)
+{
+	int idx;
+	struct bus_id_priv *bid = NULL;
+
+	spin_lock(&busid_table_lock);
+	idx = get_busid_idx(busid);
+	if (idx >= 0)
+		bid = &(busid_table[idx]);
+	spin_unlock(&busid_table_lock);
+
+	return bid;
+}
+
+static int add_match_busid(char *busid)
+{
+	int i;
+	int ret = -1;
+
+	spin_lock(&busid_table_lock);
+	/* already registered? */
+	if (get_busid_idx(busid) >= 0) {
+		ret = 0;
+		goto out;
+	}
+
+	for (i = 0; i < MAX_BUSID; i++)
+		if (!busid_table[i].name[0]) {
+			strncpy(busid_table[i].name, busid, BUSID_SIZE);
+			if ((busid_table[i].status != STUB_BUSID_ALLOC) &&
+			    (busid_table[i].status != STUB_BUSID_REMOV))
+				busid_table[i].status = STUB_BUSID_ADDED;
+			ret = 0;
+			break;
+		}
+
+out:
+	spin_unlock(&busid_table_lock);
+
+	return ret;
+}
+
+int del_match_busid(char *busid)
+{
+	int idx;
+	int ret = -1;
+
+	spin_lock(&busid_table_lock);
+	idx = get_busid_idx(busid);
+	if (idx < 0)
+		goto out;
+
+	/* found */
+	ret = 0;
+
+	if (busid_table[idx].status == STUB_BUSID_OTHER)
+		memset(busid_table[idx].name, 0, BUSID_SIZE);
+
+	if ((busid_table[idx].status != STUB_BUSID_OTHER) &&
+	    (busid_table[idx].status != STUB_BUSID_ADDED))
+		busid_table[idx].status = STUB_BUSID_REMOV;
+
+out:
+	spin_unlock(&busid_table_lock);
+
+	return ret;
+}
+
+static ssize_t show_match_busid(struct device_driver *drv, char *buf)
+{
+	int i;
+	char *out = buf;
+
+	spin_lock(&busid_table_lock);
+	for (i = 0; i < MAX_BUSID; i++)
+		if (busid_table[i].name[0])
+			out += sprintf(out, "%s ", busid_table[i].name);
+	spin_unlock(&busid_table_lock);
+	out += sprintf(out, "\n");
+
+	return out - buf;
+}
+
+static ssize_t store_match_busid(struct device_driver *dev, const char *buf,
+				 size_t count)
+{
+	int len;
+	char busid[BUSID_SIZE];
+
+	if (count < 5)
+		return -EINVAL;
+
+	/* strnlen() does not include \0 */
+	len = strnlen(buf + 4, BUSID_SIZE);
+
+	/* busid needs to include \0 termination */
+	if (!(len < BUSID_SIZE))
+		return -EINVAL;
+
+	strncpy(busid, buf + 4, BUSID_SIZE);
+
+	if (!strncmp(buf, "add ", 4)) {
+		if (add_match_busid(busid) < 0)
+			return -ENOMEM;
+
+		pr_debug("add busid %s\n", busid);
+		return count;
+	}
+
+	if (!strncmp(buf, "del ", 4)) {
+		if (del_match_busid(busid) < 0)
+			return -ENODEV;
+
+		pr_debug("del busid %s\n", busid);
+		return count;
+	}
+
+	return -EINVAL;
+}
+static DRIVER_ATTR(match_busid, S_IRUSR | S_IWUSR, show_match_busid,
+		   store_match_busid);
+
+static ssize_t rebind_store(struct device_driver *dev, const char *buf,
+				 size_t count)
+{
+	int ret;
+	int len;
+	struct bus_id_priv *bid;
+
+	/* buf length should be less that BUSID_SIZE */
+	len = strnlen(buf, BUSID_SIZE);
+
+	if (!(len < BUSID_SIZE))
+		return -EINVAL;
+
+	bid = get_busid_priv(buf);
+	if (!bid)
+		return -ENODEV;
+
+	ret = device_attach(&bid->udev->dev);
+	if (ret < 0) {
+		dev_err(&bid->udev->dev, "rebind failed\n");
+		return ret;
+	}
+
+	return count;
+}
+
+static DRIVER_ATTR_WO(rebind);
+
+static struct stub_priv *stub_priv_pop_from_listhead(struct list_head *listhead)
+{
+	struct stub_priv *priv, *tmp;
+
+	list_for_each_entry_safe(priv, tmp, listhead, list) {
+		list_del(&priv->list);
+		return priv;
+	}
+
+	return NULL;
+}
+
+static struct stub_priv *stub_priv_pop(struct stub_device *sdev)
+{
+	unsigned long flags;
+	struct stub_priv *priv;
+
+	spin_lock_irqsave(&sdev->priv_lock, flags);
+
+	priv = stub_priv_pop_from_listhead(&sdev->priv_init);
+	if (priv)
+		goto done;
+
+	priv = stub_priv_pop_from_listhead(&sdev->priv_tx);
+	if (priv)
+		goto done;
+
+	priv = stub_priv_pop_from_listhead(&sdev->priv_free);
+
+done:
+	spin_unlock_irqrestore(&sdev->priv_lock, flags);
+
+	return priv;
+}
+
+void stub_device_cleanup_urbs(struct stub_device *sdev)
+{
+	struct stub_priv *priv;
+	struct urb *urb;
+
+	dev_dbg(&sdev->udev->dev, "free sdev %p\n", sdev);
+
+	while ((priv = stub_priv_pop(sdev))) {
+		urb = priv->urb;
+		dev_dbg(&sdev->udev->dev, "free urb %p\n", urb);
+		usb_kill_urb(urb);
+
+		kmem_cache_free(stub_priv_cache, priv);
+
+		kfree(urb->transfer_buffer);
+		kfree(urb->setup_packet);
+		usb_free_urb(urb);
+	}
+}
+
+static int __init usbip_host_init(void)
+{
+	int ret;
+
+	init_busid_table();
+
+	stub_priv_cache = KMEM_CACHE(stub_priv, SLAB_HWCACHE_ALIGN);
+	if (!stub_priv_cache) {
+		pr_err("kmem_cache_create failed\n");
+		return -ENOMEM;
+	}
+
+	ret = usb_register_device_driver(&stub_driver, THIS_MODULE);
+	if (ret) {
+		pr_err("usb_register failed %d\n", ret);
+		goto err_usb_register;
+	}
+
+	ret = driver_create_file(&stub_driver.drvwrap.driver,
+				 &driver_attr_match_busid);
+	if (ret) {
+		pr_err("driver_create_file failed\n");
+		goto err_create_file;
+	}
+
+	ret = driver_create_file(&stub_driver.drvwrap.driver,
+				 &driver_attr_rebind);
+	if (ret) {
+		pr_err("driver_create_file failed\n");
+		goto err_create_file;
+	}
+
+	pr_info(DRIVER_DESC " v" USBIP_VERSION "\n");
+	return ret;
+
+err_create_file:
+	usb_deregister_device_driver(&stub_driver);
+err_usb_register:
+	kmem_cache_destroy(stub_priv_cache);
+	return ret;
+}
+
+static void __exit usbip_host_exit(void)
+{
+	driver_remove_file(&stub_driver.drvwrap.driver,
+			   &driver_attr_match_busid);
+
+	driver_remove_file(&stub_driver.drvwrap.driver,
+			   &driver_attr_rebind);
+
+	/*
+	 * deregister() calls stub_disconnect() for all devices. Device
+	 * specific data is cleared in stub_disconnect().
+	 */
+	usb_deregister_device_driver(&stub_driver);
+
+	kmem_cache_destroy(stub_priv_cache);
+}
+
+module_init(usbip_host_init);
+module_exit(usbip_host_exit);
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
+MODULE_VERSION(USBIP_VERSION);
diff --git a/drivers/usb/usbip/stub_rx.c b/drivers/usb/usbip/stub_rx.c
new file mode 100644
index 0000000..e0b6d6b
--- /dev/null
+++ b/drivers/usb/usbip/stub_rx.c
@@ -0,0 +1,595 @@
+/*
+ * Copyright (C) 2003-2008 Takahiro Hirofuchi
+ *
+ * This is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
+ * USA.
+ */
+
+#include <asm/byteorder.h>
+#include <linux/kthread.h>
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+
+#include "usbip_common.h"
+#include "stub.h"
+
+static int is_clear_halt_cmd(struct urb *urb)
+{
+	struct usb_ctrlrequest *req;
+
+	req = (struct usb_ctrlrequest *) urb->setup_packet;
+
+	 return (req->bRequest == USB_REQ_CLEAR_FEATURE) &&
+		 (req->bRequestType == USB_RECIP_ENDPOINT) &&
+		 (req->wValue == USB_ENDPOINT_HALT);
+}
+
+static int is_set_interface_cmd(struct urb *urb)
+{
+	struct usb_ctrlrequest *req;
+
+	req = (struct usb_ctrlrequest *) urb->setup_packet;
+
+	return (req->bRequest == USB_REQ_SET_INTERFACE) &&
+		(req->bRequestType == USB_RECIP_INTERFACE);
+}
+
+static int is_set_configuration_cmd(struct urb *urb)
+{
+	struct usb_ctrlrequest *req;
+
+	req = (struct usb_ctrlrequest *) urb->setup_packet;
+
+	return (req->bRequest == USB_REQ_SET_CONFIGURATION) &&
+		(req->bRequestType == USB_RECIP_DEVICE);
+}
+
+static int is_reset_device_cmd(struct urb *urb)
+{
+	struct usb_ctrlrequest *req;
+	__u16 value;
+	__u16 index;
+
+	req = (struct usb_ctrlrequest *) urb->setup_packet;
+	value = le16_to_cpu(req->wValue);
+	index = le16_to_cpu(req->wIndex);
+
+	if ((req->bRequest == USB_REQ_SET_FEATURE) &&
+	    (req->bRequestType == USB_RT_PORT) &&
+	    (value == USB_PORT_FEAT_RESET)) {
+		usbip_dbg_stub_rx("reset_device_cmd, port %u\n", index);
+		return 1;
+	} else
+		return 0;
+}
+
+static int tweak_clear_halt_cmd(struct urb *urb)
+{
+	struct usb_ctrlrequest *req;
+	int target_endp;
+	int target_dir;
+	int target_pipe;
+	int ret;
+
+	req = (struct usb_ctrlrequest *) urb->setup_packet;
+
+	/*
+	 * The stalled endpoint is specified in the wIndex value. The endpoint
+	 * of the urb is the target of this clear_halt request (i.e., control
+	 * endpoint).
+	 */
+	target_endp = le16_to_cpu(req->wIndex) & 0x000f;
+
+	/* the stalled endpoint direction is IN or OUT?. USB_DIR_IN is 0x80.  */
+	target_dir = le16_to_cpu(req->wIndex) & 0x0080;
+
+	if (target_dir)
+		target_pipe = usb_rcvctrlpipe(urb->dev, target_endp);
+	else
+		target_pipe = usb_sndctrlpipe(urb->dev, target_endp);
+
+	ret = usb_clear_halt(urb->dev, target_pipe);
+	if (ret < 0)
+		dev_err(&urb->dev->dev,
+			"usb_clear_halt error: devnum %d endp %d ret %d\n",
+			urb->dev->devnum, target_endp, ret);
+	else
+		dev_info(&urb->dev->dev,
+			 "usb_clear_halt done: devnum %d endp %d\n",
+			 urb->dev->devnum, target_endp);
+
+	return ret;
+}
+
+static int tweak_set_interface_cmd(struct urb *urb)
+{
+	struct usb_ctrlrequest *req;
+	__u16 alternate;
+	__u16 interface;
+	int ret;
+
+	req = (struct usb_ctrlrequest *) urb->setup_packet;
+	alternate = le16_to_cpu(req->wValue);
+	interface = le16_to_cpu(req->wIndex);
+
+	usbip_dbg_stub_rx("set_interface: inf %u alt %u\n",
+			  interface, alternate);
+
+	ret = usb_set_interface(urb->dev, interface, alternate);
+	if (ret < 0)
+		dev_err(&urb->dev->dev,
+			"usb_set_interface error: inf %u alt %u ret %d\n",
+			interface, alternate, ret);
+	else
+		dev_info(&urb->dev->dev,
+			"usb_set_interface done: inf %u alt %u\n",
+			interface, alternate);
+
+	return ret;
+}
+
+static int tweak_set_configuration_cmd(struct urb *urb)
+{
+	struct stub_priv *priv = (struct stub_priv *) urb->context;
+	struct stub_device *sdev = priv->sdev;
+	struct usb_ctrlrequest *req;
+	__u16 config;
+	int err;
+
+	req = (struct usb_ctrlrequest *) urb->setup_packet;
+	config = le16_to_cpu(req->wValue);
+
+	err = usb_set_configuration(sdev->udev, config);
+	if (err && err != -ENODEV)
+		dev_err(&sdev->udev->dev, "can't set config #%d, error %d\n",
+			config, err);
+	return 0;
+}
+
+static int tweak_reset_device_cmd(struct urb *urb)
+{
+	struct stub_priv *priv = (struct stub_priv *) urb->context;
+	struct stub_device *sdev = priv->sdev;
+
+	dev_info(&urb->dev->dev, "usb_queue_reset_device\n");
+
+	/*
+	 * With the implementation of pre_reset and post_reset the driver no
+	 * longer unbinds. This allows the use of synchronous reset.
+	 */
+
+	if (usb_lock_device_for_reset(sdev->udev, sdev->interface) < 0) {
+		dev_err(&urb->dev->dev, "could not obtain lock to reset device\n");
+		return 0;
+	}
+	usb_reset_device(sdev->udev);
+	usb_unlock_device(sdev->udev);
+
+	return 0;
+}
+
+/*
+ * clear_halt, set_interface, and set_configuration require special tricks.
+ */
+static void tweak_special_requests(struct urb *urb)
+{
+	if (!urb || !urb->setup_packet)
+		return;
+
+	if (usb_pipetype(urb->pipe) != PIPE_CONTROL)
+		return;
+
+	if (is_clear_halt_cmd(urb))
+		/* tweak clear_halt */
+		 tweak_clear_halt_cmd(urb);
+
+	else if (is_set_interface_cmd(urb))
+		/* tweak set_interface */
+		tweak_set_interface_cmd(urb);
+
+	else if (is_set_configuration_cmd(urb))
+		/* tweak set_configuration */
+		tweak_set_configuration_cmd(urb);
+
+	else if (is_reset_device_cmd(urb))
+		tweak_reset_device_cmd(urb);
+	else
+		usbip_dbg_stub_rx("no need to tweak\n");
+}
+
+/*
+ * stub_recv_unlink() unlinks the URB by a call to usb_unlink_urb().
+ * By unlinking the urb asynchronously, stub_rx can continuously
+ * process coming urbs.  Even if the urb is unlinked, its completion
+ * handler will be called and stub_tx will send a return pdu.
+ *
+ * See also comments about unlinking strategy in vhci_hcd.c.
+ */
+static int stub_recv_cmd_unlink(struct stub_device *sdev,
+				struct usbip_header *pdu)
+{
+	int ret;
+	unsigned long flags;
+	struct stub_priv *priv;
+
+	spin_lock_irqsave(&sdev->priv_lock, flags);
+
+	list_for_each_entry(priv, &sdev->priv_init, list) {
+		if (priv->seqnum != pdu->u.cmd_unlink.seqnum)
+			continue;
+
+		dev_info(&priv->urb->dev->dev, "unlink urb %p\n",
+			 priv->urb);
+
+		/*
+		 * This matched urb is not completed yet (i.e., be in
+		 * flight in usb hcd hardware/driver). Now we are
+		 * cancelling it. The unlinking flag means that we are
+		 * now not going to return the normal result pdu of a
+		 * submission request, but going to return a result pdu
+		 * of the unlink request.
+		 */
+		priv->unlinking = 1;
+
+		/*
+		 * In the case that unlinking flag is on, prev->seqnum
+		 * is changed from the seqnum of the cancelling urb to
+		 * the seqnum of the unlink request. This will be used
+		 * to make the result pdu of the unlink request.
+		 */
+		priv->seqnum = pdu->base.seqnum;
+
+		spin_unlock_irqrestore(&sdev->priv_lock, flags);
+
+		/*
+		 * usb_unlink_urb() is now out of spinlocking to avoid
+		 * spinlock recursion since stub_complete() is
+		 * sometimes called in this context but not in the
+		 * interrupt context.  If stub_complete() is executed
+		 * before we call usb_unlink_urb(), usb_unlink_urb()
+		 * will return an error value. In this case, stub_tx
+		 * will return the result pdu of this unlink request
+		 * though submission is completed and actual unlinking
+		 * is not executed. OK?
+		 */
+		/* In the above case, urb->status is not -ECONNRESET,
+		 * so a driver in a client host will know the failure
+		 * of the unlink request ?
+		 */
+		ret = usb_unlink_urb(priv->urb);
+		if (ret != -EINPROGRESS)
+			dev_err(&priv->urb->dev->dev,
+				"failed to unlink a urb %p, ret %d\n",
+				priv->urb, ret);
+
+		return 0;
+	}
+
+	usbip_dbg_stub_rx("seqnum %d is not pending\n",
+			  pdu->u.cmd_unlink.seqnum);
+
+	/*
+	 * The urb of the unlink target is not found in priv_init queue. It was
+	 * already completed and its results is/was going to be sent by a
+	 * CMD_RET pdu. In this case, usb_unlink_urb() is not needed. We only
+	 * return the completeness of this unlink request to vhci_hcd.
+	 */
+	stub_enqueue_ret_unlink(sdev, pdu->base.seqnum, 0);
+
+	spin_unlock_irqrestore(&sdev->priv_lock, flags);
+
+	return 0;
+}
+
+static int valid_request(struct stub_device *sdev, struct usbip_header *pdu)
+{
+	struct usbip_device *ud = &sdev->ud;
+	int valid = 0;
+
+	if (pdu->base.devid == sdev->devid) {
+		spin_lock_irq(&ud->lock);
+		if (ud->status == SDEV_ST_USED) {
+			/* A request is valid. */
+			valid = 1;
+		}
+		spin_unlock_irq(&ud->lock);
+	}
+
+	return valid;
+}
+
+static struct stub_priv *stub_priv_alloc(struct stub_device *sdev,
+					 struct usbip_header *pdu)
+{
+	struct stub_priv *priv;
+	struct usbip_device *ud = &sdev->ud;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sdev->priv_lock, flags);
+
+	priv = kmem_cache_zalloc(stub_priv_cache, GFP_ATOMIC);
+	if (!priv) {
+		dev_err(&sdev->interface->dev, "alloc stub_priv\n");
+		spin_unlock_irqrestore(&sdev->priv_lock, flags);
+		usbip_event_add(ud, SDEV_EVENT_ERROR_MALLOC);
+		return NULL;
+	}
+
+	priv->seqnum = pdu->base.seqnum;
+	priv->sdev = sdev;
+
+	/*
+	 * After a stub_priv is linked to a list_head,
+	 * our error handler can free allocated data.
+	 */
+	list_add_tail(&priv->list, &sdev->priv_init);
+
+	spin_unlock_irqrestore(&sdev->priv_lock, flags);
+
+	return priv;
+}
+
+static int get_pipe(struct stub_device *sdev, int epnum, int dir)
+{
+	struct usb_device *udev = sdev->udev;
+	struct usb_host_endpoint *ep;
+	struct usb_endpoint_descriptor *epd = NULL;
+
+	if (dir == USBIP_DIR_IN)
+		ep = udev->ep_in[epnum & 0x7f];
+	else
+		ep = udev->ep_out[epnum & 0x7f];
+	if (!ep) {
+		dev_err(&sdev->interface->dev, "no such endpoint?, %d\n",
+			epnum);
+		BUG();
+	}
+
+	epd = &ep->desc;
+	if (usb_endpoint_xfer_control(epd)) {
+		if (dir == USBIP_DIR_OUT)
+			return usb_sndctrlpipe(udev, epnum);
+		else
+			return usb_rcvctrlpipe(udev, epnum);
+	}
+
+	if (usb_endpoint_xfer_bulk(epd)) {
+		if (dir == USBIP_DIR_OUT)
+			return usb_sndbulkpipe(udev, epnum);
+		else
+			return usb_rcvbulkpipe(udev, epnum);
+	}
+
+	if (usb_endpoint_xfer_int(epd)) {
+		if (dir == USBIP_DIR_OUT)
+			return usb_sndintpipe(udev, epnum);
+		else
+			return usb_rcvintpipe(udev, epnum);
+	}
+
+	if (usb_endpoint_xfer_isoc(epd)) {
+		if (dir == USBIP_DIR_OUT)
+			return usb_sndisocpipe(udev, epnum);
+		else
+			return usb_rcvisocpipe(udev, epnum);
+	}
+
+	/* NOT REACHED */
+	dev_err(&sdev->interface->dev, "get pipe, epnum %d\n", epnum);
+	return 0;
+}
+
+static void masking_bogus_flags(struct urb *urb)
+{
+	int				xfertype;
+	struct usb_device		*dev;
+	struct usb_host_endpoint	*ep;
+	int				is_out;
+	unsigned int	allowed;
+
+	if (!urb || urb->hcpriv || !urb->complete)
+		return;
+	dev = urb->dev;
+	if ((!dev) || (dev->state < USB_STATE_UNAUTHENTICATED))
+		return;
+
+	ep = (usb_pipein(urb->pipe) ? dev->ep_in : dev->ep_out)
+		[usb_pipeendpoint(urb->pipe)];
+	if (!ep)
+		return;
+
+	xfertype = usb_endpoint_type(&ep->desc);
+	if (xfertype == USB_ENDPOINT_XFER_CONTROL) {
+		struct usb_ctrlrequest *setup =
+			(struct usb_ctrlrequest *) urb->setup_packet;
+
+		if (!setup)
+			return;
+		is_out = !(setup->bRequestType & USB_DIR_IN) ||
+			!setup->wLength;
+	} else {
+		is_out = usb_endpoint_dir_out(&ep->desc);
+	}
+
+	/* enforce simple/standard policy */
+	allowed = (URB_NO_TRANSFER_DMA_MAP | URB_NO_INTERRUPT |
+		   URB_DIR_MASK | URB_FREE_BUFFER);
+	switch (xfertype) {
+	case USB_ENDPOINT_XFER_BULK:
+		if (is_out)
+			allowed |= URB_ZERO_PACKET;
+		/* FALLTHROUGH */
+	case USB_ENDPOINT_XFER_CONTROL:
+		allowed |= URB_NO_FSBR;	/* only affects UHCI */
+		/* FALLTHROUGH */
+	default:			/* all non-iso endpoints */
+		if (!is_out)
+			allowed |= URB_SHORT_NOT_OK;
+		break;
+	case USB_ENDPOINT_XFER_ISOC:
+		allowed |= URB_ISO_ASAP;
+		break;
+	}
+	urb->transfer_flags &= allowed;
+}
+
+static void stub_recv_cmd_submit(struct stub_device *sdev,
+				 struct usbip_header *pdu)
+{
+	int ret;
+	struct stub_priv *priv;
+	struct usbip_device *ud = &sdev->ud;
+	struct usb_device *udev = sdev->udev;
+	int pipe = get_pipe(sdev, pdu->base.ep, pdu->base.direction);
+
+	priv = stub_priv_alloc(sdev, pdu);
+	if (!priv)
+		return;
+
+	/* setup a urb */
+	if (usb_pipeisoc(pipe))
+		priv->urb = usb_alloc_urb(pdu->u.cmd_submit.number_of_packets,
+					  GFP_KERNEL);
+	else
+		priv->urb = usb_alloc_urb(0, GFP_KERNEL);
+
+	if (!priv->urb) {
+		dev_err(&sdev->interface->dev, "malloc urb\n");
+		usbip_event_add(ud, SDEV_EVENT_ERROR_MALLOC);
+		return;
+	}
+
+	/* allocate urb transfer buffer, if needed */
+	if (pdu->u.cmd_submit.transfer_buffer_length > 0) {
+		priv->urb->transfer_buffer =
+			kzalloc(pdu->u.cmd_submit.transfer_buffer_length,
+				GFP_KERNEL);
+		if (!priv->urb->transfer_buffer) {
+			usbip_event_add(ud, SDEV_EVENT_ERROR_MALLOC);
+			return;
+		}
+	}
+
+	/* copy urb setup packet */
+	priv->urb->setup_packet = kmemdup(&pdu->u.cmd_submit.setup, 8,
+					  GFP_KERNEL);
+	if (!priv->urb->setup_packet) {
+		dev_err(&sdev->interface->dev, "allocate setup_packet\n");
+		usbip_event_add(ud, SDEV_EVENT_ERROR_MALLOC);
+		return;
+	}
+
+	/* set other members from the base header of pdu */
+	priv->urb->context                = (void *) priv;
+	priv->urb->dev                    = udev;
+	priv->urb->pipe                   = pipe;
+	priv->urb->complete               = stub_complete;
+
+	usbip_pack_pdu(pdu, priv->urb, USBIP_CMD_SUBMIT, 0);
+
+
+	if (usbip_recv_xbuff(ud, priv->urb) < 0)
+		return;
+
+	if (usbip_recv_iso(ud, priv->urb) < 0)
+		return;
+
+	/* no need to submit an intercepted request, but harmless? */
+	tweak_special_requests(priv->urb);
+
+	masking_bogus_flags(priv->urb);
+	/* urb is now ready to submit */
+	ret = usb_submit_urb(priv->urb, GFP_KERNEL);
+
+	if (ret == 0)
+		usbip_dbg_stub_rx("submit urb ok, seqnum %u\n",
+				  pdu->base.seqnum);
+	else {
+		dev_err(&sdev->interface->dev, "submit_urb error, %d\n", ret);
+		usbip_dump_header(pdu);
+		usbip_dump_urb(priv->urb);
+
+		/*
+		 * Pessimistic.
+		 * This connection will be discarded.
+		 */
+		usbip_event_add(ud, SDEV_EVENT_ERROR_SUBMIT);
+	}
+
+	usbip_dbg_stub_rx("Leave\n");
+	return;
+}
+
+/* recv a pdu */
+static void stub_rx_pdu(struct usbip_device *ud)
+{
+	int ret;
+	struct usbip_header pdu;
+	struct stub_device *sdev = container_of(ud, struct stub_device, ud);
+	struct device *dev = &sdev->udev->dev;
+
+	usbip_dbg_stub_rx("Enter\n");
+
+	memset(&pdu, 0, sizeof(pdu));
+
+	/* receive a pdu header */
+	ret = usbip_recv(ud->tcp_socket, &pdu, sizeof(pdu));
+	if (ret != sizeof(pdu)) {
+		dev_err(dev, "recv a header, %d\n", ret);
+		usbip_event_add(ud, SDEV_EVENT_ERROR_TCP);
+		return;
+	}
+
+	usbip_header_correct_endian(&pdu, 0);
+
+	if (usbip_dbg_flag_stub_rx)
+		usbip_dump_header(&pdu);
+
+	if (!valid_request(sdev, &pdu)) {
+		dev_err(dev, "recv invalid request\n");
+		usbip_event_add(ud, SDEV_EVENT_ERROR_TCP);
+		return;
+	}
+
+	switch (pdu.base.command) {
+	case USBIP_CMD_UNLINK:
+		stub_recv_cmd_unlink(sdev, &pdu);
+		break;
+
+	case USBIP_CMD_SUBMIT:
+		stub_recv_cmd_submit(sdev, &pdu);
+		break;
+
+	default:
+		/* NOTREACHED */
+		dev_err(dev, "unknown pdu\n");
+		usbip_event_add(ud, SDEV_EVENT_ERROR_TCP);
+		break;
+	}
+}
+
+int stub_rx_loop(void *data)
+{
+	struct usbip_device *ud = data;
+
+	while (!kthread_should_stop()) {
+		if (usbip_event_happened(ud))
+			break;
+
+		stub_rx_pdu(ud);
+	}
+
+	return 0;
+}
diff --git a/drivers/usb/usbip/stub_tx.c b/drivers/usb/usbip/stub_tx.c
new file mode 100644
index 0000000..cd5326a
--- /dev/null
+++ b/drivers/usb/usbip/stub_tx.c
@@ -0,0 +1,397 @@
+/*
+ * Copyright (C) 2003-2008 Takahiro Hirofuchi
+ *
+ * This is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
+ * USA.
+ */
+
+#include <linux/kthread.h>
+#include <linux/socket.h>
+
+#include "usbip_common.h"
+#include "stub.h"
+
+static void stub_free_priv_and_urb(struct stub_priv *priv)
+{
+	struct urb *urb = priv->urb;
+
+	kfree(urb->setup_packet);
+	kfree(urb->transfer_buffer);
+	list_del(&priv->list);
+	kmem_cache_free(stub_priv_cache, priv);
+	usb_free_urb(urb);
+}
+
+/* be in spin_lock_irqsave(&sdev->priv_lock, flags) */
+void stub_enqueue_ret_unlink(struct stub_device *sdev, __u32 seqnum,
+			     __u32 status)
+{
+	struct stub_unlink *unlink;
+
+	unlink = kzalloc(sizeof(struct stub_unlink), GFP_ATOMIC);
+	if (!unlink) {
+		usbip_event_add(&sdev->ud, VDEV_EVENT_ERROR_MALLOC);
+		return;
+	}
+
+	unlink->seqnum = seqnum;
+	unlink->status = status;
+
+	list_add_tail(&unlink->list, &sdev->unlink_tx);
+}
+
+/**
+ * stub_complete - completion handler of a usbip urb
+ * @urb: pointer to the urb completed
+ *
+ * When a urb has completed, the USB core driver calls this function mostly in
+ * the interrupt context. To return the result of a urb, the completed urb is
+ * linked to the pending list of returning.
+ *
+ */
+void stub_complete(struct urb *urb)
+{
+	struct stub_priv *priv = (struct stub_priv *) urb->context;
+	struct stub_device *sdev = priv->sdev;
+	unsigned long flags;
+
+	usbip_dbg_stub_tx("complete! status %d\n", urb->status);
+
+	switch (urb->status) {
+	case 0:
+		/* OK */
+		break;
+	case -ENOENT:
+		dev_info(&urb->dev->dev, "stopped by a call to usb_kill_urb() "
+			 "because of cleaning up a virtual connection\n");
+		return;
+	case -ECONNRESET:
+		dev_info(&urb->dev->dev, "unlinked by a call to "
+			 "usb_unlink_urb()\n");
+		break;
+	case -EPIPE:
+		dev_info(&urb->dev->dev, "endpoint %d is stalled\n",
+			 usb_pipeendpoint(urb->pipe));
+		break;
+	case -ESHUTDOWN:
+		dev_info(&urb->dev->dev, "device removed?\n");
+		break;
+	default:
+		dev_info(&urb->dev->dev, "urb completion with non-zero status "
+			 "%d\n", urb->status);
+		break;
+	}
+
+	/* link a urb to the queue of tx. */
+	spin_lock_irqsave(&sdev->priv_lock, flags);
+	if (priv->unlinking) {
+		stub_enqueue_ret_unlink(sdev, priv->seqnum, urb->status);
+		stub_free_priv_and_urb(priv);
+	} else {
+		list_move_tail(&priv->list, &sdev->priv_tx);
+	}
+	spin_unlock_irqrestore(&sdev->priv_lock, flags);
+
+	/* wake up tx_thread */
+	wake_up(&sdev->tx_waitq);
+}
+
+static inline void setup_base_pdu(struct usbip_header_basic *base,
+				  __u32 command, __u32 seqnum)
+{
+	base->command	= command;
+	base->seqnum	= seqnum;
+	base->devid	= 0;
+	base->ep	= 0;
+	base->direction = 0;
+}
+
+static void setup_ret_submit_pdu(struct usbip_header *rpdu, struct urb *urb)
+{
+	struct stub_priv *priv = (struct stub_priv *) urb->context;
+
+	setup_base_pdu(&rpdu->base, USBIP_RET_SUBMIT, priv->seqnum);
+	usbip_pack_pdu(rpdu, urb, USBIP_RET_SUBMIT, 1);
+}
+
+static void setup_ret_unlink_pdu(struct usbip_header *rpdu,
+				 struct stub_unlink *unlink)
+{
+	setup_base_pdu(&rpdu->base, USBIP_RET_UNLINK, unlink->seqnum);
+	rpdu->u.ret_unlink.status = unlink->status;
+}
+
+static struct stub_priv *dequeue_from_priv_tx(struct stub_device *sdev)
+{
+	unsigned long flags;
+	struct stub_priv *priv, *tmp;
+
+	spin_lock_irqsave(&sdev->priv_lock, flags);
+
+	list_for_each_entry_safe(priv, tmp, &sdev->priv_tx, list) {
+		list_move_tail(&priv->list, &sdev->priv_free);
+		spin_unlock_irqrestore(&sdev->priv_lock, flags);
+		return priv;
+	}
+
+	spin_unlock_irqrestore(&sdev->priv_lock, flags);
+
+	return NULL;
+}
+
+static int stub_send_ret_submit(struct stub_device *sdev)
+{
+	unsigned long flags;
+	struct stub_priv *priv, *tmp;
+
+	struct msghdr msg;
+	size_t txsize;
+
+	size_t total_size = 0;
+
+	while ((priv = dequeue_from_priv_tx(sdev)) != NULL) {
+		int ret;
+		struct urb *urb = priv->urb;
+		struct usbip_header pdu_header;
+		struct usbip_iso_packet_descriptor *iso_buffer = NULL;
+		struct kvec *iov = NULL;
+		int iovnum = 0;
+
+		txsize = 0;
+		memset(&pdu_header, 0, sizeof(pdu_header));
+		memset(&msg, 0, sizeof(msg));
+
+		if (usb_pipetype(urb->pipe) == PIPE_ISOCHRONOUS)
+			iovnum = 2 + urb->number_of_packets;
+		else
+			iovnum = 2;
+
+		iov = kzalloc(iovnum * sizeof(struct kvec), GFP_KERNEL);
+
+		if (!iov) {
+			usbip_event_add(&sdev->ud, SDEV_EVENT_ERROR_MALLOC);
+			return -1;
+		}
+
+		iovnum = 0;
+
+		/* 1. setup usbip_header */
+		setup_ret_submit_pdu(&pdu_header, urb);
+		usbip_dbg_stub_tx("setup txdata seqnum: %d urb: %p\n",
+				  pdu_header.base.seqnum, urb);
+		usbip_header_correct_endian(&pdu_header, 1);
+
+		iov[iovnum].iov_base = &pdu_header;
+		iov[iovnum].iov_len  = sizeof(pdu_header);
+		iovnum++;
+		txsize += sizeof(pdu_header);
+
+		/* 2. setup transfer buffer */
+		if (usb_pipein(urb->pipe) &&
+		    usb_pipetype(urb->pipe) != PIPE_ISOCHRONOUS &&
+		    urb->actual_length > 0) {
+			iov[iovnum].iov_base = urb->transfer_buffer;
+			iov[iovnum].iov_len  = urb->actual_length;
+			iovnum++;
+			txsize += urb->actual_length;
+		} else if (usb_pipein(urb->pipe) &&
+			   usb_pipetype(urb->pipe) == PIPE_ISOCHRONOUS) {
+			/*
+			 * For isochronous packets: actual length is the sum of
+			 * the actual length of the individual, packets, but as
+			 * the packet offsets are not changed there will be
+			 * padding between the packets. To optimally use the
+			 * bandwidth the padding is not transmitted.
+			 */
+
+			int i;
+			for (i = 0; i < urb->number_of_packets; i++) {
+				iov[iovnum].iov_base = urb->transfer_buffer +
+					urb->iso_frame_desc[i].offset;
+				iov[iovnum].iov_len =
+					urb->iso_frame_desc[i].actual_length;
+				iovnum++;
+				txsize += urb->iso_frame_desc[i].actual_length;
+			}
+
+			if (txsize != sizeof(pdu_header) + urb->actual_length) {
+				dev_err(&sdev->interface->dev,
+					"actual length of urb %d does not "
+					"match iso packet sizes %zu\n",
+					urb->actual_length,
+					txsize-sizeof(pdu_header));
+				kfree(iov);
+				usbip_event_add(&sdev->ud,
+						SDEV_EVENT_ERROR_TCP);
+			   return -1;
+			}
+		}
+
+		/* 3. setup iso_packet_descriptor */
+		if (usb_pipetype(urb->pipe) == PIPE_ISOCHRONOUS) {
+			ssize_t len = 0;
+
+			iso_buffer = usbip_alloc_iso_desc_pdu(urb, &len);
+			if (!iso_buffer) {
+				usbip_event_add(&sdev->ud,
+						SDEV_EVENT_ERROR_MALLOC);
+				kfree(iov);
+				return -1;
+			}
+
+			iov[iovnum].iov_base = iso_buffer;
+			iov[iovnum].iov_len  = len;
+			txsize += len;
+			iovnum++;
+		}
+
+		ret = kernel_sendmsg(sdev->ud.tcp_socket, &msg,
+						iov,  iovnum, txsize);
+		if (ret != txsize) {
+			dev_err(&sdev->interface->dev,
+				"sendmsg failed!, retval %d for %zd\n",
+				ret, txsize);
+			kfree(iov);
+			kfree(iso_buffer);
+			usbip_event_add(&sdev->ud, SDEV_EVENT_ERROR_TCP);
+			return -1;
+		}
+
+		kfree(iov);
+		kfree(iso_buffer);
+
+		total_size += txsize;
+	}
+
+	spin_lock_irqsave(&sdev->priv_lock, flags);
+	list_for_each_entry_safe(priv, tmp, &sdev->priv_free, list) {
+		stub_free_priv_and_urb(priv);
+	}
+	spin_unlock_irqrestore(&sdev->priv_lock, flags);
+
+	return total_size;
+}
+
+static struct stub_unlink *dequeue_from_unlink_tx(struct stub_device *sdev)
+{
+	unsigned long flags;
+	struct stub_unlink *unlink, *tmp;
+
+	spin_lock_irqsave(&sdev->priv_lock, flags);
+
+	list_for_each_entry_safe(unlink, tmp, &sdev->unlink_tx, list) {
+		list_move_tail(&unlink->list, &sdev->unlink_free);
+		spin_unlock_irqrestore(&sdev->priv_lock, flags);
+		return unlink;
+	}
+
+	spin_unlock_irqrestore(&sdev->priv_lock, flags);
+
+	return NULL;
+}
+
+static int stub_send_ret_unlink(struct stub_device *sdev)
+{
+	unsigned long flags;
+	struct stub_unlink *unlink, *tmp;
+
+	struct msghdr msg;
+	struct kvec iov[1];
+	size_t txsize;
+
+	size_t total_size = 0;
+
+	while ((unlink = dequeue_from_unlink_tx(sdev)) != NULL) {
+		int ret;
+		struct usbip_header pdu_header;
+
+		txsize = 0;
+		memset(&pdu_header, 0, sizeof(pdu_header));
+		memset(&msg, 0, sizeof(msg));
+		memset(&iov, 0, sizeof(iov));
+
+		usbip_dbg_stub_tx("setup ret unlink %lu\n", unlink->seqnum);
+
+		/* 1. setup usbip_header */
+		setup_ret_unlink_pdu(&pdu_header, unlink);
+		usbip_header_correct_endian(&pdu_header, 1);
+
+		iov[0].iov_base = &pdu_header;
+		iov[0].iov_len  = sizeof(pdu_header);
+		txsize += sizeof(pdu_header);
+
+		ret = kernel_sendmsg(sdev->ud.tcp_socket, &msg, iov,
+				     1, txsize);
+		if (ret != txsize) {
+			dev_err(&sdev->interface->dev,
+				"sendmsg failed!, retval %d for %zd\n",
+				ret, txsize);
+			usbip_event_add(&sdev->ud, SDEV_EVENT_ERROR_TCP);
+			return -1;
+		}
+
+		usbip_dbg_stub_tx("send txdata\n");
+		total_size += txsize;
+	}
+
+	spin_lock_irqsave(&sdev->priv_lock, flags);
+
+	list_for_each_entry_safe(unlink, tmp, &sdev->unlink_free, list) {
+		list_del(&unlink->list);
+		kfree(unlink);
+	}
+
+	spin_unlock_irqrestore(&sdev->priv_lock, flags);
+
+	return total_size;
+}
+
+int stub_tx_loop(void *data)
+{
+	struct usbip_device *ud = data;
+	struct stub_device *sdev = container_of(ud, struct stub_device, ud);
+
+	while (!kthread_should_stop()) {
+		if (usbip_event_happened(ud))
+			break;
+
+		/*
+		 * send_ret_submit comes earlier than send_ret_unlink.  stub_rx
+		 * looks at only priv_init queue. If the completion of a URB is
+		 * earlier than the receive of CMD_UNLINK, priv is moved to
+		 * priv_tx queue and stub_rx does not find the target priv. In
+		 * this case, vhci_rx receives the result of the submit request
+		 * and then receives the result of the unlink request. The
+		 * result of the submit is given back to the usbcore as the
+		 * completion of the unlink request. The request of the
+		 * unlink is ignored. This is ok because a driver who calls
+		 * usb_unlink_urb() understands the unlink was too late by
+		 * getting the status of the given-backed URB which has the
+		 * status of usb_submit_urb().
+		 */
+		if (stub_send_ret_submit(sdev) < 0)
+			break;
+
+		if (stub_send_ret_unlink(sdev) < 0)
+			break;
+
+		wait_event_interruptible(sdev->tx_waitq,
+					 (!list_empty(&sdev->priv_tx) ||
+					  !list_empty(&sdev->unlink_tx) ||
+					  kthread_should_stop()));
+	}
+
+	return 0;
+}
diff --git a/drivers/usb/usbip/usbip_common.c b/drivers/usb/usbip/usbip_common.c
new file mode 100644
index 0000000..2a11233
--- /dev/null
+++ b/drivers/usb/usbip/usbip_common.c
@@ -0,0 +1,803 @@
+/*
+ * Copyright (C) 2003-2008 Takahiro Hirofuchi
+ *
+ * This is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
+ * USA.
+ */
+
+#include <asm/byteorder.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/stat.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <net/sock.h>
+
+#include "usbip_common.h"
+
+#define DRIVER_AUTHOR "Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>"
+#define DRIVER_DESC "USB/IP Core"
+
+#ifdef CONFIG_USBIP_DEBUG
+unsigned long usbip_debug_flag = 0xffffffff;
+#else
+unsigned long usbip_debug_flag;
+#endif
+EXPORT_SYMBOL_GPL(usbip_debug_flag);
+module_param(usbip_debug_flag, ulong, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(usbip_debug_flag, "debug flags (defined in usbip_common.h)");
+
+/* FIXME */
+struct device_attribute dev_attr_usbip_debug;
+EXPORT_SYMBOL_GPL(dev_attr_usbip_debug);
+
+static ssize_t usbip_debug_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%lx\n", usbip_debug_flag);
+}
+
+static ssize_t usbip_debug_store(struct device *dev,
+				 struct device_attribute *attr, const char *buf,
+				 size_t count)
+{
+	if (sscanf(buf, "%lx", &usbip_debug_flag) != 1)
+		return -EINVAL;
+	return count;
+}
+DEVICE_ATTR_RW(usbip_debug);
+
+static void usbip_dump_buffer(char *buff, int bufflen)
+{
+	print_hex_dump(KERN_DEBUG, "usbip-core", DUMP_PREFIX_OFFSET, 16, 4,
+		       buff, bufflen, false);
+}
+
+static void usbip_dump_pipe(unsigned int p)
+{
+	unsigned char type = usb_pipetype(p);
+	unsigned char ep   = usb_pipeendpoint(p);
+	unsigned char dev  = usb_pipedevice(p);
+	unsigned char dir  = usb_pipein(p);
+
+	pr_debug("dev(%d) ep(%d) [%s] ", dev, ep, dir ? "IN" : "OUT");
+
+	switch (type) {
+	case PIPE_ISOCHRONOUS:
+		pr_debug("ISO\n");
+		break;
+	case PIPE_INTERRUPT:
+		pr_debug("INT\n");
+		break;
+	case PIPE_CONTROL:
+		pr_debug("CTRL\n");
+		break;
+	case PIPE_BULK:
+		pr_debug("BULK\n");
+		break;
+	default:
+		pr_debug("ERR\n");
+		break;
+	}
+}
+
+static void usbip_dump_usb_device(struct usb_device *udev)
+{
+	struct device *dev = &udev->dev;
+	int i;
+
+	dev_dbg(dev, "       devnum(%d) devpath(%s) usb speed(%s)",
+		udev->devnum, udev->devpath, usb_speed_string(udev->speed));
+
+	pr_debug("tt %p, ttport %d\n", udev->tt, udev->ttport);
+
+	dev_dbg(dev, "                    ");
+	for (i = 0; i < 16; i++)
+		pr_debug(" %2u", i);
+	pr_debug("\n");
+
+	dev_dbg(dev, "       toggle0(IN) :");
+	for (i = 0; i < 16; i++)
+		pr_debug(" %2u", (udev->toggle[0] & (1 << i)) ? 1 : 0);
+	pr_debug("\n");
+
+	dev_dbg(dev, "       toggle1(OUT):");
+	for (i = 0; i < 16; i++)
+		pr_debug(" %2u", (udev->toggle[1] & (1 << i)) ? 1 : 0);
+	pr_debug("\n");
+
+	dev_dbg(dev, "       epmaxp_in   :");
+	for (i = 0; i < 16; i++) {
+		if (udev->ep_in[i])
+			pr_debug(" %2u",
+			    le16_to_cpu(udev->ep_in[i]->desc.wMaxPacketSize));
+	}
+	pr_debug("\n");
+
+	dev_dbg(dev, "       epmaxp_out  :");
+	for (i = 0; i < 16; i++) {
+		if (udev->ep_out[i])
+			pr_debug(" %2u",
+			    le16_to_cpu(udev->ep_out[i]->desc.wMaxPacketSize));
+	}
+	pr_debug("\n");
+
+	dev_dbg(dev, "parent %p, bus %p\n", udev->parent, udev->bus);
+
+	dev_dbg(dev,
+		"descriptor %p, config %p, actconfig %p, rawdescriptors %p\n",
+		&udev->descriptor, udev->config,
+		udev->actconfig, udev->rawdescriptors);
+
+	dev_dbg(dev, "have_langid %d, string_langid %d\n",
+		udev->have_langid, udev->string_langid);
+
+	dev_dbg(dev, "maxchild %d\n", udev->maxchild);
+}
+
+static void usbip_dump_request_type(__u8 rt)
+{
+	switch (rt & USB_RECIP_MASK) {
+	case USB_RECIP_DEVICE:
+		pr_debug("DEVICE");
+		break;
+	case USB_RECIP_INTERFACE:
+		pr_debug("INTERF");
+		break;
+	case USB_RECIP_ENDPOINT:
+		pr_debug("ENDPOI");
+		break;
+	case USB_RECIP_OTHER:
+		pr_debug("OTHER ");
+		break;
+	default:
+		pr_debug("------");
+		break;
+	}
+}
+
+static void usbip_dump_usb_ctrlrequest(struct usb_ctrlrequest *cmd)
+{
+	if (!cmd) {
+		pr_debug("       : null pointer\n");
+		return;
+	}
+
+	pr_debug("       ");
+	pr_debug("bRequestType(%02X) bRequest(%02X) wValue(%04X) wIndex(%04X) "
+		 "wLength(%04X) ", cmd->bRequestType, cmd->bRequest,
+		 cmd->wValue, cmd->wIndex, cmd->wLength);
+	pr_debug("\n       ");
+
+	if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_STANDARD) {
+		pr_debug("STANDARD ");
+		switch (cmd->bRequest) {
+		case USB_REQ_GET_STATUS:
+			pr_debug("GET_STATUS\n");
+			break;
+		case USB_REQ_CLEAR_FEATURE:
+			pr_debug("CLEAR_FEAT\n");
+			break;
+		case USB_REQ_SET_FEATURE:
+			pr_debug("SET_FEAT\n");
+			break;
+		case USB_REQ_SET_ADDRESS:
+			pr_debug("SET_ADDRRS\n");
+			break;
+		case USB_REQ_GET_DESCRIPTOR:
+			pr_debug("GET_DESCRI\n");
+			break;
+		case USB_REQ_SET_DESCRIPTOR:
+			pr_debug("SET_DESCRI\n");
+			break;
+		case USB_REQ_GET_CONFIGURATION:
+			pr_debug("GET_CONFIG\n");
+			break;
+		case USB_REQ_SET_CONFIGURATION:
+			pr_debug("SET_CONFIG\n");
+			break;
+		case USB_REQ_GET_INTERFACE:
+			pr_debug("GET_INTERF\n");
+			break;
+		case USB_REQ_SET_INTERFACE:
+			pr_debug("SET_INTERF\n");
+			break;
+		case USB_REQ_SYNCH_FRAME:
+			pr_debug("SYNC_FRAME\n");
+			break;
+		default:
+			pr_debug("REQ(%02X)\n", cmd->bRequest);
+			break;
+		}
+		usbip_dump_request_type(cmd->bRequestType);
+	} else if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_CLASS) {
+		pr_debug("CLASS\n");
+	} else if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_VENDOR) {
+		pr_debug("VENDOR\n");
+	} else if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_RESERVED) {
+		pr_debug("RESERVED\n");
+	}
+}
+
+void usbip_dump_urb(struct urb *urb)
+{
+	struct device *dev;
+
+	if (!urb) {
+		pr_debug("urb: null pointer!!\n");
+		return;
+	}
+
+	if (!urb->dev) {
+		pr_debug("urb->dev: null pointer!!\n");
+		return;
+	}
+
+	dev = &urb->dev->dev;
+
+	dev_dbg(dev, "   urb                   :%p\n", urb);
+	dev_dbg(dev, "   dev                   :%p\n", urb->dev);
+
+	usbip_dump_usb_device(urb->dev);
+
+	dev_dbg(dev, "   pipe                  :%08x ", urb->pipe);
+
+	usbip_dump_pipe(urb->pipe);
+
+	dev_dbg(dev, "   status                :%d\n", urb->status);
+	dev_dbg(dev, "   transfer_flags        :%08X\n", urb->transfer_flags);
+	dev_dbg(dev, "   transfer_buffer       :%p\n", urb->transfer_buffer);
+	dev_dbg(dev, "   transfer_buffer_length:%d\n",
+						urb->transfer_buffer_length);
+	dev_dbg(dev, "   actual_length         :%d\n", urb->actual_length);
+	dev_dbg(dev, "   setup_packet          :%p\n", urb->setup_packet);
+
+	if (urb->setup_packet && usb_pipetype(urb->pipe) == PIPE_CONTROL)
+		usbip_dump_usb_ctrlrequest(
+			(struct usb_ctrlrequest *)urb->setup_packet);
+
+	dev_dbg(dev, "   start_frame           :%d\n", urb->start_frame);
+	dev_dbg(dev, "   number_of_packets     :%d\n", urb->number_of_packets);
+	dev_dbg(dev, "   interval              :%d\n", urb->interval);
+	dev_dbg(dev, "   error_count           :%d\n", urb->error_count);
+	dev_dbg(dev, "   context               :%p\n", urb->context);
+	dev_dbg(dev, "   complete              :%p\n", urb->complete);
+}
+EXPORT_SYMBOL_GPL(usbip_dump_urb);
+
+void usbip_dump_header(struct usbip_header *pdu)
+{
+	pr_debug("BASE: cmd %u seq %u devid %u dir %u ep %u\n",
+		 pdu->base.command,
+		 pdu->base.seqnum,
+		 pdu->base.devid,
+		 pdu->base.direction,
+		 pdu->base.ep);
+
+	switch (pdu->base.command) {
+	case USBIP_CMD_SUBMIT:
+		pr_debug("USBIP_CMD_SUBMIT: "
+			 "x_flags %u x_len %u sf %u #p %d iv %d\n",
+			 pdu->u.cmd_submit.transfer_flags,
+			 pdu->u.cmd_submit.transfer_buffer_length,
+			 pdu->u.cmd_submit.start_frame,
+			 pdu->u.cmd_submit.number_of_packets,
+			 pdu->u.cmd_submit.interval);
+		break;
+	case USBIP_CMD_UNLINK:
+		pr_debug("USBIP_CMD_UNLINK: seq %u\n",
+			 pdu->u.cmd_unlink.seqnum);
+		break;
+	case USBIP_RET_SUBMIT:
+		pr_debug("USBIP_RET_SUBMIT: st %d al %u sf %d #p %d ec %d\n",
+			 pdu->u.ret_submit.status,
+			 pdu->u.ret_submit.actual_length,
+			 pdu->u.ret_submit.start_frame,
+			 pdu->u.ret_submit.number_of_packets,
+			 pdu->u.ret_submit.error_count);
+		break;
+	case USBIP_RET_UNLINK:
+		pr_debug("USBIP_RET_UNLINK: status %d\n",
+			 pdu->u.ret_unlink.status);
+		break;
+	default:
+		/* NOT REACHED */
+		pr_err("unknown command\n");
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(usbip_dump_header);
+
+/* Receive data over TCP/IP. */
+int usbip_recv(struct socket *sock, void *buf, int size)
+{
+	int result;
+	struct msghdr msg;
+	struct kvec iov;
+	int total = 0;
+
+	/* for blocks of if (usbip_dbg_flag_xmit) */
+	char *bp = buf;
+	int osize = size;
+
+	usbip_dbg_xmit("enter\n");
+
+	if (!sock || !buf || !size) {
+		pr_err("invalid arg, sock %p buff %p size %d\n", sock, buf,
+		       size);
+		return -EINVAL;
+	}
+
+	do {
+		sock->sk->sk_allocation = GFP_NOIO;
+		iov.iov_base    = buf;
+		iov.iov_len     = size;
+		msg.msg_name    = NULL;
+		msg.msg_namelen = 0;
+		msg.msg_control = NULL;
+		msg.msg_controllen = 0;
+		msg.msg_flags      = MSG_NOSIGNAL;
+
+		result = kernel_recvmsg(sock, &msg, &iov, 1, size, MSG_WAITALL);
+		if (result <= 0) {
+			pr_debug("receive sock %p buf %p size %u ret %d total %d\n",
+				 sock, buf, size, result, total);
+			goto err;
+		}
+
+		size -= result;
+		buf += result;
+		total += result;
+	} while (size > 0);
+
+	if (usbip_dbg_flag_xmit) {
+		if (!in_interrupt())
+			pr_debug("%-10s:", current->comm);
+		else
+			pr_debug("interrupt  :");
+
+		pr_debug("receiving....\n");
+		usbip_dump_buffer(bp, osize);
+		pr_debug("received, osize %d ret %d size %d total %d\n",
+			 osize, result, size, total);
+	}
+
+	return total;
+
+err:
+	return result;
+}
+EXPORT_SYMBOL_GPL(usbip_recv);
+
+struct socket *sockfd_to_socket(unsigned int sockfd)
+{
+	struct socket *socket;
+	struct file *file;
+	struct inode *inode;
+
+	file = fget(sockfd);
+	if (!file) {
+		pr_err("invalid sockfd\n");
+		return NULL;
+	}
+
+	inode = file_inode(file);
+
+	if (!inode || !S_ISSOCK(inode->i_mode)) {
+		fput(file);
+		return NULL;
+	}
+
+	socket = SOCKET_I(inode);
+
+	return socket;
+}
+EXPORT_SYMBOL_GPL(sockfd_to_socket);
+
+/* there may be more cases to tweak the flags. */
+static unsigned int tweak_transfer_flags(unsigned int flags)
+{
+	flags &= ~URB_NO_TRANSFER_DMA_MAP;
+	return flags;
+}
+
+static void usbip_pack_cmd_submit(struct usbip_header *pdu, struct urb *urb,
+				  int pack)
+{
+	struct usbip_header_cmd_submit *spdu = &pdu->u.cmd_submit;
+
+	/*
+	 * Some members are not still implemented in usbip. I hope this issue
+	 * will be discussed when usbip is ported to other operating systems.
+	 */
+	if (pack) {
+		spdu->transfer_flags =
+			tweak_transfer_flags(urb->transfer_flags);
+		spdu->transfer_buffer_length	= urb->transfer_buffer_length;
+		spdu->start_frame		= urb->start_frame;
+		spdu->number_of_packets		= urb->number_of_packets;
+		spdu->interval			= urb->interval;
+	} else  {
+		urb->transfer_flags         = spdu->transfer_flags;
+		urb->transfer_buffer_length = spdu->transfer_buffer_length;
+		urb->start_frame            = spdu->start_frame;
+		urb->number_of_packets      = spdu->number_of_packets;
+		urb->interval               = spdu->interval;
+	}
+}
+
+static void usbip_pack_ret_submit(struct usbip_header *pdu, struct urb *urb,
+				  int pack)
+{
+	struct usbip_header_ret_submit *rpdu = &pdu->u.ret_submit;
+
+	if (pack) {
+		rpdu->status		= urb->status;
+		rpdu->actual_length	= urb->actual_length;
+		rpdu->start_frame	= urb->start_frame;
+		rpdu->number_of_packets = urb->number_of_packets;
+		rpdu->error_count	= urb->error_count;
+	} else {
+		urb->status		= rpdu->status;
+		urb->actual_length	= rpdu->actual_length;
+		urb->start_frame	= rpdu->start_frame;
+		urb->number_of_packets = rpdu->number_of_packets;
+		urb->error_count	= rpdu->error_count;
+	}
+}
+
+void usbip_pack_pdu(struct usbip_header *pdu, struct urb *urb, int cmd,
+		    int pack)
+{
+	switch (cmd) {
+	case USBIP_CMD_SUBMIT:
+		usbip_pack_cmd_submit(pdu, urb, pack);
+		break;
+	case USBIP_RET_SUBMIT:
+		usbip_pack_ret_submit(pdu, urb, pack);
+		break;
+	default:
+		/* NOT REACHED */
+		pr_err("unknown command\n");
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(usbip_pack_pdu);
+
+static void correct_endian_basic(struct usbip_header_basic *base, int send)
+{
+	if (send) {
+		base->command	= cpu_to_be32(base->command);
+		base->seqnum	= cpu_to_be32(base->seqnum);
+		base->devid	= cpu_to_be32(base->devid);
+		base->direction	= cpu_to_be32(base->direction);
+		base->ep	= cpu_to_be32(base->ep);
+	} else {
+		base->command	= be32_to_cpu(base->command);
+		base->seqnum	= be32_to_cpu(base->seqnum);
+		base->devid	= be32_to_cpu(base->devid);
+		base->direction	= be32_to_cpu(base->direction);
+		base->ep	= be32_to_cpu(base->ep);
+	}
+}
+
+static void correct_endian_cmd_submit(struct usbip_header_cmd_submit *pdu,
+				      int send)
+{
+	if (send) {
+		pdu->transfer_flags = cpu_to_be32(pdu->transfer_flags);
+
+		cpu_to_be32s(&pdu->transfer_buffer_length);
+		cpu_to_be32s(&pdu->start_frame);
+		cpu_to_be32s(&pdu->number_of_packets);
+		cpu_to_be32s(&pdu->interval);
+	} else {
+		pdu->transfer_flags = be32_to_cpu(pdu->transfer_flags);
+
+		be32_to_cpus(&pdu->transfer_buffer_length);
+		be32_to_cpus(&pdu->start_frame);
+		be32_to_cpus(&pdu->number_of_packets);
+		be32_to_cpus(&pdu->interval);
+	}
+}
+
+static void correct_endian_ret_submit(struct usbip_header_ret_submit *pdu,
+				      int send)
+{
+	if (send) {
+		cpu_to_be32s(&pdu->status);
+		cpu_to_be32s(&pdu->actual_length);
+		cpu_to_be32s(&pdu->start_frame);
+		cpu_to_be32s(&pdu->number_of_packets);
+		cpu_to_be32s(&pdu->error_count);
+	} else {
+		be32_to_cpus(&pdu->status);
+		be32_to_cpus(&pdu->actual_length);
+		be32_to_cpus(&pdu->start_frame);
+		be32_to_cpus(&pdu->number_of_packets);
+		be32_to_cpus(&pdu->error_count);
+	}
+}
+
+static void correct_endian_cmd_unlink(struct usbip_header_cmd_unlink *pdu,
+				      int send)
+{
+	if (send)
+		pdu->seqnum = cpu_to_be32(pdu->seqnum);
+	else
+		pdu->seqnum = be32_to_cpu(pdu->seqnum);
+}
+
+static void correct_endian_ret_unlink(struct usbip_header_ret_unlink *pdu,
+				      int send)
+{
+	if (send)
+		cpu_to_be32s(&pdu->status);
+	else
+		be32_to_cpus(&pdu->status);
+}
+
+void usbip_header_correct_endian(struct usbip_header *pdu, int send)
+{
+	__u32 cmd = 0;
+
+	if (send)
+		cmd = pdu->base.command;
+
+	correct_endian_basic(&pdu->base, send);
+
+	if (!send)
+		cmd = pdu->base.command;
+
+	switch (cmd) {
+	case USBIP_CMD_SUBMIT:
+		correct_endian_cmd_submit(&pdu->u.cmd_submit, send);
+		break;
+	case USBIP_RET_SUBMIT:
+		correct_endian_ret_submit(&pdu->u.ret_submit, send);
+		break;
+	case USBIP_CMD_UNLINK:
+		correct_endian_cmd_unlink(&pdu->u.cmd_unlink, send);
+		break;
+	case USBIP_RET_UNLINK:
+		correct_endian_ret_unlink(&pdu->u.ret_unlink, send);
+		break;
+	default:
+		/* NOT REACHED */
+		pr_err("unknown command\n");
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(usbip_header_correct_endian);
+
+static void usbip_iso_packet_correct_endian(
+		struct usbip_iso_packet_descriptor *iso, int send)
+{
+	/* does not need all members. but copy all simply. */
+	if (send) {
+		iso->offset	= cpu_to_be32(iso->offset);
+		iso->length	= cpu_to_be32(iso->length);
+		iso->status	= cpu_to_be32(iso->status);
+		iso->actual_length = cpu_to_be32(iso->actual_length);
+	} else {
+		iso->offset	= be32_to_cpu(iso->offset);
+		iso->length	= be32_to_cpu(iso->length);
+		iso->status	= be32_to_cpu(iso->status);
+		iso->actual_length = be32_to_cpu(iso->actual_length);
+	}
+}
+
+static void usbip_pack_iso(struct usbip_iso_packet_descriptor *iso,
+			   struct usb_iso_packet_descriptor *uiso, int pack)
+{
+	if (pack) {
+		iso->offset		= uiso->offset;
+		iso->length		= uiso->length;
+		iso->status		= uiso->status;
+		iso->actual_length	= uiso->actual_length;
+	} else {
+		uiso->offset		= iso->offset;
+		uiso->length		= iso->length;
+		uiso->status		= iso->status;
+		uiso->actual_length	= iso->actual_length;
+	}
+}
+
+/* must free buffer */
+struct usbip_iso_packet_descriptor*
+usbip_alloc_iso_desc_pdu(struct urb *urb, ssize_t *bufflen)
+{
+	struct usbip_iso_packet_descriptor *iso;
+	int np = urb->number_of_packets;
+	ssize_t size = np * sizeof(*iso);
+	int i;
+
+	iso = kzalloc(size, GFP_KERNEL);
+	if (!iso)
+		return NULL;
+
+	for (i = 0; i < np; i++) {
+		usbip_pack_iso(&iso[i], &urb->iso_frame_desc[i], 1);
+		usbip_iso_packet_correct_endian(&iso[i], 1);
+	}
+
+	*bufflen = size;
+
+	return iso;
+}
+EXPORT_SYMBOL_GPL(usbip_alloc_iso_desc_pdu);
+
+/* some members of urb must be substituted before. */
+int usbip_recv_iso(struct usbip_device *ud, struct urb *urb)
+{
+	void *buff;
+	struct usbip_iso_packet_descriptor *iso;
+	int np = urb->number_of_packets;
+	int size = np * sizeof(*iso);
+	int i;
+	int ret;
+	int total_length = 0;
+
+	if (!usb_pipeisoc(urb->pipe))
+		return 0;
+
+	/* my Bluetooth dongle gets ISO URBs which are np = 0 */
+	if (np == 0)
+		return 0;
+
+	buff = kzalloc(size, GFP_KERNEL);
+	if (!buff)
+		return -ENOMEM;
+
+	ret = usbip_recv(ud->tcp_socket, buff, size);
+	if (ret != size) {
+		dev_err(&urb->dev->dev, "recv iso_frame_descriptor, %d\n",
+			ret);
+		kfree(buff);
+
+		if (ud->side == USBIP_STUB)
+			usbip_event_add(ud, SDEV_EVENT_ERROR_TCP);
+		else
+			usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
+
+		return -EPIPE;
+	}
+
+	iso = (struct usbip_iso_packet_descriptor *) buff;
+	for (i = 0; i < np; i++) {
+		usbip_iso_packet_correct_endian(&iso[i], 0);
+		usbip_pack_iso(&iso[i], &urb->iso_frame_desc[i], 0);
+		total_length += urb->iso_frame_desc[i].actual_length;
+	}
+
+	kfree(buff);
+
+	if (total_length != urb->actual_length) {
+		dev_err(&urb->dev->dev,
+			"total length of iso packets %d not equal to actual "
+			"length of buffer %d\n",
+			total_length, urb->actual_length);
+
+		if (ud->side == USBIP_STUB)
+			usbip_event_add(ud, SDEV_EVENT_ERROR_TCP);
+		else
+			usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
+
+		return -EPIPE;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(usbip_recv_iso);
+
+/*
+ * This functions restores the padding which was removed for optimizing
+ * the bandwidth during transfer over tcp/ip
+ *
+ * buffer and iso packets need to be stored and be in propeper endian in urb
+ * before calling this function
+ */
+void usbip_pad_iso(struct usbip_device *ud, struct urb *urb)
+{
+	int np = urb->number_of_packets;
+	int i;
+	int actualoffset = urb->actual_length;
+
+	if (!usb_pipeisoc(urb->pipe))
+		return;
+
+	/* if no packets or length of data is 0, then nothing to unpack */
+	if (np == 0 || urb->actual_length == 0)
+		return;
+
+	/*
+	 * if actual_length is transfer_buffer_length then no padding is
+	 * present.
+	 */
+	if (urb->actual_length == urb->transfer_buffer_length)
+		return;
+
+	/*
+	 * loop over all packets from last to first (to prevent overwritting
+	 * memory when padding) and move them into the proper place
+	 */
+	for (i = np-1; i > 0; i--) {
+		actualoffset -= urb->iso_frame_desc[i].actual_length;
+		memmove(urb->transfer_buffer + urb->iso_frame_desc[i].offset,
+			urb->transfer_buffer + actualoffset,
+			urb->iso_frame_desc[i].actual_length);
+	}
+}
+EXPORT_SYMBOL_GPL(usbip_pad_iso);
+
+/* some members of urb must be substituted before. */
+int usbip_recv_xbuff(struct usbip_device *ud, struct urb *urb)
+{
+	int ret;
+	int size;
+
+	if (ud->side == USBIP_STUB) {
+		/* the direction of urb must be OUT. */
+		if (usb_pipein(urb->pipe))
+			return 0;
+
+		size = urb->transfer_buffer_length;
+	} else {
+		/* the direction of urb must be IN. */
+		if (usb_pipeout(urb->pipe))
+			return 0;
+
+		size = urb->actual_length;
+	}
+
+	/* no need to recv xbuff */
+	if (!(size > 0))
+		return 0;
+
+	ret = usbip_recv(ud->tcp_socket, urb->transfer_buffer, size);
+	if (ret != size) {
+		dev_err(&urb->dev->dev, "recv xbuf, %d\n", ret);
+		if (ud->side == USBIP_STUB) {
+			usbip_event_add(ud, SDEV_EVENT_ERROR_TCP);
+		} else {
+			usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
+			return -EPIPE;
+		}
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(usbip_recv_xbuff);
+
+static int __init usbip_core_init(void)
+{
+	pr_info(DRIVER_DESC " v" USBIP_VERSION "\n");
+	return 0;
+}
+
+static void __exit usbip_core_exit(void)
+{
+	return;
+}
+
+module_init(usbip_core_init);
+module_exit(usbip_core_exit);
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
+MODULE_VERSION(USBIP_VERSION);
diff --git a/drivers/usb/usbip/usbip_common.h b/drivers/usb/usbip/usbip_common.h
new file mode 100644
index 0000000..0f3d9fb
--- /dev/null
+++ b/drivers/usb/usbip/usbip_common.h
@@ -0,0 +1,334 @@
+/*
+ * Copyright (C) 2003-2008 Takahiro Hirofuchi
+ *
+ * This is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
+ * USA.
+ */
+
+#ifndef __USBIP_COMMON_H
+#define __USBIP_COMMON_H
+
+#include <linux/compiler.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/net.h>
+#include <linux/printk.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/usb.h>
+#include <linux/wait.h>
+#include <linux/usbip.h>
+
+#define USBIP_VERSION "1.0.0"
+
+#undef pr_fmt
+
+#ifdef DEBUG
+#define pr_fmt(fmt)     KBUILD_MODNAME ": %s:%d: " fmt, __func__, __LINE__
+#else
+#define pr_fmt(fmt)     KBUILD_MODNAME ": " fmt
+#endif
+
+enum {
+	usbip_debug_xmit	= (1 << 0),
+	usbip_debug_sysfs	= (1 << 1),
+	usbip_debug_urb		= (1 << 2),
+	usbip_debug_eh		= (1 << 3),
+
+	usbip_debug_stub_cmp	= (1 << 8),
+	usbip_debug_stub_dev	= (1 << 9),
+	usbip_debug_stub_rx	= (1 << 10),
+	usbip_debug_stub_tx	= (1 << 11),
+
+	usbip_debug_vhci_rh	= (1 << 8),
+	usbip_debug_vhci_hc	= (1 << 9),
+	usbip_debug_vhci_rx	= (1 << 10),
+	usbip_debug_vhci_tx	= (1 << 11),
+	usbip_debug_vhci_sysfs  = (1 << 12)
+};
+
+#define usbip_dbg_flag_xmit	(usbip_debug_flag & usbip_debug_xmit)
+#define usbip_dbg_flag_vhci_rh	(usbip_debug_flag & usbip_debug_vhci_rh)
+#define usbip_dbg_flag_vhci_hc	(usbip_debug_flag & usbip_debug_vhci_hc)
+#define usbip_dbg_flag_vhci_rx	(usbip_debug_flag & usbip_debug_vhci_rx)
+#define usbip_dbg_flag_vhci_tx	(usbip_debug_flag & usbip_debug_vhci_tx)
+#define usbip_dbg_flag_stub_rx	(usbip_debug_flag & usbip_debug_stub_rx)
+#define usbip_dbg_flag_stub_tx	(usbip_debug_flag & usbip_debug_stub_tx)
+#define usbip_dbg_flag_vhci_sysfs  (usbip_debug_flag & usbip_debug_vhci_sysfs)
+
+extern unsigned long usbip_debug_flag;
+extern struct device_attribute dev_attr_usbip_debug;
+
+#define usbip_dbg_with_flag(flag, fmt, args...)		\
+	do {						\
+		if (flag & usbip_debug_flag)		\
+			pr_debug(fmt, ##args);		\
+	} while (0)
+
+#define usbip_dbg_sysfs(fmt, args...) \
+	usbip_dbg_with_flag(usbip_debug_sysfs, fmt , ##args)
+#define usbip_dbg_xmit(fmt, args...) \
+	usbip_dbg_with_flag(usbip_debug_xmit, fmt , ##args)
+#define usbip_dbg_urb(fmt, args...) \
+	usbip_dbg_with_flag(usbip_debug_urb, fmt , ##args)
+#define usbip_dbg_eh(fmt, args...) \
+	usbip_dbg_with_flag(usbip_debug_eh, fmt , ##args)
+
+#define usbip_dbg_vhci_rh(fmt, args...)	\
+	usbip_dbg_with_flag(usbip_debug_vhci_rh, fmt , ##args)
+#define usbip_dbg_vhci_hc(fmt, args...)	\
+	usbip_dbg_with_flag(usbip_debug_vhci_hc, fmt , ##args)
+#define usbip_dbg_vhci_rx(fmt, args...)	\
+	usbip_dbg_with_flag(usbip_debug_vhci_rx, fmt , ##args)
+#define usbip_dbg_vhci_tx(fmt, args...)	\
+	usbip_dbg_with_flag(usbip_debug_vhci_tx, fmt , ##args)
+#define usbip_dbg_vhci_sysfs(fmt, args...) \
+	usbip_dbg_with_flag(usbip_debug_vhci_sysfs, fmt , ##args)
+
+#define usbip_dbg_stub_cmp(fmt, args...) \
+	usbip_dbg_with_flag(usbip_debug_stub_cmp, fmt , ##args)
+#define usbip_dbg_stub_rx(fmt, args...) \
+	usbip_dbg_with_flag(usbip_debug_stub_rx, fmt , ##args)
+#define usbip_dbg_stub_tx(fmt, args...) \
+	usbip_dbg_with_flag(usbip_debug_stub_tx, fmt , ##args)
+
+/*
+ * USB/IP request headers
+ *
+ * Each request is transferred across the network to its counterpart, which
+ * facilitates the normal USB communication. The values contained in the headers
+ * are basically the same as in a URB. Currently, four request types are
+ * defined:
+ *
+ *  - USBIP_CMD_SUBMIT: a USB request block, corresponds to usb_submit_urb()
+ *    (client to server)
+ *
+ *  - USBIP_RET_SUBMIT: the result of USBIP_CMD_SUBMIT
+ *    (server to client)
+ *
+ *  - USBIP_CMD_UNLINK: an unlink request of a pending USBIP_CMD_SUBMIT,
+ *    corresponds to usb_unlink_urb()
+ *    (client to server)
+ *
+ *  - USBIP_RET_UNLINK: the result of USBIP_CMD_UNLINK
+ *    (server to client)
+ *
+ */
+#define USBIP_CMD_SUBMIT	0x0001
+#define USBIP_CMD_UNLINK	0x0002
+#define USBIP_RET_SUBMIT	0x0003
+#define USBIP_RET_UNLINK	0x0004
+
+#define USBIP_DIR_OUT	0x00
+#define USBIP_DIR_IN	0x01
+
+/**
+ * struct usbip_header_basic - data pertinent to every request
+ * @command: the usbip request type
+ * @seqnum: sequential number that identifies requests; incremented per
+ *	    connection
+ * @devid: specifies a remote USB device uniquely instead of busnum and devnum;
+ *	   in the stub driver, this value is ((busnum << 16) | devnum)
+ * @direction: direction of the transfer
+ * @ep: endpoint number
+ */
+struct usbip_header_basic {
+	__u32 command;
+	__u32 seqnum;
+	__u32 devid;
+	__u32 direction;
+	__u32 ep;
+} __packed;
+
+/**
+ * struct usbip_header_cmd_submit - USBIP_CMD_SUBMIT packet header
+ * @transfer_flags: URB flags
+ * @transfer_buffer_length: the data size for (in) or (out) transfer
+ * @start_frame: initial frame for isochronous or interrupt transfers
+ * @number_of_packets: number of isochronous packets
+ * @interval: maximum time for the request on the server-side host controller
+ * @setup: setup data for a control request
+ */
+struct usbip_header_cmd_submit {
+	__u32 transfer_flags;
+	__s32 transfer_buffer_length;
+
+	/* it is difficult for usbip to sync frames (reserved only?) */
+	__s32 start_frame;
+	__s32 number_of_packets;
+	__s32 interval;
+
+	unsigned char setup[8];
+} __packed;
+
+/**
+ * struct usbip_header_ret_submit - USBIP_RET_SUBMIT packet header
+ * @status: return status of a non-iso request
+ * @actual_length: number of bytes transferred
+ * @start_frame: initial frame for isochronous or interrupt transfers
+ * @number_of_packets: number of isochronous packets
+ * @error_count: number of errors for isochronous transfers
+ */
+struct usbip_header_ret_submit {
+	__s32 status;
+	__s32 actual_length;
+	__s32 start_frame;
+	__s32 number_of_packets;
+	__s32 error_count;
+} __packed;
+
+/**
+ * struct usbip_header_cmd_unlink - USBIP_CMD_UNLINK packet header
+ * @seqnum: the URB seqnum to unlink
+ */
+struct usbip_header_cmd_unlink {
+	__u32 seqnum;
+} __packed;
+
+/**
+ * struct usbip_header_ret_unlink - USBIP_RET_UNLINK packet header
+ * @status: return status of the request
+ */
+struct usbip_header_ret_unlink {
+	__s32 status;
+} __packed;
+
+/**
+ * struct usbip_header - common header for all usbip packets
+ * @base: the basic header
+ * @u: packet type dependent header
+ */
+struct usbip_header {
+	struct usbip_header_basic base;
+
+	union {
+		struct usbip_header_cmd_submit	cmd_submit;
+		struct usbip_header_ret_submit	ret_submit;
+		struct usbip_header_cmd_unlink	cmd_unlink;
+		struct usbip_header_ret_unlink	ret_unlink;
+	} u;
+} __packed;
+
+/*
+ * This is the same as usb_iso_packet_descriptor but packed for pdu.
+ */
+struct usbip_iso_packet_descriptor {
+	__u32 offset;
+	__u32 length;			/* expected length */
+	__u32 actual_length;
+	__u32 status;
+} __packed;
+
+enum usbip_side {
+	USBIP_VHCI,
+	USBIP_STUB,
+};
+
+/* event handler */
+#define USBIP_EH_SHUTDOWN	(1 << 0)
+#define USBIP_EH_BYE		(1 << 1)
+#define USBIP_EH_RESET		(1 << 2)
+#define USBIP_EH_UNUSABLE	(1 << 3)
+
+#define SDEV_EVENT_REMOVED   (USBIP_EH_SHUTDOWN | USBIP_EH_RESET | USBIP_EH_BYE)
+#define	SDEV_EVENT_DOWN		(USBIP_EH_SHUTDOWN | USBIP_EH_RESET)
+#define	SDEV_EVENT_ERROR_TCP	(USBIP_EH_SHUTDOWN | USBIP_EH_RESET)
+#define	SDEV_EVENT_ERROR_SUBMIT	(USBIP_EH_SHUTDOWN | USBIP_EH_RESET)
+#define	SDEV_EVENT_ERROR_MALLOC	(USBIP_EH_SHUTDOWN | USBIP_EH_UNUSABLE)
+
+#define	VDEV_EVENT_REMOVED	(USBIP_EH_SHUTDOWN | USBIP_EH_BYE)
+#define	VDEV_EVENT_DOWN		(USBIP_EH_SHUTDOWN | USBIP_EH_RESET)
+#define	VDEV_EVENT_ERROR_TCP	(USBIP_EH_SHUTDOWN | USBIP_EH_RESET)
+#define	VDEV_EVENT_ERROR_MALLOC	(USBIP_EH_SHUTDOWN | USBIP_EH_UNUSABLE)
+
+/* a common structure for stub_device and vhci_device */
+struct usbip_device {
+	enum usbip_side side;
+	enum usbip_device_status status;
+
+	/* lock for status */
+	spinlock_t lock;
+
+	struct socket *tcp_socket;
+
+	struct task_struct *tcp_rx;
+	struct task_struct *tcp_tx;
+
+	unsigned long event;
+	struct task_struct *eh;
+	wait_queue_head_t eh_waitq;
+
+	struct eh_ops {
+		void (*shutdown)(struct usbip_device *);
+		void (*reset)(struct usbip_device *);
+		void (*unusable)(struct usbip_device *);
+	} eh_ops;
+};
+
+#define kthread_get_run(threadfn, data, namefmt, ...)			   \
+({									   \
+	struct task_struct *__k						   \
+		= kthread_create(threadfn, data, namefmt, ## __VA_ARGS__); \
+	if (!IS_ERR(__k)) {						   \
+		get_task_struct(__k);					   \
+		wake_up_process(__k);					   \
+	}								   \
+	__k;								   \
+})
+
+#define kthread_stop_put(k)		\
+	do {				\
+		kthread_stop(k);	\
+		put_task_struct(k);	\
+	} while (0)
+
+/* usbip_common.c */
+void usbip_dump_urb(struct urb *purb);
+void usbip_dump_header(struct usbip_header *pdu);
+
+int usbip_recv(struct socket *sock, void *buf, int size);
+struct socket *sockfd_to_socket(unsigned int sockfd);
+
+void usbip_pack_pdu(struct usbip_header *pdu, struct urb *urb, int cmd,
+		    int pack);
+void usbip_header_correct_endian(struct usbip_header *pdu, int send);
+
+struct usbip_iso_packet_descriptor*
+usbip_alloc_iso_desc_pdu(struct urb *urb, ssize_t *bufflen);
+
+/* some members of urb must be substituted before. */
+int usbip_recv_iso(struct usbip_device *ud, struct urb *urb);
+void usbip_pad_iso(struct usbip_device *ud, struct urb *urb);
+int usbip_recv_xbuff(struct usbip_device *ud, struct urb *urb);
+
+/* usbip_event.c */
+int usbip_start_eh(struct usbip_device *ud);
+void usbip_stop_eh(struct usbip_device *ud);
+void usbip_event_add(struct usbip_device *ud, unsigned long event);
+int usbip_event_happened(struct usbip_device *ud);
+
+static inline int interface_to_busnum(struct usb_interface *interface)
+{
+	struct usb_device *udev = interface_to_usbdev(interface);
+	return udev->bus->busnum;
+}
+
+static inline int interface_to_devnum(struct usb_interface *interface)
+{
+	struct usb_device *udev = interface_to_usbdev(interface);
+	return udev->devnum;
+}
+
+#endif /* __USBIP_COMMON_H */
diff --git a/drivers/usb/usbip/usbip_event.c b/drivers/usb/usbip/usbip_event.c
new file mode 100644
index 0000000..64933b9
--- /dev/null
+++ b/drivers/usb/usbip/usbip_event.c
@@ -0,0 +1,128 @@
+/*
+ * Copyright (C) 2003-2008 Takahiro Hirofuchi
+ *
+ * This is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
+ * USA.
+ */
+
+#include <linux/kthread.h>
+#include <linux/export.h>
+
+#include "usbip_common.h"
+
+static int event_handler(struct usbip_device *ud)
+{
+	usbip_dbg_eh("enter\n");
+
+	/*
+	 * Events are handled by only this thread.
+	 */
+	while (usbip_event_happened(ud)) {
+		usbip_dbg_eh("pending event %lx\n", ud->event);
+
+		/*
+		 * NOTE: shutdown must come first.
+		 * Shutdown the device.
+		 */
+		if (ud->event & USBIP_EH_SHUTDOWN) {
+			ud->eh_ops.shutdown(ud);
+			ud->event &= ~USBIP_EH_SHUTDOWN;
+		}
+
+		/* Reset the device. */
+		if (ud->event & USBIP_EH_RESET) {
+			ud->eh_ops.reset(ud);
+			ud->event &= ~USBIP_EH_RESET;
+		}
+
+		/* Mark the device as unusable. */
+		if (ud->event & USBIP_EH_UNUSABLE) {
+			ud->eh_ops.unusable(ud);
+			ud->event &= ~USBIP_EH_UNUSABLE;
+		}
+
+		/* Stop the error handler. */
+		if (ud->event & USBIP_EH_BYE)
+			return -1;
+	}
+
+	return 0;
+}
+
+static int event_handler_loop(void *data)
+{
+	struct usbip_device *ud = data;
+
+	while (!kthread_should_stop()) {
+		wait_event_interruptible(ud->eh_waitq,
+					 usbip_event_happened(ud) ||
+					 kthread_should_stop());
+		usbip_dbg_eh("wakeup\n");
+
+		if (event_handler(ud) < 0)
+			break;
+	}
+
+	return 0;
+}
+
+int usbip_start_eh(struct usbip_device *ud)
+{
+	init_waitqueue_head(&ud->eh_waitq);
+	ud->event = 0;
+
+	ud->eh = kthread_run(event_handler_loop, ud, "usbip_eh");
+	if (IS_ERR(ud->eh)) {
+		pr_warn("Unable to start control thread\n");
+		return PTR_ERR(ud->eh);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(usbip_start_eh);
+
+void usbip_stop_eh(struct usbip_device *ud)
+{
+	if (ud->eh == current)
+		return; /* do not wait for myself */
+
+	kthread_stop(ud->eh);
+	usbip_dbg_eh("usbip_eh has finished\n");
+}
+EXPORT_SYMBOL_GPL(usbip_stop_eh);
+
+void usbip_event_add(struct usbip_device *ud, unsigned long event)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ud->lock, flags);
+	ud->event |= event;
+	wake_up(&ud->eh_waitq);
+	spin_unlock_irqrestore(&ud->lock, flags);
+}
+EXPORT_SYMBOL_GPL(usbip_event_add);
+
+int usbip_event_happened(struct usbip_device *ud)
+{
+	int happened = 0;
+
+	spin_lock(&ud->lock);
+	if (ud->event != 0)
+		happened = 1;
+	spin_unlock(&ud->lock);
+
+	return happened;
+}
+EXPORT_SYMBOL_GPL(usbip_event_happened);
diff --git a/drivers/usb/usbip/usbip_protocol.txt b/drivers/usb/usbip/usbip_protocol.txt
new file mode 100644
index 0000000..16b6fe2
--- /dev/null
+++ b/drivers/usb/usbip/usbip_protocol.txt
@@ -0,0 +1,358 @@
+PRELIMINARY DRAFT, MAY CONTAIN MISTAKES!
+28 Jun 2011
+
+The USB/IP protocol follows a server/client architecture. The server exports the
+USB devices and the clients imports them. The device driver for the exported
+USB device runs on the client machine.
+
+The client may ask for the list of the exported USB devices. To get the list the
+client opens a TCP/IP connection towards the server, and sends an OP_REQ_DEVLIST
+packet on top of the TCP/IP connection (so the actual OP_REQ_DEVLIST may be sent
+in one or more pieces at the low level transport layer). The server sends back
+the OP_REP_DEVLIST packet which lists the exported USB devices. Finally the
+TCP/IP connection is closed.
+
+ virtual host controller                                 usb host
+      "client"                                           "server"
+  (imports USB devices)                             (exports USB devices)
+          |                                                 |
+          |                  OP_REQ_DEVLIST                 |
+          | ----------------------------------------------> |
+          |                                                 |
+          |                  OP_REP_DEVLIST                 |
+          | <---------------------------------------------- |
+          |                                                 |
+
+Once the client knows the list of exported USB devices it may decide to use one
+of them. First the client opens a TCP/IP connection towards the server and
+sends an OP_REQ_IMPORT packet. The server replies with OP_REP_IMPORT. If the
+import was successful the TCP/IP connection remains open and will be used
+to transfer the URB traffic between the client and the server. The client may
+send two types of packets: the USBIP_CMD_SUBMIT to submit an URB, and
+USBIP_CMD_UNLINK to unlink a previously submitted URB. The answers of the
+server may be USBIP_RET_SUBMIT and USBIP_RET_UNLINK respectively.
+
+ virtual host controller                                 usb host
+      "client"                                           "server"
+  (imports USB devices)                             (exports USB devices)
+          |                                                 |
+          |                  OP_REQ_IMPORT                  |
+          | ----------------------------------------------> |
+          |                                                 |
+          |                  OP_REP_IMPORT                  |
+          | <---------------------------------------------- |
+          |                                                 |
+          |                                                 |
+          |            USBIP_CMD_SUBMIT(seqnum = n)         |
+          | ----------------------------------------------> |
+          |                                                 |
+          |            USBIP_RET_SUBMIT(seqnum = n)         |
+          | <---------------------------------------------- |
+          |                        .                        |
+          |                        :                        |
+          |                                                 |
+          |            USBIP_CMD_SUBMIT(seqnum = m)         |
+          | ----------------------------------------------> |
+          |                                                 |
+          |            USBIP_CMD_SUBMIT(seqnum = m+1)       |
+          | ----------------------------------------------> |
+          |                                                 |
+          |            USBIP_CMD_SUBMIT(seqnum = m+2)       |
+          | ----------------------------------------------> |
+          |                                                 |
+          |            USBIP_RET_SUBMIT(seqnum = m)         |
+          | <---------------------------------------------- |
+          |                                                 |
+          |            USBIP_CMD_SUBMIT(seqnum = m+3)       |
+          | ----------------------------------------------> |
+          |                                                 |
+          |            USBIP_RET_SUBMIT(seqnum = m+1)       |
+          | <---------------------------------------------- |
+          |                                                 |
+          |            USBIP_CMD_SUBMIT(seqnum = m+4)       |
+          | ----------------------------------------------> |
+          |                                                 |
+          |            USBIP_RET_SUBMIT(seqnum = m+2)       |
+          | <---------------------------------------------- |
+          |                        .                        |
+          |                        :                        |
+          |                                                 |
+          |               USBIP_CMD_UNLINK                  |
+          | ----------------------------------------------> |
+          |                                                 |
+          |               USBIP_RET_UNLINK                  |
+          | <---------------------------------------------- |
+          |                                                 |
+
+The fields are in network (big endian) byte order meaning that the most significant
+byte (MSB) is stored at the lowest address.
+
+
+OP_REQ_DEVLIST: Retrieve the list of exported USB devices.
+
+ Offset    | Length | Value      | Description
+-----------+--------+------------+---------------------------------------------------
+ 0         | 2      | 0x0100     | Binary-coded decimal USBIP version number: v1.0.0
+-----------+--------+------------+---------------------------------------------------
+ 2         | 2      | 0x8005     | Command code: Retrieve the list of exported USB
+           |        |            |   devices.
+-----------+--------+------------+---------------------------------------------------
+ 4         | 4      | 0x00000000 | Status: unused, shall be set to 0
+
+OP_REP_DEVLIST: Reply with the list of exported USB devices.
+
+ Offset    | Length | Value      | Description
+-----------+--------+------------+---------------------------------------------------
+ 0         | 2      | 0x0100     | Binary-coded decimal USBIP version number: v1.0.0.
+-----------+--------+------------+---------------------------------------------------
+ 2         | 2      | 0x0005     | Reply code: The list of exported USB devices.
+-----------+--------+------------+---------------------------------------------------
+ 4         | 4      | 0x00000000 | Status: 0 for OK
+-----------+--------+------------+---------------------------------------------------
+ 8         | 4      | n          | Number of exported devices: 0 means no exported
+           |        |            |   devices.
+-----------+--------+------------+---------------------------------------------------
+ 0x0C      |        |            | From now on the exported n devices are described,
+           |        |            |   if any. If no devices are exported the message
+           |        |            |   ends with the previous "number of exported
+           |        |            |   devices" field.
+-----------+--------+------------+---------------------------------------------------
+           | 256    |            | path: Path of the device on the host exporting the
+           |        |            |   USB device, string closed with zero byte, e.g.
+           |        |            |   "/sys/devices/pci0000:00/0000:00:1d.1/usb3/3-2"
+           |        |            |   The unused bytes shall be filled with zero
+           |        |            |   bytes.
+-----------+--------+------------+---------------------------------------------------
+ 0x10C     | 32     |            | busid: Bus ID of the exported device, string
+           |        |            |   closed with zero byte, e.g. "3-2". The unused
+           |        |            |   bytes shall be filled with zero bytes.
+-----------+--------+------------+---------------------------------------------------
+ 0x12C     | 4      |            | busnum
+-----------+--------+------------+---------------------------------------------------
+ 0x130     | 4      |            | devnum
+-----------+--------+------------+---------------------------------------------------
+ 0x134     | 4      |            | speed
+-----------+--------+------------+---------------------------------------------------
+ 0x138     | 2      |            | idVendor
+-----------+--------+------------+---------------------------------------------------
+ 0x13A     | 2      |            | idProduct
+-----------+--------+------------+---------------------------------------------------
+ 0x13C     | 2      |            | bcdDevice
+-----------+--------+------------+---------------------------------------------------
+ 0x13E     | 1      |            | bDeviceClass
+-----------+--------+------------+---------------------------------------------------
+ 0x13F     | 1      |            | bDeviceSubClass
+-----------+--------+------------+---------------------------------------------------
+ 0x140     | 1      |            | bDeviceProtocol
+-----------+--------+------------+---------------------------------------------------
+ 0x141     | 1      |            | bConfigurationValue
+-----------+--------+------------+---------------------------------------------------
+ 0x142     | 1      |            | bNumConfigurations
+-----------+--------+------------+---------------------------------------------------
+ 0x143     | 1      |            | bNumInterfaces
+-----------+--------+------------+---------------------------------------------------
+ 0x144     |        | m_0        | From now on each interface is described, all
+           |        |            |   together bNumInterfaces times, with the
+           |        |            |   the following 4 fields:
+-----------+--------+------------+---------------------------------------------------
+           | 1      |            | bInterfaceClass
+-----------+--------+------------+---------------------------------------------------
+ 0x145     | 1      |            | bInterfaceSubClass
+-----------+--------+------------+---------------------------------------------------
+ 0x146     | 1      |            | bInterfaceProtocol
+-----------+--------+------------+---------------------------------------------------
+ 0x147     | 1      |            | padding byte for alignment, shall be set to zero
+-----------+--------+------------+---------------------------------------------------
+ 0xC +     |        |            | The second exported USB device starts at i=1
+ i*0x138 + |        |            | with the busid field.
+ m_(i-1)*4 |        |            |
+
+OP_REQ_IMPORT: Request to import (attach) a remote USB device.
+
+ Offset    | Length | Value      | Description
+-----------+--------+------------+---------------------------------------------------
+ 0         | 2      | 0x0100     | Binary-coded decimal USBIP version number: v1.0.0
+-----------+--------+------------+---------------------------------------------------
+ 2         | 2      | 0x8003     | Command code: import a remote USB device.
+-----------+--------+------------+---------------------------------------------------
+ 4         | 4      | 0x00000000 | Status: unused, shall be set to 0
+-----------+--------+------------+---------------------------------------------------
+ 8         | 32     |            | busid: the busid of the exported device on the
+           |        |            |   remote host. The possible values are taken
+           |        |            |   from the message field OP_REP_DEVLIST.busid.
+           |        |            |   A string closed with zero, the unused bytes
+           |        |            |   shall be filled with zeros.
+-----------+--------+------------+---------------------------------------------------
+
+OP_REP_IMPORT: Reply to import (attach) a remote USB device.
+
+ Offset    | Length | Value      | Description
+-----------+--------+------------+---------------------------------------------------
+ 0         | 2      | 0x0100     | Binary-coded decimal USBIP version number: v1.0.0
+-----------+--------+------------+---------------------------------------------------
+ 2         | 2      | 0x0003     | Reply code: Reply to import.
+-----------+--------+------------+---------------------------------------------------
+ 4         | 4      | 0x00000000 | Status: 0 for OK
+           |        |            |         1 for error
+-----------+--------+------------+---------------------------------------------------
+ 8         |        |            | From now on comes the details of the imported
+           |        |            |   device, if the previous status field was OK (0),
+           |        |            |   otherwise the reply ends with the status field.
+-----------+--------+------------+---------------------------------------------------
+           | 256    |            | path: Path of the device on the host exporting the
+           |        |            |   USB device, string closed with zero byte, e.g.
+           |        |            |   "/sys/devices/pci0000:00/0000:00:1d.1/usb3/3-2"
+           |        |            |   The unused bytes shall be filled with zero
+           |        |            |   bytes.
+-----------+--------+------------+---------------------------------------------------
+ 0x108     | 32     |            | busid: Bus ID of the exported device, string
+           |        |            |   closed with zero byte, e.g. "3-2". The unused
+           |        |            |   bytes shall be filled with zero bytes.
+-----------+--------+------------+---------------------------------------------------
+ 0x128     | 4      |            | busnum
+-----------+--------+------------+---------------------------------------------------
+ 0x12C     | 4      |            | devnum
+-----------+--------+------------+---------------------------------------------------
+ 0x130     | 4      |            | speed
+-----------+--------+------------+---------------------------------------------------
+ 0x134     | 2      |            | idVendor
+-----------+--------+------------+---------------------------------------------------
+ 0x136     | 2      |            | idProduct
+-----------+--------+------------+---------------------------------------------------
+ 0x138     | 2      |            | bcdDevice
+-----------+--------+------------+---------------------------------------------------
+ 0x139     | 1      |            | bDeviceClass
+-----------+--------+------------+---------------------------------------------------
+ 0x13A     | 1      |            | bDeviceSubClass
+-----------+--------+------------+---------------------------------------------------
+ 0x13B     | 1      |            | bDeviceProtocol
+-----------+--------+------------+---------------------------------------------------
+ 0x13C     | 1      |            | bConfigurationValue
+-----------+--------+------------+---------------------------------------------------
+ 0x13D     | 1      |            | bNumConfigurations
+-----------+--------+------------+---------------------------------------------------
+ 0x13E     | 1      |            | bNumInterfaces
+
+USBIP_CMD_SUBMIT: Submit an URB
+
+ Offset    | Length | Value      | Description
+-----------+--------+------------+---------------------------------------------------
+ 0         | 4      | 0x00000001 | command: Submit an URB
+-----------+--------+------------+---------------------------------------------------
+ 4         | 4      |            | seqnum: the sequence number of the URB to submit
+-----------+--------+------------+---------------------------------------------------
+ 8         | 4      |            | devid
+-----------+--------+------------+---------------------------------------------------
+ 0xC       | 4      |            | direction: 0: USBIP_DIR_OUT
+           |        |            |            1: USBIP_DIR_IN
+-----------+--------+------------+---------------------------------------------------
+ 0x10      | 4      |            | ep: endpoint number, possible values are: 0...15
+-----------+--------+------------+---------------------------------------------------
+ 0x14      | 4      |            | transfer_flags: possible values depend on the
+           |        |            |   URB transfer type, see below
+-----------+--------+------------+---------------------------------------------------
+ 0x18      | 4      |            | transfer_buffer_length
+-----------+--------+------------+---------------------------------------------------
+ 0x1C      | 4      |            | start_frame: specify the selected frame to
+           |        |            |   transmit an ISO frame, ignored if URB_ISO_ASAP
+           |        |            |   is specified at transfer_flags
+-----------+--------+------------+---------------------------------------------------
+ 0x20      | 4      |            | number_of_packets: number of ISO packets
+-----------+--------+------------+---------------------------------------------------
+ 0x24      | 4      |            | interval: maximum time for the request on the
+           |        |            |   server-side host controller
+-----------+--------+------------+---------------------------------------------------
+ 0x28      | 8      |            | setup: data bytes for USB setup, filled with
+           |        |            |   zeros if not used
+-----------+--------+------------+---------------------------------------------------
+ 0x30      |        |            | URB data. For ISO transfers the padding between
+           |        |            |   each ISO packets is not transmitted.
+
+
+  Allowed transfer_flags  | value      | control | interrupt | bulk     | isochronous
+ -------------------------+------------+---------+-----------+----------+-------------
+  URB_SHORT_NOT_OK        | 0x00000001 | only in | only in   | only in  | no
+  URB_ISO_ASAP            | 0x00000002 | no      | no        | no       | yes
+  URB_NO_TRANSFER_DMA_MAP | 0x00000004 | yes     | yes       | yes      | yes
+  URB_NO_FSBR             | 0x00000020 | yes     | no        | no       | no
+  URB_ZERO_PACKET         | 0x00000040 | no      | no        | only out | no
+  URB_NO_INTERRUPT        | 0x00000080 | yes     | yes       | yes      | yes
+  URB_FREE_BUFFER         | 0x00000100 | yes     | yes       | yes      | yes
+  URB_DIR_MASK            | 0x00000200 | yes     | yes       | yes      | yes
+
+
+USBIP_RET_SUBMIT: Reply for submitting an URB
+
+ Offset    | Length | Value      | Description
+-----------+--------+------------+---------------------------------------------------
+ 0         | 4      | 0x00000003 | command
+-----------+--------+------------+---------------------------------------------------
+ 4         | 4      |            | seqnum: URB sequence number
+-----------+--------+------------+---------------------------------------------------
+ 8         | 4      |            | devid
+-----------+--------+------------+---------------------------------------------------
+ 0xC       | 4      |            | direction: 0: USBIP_DIR_OUT
+           |        |            |            1: USBIP_DIR_IN
+-----------+--------+------------+---------------------------------------------------
+ 0x10      | 4      |            | ep: endpoint number
+-----------+--------+------------+---------------------------------------------------
+ 0x14      | 4      |            | status: zero for successful URB transaction,
+           |        |            |   otherwise some kind of error happened.
+-----------+--------+------------+---------------------------------------------------
+ 0x18      | 4      | n          | actual_length: number of URB data bytes
+-----------+--------+------------+---------------------------------------------------
+ 0x1C      | 4      |            | start_frame: for an ISO frame the actually
+           |        |            |   selected frame for transmit.
+-----------+--------+------------+---------------------------------------------------
+ 0x20      | 4      |            | number_of_packets
+-----------+--------+------------+---------------------------------------------------
+ 0x24      | 4      |            | error_count
+-----------+--------+------------+---------------------------------------------------
+ 0x28      | 8      |            | setup: data bytes for USB setup, filled with
+           |        |            |   zeros if not used
+-----------+--------+------------+---------------------------------------------------
+ 0x30      | n      |            | URB data bytes. For ISO transfers the padding
+           |        |            |   between each ISO packets is not transmitted.
+
+USBIP_CMD_UNLINK: Unlink an URB
+
+ Offset    | Length | Value      | Description
+-----------+--------+------------+---------------------------------------------------
+ 0         | 4      | 0x00000002 | command: URB unlink command
+-----------+--------+------------+---------------------------------------------------
+ 4         | 4      |            | seqnum: URB sequence number to unlink: FIXME: is this so?
+-----------+--------+------------+---------------------------------------------------
+ 8         | 4      |            | devid
+-----------+--------+------------+---------------------------------------------------
+ 0xC       | 4      |            | direction: 0: USBIP_DIR_OUT
+           |        |            |            1: USBIP_DIR_IN
+-----------+--------+------------+---------------------------------------------------
+ 0x10      | 4      |            | ep: endpoint number: zero
+-----------+--------+------------+---------------------------------------------------
+ 0x14      | 4      |            | seqnum: the URB sequence number given previously
+           |        |            |   at USBIP_CMD_SUBMIT.seqnum field
+-----------+--------+------------+---------------------------------------------------
+ 0x30      | n      |            | URB data bytes. For ISO transfers the padding
+           |        |            |   between each ISO packets is not transmitted.
+
+USBIP_RET_UNLINK: Reply for URB unlink
+
+ Offset    | Length | Value      | Description
+-----------+--------+------------+---------------------------------------------------
+ 0         | 4      | 0x00000004 | command: reply for the URB unlink command
+-----------+--------+------------+---------------------------------------------------
+ 4         | 4      |            | seqnum: the unlinked URB sequence number
+-----------+--------+------------+---------------------------------------------------
+ 8         | 4      |            | devid
+-----------+--------+------------+---------------------------------------------------
+ 0xC       | 4      |            | direction: 0: USBIP_DIR_OUT
+           |        |            |            1: USBIP_DIR_IN
+-----------+--------+------------+---------------------------------------------------
+ 0x10      | 4      |            | ep: endpoint number
+-----------+--------+------------+---------------------------------------------------
+ 0x14      | 4      |            | status: This is the value contained in the
+           |        |            |   urb->status in the URB completition handler.
+           |        |            |   FIXME: a better explanation needed.
+-----------+--------+------------+---------------------------------------------------
+ 0x30      | n      |            | URB data bytes. For ISO transfers the padding
+           |        |            |   between each ISO packets is not transmitted.
diff --git a/drivers/usb/usbip/vhci.h b/drivers/usb/usbip/vhci.h
new file mode 100644
index 0000000..a863a98
--- /dev/null
+++ b/drivers/usb/usbip/vhci.h
@@ -0,0 +1,129 @@
+/*
+ * Copyright (C) 2003-2008 Takahiro Hirofuchi
+ *
+ * This is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#ifndef __USBIP_VHCI_H
+#define __USBIP_VHCI_H
+
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/sysfs.h>
+#include <linux/types.h>
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+#include <linux/wait.h>
+
+struct vhci_device {
+	struct usb_device *udev;
+
+	/*
+	 * devid specifies a remote usb device uniquely instead
+	 * of combination of busnum and devnum.
+	 */
+	__u32 devid;
+
+	/* speed of a remote device */
+	enum usb_device_speed speed;
+
+	/* vhci root-hub port to which this device is attached */
+	__u32 rhport;
+
+	struct usbip_device ud;
+
+	/* lock for the below link lists */
+	spinlock_t priv_lock;
+
+	/* vhci_priv is linked to one of them. */
+	struct list_head priv_tx;
+	struct list_head priv_rx;
+
+	/* vhci_unlink is linked to one of them */
+	struct list_head unlink_tx;
+	struct list_head unlink_rx;
+
+	/* vhci_tx thread sleeps for this queue */
+	wait_queue_head_t waitq_tx;
+};
+
+/* urb->hcpriv, use container_of() */
+struct vhci_priv {
+	unsigned long seqnum;
+	struct list_head list;
+
+	struct vhci_device *vdev;
+	struct urb *urb;
+};
+
+struct vhci_unlink {
+	/* seqnum of this request */
+	unsigned long seqnum;
+
+	struct list_head list;
+
+	/* seqnum of the unlink target */
+	unsigned long unlink_seqnum;
+};
+
+/* Number of supported ports. Value has an upperbound of USB_MAXCHILDREN */
+#define VHCI_NPORTS 8
+
+/* for usb_bus.hcpriv */
+struct vhci_hcd {
+	spinlock_t lock;
+
+	u32 port_status[VHCI_NPORTS];
+
+	unsigned resuming:1;
+	unsigned long re_timeout;
+
+	atomic_t seqnum;
+
+	/*
+	 * NOTE:
+	 * wIndex shows the port number and begins from 1.
+	 * But, the index of this array begins from 0.
+	 */
+	struct vhci_device vdev[VHCI_NPORTS];
+};
+
+extern struct vhci_hcd *the_controller;
+extern const struct attribute_group dev_attr_group;
+
+/* vhci_hcd.c */
+void rh_port_connect(int rhport, enum usb_device_speed speed);
+
+/* vhci_rx.c */
+struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev, __u32 seqnum);
+int vhci_rx_loop(void *data);
+
+/* vhci_tx.c */
+int vhci_tx_loop(void *data);
+
+static inline struct vhci_device *port_to_vdev(__u32 port)
+{
+	return &the_controller->vdev[port];
+}
+
+static inline struct vhci_hcd *hcd_to_vhci(struct usb_hcd *hcd)
+{
+	return (struct vhci_hcd *) (hcd->hcd_priv);
+}
+
+static inline struct usb_hcd *vhci_to_hcd(struct vhci_hcd *vhci)
+{
+	return container_of((void *) vhci, struct usb_hcd, hcd_priv);
+}
+
+static inline struct device *vhci_dev(struct vhci_hcd *vhci)
+{
+	return vhci_to_hcd(vhci)->self.controller;
+}
+
+#endif /* __USBIP_VHCI_H */
diff --git a/drivers/usb/usbip/vhci_hcd.c b/drivers/usb/usbip/vhci_hcd.c
new file mode 100644
index 0000000..adb6201
--- /dev/null
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -0,0 +1,1168 @@
+/*
+ * Copyright (C) 2003-2008 Takahiro Hirofuchi
+ *
+ * This is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
+ * USA.
+ */
+
+#include <linux/init.h>
+#include <linux/file.h>
+#include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include "usbip_common.h"
+#include "vhci.h"
+
+#define DRIVER_AUTHOR "Takahiro Hirofuchi"
+#define DRIVER_DESC "USB/IP 'Virtual' Host Controller (VHCI) Driver"
+
+/*
+ * TODO
+ *	- update root hub emulation
+ *	- move the emulation code to userland ?
+ *		porting to other operating systems
+ *		minimize kernel code
+ *	- add suspend/resume code
+ *	- clean up everything
+ */
+
+/* See usb gadget dummy hcd */
+
+static int vhci_hub_status(struct usb_hcd *hcd, char *buff);
+static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
+			    u16 wIndex, char *buff, u16 wLength);
+static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
+			    gfp_t mem_flags);
+static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status);
+static int vhci_start(struct usb_hcd *vhci_hcd);
+static void vhci_stop(struct usb_hcd *hcd);
+static int vhci_get_frame_number(struct usb_hcd *hcd);
+
+static const char driver_name[] = "vhci_hcd";
+static const char driver_desc[] = "USB/IP Virtual Host Controller";
+
+struct vhci_hcd *the_controller;
+
+static const char * const bit_desc[] = {
+	"CONNECTION",		/*0*/
+	"ENABLE",		/*1*/
+	"SUSPEND",		/*2*/
+	"OVER_CURRENT",		/*3*/
+	"RESET",		/*4*/
+	"R5",			/*5*/
+	"R6",			/*6*/
+	"R7",			/*7*/
+	"POWER",		/*8*/
+	"LOWSPEED",		/*9*/
+	"HIGHSPEED",		/*10*/
+	"PORT_TEST",		/*11*/
+	"INDICATOR",		/*12*/
+	"R13",			/*13*/
+	"R14",			/*14*/
+	"R15",			/*15*/
+	"C_CONNECTION",		/*16*/
+	"C_ENABLE",		/*17*/
+	"C_SUSPEND",		/*18*/
+	"C_OVER_CURRENT",	/*19*/
+	"C_RESET",		/*20*/
+	"R21",			/*21*/
+	"R22",			/*22*/
+	"R23",			/*23*/
+	"R24",			/*24*/
+	"R25",			/*25*/
+	"R26",			/*26*/
+	"R27",			/*27*/
+	"R28",			/*28*/
+	"R29",			/*29*/
+	"R30",			/*30*/
+	"R31",			/*31*/
+};
+
+static void dump_port_status_diff(u32 prev_status, u32 new_status)
+{
+	int i = 0;
+	u32 bit = 1;
+
+	pr_debug("status prev -> new: %08x -> %08x\n", prev_status, new_status);
+	while (bit) {
+		u32 prev = prev_status & bit;
+		u32 new = new_status & bit;
+		char change;
+
+		if (!prev && new)
+			change = '+';
+		else if (prev && !new)
+			change = '-';
+		else
+			change = ' ';
+
+		if (prev || new)
+			pr_debug(" %c%s\n", change, bit_desc[i]);
+		bit <<= 1;
+		i++;
+	}
+	pr_debug("\n");
+}
+
+void rh_port_connect(int rhport, enum usb_device_speed speed)
+{
+	usbip_dbg_vhci_rh("rh_port_connect %d\n", rhport);
+
+	spin_lock(&the_controller->lock);
+
+	the_controller->port_status[rhport] |= USB_PORT_STAT_CONNECTION
+		| (1 << USB_PORT_FEAT_C_CONNECTION);
+
+	switch (speed) {
+	case USB_SPEED_HIGH:
+		the_controller->port_status[rhport] |= USB_PORT_STAT_HIGH_SPEED;
+		break;
+	case USB_SPEED_LOW:
+		the_controller->port_status[rhport] |= USB_PORT_STAT_LOW_SPEED;
+		break;
+	default:
+		break;
+	}
+
+	spin_unlock(&the_controller->lock);
+
+	usb_hcd_poll_rh_status(vhci_to_hcd(the_controller));
+}
+
+static void rh_port_disconnect(int rhport)
+{
+	usbip_dbg_vhci_rh("rh_port_disconnect %d\n", rhport);
+
+	spin_lock(&the_controller->lock);
+
+	the_controller->port_status[rhport] &= ~USB_PORT_STAT_CONNECTION;
+	the_controller->port_status[rhport] |=
+					(1 << USB_PORT_FEAT_C_CONNECTION);
+
+	spin_unlock(&the_controller->lock);
+	usb_hcd_poll_rh_status(vhci_to_hcd(the_controller));
+}
+
+#define PORT_C_MASK				\
+	((USB_PORT_STAT_C_CONNECTION		\
+	  | USB_PORT_STAT_C_ENABLE		\
+	  | USB_PORT_STAT_C_SUSPEND		\
+	  | USB_PORT_STAT_C_OVERCURRENT		\
+	  | USB_PORT_STAT_C_RESET) << 16)
+
+/*
+ * Returns 0 if the status hasn't changed, or the number of bytes in buf.
+ * Ports are 0-indexed from the HCD point of view,
+ * and 1-indexed from the USB core pointer of view.
+ *
+ * @buf: a bitmap to show which port status has been changed.
+ *  bit  0: reserved
+ *  bit  1: the status of port 0 has been changed.
+ *  bit  2: the status of port 1 has been changed.
+ *  ...
+ */
+static int vhci_hub_status(struct usb_hcd *hcd, char *buf)
+{
+	struct vhci_hcd	*vhci;
+	int		retval;
+	int		rhport;
+	int		changed = 0;
+
+	retval = DIV_ROUND_UP(VHCI_NPORTS + 1, 8);
+	memset(buf, 0, retval);
+
+	vhci = hcd_to_vhci(hcd);
+
+	spin_lock(&vhci->lock);
+	if (!HCD_HW_ACCESSIBLE(hcd)) {
+		usbip_dbg_vhci_rh("hw accessible flag not on?\n");
+		goto done;
+	}
+
+	/* check pseudo status register for each port */
+	for (rhport = 0; rhport < VHCI_NPORTS; rhport++) {
+		if ((vhci->port_status[rhport] & PORT_C_MASK)) {
+			/* The status of a port has been changed, */
+			usbip_dbg_vhci_rh("port %d status changed\n", rhport);
+
+			buf[(rhport + 1) / 8] |= 1 << (rhport + 1) % 8;
+			changed = 1;
+		}
+	}
+
+	if ((hcd->state == HC_STATE_SUSPENDED) && (changed == 1))
+		usb_hcd_resume_root_hub(hcd);
+
+done:
+	spin_unlock(&vhci->lock);
+	return changed ? retval : 0;
+}
+
+static inline void hub_descriptor(struct usb_hub_descriptor *desc)
+{
+	memset(desc, 0, sizeof(*desc));
+	desc->bDescriptorType = 0x29;
+	desc->bDescLength = 9;
+	desc->wHubCharacteristics = (__constant_cpu_to_le16(0x0001));
+	desc->bNbrPorts = VHCI_NPORTS;
+	desc->u.hs.DeviceRemovable[0] = 0xff;
+	desc->u.hs.DeviceRemovable[1] = 0xff;
+}
+
+static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
+			    u16 wIndex, char *buf, u16 wLength)
+{
+	struct vhci_hcd	*dum;
+	int             retval = 0;
+	int		rhport;
+
+	u32 prev_port_status[VHCI_NPORTS];
+
+	if (!HCD_HW_ACCESSIBLE(hcd))
+		return -ETIMEDOUT;
+
+	/*
+	 * NOTE:
+	 * wIndex shows the port number and begins from 1.
+	 */
+	usbip_dbg_vhci_rh("typeReq %x wValue %x wIndex %x\n", typeReq, wValue,
+			  wIndex);
+	if (wIndex > VHCI_NPORTS)
+		pr_err("invalid port number %d\n", wIndex);
+	rhport = ((__u8)(wIndex & 0x00ff)) - 1;
+
+	dum = hcd_to_vhci(hcd);
+
+	spin_lock(&dum->lock);
+
+	/* store old status and compare now and old later */
+	if (usbip_dbg_flag_vhci_rh) {
+		memcpy(prev_port_status, dum->port_status,
+			sizeof(prev_port_status));
+	}
+
+	switch (typeReq) {
+	case ClearHubFeature:
+		usbip_dbg_vhci_rh(" ClearHubFeature\n");
+		break;
+	case ClearPortFeature:
+		switch (wValue) {
+		case USB_PORT_FEAT_SUSPEND:
+			if (dum->port_status[rhport] & USB_PORT_STAT_SUSPEND) {
+				/* 20msec signaling */
+				dum->resuming = 1;
+				dum->re_timeout =
+					jiffies + msecs_to_jiffies(20);
+			}
+			break;
+		case USB_PORT_FEAT_POWER:
+			usbip_dbg_vhci_rh(" ClearPortFeature: "
+					  "USB_PORT_FEAT_POWER\n");
+			dum->port_status[rhport] = 0;
+			dum->resuming = 0;
+			break;
+		case USB_PORT_FEAT_C_RESET:
+			usbip_dbg_vhci_rh(" ClearPortFeature: "
+					  "USB_PORT_FEAT_C_RESET\n");
+			switch (dum->vdev[rhport].speed) {
+			case USB_SPEED_HIGH:
+				dum->port_status[rhport] |=
+					USB_PORT_STAT_HIGH_SPEED;
+				break;
+			case USB_SPEED_LOW:
+				dum->port_status[rhport] |=
+					USB_PORT_STAT_LOW_SPEED;
+				break;
+			default:
+				break;
+			}
+		default:
+			usbip_dbg_vhci_rh(" ClearPortFeature: default %x\n",
+					  wValue);
+			dum->port_status[rhport] &= ~(1 << wValue);
+			break;
+		}
+		break;
+	case GetHubDescriptor:
+		usbip_dbg_vhci_rh(" GetHubDescriptor\n");
+		hub_descriptor((struct usb_hub_descriptor *) buf);
+		break;
+	case GetHubStatus:
+		usbip_dbg_vhci_rh(" GetHubStatus\n");
+		*(__le32 *) buf = __constant_cpu_to_le32(0);
+		break;
+	case GetPortStatus:
+		usbip_dbg_vhci_rh(" GetPortStatus port %x\n", wIndex);
+		if (wIndex > VHCI_NPORTS || wIndex < 1) {
+			pr_err("invalid port number %d\n", wIndex);
+			retval = -EPIPE;
+		}
+
+		/* we do not care about resume. */
+
+		/* whoever resets or resumes must GetPortStatus to
+		 * complete it!!
+		 */
+		if (dum->resuming && time_after(jiffies, dum->re_timeout)) {
+			dum->port_status[rhport] |=
+				(1 << USB_PORT_FEAT_C_SUSPEND);
+			dum->port_status[rhport] &=
+				~(1 << USB_PORT_FEAT_SUSPEND);
+			dum->resuming = 0;
+			dum->re_timeout = 0;
+		}
+
+		if ((dum->port_status[rhport] & (1 << USB_PORT_FEAT_RESET)) !=
+		    0 && time_after(jiffies, dum->re_timeout)) {
+			dum->port_status[rhport] |=
+				(1 << USB_PORT_FEAT_C_RESET);
+			dum->port_status[rhport] &=
+				~(1 << USB_PORT_FEAT_RESET);
+			dum->re_timeout = 0;
+
+			if (dum->vdev[rhport].ud.status ==
+			    VDEV_ST_NOTASSIGNED) {
+				usbip_dbg_vhci_rh(" enable rhport %d "
+						  "(status %u)\n",
+						  rhport,
+						  dum->vdev[rhport].ud.status);
+				dum->port_status[rhport] |=
+					USB_PORT_STAT_ENABLE;
+			}
+		}
+		((__le16 *) buf)[0] = cpu_to_le16(dum->port_status[rhport]);
+		((__le16 *) buf)[1] = cpu_to_le16(dum->port_status[rhport] >> 16);
+
+		usbip_dbg_vhci_rh(" GetPortStatus bye %x %x\n", ((u16 *)buf)[0],
+				  ((u16 *)buf)[1]);
+		break;
+	case SetHubFeature:
+		usbip_dbg_vhci_rh(" SetHubFeature\n");
+		retval = -EPIPE;
+		break;
+	case SetPortFeature:
+		switch (wValue) {
+		case USB_PORT_FEAT_SUSPEND:
+			usbip_dbg_vhci_rh(" SetPortFeature: "
+					  "USB_PORT_FEAT_SUSPEND\n");
+			break;
+		case USB_PORT_FEAT_RESET:
+			usbip_dbg_vhci_rh(" SetPortFeature: "
+					  "USB_PORT_FEAT_RESET\n");
+			/* if it's already running, disconnect first */
+			if (dum->port_status[rhport] & USB_PORT_STAT_ENABLE) {
+				dum->port_status[rhport] &=
+					~(USB_PORT_STAT_ENABLE |
+					  USB_PORT_STAT_LOW_SPEED |
+					  USB_PORT_STAT_HIGH_SPEED);
+				/* FIXME test that code path! */
+			}
+			/* 50msec reset signaling */
+			dum->re_timeout = jiffies + msecs_to_jiffies(50);
+
+			/* FALLTHROUGH */
+		default:
+			usbip_dbg_vhci_rh(" SetPortFeature: default %d\n",
+					  wValue);
+			dum->port_status[rhport] |= (1 << wValue);
+			break;
+		}
+		break;
+
+	default:
+		pr_err("default: no such request\n");
+
+		/* "protocol stall" on error */
+		retval = -EPIPE;
+	}
+
+	if (usbip_dbg_flag_vhci_rh) {
+		pr_debug("port %d\n", rhport);
+		/* Only dump valid port status */
+		if (rhport >= 0) {
+			dump_port_status_diff(prev_port_status[rhport],
+					      dum->port_status[rhport]);
+		}
+	}
+	usbip_dbg_vhci_rh(" bye\n");
+
+	spin_unlock(&dum->lock);
+
+	return retval;
+}
+
+static struct vhci_device *get_vdev(struct usb_device *udev)
+{
+	int i;
+
+	if (!udev)
+		return NULL;
+
+	for (i = 0; i < VHCI_NPORTS; i++)
+		if (the_controller->vdev[i].udev == udev)
+			return port_to_vdev(i);
+
+	return NULL;
+}
+
+static void vhci_tx_urb(struct urb *urb)
+{
+	struct vhci_device *vdev = get_vdev(urb->dev);
+	struct vhci_priv *priv;
+
+	if (!vdev) {
+		pr_err("could not get virtual device");
+		return;
+	}
+
+	priv = kzalloc(sizeof(struct vhci_priv), GFP_ATOMIC);
+	if (!priv) {
+		usbip_event_add(&vdev->ud, VDEV_EVENT_ERROR_MALLOC);
+		return;
+	}
+
+	spin_lock(&vdev->priv_lock);
+
+	priv->seqnum = atomic_inc_return(&the_controller->seqnum);
+	if (priv->seqnum == 0xffff)
+		dev_info(&urb->dev->dev, "seqnum max\n");
+
+	priv->vdev = vdev;
+	priv->urb = urb;
+
+	urb->hcpriv = (void *) priv;
+
+	list_add_tail(&priv->list, &vdev->priv_tx);
+
+	wake_up(&vdev->waitq_tx);
+	spin_unlock(&vdev->priv_lock);
+}
+
+static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
+			    gfp_t mem_flags)
+{
+	struct device *dev = &urb->dev->dev;
+	int ret = 0;
+	struct vhci_device *vdev;
+
+	usbip_dbg_vhci_hc("enter, usb_hcd %p urb %p mem_flags %d\n",
+			  hcd, urb, mem_flags);
+
+	/* patch to usb_sg_init() is in 2.5.60 */
+	BUG_ON(!urb->transfer_buffer && urb->transfer_buffer_length);
+
+	spin_lock(&the_controller->lock);
+
+	if (urb->status != -EINPROGRESS) {
+		dev_err(dev, "URB already unlinked!, status %d\n", urb->status);
+		spin_unlock(&the_controller->lock);
+		return urb->status;
+	}
+
+	vdev = port_to_vdev(urb->dev->portnum-1);
+
+	/* refuse enqueue for dead connection */
+	spin_lock(&vdev->ud.lock);
+	if (vdev->ud.status == VDEV_ST_NULL ||
+	    vdev->ud.status == VDEV_ST_ERROR) {
+		dev_err(dev, "enqueue for inactive port %d\n", vdev->rhport);
+		spin_unlock(&vdev->ud.lock);
+		spin_unlock(&the_controller->lock);
+		return -ENODEV;
+	}
+	spin_unlock(&vdev->ud.lock);
+
+	ret = usb_hcd_link_urb_to_ep(hcd, urb);
+	if (ret)
+		goto no_need_unlink;
+
+	/*
+	 * The enumeration process is as follows;
+	 *
+	 *  1. Get_Descriptor request to DevAddrs(0) EndPoint(0)
+	 *     to get max packet length of default pipe
+	 *
+	 *  2. Set_Address request to DevAddr(0) EndPoint(0)
+	 *
+	 */
+	if (usb_pipedevice(urb->pipe) == 0) {
+		__u8 type = usb_pipetype(urb->pipe);
+		struct usb_ctrlrequest *ctrlreq =
+			(struct usb_ctrlrequest *) urb->setup_packet;
+
+		if (type != PIPE_CONTROL || !ctrlreq) {
+			dev_err(dev, "invalid request to devnum 0\n");
+			ret = -EINVAL;
+			goto no_need_xmit;
+		}
+
+		switch (ctrlreq->bRequest) {
+		case USB_REQ_SET_ADDRESS:
+			/* set_address may come when a device is reset */
+			dev_info(dev, "SetAddress Request (%d) to port %d\n",
+				 ctrlreq->wValue, vdev->rhport);
+
+			if (vdev->udev)
+				usb_put_dev(vdev->udev);
+			vdev->udev = usb_get_dev(urb->dev);
+
+			spin_lock(&vdev->ud.lock);
+			vdev->ud.status = VDEV_ST_USED;
+			spin_unlock(&vdev->ud.lock);
+
+			if (urb->status == -EINPROGRESS) {
+				/* This request is successfully completed. */
+				/* If not -EINPROGRESS, possibly unlinked. */
+				urb->status = 0;
+			}
+
+			goto no_need_xmit;
+
+		case USB_REQ_GET_DESCRIPTOR:
+			if (ctrlreq->wValue == cpu_to_le16(USB_DT_DEVICE << 8))
+				usbip_dbg_vhci_hc("Not yet?: "
+						  "Get_Descriptor to device 0 "
+						  "(get max pipe size)\n");
+
+			if (vdev->udev)
+				usb_put_dev(vdev->udev);
+			vdev->udev = usb_get_dev(urb->dev);
+			goto out;
+
+		default:
+			/* NOT REACHED */
+			dev_err(dev, "invalid request to devnum 0 bRequest %u, "
+				"wValue %u\n", ctrlreq->bRequest,
+				ctrlreq->wValue);
+			ret =  -EINVAL;
+			goto no_need_xmit;
+		}
+
+	}
+
+out:
+	vhci_tx_urb(urb);
+	spin_unlock(&the_controller->lock);
+
+	return 0;
+
+no_need_xmit:
+	usb_hcd_unlink_urb_from_ep(hcd, urb);
+no_need_unlink:
+	spin_unlock(&the_controller->lock);
+	usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb, urb->status);
+	return ret;
+}
+
+/*
+ * vhci_rx gives back the urb after receiving the reply of the urb.  If an
+ * unlink pdu is sent or not, vhci_rx receives a normal return pdu and gives
+ * back its urb. For the driver unlinking the urb, the content of the urb is
+ * not important, but the calling to its completion handler is important; the
+ * completion of unlinking is notified by the completion handler.
+ *
+ *
+ * CLIENT SIDE
+ *
+ * - When vhci_hcd receives RET_SUBMIT,
+ *
+ *	- case 1a). the urb of the pdu is not unlinking.
+ *		- normal case
+ *		=> just give back the urb
+ *
+ *	- case 1b). the urb of the pdu is unlinking.
+ *		- usbip.ko will return a reply of the unlinking request.
+ *		=> give back the urb now and go to case 2b).
+ *
+ * - When vhci_hcd receives RET_UNLINK,
+ *
+ *	- case 2a). a submit request is still pending in vhci_hcd.
+ *		- urb was really pending in usbip.ko and urb_unlink_urb() was
+ *		  completed there.
+ *		=> free a pending submit request
+ *		=> notify unlink completeness by giving back the urb
+ *
+ *	- case 2b). a submit request is *not* pending in vhci_hcd.
+ *		- urb was already given back to the core driver.
+ *		=> do not give back the urb
+ *
+ *
+ * SERVER SIDE
+ *
+ * - When usbip receives CMD_UNLINK,
+ *
+ *	- case 3a). the urb of the unlink request is now in submission.
+ *		=> do usb_unlink_urb().
+ *		=> after the unlink is completed, send RET_UNLINK.
+ *
+ *	- case 3b). the urb of the unlink request is not in submission.
+ *		- may be already completed or never be received
+ *		=> send RET_UNLINK
+ *
+ */
+static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
+{
+	struct vhci_priv *priv;
+	struct vhci_device *vdev;
+
+	pr_info("dequeue a urb %p\n", urb);
+
+	spin_lock(&the_controller->lock);
+
+	priv = urb->hcpriv;
+	if (!priv) {
+		/* URB was never linked! or will be soon given back by
+		 * vhci_rx. */
+		spin_unlock(&the_controller->lock);
+		return 0;
+	}
+
+	{
+		int ret = 0;
+		ret = usb_hcd_check_unlink_urb(hcd, urb, status);
+		if (ret) {
+			spin_unlock(&the_controller->lock);
+			return ret;
+		}
+	}
+
+	 /* send unlink request here? */
+	vdev = priv->vdev;
+
+	if (!vdev->ud.tcp_socket) {
+		/* tcp connection is closed */
+		spin_lock(&vdev->priv_lock);
+
+		pr_info("device %p seems to be disconnected\n", vdev);
+		list_del(&priv->list);
+		kfree(priv);
+		urb->hcpriv = NULL;
+
+		spin_unlock(&vdev->priv_lock);
+
+		/*
+		 * If tcp connection is alive, we have sent CMD_UNLINK.
+		 * vhci_rx will receive RET_UNLINK and give back the URB.
+		 * Otherwise, we give back it here.
+		 */
+		pr_info("gives back urb %p\n", urb);
+
+		usb_hcd_unlink_urb_from_ep(hcd, urb);
+
+		spin_unlock(&the_controller->lock);
+		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb,
+				     urb->status);
+		spin_lock(&the_controller->lock);
+
+	} else {
+		/* tcp connection is alive */
+		struct vhci_unlink *unlink;
+
+		spin_lock(&vdev->priv_lock);
+
+		/* setup CMD_UNLINK pdu */
+		unlink = kzalloc(sizeof(struct vhci_unlink), GFP_ATOMIC);
+		if (!unlink) {
+			spin_unlock(&vdev->priv_lock);
+			spin_unlock(&the_controller->lock);
+			usbip_event_add(&vdev->ud, VDEV_EVENT_ERROR_MALLOC);
+			return -ENOMEM;
+		}
+
+		unlink->seqnum = atomic_inc_return(&the_controller->seqnum);
+		if (unlink->seqnum == 0xffff)
+			pr_info("seqnum max\n");
+
+		unlink->unlink_seqnum = priv->seqnum;
+
+		pr_info("device %p seems to be still connected\n", vdev);
+
+		/* send cmd_unlink and try to cancel the pending URB in the
+		 * peer */
+		list_add_tail(&unlink->list, &vdev->unlink_tx);
+		wake_up(&vdev->waitq_tx);
+
+		spin_unlock(&vdev->priv_lock);
+	}
+
+	spin_unlock(&the_controller->lock);
+
+	usbip_dbg_vhci_hc("leave\n");
+	return 0;
+}
+
+static void vhci_device_unlink_cleanup(struct vhci_device *vdev)
+{
+	struct vhci_unlink *unlink, *tmp;
+
+	spin_lock(&the_controller->lock);
+	spin_lock(&vdev->priv_lock);
+
+	list_for_each_entry_safe(unlink, tmp, &vdev->unlink_tx, list) {
+		pr_info("unlink cleanup tx %lu\n", unlink->unlink_seqnum);
+		list_del(&unlink->list);
+		kfree(unlink);
+	}
+
+	while (!list_empty(&vdev->unlink_rx)) {
+		struct urb *urb;
+
+		unlink = list_first_entry(&vdev->unlink_rx, struct vhci_unlink,
+			list);
+
+		/* give back URB of unanswered unlink request */
+		pr_info("unlink cleanup rx %lu\n", unlink->unlink_seqnum);
+
+		urb = pickup_urb_and_free_priv(vdev, unlink->unlink_seqnum);
+		if (!urb) {
+			pr_info("the urb (seqnum %lu) was already given back\n",
+				unlink->unlink_seqnum);
+			list_del(&unlink->list);
+			kfree(unlink);
+			continue;
+		}
+
+		urb->status = -ENODEV;
+
+		usb_hcd_unlink_urb_from_ep(vhci_to_hcd(the_controller), urb);
+
+		list_del(&unlink->list);
+
+		spin_unlock(&vdev->priv_lock);
+		spin_unlock(&the_controller->lock);
+
+		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb,
+				     urb->status);
+
+		spin_lock(&the_controller->lock);
+		spin_lock(&vdev->priv_lock);
+
+		kfree(unlink);
+	}
+
+	spin_unlock(&vdev->priv_lock);
+	spin_unlock(&the_controller->lock);
+}
+
+/*
+ * The important thing is that only one context begins cleanup.
+ * This is why error handling and cleanup become simple.
+ * We do not want to consider race condition as possible.
+ */
+static void vhci_shutdown_connection(struct usbip_device *ud)
+{
+	struct vhci_device *vdev = container_of(ud, struct vhci_device, ud);
+
+	/* need this? see stub_dev.c */
+	if (ud->tcp_socket) {
+		pr_debug("shutdown tcp_socket %p\n", ud->tcp_socket);
+		kernel_sock_shutdown(ud->tcp_socket, SHUT_RDWR);
+	}
+
+	/* kill threads related to this sdev */
+	if (vdev->ud.tcp_rx) {
+		kthread_stop_put(vdev->ud.tcp_rx);
+		vdev->ud.tcp_rx = NULL;
+	}
+	if (vdev->ud.tcp_tx) {
+		kthread_stop_put(vdev->ud.tcp_tx);
+		vdev->ud.tcp_tx = NULL;
+	}
+	pr_info("stop threads\n");
+
+	/* active connection is closed */
+	if (vdev->ud.tcp_socket) {
+		fput(vdev->ud.tcp_socket->file);
+		vdev->ud.tcp_socket = NULL;
+	}
+	pr_info("release socket\n");
+
+	vhci_device_unlink_cleanup(vdev);
+
+	/*
+	 * rh_port_disconnect() is a trigger of ...
+	 *   usb_disable_device():
+	 *	disable all the endpoints for a USB device.
+	 *   usb_disable_endpoint():
+	 *	disable endpoints. pending urbs are unlinked(dequeued).
+	 *
+	 * NOTE: After calling rh_port_disconnect(), the USB device drivers of a
+	 * detached device should release used urbs in a cleanup function (i.e.
+	 * xxx_disconnect()). Therefore, vhci_hcd does not need to release
+	 * pushed urbs and their private data in this function.
+	 *
+	 * NOTE: vhci_dequeue() must be considered carefully. When shutting down
+	 * a connection, vhci_shutdown_connection() expects vhci_dequeue()
+	 * gives back pushed urbs and frees their private data by request of
+	 * the cleanup function of a USB driver. When unlinking a urb with an
+	 * active connection, vhci_dequeue() does not give back the urb which
+	 * is actually given back by vhci_rx after receiving its return pdu.
+	 *
+	 */
+	rh_port_disconnect(vdev->rhport);
+
+	pr_info("disconnect device\n");
+}
+
+
+static void vhci_device_reset(struct usbip_device *ud)
+{
+	struct vhci_device *vdev = container_of(ud, struct vhci_device, ud);
+
+	spin_lock(&ud->lock);
+
+	vdev->speed  = 0;
+	vdev->devid  = 0;
+
+	if (vdev->udev)
+		usb_put_dev(vdev->udev);
+	vdev->udev = NULL;
+
+	if (ud->tcp_socket) {
+		fput(ud->tcp_socket->file);
+		ud->tcp_socket = NULL;
+	}
+	ud->status = VDEV_ST_NULL;
+
+	spin_unlock(&ud->lock);
+}
+
+static void vhci_device_unusable(struct usbip_device *ud)
+{
+	spin_lock(&ud->lock);
+	ud->status = VDEV_ST_ERROR;
+	spin_unlock(&ud->lock);
+}
+
+static void vhci_device_init(struct vhci_device *vdev)
+{
+	memset(vdev, 0, sizeof(*vdev));
+
+	vdev->ud.side   = USBIP_VHCI;
+	vdev->ud.status = VDEV_ST_NULL;
+	spin_lock_init(&vdev->ud.lock);
+
+	INIT_LIST_HEAD(&vdev->priv_rx);
+	INIT_LIST_HEAD(&vdev->priv_tx);
+	INIT_LIST_HEAD(&vdev->unlink_tx);
+	INIT_LIST_HEAD(&vdev->unlink_rx);
+	spin_lock_init(&vdev->priv_lock);
+
+	init_waitqueue_head(&vdev->waitq_tx);
+
+	vdev->ud.eh_ops.shutdown = vhci_shutdown_connection;
+	vdev->ud.eh_ops.reset = vhci_device_reset;
+	vdev->ud.eh_ops.unusable = vhci_device_unusable;
+
+	usbip_start_eh(&vdev->ud);
+}
+
+static int vhci_start(struct usb_hcd *hcd)
+{
+	struct vhci_hcd *vhci = hcd_to_vhci(hcd);
+	int rhport;
+	int err = 0;
+
+	usbip_dbg_vhci_hc("enter vhci_start\n");
+
+	/* initialize private data of usb_hcd */
+
+	for (rhport = 0; rhport < VHCI_NPORTS; rhport++) {
+		struct vhci_device *vdev = &vhci->vdev[rhport];
+		vhci_device_init(vdev);
+		vdev->rhport = rhport;
+	}
+
+	atomic_set(&vhci->seqnum, 0);
+	spin_lock_init(&vhci->lock);
+
+	hcd->power_budget = 0; /* no limit */
+	hcd->uses_new_polling = 1;
+
+	/* vhci_hcd is now ready to be controlled through sysfs */
+	err = sysfs_create_group(&vhci_dev(vhci)->kobj, &dev_attr_group);
+	if (err) {
+		pr_err("create sysfs files\n");
+		return err;
+	}
+
+	return 0;
+}
+
+static void vhci_stop(struct usb_hcd *hcd)
+{
+	struct vhci_hcd *vhci = hcd_to_vhci(hcd);
+	int rhport = 0;
+
+	usbip_dbg_vhci_hc("stop VHCI controller\n");
+
+	/* 1. remove the userland interface of vhci_hcd */
+	sysfs_remove_group(&vhci_dev(vhci)->kobj, &dev_attr_group);
+
+	/* 2. shutdown all the ports of vhci_hcd */
+	for (rhport = 0; rhport < VHCI_NPORTS; rhport++) {
+		struct vhci_device *vdev = &vhci->vdev[rhport];
+
+		usbip_event_add(&vdev->ud, VDEV_EVENT_REMOVED);
+		usbip_stop_eh(&vdev->ud);
+	}
+}
+
+static int vhci_get_frame_number(struct usb_hcd *hcd)
+{
+	pr_err("Not yet implemented\n");
+	return 0;
+}
+
+#ifdef CONFIG_PM
+
+/* FIXME: suspend/resume */
+static int vhci_bus_suspend(struct usb_hcd *hcd)
+{
+	struct vhci_hcd *vhci = hcd_to_vhci(hcd);
+
+	dev_dbg(&hcd->self.root_hub->dev, "%s\n", __func__);
+
+	spin_lock(&vhci->lock);
+	hcd->state = HC_STATE_SUSPENDED;
+	spin_unlock(&vhci->lock);
+
+	return 0;
+}
+
+static int vhci_bus_resume(struct usb_hcd *hcd)
+{
+	struct vhci_hcd *vhci = hcd_to_vhci(hcd);
+	int rc = 0;
+
+	dev_dbg(&hcd->self.root_hub->dev, "%s\n", __func__);
+
+	spin_lock(&vhci->lock);
+	if (!HCD_HW_ACCESSIBLE(hcd))
+		rc = -ESHUTDOWN;
+	else
+		hcd->state = HC_STATE_RUNNING;
+	spin_unlock(&vhci->lock);
+
+	return rc;
+}
+
+#else
+
+#define vhci_bus_suspend      NULL
+#define vhci_bus_resume       NULL
+#endif
+
+static struct hc_driver vhci_hc_driver = {
+	.description	= driver_name,
+	.product_desc	= driver_desc,
+	.hcd_priv_size	= sizeof(struct vhci_hcd),
+
+	.flags		= HCD_USB2,
+
+	.start		= vhci_start,
+	.stop		= vhci_stop,
+
+	.urb_enqueue	= vhci_urb_enqueue,
+	.urb_dequeue	= vhci_urb_dequeue,
+
+	.get_frame_number = vhci_get_frame_number,
+
+	.hub_status_data = vhci_hub_status,
+	.hub_control    = vhci_hub_control,
+	.bus_suspend	= vhci_bus_suspend,
+	.bus_resume	= vhci_bus_resume,
+};
+
+static int vhci_hcd_probe(struct platform_device *pdev)
+{
+	struct usb_hcd		*hcd;
+	int			ret;
+
+	usbip_dbg_vhci_hc("name %s id %d\n", pdev->name, pdev->id);
+
+	/*
+	 * Allocate and initialize hcd.
+	 * Our private data is also allocated automatically.
+	 */
+	hcd = usb_create_hcd(&vhci_hc_driver, &pdev->dev, dev_name(&pdev->dev));
+	if (!hcd) {
+		pr_err("create hcd failed\n");
+		return -ENOMEM;
+	}
+	hcd->has_tt = 1;
+
+	/* this is private data for vhci_hcd */
+	the_controller = hcd_to_vhci(hcd);
+
+	/*
+	 * Finish generic HCD structure initialization and register.
+	 * Call the driver's reset() and start() routines.
+	 */
+	ret = usb_add_hcd(hcd, 0, 0);
+	if (ret != 0) {
+		pr_err("usb_add_hcd failed %d\n", ret);
+		usb_put_hcd(hcd);
+		the_controller = NULL;
+		return ret;
+	}
+
+	usbip_dbg_vhci_hc("bye\n");
+	return 0;
+}
+
+static int vhci_hcd_remove(struct platform_device *pdev)
+{
+	struct usb_hcd	*hcd;
+
+	hcd = platform_get_drvdata(pdev);
+	if (!hcd)
+		return 0;
+
+	/*
+	 * Disconnects the root hub,
+	 * then reverses the effects of usb_add_hcd(),
+	 * invoking the HCD's stop() methods.
+	 */
+	usb_remove_hcd(hcd);
+	usb_put_hcd(hcd);
+	the_controller = NULL;
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+
+/* what should happen for USB/IP under suspend/resume? */
+static int vhci_hcd_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct usb_hcd *hcd;
+	int rhport = 0;
+	int connected = 0;
+	int ret = 0;
+
+	hcd = platform_get_drvdata(pdev);
+
+	spin_lock(&the_controller->lock);
+
+	for (rhport = 0; rhport < VHCI_NPORTS; rhport++)
+		if (the_controller->port_status[rhport] &
+		    USB_PORT_STAT_CONNECTION)
+			connected += 1;
+
+	spin_unlock(&the_controller->lock);
+
+	if (connected > 0) {
+		dev_info(&pdev->dev, "We have %d active connection%s. Do not "
+			 "suspend.\n", connected, (connected == 1 ? "" : "s"));
+		ret =  -EBUSY;
+	} else {
+		dev_info(&pdev->dev, "suspend vhci_hcd");
+		clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
+	}
+
+	return ret;
+}
+
+static int vhci_hcd_resume(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd;
+
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	hcd = platform_get_drvdata(pdev);
+	set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
+	usb_hcd_poll_rh_status(hcd);
+
+	return 0;
+}
+
+#else
+
+#define vhci_hcd_suspend	NULL
+#define vhci_hcd_resume		NULL
+
+#endif
+
+static struct platform_driver vhci_driver = {
+	.probe	= vhci_hcd_probe,
+	.remove	= vhci_hcd_remove,
+	.suspend = vhci_hcd_suspend,
+	.resume	= vhci_hcd_resume,
+	.driver	= {
+		.name = driver_name,
+		.owner = THIS_MODULE,
+	},
+};
+
+/*
+ * The VHCI 'device' is 'virtual'; not a real plug&play hardware.
+ * We need to add this virtual device as a platform device arbitrarily:
+ *	1. platform_device_register()
+ */
+static void the_pdev_release(struct device *dev)
+{
+	return;
+}
+
+static struct platform_device the_pdev = {
+	/* should be the same name as driver_name */
+	.name = driver_name,
+	.id = -1,
+	.dev = {
+		.release = the_pdev_release,
+	},
+};
+
+static int __init vhci_hcd_init(void)
+{
+	int ret;
+
+	if (usb_disabled())
+		return -ENODEV;
+
+	ret = platform_driver_register(&vhci_driver);
+	if (ret)
+		goto err_driver_register;
+
+	ret = platform_device_register(&the_pdev);
+	if (ret)
+		goto err_platform_device_register;
+
+	pr_info(DRIVER_DESC " v" USBIP_VERSION "\n");
+	return ret;
+
+err_platform_device_register:
+	platform_driver_unregister(&vhci_driver);
+err_driver_register:
+	return ret;
+}
+
+static void __exit vhci_hcd_exit(void)
+{
+	platform_device_unregister(&the_pdev);
+	platform_driver_unregister(&vhci_driver);
+}
+
+module_init(vhci_hcd_init);
+module_exit(vhci_hcd_exit);
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
+MODULE_VERSION(USBIP_VERSION);
diff --git a/drivers/usb/usbip/vhci_rx.c b/drivers/usb/usbip/vhci_rx.c
new file mode 100644
index 0000000..d07fcb5
--- /dev/null
+++ b/drivers/usb/usbip/vhci_rx.c
@@ -0,0 +1,270 @@
+/*
+ * Copyright (C) 2003-2008 Takahiro Hirofuchi
+ *
+ * This is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
+ * USA.
+ */
+
+#include <linux/kthread.h>
+#include <linux/slab.h>
+
+#include "usbip_common.h"
+#include "vhci.h"
+
+/* get URB from transmitted urb queue. caller must hold vdev->priv_lock */
+struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev, __u32 seqnum)
+{
+	struct vhci_priv *priv, *tmp;
+	struct urb *urb = NULL;
+	int status;
+
+	list_for_each_entry_safe(priv, tmp, &vdev->priv_rx, list) {
+		if (priv->seqnum != seqnum)
+			continue;
+
+		urb = priv->urb;
+		status = urb->status;
+
+		usbip_dbg_vhci_rx("find urb %p vurb %p seqnum %u\n",
+				urb, priv, seqnum);
+
+		switch (status) {
+		case -ENOENT:
+			/* fall through */
+		case -ECONNRESET:
+			dev_info(&urb->dev->dev,
+				 "urb %p was unlinked %ssynchronuously.\n", urb,
+				 status == -ENOENT ? "" : "a");
+			break;
+		case -EINPROGRESS:
+			/* no info output */
+			break;
+		default:
+			dev_info(&urb->dev->dev,
+				 "urb %p may be in a error, status %d\n", urb,
+				 status);
+		}
+
+		list_del(&priv->list);
+		kfree(priv);
+		urb->hcpriv = NULL;
+
+		break;
+	}
+
+	return urb;
+}
+
+static void vhci_recv_ret_submit(struct vhci_device *vdev,
+				 struct usbip_header *pdu)
+{
+	struct usbip_device *ud = &vdev->ud;
+	struct urb *urb;
+
+	spin_lock(&vdev->priv_lock);
+	urb = pickup_urb_and_free_priv(vdev, pdu->base.seqnum);
+	spin_unlock(&vdev->priv_lock);
+
+	if (!urb) {
+		pr_err("cannot find a urb of seqnum %u\n", pdu->base.seqnum);
+		pr_info("max seqnum %d\n",
+			atomic_read(&the_controller->seqnum));
+		usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
+		return;
+	}
+
+	/* unpack the pdu to a urb */
+	usbip_pack_pdu(pdu, urb, USBIP_RET_SUBMIT, 0);
+
+	/* recv transfer buffer */
+	if (usbip_recv_xbuff(ud, urb) < 0)
+		return;
+
+	/* recv iso_packet_descriptor */
+	if (usbip_recv_iso(ud, urb) < 0)
+		return;
+
+	/* restore the padding in iso packets */
+	usbip_pad_iso(ud, urb);
+
+	if (usbip_dbg_flag_vhci_rx)
+		usbip_dump_urb(urb);
+
+	usbip_dbg_vhci_rx("now giveback urb %p\n", urb);
+
+	spin_lock(&the_controller->lock);
+	usb_hcd_unlink_urb_from_ep(vhci_to_hcd(the_controller), urb);
+	spin_unlock(&the_controller->lock);
+
+	usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb, urb->status);
+
+	usbip_dbg_vhci_rx("Leave\n");
+
+	return;
+}
+
+static struct vhci_unlink *dequeue_pending_unlink(struct vhci_device *vdev,
+						  struct usbip_header *pdu)
+{
+	struct vhci_unlink *unlink, *tmp;
+
+	spin_lock(&vdev->priv_lock);
+
+	list_for_each_entry_safe(unlink, tmp, &vdev->unlink_rx, list) {
+		pr_info("unlink->seqnum %lu\n", unlink->seqnum);
+		if (unlink->seqnum == pdu->base.seqnum) {
+			usbip_dbg_vhci_rx("found pending unlink, %lu\n",
+					  unlink->seqnum);
+			list_del(&unlink->list);
+
+			spin_unlock(&vdev->priv_lock);
+			return unlink;
+		}
+	}
+
+	spin_unlock(&vdev->priv_lock);
+
+	return NULL;
+}
+
+static void vhci_recv_ret_unlink(struct vhci_device *vdev,
+				 struct usbip_header *pdu)
+{
+	struct vhci_unlink *unlink;
+	struct urb *urb;
+
+	usbip_dump_header(pdu);
+
+	unlink = dequeue_pending_unlink(vdev, pdu);
+	if (!unlink) {
+		pr_info("cannot find the pending unlink %u\n",
+			pdu->base.seqnum);
+		return;
+	}
+
+	spin_lock(&vdev->priv_lock);
+	urb = pickup_urb_and_free_priv(vdev, unlink->unlink_seqnum);
+	spin_unlock(&vdev->priv_lock);
+
+	if (!urb) {
+		/*
+		 * I get the result of a unlink request. But, it seems that I
+		 * already received the result of its submit result and gave
+		 * back the URB.
+		 */
+		pr_info("the urb (seqnum %d) was already given back\n",
+			pdu->base.seqnum);
+	} else {
+		usbip_dbg_vhci_rx("now giveback urb %p\n", urb);
+
+		/* If unlink is successful, status is -ECONNRESET */
+		urb->status = pdu->u.ret_unlink.status;
+		pr_info("urb->status %d\n", urb->status);
+
+		spin_lock(&the_controller->lock);
+		usb_hcd_unlink_urb_from_ep(vhci_to_hcd(the_controller), urb);
+		spin_unlock(&the_controller->lock);
+
+		usb_hcd_giveback_urb(vhci_to_hcd(the_controller), urb,
+				     urb->status);
+	}
+
+	kfree(unlink);
+}
+
+static int vhci_priv_tx_empty(struct vhci_device *vdev)
+{
+	int empty = 0;
+
+	spin_lock(&vdev->priv_lock);
+	empty = list_empty(&vdev->priv_rx);
+	spin_unlock(&vdev->priv_lock);
+
+	return empty;
+}
+
+/* recv a pdu */
+static void vhci_rx_pdu(struct usbip_device *ud)
+{
+	int ret;
+	struct usbip_header pdu;
+	struct vhci_device *vdev = container_of(ud, struct vhci_device, ud);
+
+	usbip_dbg_vhci_rx("Enter\n");
+
+	memset(&pdu, 0, sizeof(pdu));
+
+	/* receive a pdu header */
+	ret = usbip_recv(ud->tcp_socket, &pdu, sizeof(pdu));
+	if (ret < 0) {
+		if (ret == -ECONNRESET)
+			pr_info("connection reset by peer\n");
+		else if (ret == -EAGAIN) {
+			/* ignore if connection was idle */
+			if (vhci_priv_tx_empty(vdev))
+				return;
+			pr_info("connection timed out with pending urbs\n");
+		} else if (ret != -ERESTARTSYS)
+			pr_info("xmit failed %d\n", ret);
+
+		usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
+		return;
+	}
+	if (ret == 0) {
+		pr_info("connection closed");
+		usbip_event_add(ud, VDEV_EVENT_DOWN);
+		return;
+	}
+	if (ret != sizeof(pdu)) {
+		pr_err("received pdu size is %d, should be %d\n", ret,
+		       (unsigned int)sizeof(pdu));
+		usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
+		return;
+	}
+
+	usbip_header_correct_endian(&pdu, 0);
+
+	if (usbip_dbg_flag_vhci_rx)
+		usbip_dump_header(&pdu);
+
+	switch (pdu.base.command) {
+	case USBIP_RET_SUBMIT:
+		vhci_recv_ret_submit(vdev, &pdu);
+		break;
+	case USBIP_RET_UNLINK:
+		vhci_recv_ret_unlink(vdev, &pdu);
+		break;
+	default:
+		/* NOT REACHED */
+		pr_err("unknown pdu %u\n", pdu.base.command);
+		usbip_dump_header(&pdu);
+		usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
+		break;
+	}
+}
+
+int vhci_rx_loop(void *data)
+{
+	struct usbip_device *ud = data;
+
+	while (!kthread_should_stop()) {
+		if (usbip_event_happened(ud))
+			break;
+
+		vhci_rx_pdu(ud);
+	}
+
+	return 0;
+}
diff --git a/drivers/usb/usbip/vhci_sysfs.c b/drivers/usb/usbip/vhci_sysfs.c
new file mode 100644
index 0000000..82dd49f
--- /dev/null
+++ b/drivers/usb/usbip/vhci_sysfs.c
@@ -0,0 +1,252 @@
+/*
+ * Copyright (C) 2003-2008 Takahiro Hirofuchi
+ *
+ * This is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
+ * USA.
+ */
+
+#include <linux/kthread.h>
+#include <linux/file.h>
+#include <linux/net.h>
+
+#include "usbip_common.h"
+#include "vhci.h"
+
+/* TODO: refine locking ?*/
+
+/* Sysfs entry to show port status */
+static ssize_t status_show(struct device *dev, struct device_attribute *attr,
+			   char *out)
+{
+	char *s = out;
+	int i = 0;
+
+	BUG_ON(!the_controller || !out);
+
+	spin_lock(&the_controller->lock);
+
+	/*
+	 * output example:
+	 * prt sta spd dev socket           local_busid
+	 * 000 004 000 000         c5a7bb80 1-2.3
+	 * 001 004 000 000         d8cee980 2-3.4
+	 *
+	 * IP address can be retrieved from a socket pointer address by looking
+	 * up /proc/net/{tcp,tcp6}. Also, a userland program may remember a
+	 * port number and its peer IP address.
+	 */
+	out += sprintf(out, "prt sta spd bus dev socket           "
+		       "local_busid\n");
+
+	for (i = 0; i < VHCI_NPORTS; i++) {
+		struct vhci_device *vdev = port_to_vdev(i);
+
+		spin_lock(&vdev->ud.lock);
+		out += sprintf(out, "%03u %03u ", i, vdev->ud.status);
+
+		if (vdev->ud.status == VDEV_ST_USED) {
+			out += sprintf(out, "%03u %08x ",
+				       vdev->speed, vdev->devid);
+			out += sprintf(out, "%16p ", vdev->ud.tcp_socket);
+			out += sprintf(out, "%s", dev_name(&vdev->udev->dev));
+
+		} else {
+			out += sprintf(out, "000 000 000 0000000000000000 0-0");
+		}
+
+		out += sprintf(out, "\n");
+		spin_unlock(&vdev->ud.lock);
+	}
+
+	spin_unlock(&the_controller->lock);
+
+	return out - s;
+}
+static DEVICE_ATTR_RO(status);
+
+/* Sysfs entry to shutdown a virtual connection */
+static int vhci_port_disconnect(__u32 rhport)
+{
+	struct vhci_device *vdev;
+
+	usbip_dbg_vhci_sysfs("enter\n");
+
+	/* lock */
+	spin_lock(&the_controller->lock);
+
+	vdev = port_to_vdev(rhport);
+
+	spin_lock(&vdev->ud.lock);
+	if (vdev->ud.status == VDEV_ST_NULL) {
+		pr_err("not connected %d\n", vdev->ud.status);
+
+		/* unlock */
+		spin_unlock(&vdev->ud.lock);
+		spin_unlock(&the_controller->lock);
+
+		return -EINVAL;
+	}
+
+	/* unlock */
+	spin_unlock(&vdev->ud.lock);
+	spin_unlock(&the_controller->lock);
+
+	usbip_event_add(&vdev->ud, VDEV_EVENT_DOWN);
+
+	return 0;
+}
+
+static ssize_t store_detach(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	int err;
+	__u32 rhport = 0;
+
+	if (sscanf(buf, "%u", &rhport) != 1)
+		return -EINVAL;
+
+	/* check rhport */
+	if (rhport >= VHCI_NPORTS) {
+		dev_err(dev, "invalid port %u\n", rhport);
+		return -EINVAL;
+	}
+
+	err = vhci_port_disconnect(rhport);
+	if (err < 0)
+		return -EINVAL;
+
+	usbip_dbg_vhci_sysfs("Leave\n");
+
+	return count;
+}
+static DEVICE_ATTR(detach, S_IWUSR, NULL, store_detach);
+
+/* Sysfs entry to establish a virtual connection */
+static int valid_args(__u32 rhport, enum usb_device_speed speed)
+{
+	/* check rhport */
+	if (rhport >= VHCI_NPORTS) {
+		pr_err("port %u\n", rhport);
+		return -EINVAL;
+	}
+
+	/* check speed */
+	switch (speed) {
+	case USB_SPEED_LOW:
+	case USB_SPEED_FULL:
+	case USB_SPEED_HIGH:
+	case USB_SPEED_WIRELESS:
+		break;
+	default:
+		pr_err("Failed attach request for unsupported USB speed: %s\n",
+			usb_speed_string(speed));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * To start a new USB/IP attachment, a userland program needs to setup a TCP
+ * connection and then write its socket descriptor with remote device
+ * information into this sysfs file.
+ *
+ * A remote device is virtually attached to the root-hub port of @rhport with
+ * @speed. @devid is embedded into a request to specify the remote device in a
+ * server host.
+ *
+ * write() returns 0 on success, else negative errno.
+ */
+static ssize_t store_attach(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct vhci_device *vdev;
+	struct socket *socket;
+	int sockfd = 0;
+	__u32 rhport = 0, devid = 0, speed = 0;
+
+	/*
+	 * @rhport: port number of vhci_hcd
+	 * @sockfd: socket descriptor of an established TCP connection
+	 * @devid: unique device identifier in a remote host
+	 * @speed: usb device speed in a remote host
+	 */
+	if (sscanf(buf, "%u %u %u %u", &rhport, &sockfd, &devid, &speed) != 1)
+		return -EINVAL;
+
+	usbip_dbg_vhci_sysfs("rhport(%u) sockfd(%u) devid(%u) speed(%u)\n",
+			     rhport, sockfd, devid, speed);
+
+	/* check received parameters */
+	if (valid_args(rhport, speed) < 0)
+		return -EINVAL;
+
+	/* Extract socket from fd. */
+	/* The correct way to clean this up is to fput(socket->file). */
+	socket = sockfd_to_socket(sockfd);
+	if (!socket)
+		return -EINVAL;
+
+	/* now need lock until setting vdev status as used */
+
+	/* begin a lock */
+	spin_lock(&the_controller->lock);
+	vdev = port_to_vdev(rhport);
+	spin_lock(&vdev->ud.lock);
+
+	if (vdev->ud.status != VDEV_ST_NULL) {
+		/* end of the lock */
+		spin_unlock(&vdev->ud.lock);
+		spin_unlock(&the_controller->lock);
+
+		fput(socket->file);
+
+		dev_err(dev, "port %d already used\n", rhport);
+		return -EINVAL;
+	}
+
+	dev_info(dev,
+		 "rhport(%u) sockfd(%d) devid(%u) speed(%u) speed_str(%s)\n",
+		 rhport, sockfd, devid, speed, usb_speed_string(speed));
+
+	vdev->devid         = devid;
+	vdev->speed         = speed;
+	vdev->ud.tcp_socket = socket;
+	vdev->ud.status     = VDEV_ST_NOTASSIGNED;
+
+	spin_unlock(&vdev->ud.lock);
+	spin_unlock(&the_controller->lock);
+	/* end the lock */
+
+	vdev->ud.tcp_rx = kthread_get_run(vhci_rx_loop, &vdev->ud, "vhci_rx");
+	vdev->ud.tcp_tx = kthread_get_run(vhci_tx_loop, &vdev->ud, "vhci_tx");
+
+	rh_port_connect(rhport, speed);
+
+	return count;
+}
+static DEVICE_ATTR(attach, S_IWUSR, NULL, store_attach);
+
+static struct attribute *dev_attrs[] = {
+	&dev_attr_status.attr,
+	&dev_attr_detach.attr,
+	&dev_attr_attach.attr,
+	&dev_attr_usbip_debug.attr,
+	NULL,
+};
+
+const struct attribute_group dev_attr_group = {
+	.attrs = dev_attrs,
+};
diff --git a/drivers/usb/usbip/vhci_tx.c b/drivers/usb/usbip/vhci_tx.c
new file mode 100644
index 0000000..409fd99
--- /dev/null
+++ b/drivers/usb/usbip/vhci_tx.c
@@ -0,0 +1,224 @@
+/*
+ * Copyright (C) 2003-2008 Takahiro Hirofuchi
+ *
+ * This is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
+ * USA.
+ */
+
+#include <linux/kthread.h>
+#include <linux/slab.h>
+
+#include "usbip_common.h"
+#include "vhci.h"
+
+static void setup_cmd_submit_pdu(struct usbip_header *pdup,  struct urb *urb)
+{
+	struct vhci_priv *priv = ((struct vhci_priv *)urb->hcpriv);
+	struct vhci_device *vdev = priv->vdev;
+
+	usbip_dbg_vhci_tx("URB, local devnum %u, remote devid %u\n",
+			  usb_pipedevice(urb->pipe), vdev->devid);
+
+	pdup->base.command   = USBIP_CMD_SUBMIT;
+	pdup->base.seqnum    = priv->seqnum;
+	pdup->base.devid     = vdev->devid;
+	pdup->base.direction = usb_pipein(urb->pipe) ?
+		USBIP_DIR_IN : USBIP_DIR_OUT;
+	pdup->base.ep	     = usb_pipeendpoint(urb->pipe);
+
+	usbip_pack_pdu(pdup, urb, USBIP_CMD_SUBMIT, 1);
+
+	if (urb->setup_packet)
+		memcpy(pdup->u.cmd_submit.setup, urb->setup_packet, 8);
+}
+
+static struct vhci_priv *dequeue_from_priv_tx(struct vhci_device *vdev)
+{
+	struct vhci_priv *priv, *tmp;
+
+	spin_lock(&vdev->priv_lock);
+
+	list_for_each_entry_safe(priv, tmp, &vdev->priv_tx, list) {
+		list_move_tail(&priv->list, &vdev->priv_rx);
+		spin_unlock(&vdev->priv_lock);
+		return priv;
+	}
+
+	spin_unlock(&vdev->priv_lock);
+
+	return NULL;
+}
+
+static int vhci_send_cmd_submit(struct vhci_device *vdev)
+{
+	struct vhci_priv *priv = NULL;
+
+	struct msghdr msg;
+	struct kvec iov[3];
+	size_t txsize;
+
+	size_t total_size = 0;
+
+	while ((priv = dequeue_from_priv_tx(vdev)) != NULL) {
+		int ret;
+		struct urb *urb = priv->urb;
+		struct usbip_header pdu_header;
+		struct usbip_iso_packet_descriptor *iso_buffer = NULL;
+
+		txsize = 0;
+		memset(&pdu_header, 0, sizeof(pdu_header));
+		memset(&msg, 0, sizeof(msg));
+		memset(&iov, 0, sizeof(iov));
+
+		usbip_dbg_vhci_tx("setup txdata urb %p\n", urb);
+
+		/* 1. setup usbip_header */
+		setup_cmd_submit_pdu(&pdu_header, urb);
+		usbip_header_correct_endian(&pdu_header, 1);
+
+		iov[0].iov_base = &pdu_header;
+		iov[0].iov_len  = sizeof(pdu_header);
+		txsize += sizeof(pdu_header);
+
+		/* 2. setup transfer buffer */
+		if (!usb_pipein(urb->pipe) && urb->transfer_buffer_length > 0) {
+			iov[1].iov_base = urb->transfer_buffer;
+			iov[1].iov_len  = urb->transfer_buffer_length;
+			txsize += urb->transfer_buffer_length;
+		}
+
+		/* 3. setup iso_packet_descriptor */
+		if (usb_pipetype(urb->pipe) == PIPE_ISOCHRONOUS) {
+			ssize_t len = 0;
+
+			iso_buffer = usbip_alloc_iso_desc_pdu(urb, &len);
+			if (!iso_buffer) {
+				usbip_event_add(&vdev->ud,
+						SDEV_EVENT_ERROR_MALLOC);
+				return -1;
+			}
+
+			iov[2].iov_base = iso_buffer;
+			iov[2].iov_len  = len;
+			txsize += len;
+		}
+
+		ret = kernel_sendmsg(vdev->ud.tcp_socket, &msg, iov, 3, txsize);
+		if (ret != txsize) {
+			pr_err("sendmsg failed!, ret=%d for %zd\n", ret,
+			       txsize);
+			kfree(iso_buffer);
+			usbip_event_add(&vdev->ud, VDEV_EVENT_ERROR_TCP);
+			return -1;
+		}
+
+		kfree(iso_buffer);
+		usbip_dbg_vhci_tx("send txdata\n");
+
+		total_size += txsize;
+	}
+
+	return total_size;
+}
+
+static struct vhci_unlink *dequeue_from_unlink_tx(struct vhci_device *vdev)
+{
+	struct vhci_unlink *unlink, *tmp;
+
+	spin_lock(&vdev->priv_lock);
+
+	list_for_each_entry_safe(unlink, tmp, &vdev->unlink_tx, list) {
+		list_move_tail(&unlink->list, &vdev->unlink_rx);
+		spin_unlock(&vdev->priv_lock);
+		return unlink;
+	}
+
+	spin_unlock(&vdev->priv_lock);
+
+	return NULL;
+}
+
+static int vhci_send_cmd_unlink(struct vhci_device *vdev)
+{
+	struct vhci_unlink *unlink = NULL;
+
+	struct msghdr msg;
+	struct kvec iov[3];
+	size_t txsize;
+
+	size_t total_size = 0;
+
+	while ((unlink = dequeue_from_unlink_tx(vdev)) != NULL) {
+		int ret;
+		struct usbip_header pdu_header;
+
+		txsize = 0;
+		memset(&pdu_header, 0, sizeof(pdu_header));
+		memset(&msg, 0, sizeof(msg));
+		memset(&iov, 0, sizeof(iov));
+
+		usbip_dbg_vhci_tx("setup cmd unlink, %lu\n", unlink->seqnum);
+
+		/* 1. setup usbip_header */
+		pdu_header.base.command = USBIP_CMD_UNLINK;
+		pdu_header.base.seqnum  = unlink->seqnum;
+		pdu_header.base.devid	= vdev->devid;
+		pdu_header.base.ep	= 0;
+		pdu_header.u.cmd_unlink.seqnum = unlink->unlink_seqnum;
+
+		usbip_header_correct_endian(&pdu_header, 1);
+
+		iov[0].iov_base = &pdu_header;
+		iov[0].iov_len  = sizeof(pdu_header);
+		txsize += sizeof(pdu_header);
+
+		ret = kernel_sendmsg(vdev->ud.tcp_socket, &msg, iov, 1, txsize);
+		if (ret != txsize) {
+			pr_err("sendmsg failed!, ret=%d for %zd\n", ret,
+			       txsize);
+			usbip_event_add(&vdev->ud, VDEV_EVENT_ERROR_TCP);
+			return -1;
+		}
+
+		usbip_dbg_vhci_tx("send txdata\n");
+
+		total_size += txsize;
+	}
+
+	return total_size;
+}
+
+int vhci_tx_loop(void *data)
+{
+	struct usbip_device *ud = data;
+	struct vhci_device *vdev = container_of(ud, struct vhci_device, ud);
+
+	while (!kthread_should_stop()) {
+		if (vhci_send_cmd_submit(vdev) < 0)
+			break;
+
+		if (vhci_send_cmd_unlink(vdev) < 0)
+			break;
+
+		wait_event_interruptible(vdev->waitq_tx,
+					 (!list_empty(&vdev->priv_tx) ||
+					  !list_empty(&vdev->unlink_tx) ||
+					  kthread_should_stop()));
+
+		usbip_dbg_vhci_tx("pending urbs ?, now wake up\n");
+	}
+
+	return 0;
+}
diff --git a/include/uapi/linux/usbip.h b/include/uapi/linux/usbip.h
new file mode 100644
index 0000000..fa5db30
--- /dev/null
+++ b/include/uapi/linux/usbip.h
@@ -0,0 +1,26 @@
+/*
+ *	usbip.h
+ *
+ *	USBIP uapi defines and function prototypes etc.
+*/
+
+#ifndef _UAPI_LINUX_USBIP_H
+#define _UAPI_LINUX_USBIP_H
+
+/* usbip device status - exported in usbip device sysfs status */
+enum usbip_device_status {
+	/* sdev is available. */
+	SDEV_ST_AVAILABLE = 0x01,
+	/* sdev is now used. */
+	SDEV_ST_USED,
+	/* sdev is unusable because of a fatal error. */
+	SDEV_ST_ERROR,
+
+	/* vdev does not connect a remote device. */
+	VDEV_ST_NULL,
+	/* vdev is used, but the USB address is not assigned yet */
+	VDEV_ST_NOTASSIGNED,
+	VDEV_ST_USED,
+	VDEV_ST_ERROR
+};
+#endif /* _UAPI_LINUX_USBIP_H */
-- 
1.8.1.2

