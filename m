Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbaENRUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:20:34 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39210 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbaENRUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:20:33 -0400
Date: Wed, 14 May 2014 19:20:27 +0200
From: Pawel Lebioda <pawel.lebioda89@gmail.com>
To: dan.carpenter@oracle.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: usbip: missing a blank lines after declarations
Message-ID: <20140514172023.GA2663@ThinkPad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix "Missing a blank line after declaration" style problems
for all files in drivers/staging/usbip.

Signed-off-by: Pawel Lebioda <pawel.lebioda89@gmail.com>
---
 drivers/staging/usbip/stub_dev.c                      | 1 +
 drivers/staging/usbip/stub_tx.c                       | 1 +
 drivers/staging/usbip/usbip_common.h                  | 2 ++
 drivers/staging/usbip/userspace/libsrc/usbip_common.c | 2 +-
 drivers/staging/usbip/userspace/src/usbip_attach.c    | 1 +
 drivers/staging/usbip/userspace/src/usbipd.c          | 6 +++++-
 drivers/staging/usbip/vhci_hcd.c                      | 2 ++
 7 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index de692d7..51d0c71 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -99,6 +99,7 @@ static ssize_t store_sockfd(struct device *dev, struct device_attribute *attr,
 
 	if (sockfd != -1) {
 		int err;
+
 		dev_info(dev, "stub up\n");
 
 		spin_lock_irq(&sdev->ud.lock);
diff --git a/drivers/staging/usbip/stub_tx.c b/drivers/staging/usbip/stub_tx.c
index 1622563..38fe551 100644
--- a/drivers/staging/usbip/stub_tx.c
+++ b/drivers/staging/usbip/stub_tx.c
@@ -218,6 +218,7 @@ static int stub_send_ret_submit(struct stub_device *sdev)
 			 */
 
 			int i;
+
 			for (i = 0; i < urb->number_of_packets; i++) {
 				iov[iovnum].iov_base = urb->transfer_buffer +
 					urb->iso_frame_desc[i].offset;
diff --git a/drivers/staging/usbip/usbip_common.h b/drivers/staging/usbip/usbip_common.h
index f555d83..4da3866 100644
--- a/drivers/staging/usbip/usbip_common.h
+++ b/drivers/staging/usbip/usbip_common.h
@@ -321,12 +321,14 @@ int usbip_event_happened(struct usbip_device *ud);
 static inline int interface_to_busnum(struct usb_interface *interface)
 {
 	struct usb_device *udev = interface_to_usbdev(interface);
+
 	return udev->bus->busnum;
 }
 
 static inline int interface_to_devnum(struct usb_interface *interface)
 {
 	struct usb_device *udev = interface_to_usbdev(interface);
+
 	return udev->devnum;
 }
 
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.c b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
index 238bf5b..05a7443 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.c
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
@@ -75,6 +75,7 @@ const char *usbip_speed_string(int num)
 void dump_usb_interface(struct usbip_usb_interface *uinf)
 {
 	char buff[100];
+
 	usbip_names_get_class(buff, sizeof(buff),
 			uinf->bInterfaceClass,
 			uinf->bInterfaceSubClass,
@@ -86,7 +87,6 @@ void dump_usb_device(struct usbip_usb_device *udev)
 {
 	char buff[100];
 
-
 	dbg("%-20s = %s", "path",  udev->path);
 	dbg("%-20s = %s", "busid", udev->busid);
 
diff --git a/drivers/staging/usbip/userspace/src/usbip_attach.c b/drivers/staging/usbip/userspace/src/usbip_attach.c
index 716a79e..d58a14d 100644
--- a/drivers/staging/usbip/userspace/src/usbip_attach.c
+++ b/drivers/staging/usbip/userspace/src/usbip_attach.c
@@ -56,6 +56,7 @@ static int record_connection(char *host, char *port, char *busid, int rhport)
 		/* if VHCI_STATE_PATH exists, then it better be a directory */
 		if (errno == EEXIST) {
 			struct stat s;
+
 			ret = stat(VHCI_STATE_PATH, &s);
 			if (ret < 0)
 				return -1;
diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
index 2cae4ce..b32047a 100644
--- a/drivers/staging/usbip/userspace/src/usbipd.c
+++ b/drivers/staging/usbip/userspace/src/usbipd.c
@@ -372,6 +372,7 @@ static int listen_all_addrinfo(struct addrinfo *ai_head, int sockfdlist[],
 
 	for (ai = ai_head; ai && nsockfd < maxsockfd; ai = ai->ai_next) {
 		int sock;
+
 		addrinfo_to_text(ai, ai_buf, ai_buf_size);
 		dbg("opening %s", ai_buf);
 		sock = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
@@ -461,7 +462,9 @@ static void write_pid_file()
 {
 	if (pid_file) {
 		dbg("creating pid file %s", pid_file);
-		FILE *fp = fopen(pid_file, "w");
+		FILE *fp;
+
+		fp = fopen(pid_file, "w");
 		if (!fp) {
 			err("pid_file: %s: %d (%s)",
 			    pid_file, errno, strerror(errno));
@@ -602,6 +605,7 @@ int main(int argc, char *argv[])
 	int daemonize = 0;
 	int ipv4 = 0, ipv6 = 0;
 	int opt, rc = -1;
+
 	pid_file = NULL;
 
 	usbip_use_stderr = 1;
diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 70e1755..0007d30 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -635,6 +635,7 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 
 	{
 		int ret = 0;
+
 		ret = usb_hcd_check_unlink_urb(hcd, urb, status);
 		if (ret) {
 			spin_unlock(&the_controller->lock);
@@ -885,6 +886,7 @@ static int vhci_start(struct usb_hcd *hcd)
 
 	for (rhport = 0; rhport < VHCI_NPORTS; rhport++) {
 		struct vhci_device *vdev = &vhci->vdev[rhport];
+
 		vhci_device_init(vdev);
 		vdev->rhport = rhport;
 	}
-- 
1.8.3.2
