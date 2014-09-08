Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbaIHSkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 14:40:13 -0400
Received: from scspc499.cs.uwaterloo.ca ([129.97.171.80]:52026 "EHLO
	scspc499.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbaIHSkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 14:40:11 -0400
Date: Mon, 8 Sep 2014 14:39:58 -0400
From: Adrian Nicoara <anicoara@uwaterloo.ca>
To: shigekatsu.tateno@atmel.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, tklauser@distanz.ch
Subject: [PATCH v2 1/4] staging: ozwpan: fix missing blank line after
 declaration
Message-ID: <20140908183958.GA17486@uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup checkpatch.pl warnings.

Signed-off-by: Adrian Nicoara <anicoara@uwaterloo.ca>
---
 drivers/staging/ozwpan/ozcdev.c    | 5 +++++
 drivers/staging/ozwpan/ozeltbuf.c  | 1 +
 drivers/staging/ozwpan/ozpd.c      | 6 ++++++
 drivers/staging/ozwpan/ozproto.c   | 4 ++++
 drivers/staging/ozwpan/ozusbsvc.c  | 2 ++
 drivers/staging/ozwpan/ozusbsvc1.c | 4 ++++
 6 files changed, 22 insertions(+)

diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index c73d396..da0e1fd 100644
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
@@ -320,6 +324,7 @@ static unsigned int oz_cdev_poll(struct file *filp, poll_table *wait)
 	spin_lock_bh(&dev->lock);
 	if (dev->active_pd) {
 		struct oz_serial_ctx *ctx = oz_cdev_claim_ctx(dev->active_pd);
+
 		if (ctx) {
 			if (ctx->rd_in != ctx->rd_out)
 				ret |= POLLIN | POLLRDNORM;
diff --git a/drivers/staging/ozwpan/ozeltbuf.c b/drivers/staging/ozwpan/ozeltbuf.c
index 400cc75..01b25da 100644
--- a/drivers/staging/ozwpan/ozeltbuf.c
+++ b/drivers/staging/ozwpan/ozeltbuf.c
@@ -174,6 +174,7 @@ int oz_queue_elt_info(struct oz_elt_buf *buf, u8 isoc, u8 id,
 			== OZ_USB_ENDPOINT_DATA) &&
 			(body->format == OZ_DATA_F_ISOC_FIXED)) {
 			u8 unit_count = body->frame_number;
+
 			body->frame_number = st->frame_number;
 			st->frame_number += unit_count;
 		}
diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index 7726410..26c1049 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -106,6 +106,7 @@ struct oz_pd *oz_pd_alloc(const u8 *mac_addr)

 	if (pd) {
 		int i;
+
 		atomic_set(&pd->ref_count, 2);
 		for (i = 0; i < OZ_NB_APPS; i++)
 			spin_lock_init(&pd->app_lock[i]);
@@ -153,6 +154,7 @@ static void oz_pd_free(struct work_struct *work)

 	list_for_each_safe(e, n, &pd->tx_queue) {
 		struct oz_tx_frame *f = list_entry(e, struct oz_tx_frame, link);
+
 		if (f->skb != NULL)
 			kfree_skb(f->skb);
 		oz_retire_frame(pd, f);
@@ -249,6 +251,7 @@ void oz_pd_heartbeat(struct oz_pd *pd, u16 apps)
 		hrtimer_cancel(&pd->heartbeat);
 	if (pd->mode & OZ_F_ISOC_ANYTIME) {
 		int count = 8;
+
 		while (count-- && (oz_send_isoc_frame(pd) >= 0))
 			;
 	}
@@ -752,6 +755,7 @@ int oz_send_isoc_unit(struct oz_pd *pd, u8 ep_num, const u8 *data, int len)
 	} else {
 		struct oz_hdr oz;
 		struct oz_isoc_large iso;
+
 		spin_lock_bh(&pd->stream_lock);
 		iso.frame_number = st->frame_num;
 		st->frame_num += nb_units;
@@ -774,8 +778,10 @@ int oz_send_isoc_unit(struct oz_pd *pd, u8 ep_num, const u8 *data, int len)
 		if (!(pd->mode & OZ_F_ISOC_ANYTIME)) {
 			struct oz_tx_frame *isoc_unit = NULL;
 			int nb = pd->nb_queued_isoc_frames;
+
 			if (nb >= pd->isoc_latency) {
 				struct oz_tx_frame *f;
+
 				oz_dbg(TX_FRAMES, "Dropping ISOC Unit nb= %d\n",
 				       nb);
 				spin_lock(&pd->tx_frame_lock);
diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index af3da3e..cae0e6f 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -179,6 +179,7 @@ static struct oz_pd *oz_connect_req(struct oz_pd *cur_pd, struct oz_elt *elt,
 	} else {
 		struct oz_pd *pd2 = NULL;
 		struct list_head *e;
+
 		pd = oz_pd_alloc(pd_addr);
 		if (pd == NULL)
 			return NULL;
@@ -262,6 +263,7 @@ done:
 		u16 start_apps = new_apps & ~pd->total_apps & ~0x1;
 		u16 stop_apps = pd->total_apps & ~new_apps & ~0x1;
 		u16 resume_apps = new_apps & pd->paused_apps  & ~0x1;
+
 		spin_unlock_bh(&g_polling_lock);
 		oz_pd_set_state(pd, OZ_PD_S_CONNECTED);
 		oz_dbg(ON, "new_apps=0x%x total_apps=0x%x paused_apps=0x%x\n",
@@ -383,6 +385,7 @@ static void oz_rx_frame(struct sk_buff *skb)
 		if ((oz_hdr->control & OZ_F_ACK_REQUESTED) &&
 				(pd->state == OZ_PD_S_CONNECTED)) {
 			int backlog = pd->nb_queued_frames;
+
 			pd->trigger_pkt_num = pkt_num;
 			/* Send queued frames */
 			oz_send_queued_frames(pd, backlog);
@@ -781,6 +784,7 @@ int oz_protocol_init(char *devs)
 		oz_binding_add(NULL);
 	} else {
 		char d[32];
+
 		while (*devs) {
 			devs = oz_get_next_device_name(devs, d, sizeof(d));
 			if (d[0])
diff --git a/drivers/staging/ozwpan/ozusbsvc.c b/drivers/staging/ozwpan/ozusbsvc.c
index db4a387..bf15dc3 100644
--- a/drivers/staging/ozwpan/ozusbsvc.c
+++ b/drivers/staging/ozwpan/ozusbsvc.c
@@ -128,6 +128,7 @@ void oz_usb_stop(struct oz_pd *pd, int pause)
 	spin_unlock_bh(&pd->app_lock[OZ_APPID_USB]);
 	if (usb_ctx) {
 		struct timespec ts, now;
+
 		getnstimeofday(&ts);
 		oz_dbg(ON, "USB service stopping...\n");
 		usb_ctx->stopped = 1;
@@ -235,6 +236,7 @@ int oz_usb_stream_delete(void *hpd, u8 ep_num)

 	if (usb_ctx) {
 		struct oz_pd *pd = usb_ctx->pd;
+
 		if (pd) {
 			oz_dbg(ON, "%s: (0x%x)\n", __func__, ep_num);
 			if (pd->mode & OZ_F_ISOC_NO_ELTS) {
diff --git a/drivers/staging/ozwpan/ozusbsvc1.c b/drivers/staging/ozwpan/ozusbsvc1.c
index 12bb236..be7ee01 100644
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
2.0.1

