Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbaDDT7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 15:59:31 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:41813 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbaDDT71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 15:59:27 -0400
From: Roger Zanoni <rogerzanoni@gmail.com>
To: rupesh.gujare@atmel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] staging: ozwpan: Fix checkpatch warnings
Date: Fri,  4 Apr 2014 15:57:45 -0400
Message-Id: <1396641465-14657-1-git-send-email-rogerzanoni@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add blank lines after declarations.

Signed-off-by: Roger Zanoni <rogerzanoni@gmail.com>
---
 drivers/staging/ozwpan/ozcdev.c    |  4 ++++
 drivers/staging/ozwpan/ozeltbuf.c  |  2 ++
 drivers/staging/ozwpan/ozhcd.c     | 10 ++++++++++
 drivers/staging/ozwpan/ozpd.c      |  4 ++++
 drivers/staging/ozwpan/ozproto.c   |  3 +++
 drivers/staging/ozwpan/ozusbsvc.c  |  1 +
 drivers/staging/ozwpan/ozusbsvc1.c |  4 ++++
 7 files changed, 28 insertions(+)

diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index 10c0a96..bfea31f 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -263,6 +263,7 @@ static long oz_cdev_ioctl(struct file *filp, unsigned int cmd,
 	switch (cmd) {
 	case OZ_IOCTL_GET_PD_LIST: {
 			struct oz_pd_list list;
+
 			oz_dbg(ON, "OZ_IOCTL_GET_PD_LIST\n");
 			memset(&list, 0, sizeof(list));
 			list.count = oz_get_pd_list(list.addr, OZ_MAX_PDS);
@@ -273,6 +274,7 @@ static long oz_cdev_ioctl(struct file *filp, unsigned int cmd,
 		break;
 	case OZ_IOCTL_SET_ACTIVE_PD: {
 			u8 addr[ETH_ALEN];
+
 			oz_dbg(ON, "OZ_IOCTL_SET_ACTIVE_PD\n");
 			if (copy_from_user(addr, (void __user *)arg, ETH_ALEN))
 				return -EFAULT;
@@ -281,6 +283,7 @@ static long oz_cdev_ioctl(struct file *filp, unsigned int cmd,
 		break;
 	case OZ_IOCTL_GET_ACTIVE_PD: {
 			u8 addr[ETH_ALEN];
+
 			oz_dbg(ON, "OZ_IOCTL_GET_ACTIVE_PD\n");
 			spin_lock_bh(&g_cdev.lock);
 			ether_addr_copy(addr, g_cdev.active_addr);
@@ -292,6 +295,7 @@ static long oz_cdev_ioctl(struct file *filp, unsigned int cmd,
 	case OZ_IOCTL_ADD_BINDING:
 	case OZ_IOCTL_REMOVE_BINDING: {
 			struct oz_binding_info b;
+
 			if (copy_from_user(&b, (void __user *)arg,
 				sizeof(struct oz_binding_info))) {
 				return -EFAULT;
diff --git a/drivers/staging/ozwpan/ozeltbuf.c b/drivers/staging/ozwpan/ozeltbuf.c
index bd560c6..cd811d1 100644
--- a/drivers/staging/ozwpan/ozeltbuf.c
+++ b/drivers/staging/ozwpan/ozeltbuf.c
@@ -235,6 +235,7 @@ int oz_queue_elt_info(struct oz_elt_buf *buf, u8 isoc, u8 id,
 			== OZ_USB_ENDPOINT_DATA) &&
 			(body->format == OZ_DATA_F_ISOC_FIXED)) {
 			u8 unit_count = body->frame_number;
+
 			body->frame_number = st->frame_number;
 			st->frame_number += unit_count;
 		}
@@ -253,6 +254,7 @@ int oz_queue_elt_info(struct oz_elt_buf *buf, u8 isoc, u8 id,
 			struct oz_elt_info *ei2 =
 				list_first_entry(&st->elt_list,
 					struct oz_elt_info, link);
+
 			list_del_init(&ei2->link);
 			list_del_init(&ei2->link_order);
 			st->buf_count -= ei2->length;
diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index b3d401a..41c45f3 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -294,6 +294,7 @@ static void oz_free_urb_link(struct oz_urb_link *urbl)
 {
 	if (urbl) {
 		unsigned long irq_state;
+
 		spin_lock_irqsave(&g_link_lock, irq_state);
 		if (g_link_pool_size < OZ_MAX_LINK_POOL_SIZE) {
 			urbl->link.next = g_link_pool;
@@ -815,6 +816,7 @@ void oz_hcd_get_desc_cnf(void *hport, u8 req_id, int status, const u8 *desc,
 	if (status == 0) {
 		int copy_len;
 		int required_size = urb->transfer_buffer_length;
+
 		if (required_size > total_size)
 			required_size = total_size;
 		copy_len = required_size-offset;
@@ -826,6 +828,7 @@ void oz_hcd_get_desc_cnf(void *hport, u8 req_id, int status, const u8 *desc,
 			struct usb_ctrlrequest *setup =
 				(struct usb_ctrlrequest *)urb->setup_packet;
 			unsigned wvalue = le16_to_cpu(setup->wValue);
+
 			if (oz_enqueue_ep_urb(port, 0, 0, urb, req_id))
 				err = -ENOMEM;
 			else if (oz_usb_get_desc_req(port->hpd, req_id,
@@ -974,6 +977,7 @@ void oz_hcd_control_cnf(void *hport, u8 req_id, u8 rcode, const u8 *data,
 
 	} else {
 		int copy_len;
+
 		oz_dbg(ON, "VENDOR-CLASS - cnf\n");
 		if (data_len) {
 			if (data_len <= urb->transfer_buffer_length)
@@ -1047,6 +1051,7 @@ void oz_hcd_data_ind(void *hport, u8 endpoint, const u8 *data, int data_len)
 					struct oz_urb_link, link);
 			struct urb *urb;
 			int copy_len;
+
 			list_del_init(&urbl->link);
 			spin_unlock_bh(&ozhcd->hcd_lock);
 			urb = urbl->urb;
@@ -1160,6 +1165,7 @@ int oz_hcd_heartbeat(void *hport)
 			int len = 0;
 			int copy_len;
 			int i;
+
 			if (ep->credit  < urb->number_of_packets)
 				break;
 			if (ep->buffered_units < urb->number_of_packets)
@@ -1557,6 +1563,7 @@ static void oz_process_ep0_urb(struct oz_hcd *ozhcd, struct urb *urb,
 	}
 	if (!rc && !complete) {
 		int data_len = 0;
+
 		if ((setup->bRequestType & USB_DIR_IN) == 0)
 			data_len = wlength;
 		urb->actual_length = data_len;
@@ -1645,6 +1652,7 @@ static void oz_urb_process_tasklet(unsigned long unused)
 		struct oz_urb_link *urbl =
 			list_first_entry(&ozhcd->urb_pending_list,
 				struct oz_urb_link, link);
+
 		list_del_init(&urbl->link);
 		spin_unlock_irqrestore(&g_tasklet_lock, irq_state);
 		urb = urbl->urb;
@@ -1742,6 +1750,7 @@ static void oz_urb_cancel_tasklet(unsigned long unused)
 		struct oz_urb_link *urbl =
 			list_first_entry(&ozhcd->urb_cancel_list,
 				struct oz_urb_link, link);
+
 		list_del_init(&urbl->link);
 		spin_unlock_irqrestore(&g_tasklet_lock, irq_state);
 		urb = urbl->urb;
@@ -1761,6 +1770,7 @@ static void oz_hcd_clear_orphanage(struct oz_hcd *ozhcd, int status)
 {
 	if (ozhcd) {
 		struct oz_urb_link *urbl;
+
 		while (!list_empty(&ozhcd->orphanage)) {
 			urbl = list_first_entry(&ozhcd->orphanage,
 				struct oz_urb_link, link);
diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index 10f1b3a..69771b4 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -168,6 +168,7 @@ struct oz_pd *oz_pd_alloc(const u8 *mac_addr)
 
 	if (pd) {
 		int i;
+
 		atomic_set(&pd->ref_count, 2);
 		for (i = 0; i < OZ_APPID_MAX; i++)
 			spin_lock_init(&pd->app_lock[i]);
@@ -336,6 +337,7 @@ void oz_pd_heartbeat(struct oz_pd *pd, u16 apps)
 		hrtimer_cancel(&pd->heartbeat);
 	if (pd->mode & OZ_F_ISOC_ANYTIME) {
 		int count = 8;
+
 		while (count-- && (oz_send_isoc_frame(pd) >= 0))
 			;
 	}
@@ -884,6 +886,7 @@ int oz_send_isoc_unit(struct oz_pd *pd, u8 ep_num, const u8 *data, int len)
 	} else {
 		struct oz_hdr oz;
 		struct oz_isoc_large iso;
+
 		spin_lock_bh(&pd->stream_lock);
 		iso.frame_number = st->frame_num;
 		st->frame_num += nb_units;
@@ -906,6 +909,7 @@ int oz_send_isoc_unit(struct oz_pd *pd, u8 ep_num, const u8 *data, int len)
 		if (!(pd->mode & OZ_F_ISOC_ANYTIME)) {
 			struct oz_tx_frame *isoc_unit = NULL;
 			int nb = pd->nb_queued_isoc_frames;
+
 			if (nb >= pd->isoc_latency) {
 				struct list_head *e;
 				struct oz_tx_frame *f;
diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index f09acd0..c614d70 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -260,6 +260,7 @@ done:
 		u16 start_apps = new_apps & ~pd->total_apps & ~0x1;
 		u16 stop_apps = pd->total_apps & ~new_apps & ~0x1;
 		u16 resume_apps = new_apps & pd->paused_apps  & ~0x1;
+
 		spin_unlock_bh(&g_polling_lock);
 		oz_pd_set_state(pd, OZ_PD_S_CONNECTED);
 		oz_dbg(ON, "new_apps=0x%x total_apps=0x%x paused_apps=0x%x\n",
@@ -381,6 +382,7 @@ static void oz_rx_frame(struct sk_buff *skb)
 		if ((oz_hdr->control & OZ_F_ACK_REQUESTED) &&
 				(pd->state == OZ_PD_S_CONNECTED)) {
 			int backlog = pd->nb_queued_frames;
+
 			pd->trigger_pkt_num = pkt_num;
 			/* Send queued frames */
 			oz_send_queued_frames(pd, backlog);
@@ -769,6 +771,7 @@ int oz_protocol_init(char *devs)
 		oz_binding_add(NULL);
 	} else {
 		char d[32];
+
 		while (*devs) {
 			devs = oz_get_next_device_name(devs, d, sizeof(d));
 			if (d[0])
diff --git a/drivers/staging/ozwpan/ozusbsvc.c b/drivers/staging/ozwpan/ozusbsvc.c
index edd44c4..3915e80 100644
--- a/drivers/staging/ozwpan/ozusbsvc.c
+++ b/drivers/staging/ozwpan/ozusbsvc.c
@@ -128,6 +128,7 @@ void oz_usb_stop(struct oz_pd *pd, int pause)
 	spin_unlock_bh(&pd->app_lock[OZ_APPID_USB-1]);
 	if (usb_ctx) {
 		struct timespec ts, now;
+
 		getnstimeofday(&ts);
 		oz_dbg(ON, "USB service stopping...\n");
 		usb_ctx->stopped = 1;
diff --git a/drivers/staging/ozwpan/ozusbsvc1.c b/drivers/staging/ozwpan/ozusbsvc1.c
index f32d014..20f8af5 100644
--- a/drivers/staging/ozwpan/ozusbsvc1.c
+++ b/drivers/staging/ozwpan/ozusbsvc1.c
@@ -213,6 +213,7 @@ int oz_usb_control_req(void *hpd, u8 req_id, struct usb_ctrlrequest *setup,
 		case USB_REQ_SET_INTERFACE: {
 				u8 if_num = (u8)windex;
 				u8 alt = (u8)wvalue;
+
 				rc = oz_usb_set_interface_req(hpd, req_id,
 					if_num, alt);
 			}
@@ -254,6 +255,7 @@ int oz_usb_send_isoc(void *hpd, u8 ep_num, struct urb *urb)
 	if (pd->mode & OZ_F_ISOC_NO_ELTS) {
 		for (i = 0; i < urb->number_of_packets; i++) {
 			u8 *data;
+
 			desc = &urb->iso_frame_desc[i];
 			data = ((u8 *)urb->transfer_buffer)+desc->offset;
 			oz_send_isoc_unit(pd, ep_num, data, desc->length);
@@ -271,6 +273,7 @@ int oz_usb_send_isoc(void *hpd, u8 ep_num, struct urb *urb)
 		int unit_count;
 		int unit_size;
 		int rem;
+
 		if (ei == NULL)
 			return -1;
 		rem = MAX_ISOC_FIXED_DATA;
@@ -340,6 +343,7 @@ static void oz_usb_handle_ep_data(struct oz_usb_ctx *usb_ctx,
 			u8 *data = body->data;
 			int count;
 			int i;
+
 			if (!unit_size)
 				break;
 			count = data_len/unit_size;
-- 
1.9.1

