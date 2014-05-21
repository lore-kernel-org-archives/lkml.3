Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaEUSvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 14:51:13 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:46540 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbaEUSvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 14:51:12 -0400
From: James A Shackleford <shack@linux.com>
To: rupesh.gujare@atmel.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH] staging: ozwpan: Add missing blanklines after declarations
Date: Wed, 21 May 2014 14:50:26 -0400
Message-Id: <1400698226-2267-1-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: James A Shackleford <shack@linux.com>
---
(For Eudyptula Challenge)

---
 drivers/staging/ozwpan/ozhcd.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index b3d401a..91bb29e 100644
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
@@ -424,6 +425,7 @@ static void oz_ep_free(struct oz_port *port, struct oz_endpoint *ep)
 	if (port) {
 		struct list_head list;
 		struct oz_hcd *ozhcd = port->ozhcd;
+
 		INIT_LIST_HEAD(&list);
 		if (ep->flags & OZ_F_EP_HAVE_STREAM)
 			oz_usb_stream_delete(port->hpd, ep->ep_num);
@@ -568,6 +570,7 @@ static int oz_dequeue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
 		ep = port->out_ep[ep_addr];
 	if (ep) {
 		struct list_head *e;
+
 		list_for_each(e, &ep->urb_list) {
 			urbl = container_of(e, struct oz_urb_link, link);
 			if (urbl->urb == urb) {
@@ -599,6 +602,7 @@ static struct urb *oz_find_urb_by_id(struct oz_port *port, int ep_ix,
 	ep = port->out_ep[ep_ix];
 	if (ep) {
 		struct list_head *e;
+
 		list_for_each(e, &ep->urb_list) {
 			urbl = container_of(e, struct oz_urb_link, link);
 			if (urbl->req_id == req_id) {
@@ -815,6 +819,7 @@ void oz_hcd_get_desc_cnf(void *hport, u8 req_id, int status, const u8 *desc,
 	if (status == 0) {
 		int copy_len;
 		int required_size = urb->transfer_buffer_length;
+
 		if (required_size > total_size)
 			required_size = total_size;
 		copy_len = required_size-offset;
@@ -826,6 +831,7 @@ void oz_hcd_get_desc_cnf(void *hport, u8 req_id, int status, const u8 *desc,
 			struct usb_ctrlrequest *setup =
 				(struct usb_ctrlrequest *)urb->setup_packet;
 			unsigned wvalue = le16_to_cpu(setup->wValue);
+
 			if (oz_enqueue_ep_urb(port, 0, 0, urb, req_id))
 				err = -ENOMEM;
 			else if (oz_usb_get_desc_req(port->hpd, req_id,
@@ -919,6 +925,7 @@ static void oz_hcd_complete_set_interface(struct oz_port *port, struct urb *urb,
 	if ((rcode == 0) && (port->config_num > 0)) {
 		struct usb_host_config *config;
 		struct usb_host_interface *intf;
+
 		oz_dbg(ON, "Set interface %d alt %d\n", if_num, alt);
 		oz_clean_endpoints_for_interface(hcd, port, if_num);
 		config = &urb->dev->config[port->config_num-1];
@@ -974,6 +981,7 @@ void oz_hcd_control_cnf(void *hport, u8 req_id, u8 rcode, const u8 *data,
 
 	} else {
 		int copy_len;
+
 		oz_dbg(ON, "VENDOR-CLASS - cnf\n");
 		if (data_len) {
 			if (data_len <= urb->transfer_buffer_length)
@@ -1047,6 +1055,7 @@ void oz_hcd_data_ind(void *hport, u8 endpoint, const u8 *data, int data_len)
 					struct oz_urb_link, link);
 			struct urb *urb;
 			int copy_len;
+
 			list_del_init(&urbl->link);
 			spin_unlock_bh(&ozhcd->hcd_lock);
 			urb = urbl->urb;
@@ -1140,6 +1149,7 @@ int oz_hcd_heartbeat(void *hport)
 	spin_lock_bh(&ozhcd->hcd_lock);
 	list_for_each(e, &port->isoc_in_ep) {
 		struct oz_endpoint *ep = ep_from_link(e);
+
 		if (ep->flags & OZ_F_EP_BUFFERING) {
 			if (ep->buffered_units >= OZ_IN_BUFFERING_UNITS) {
 				ep->flags &= ~OZ_F_EP_BUFFERING;
@@ -1160,6 +1170,7 @@ int oz_hcd_heartbeat(void *hport)
 			int len = 0;
 			int copy_len;
 			int i;
+
 			if (ep->credit  < urb->number_of_packets)
 				break;
 			if (ep->buffered_units < urb->number_of_packets)
@@ -1215,6 +1226,7 @@ int oz_hcd_heartbeat(void *hport)
 	if (ep) {
 		struct list_head *e;
 		struct list_head *n;
+
 		spin_lock_bh(&ozhcd->hcd_lock);
 		list_for_each_safe(e, n, &ep->urb_list) {
 			urbl = container_of(e, struct oz_urb_link, link);
@@ -1557,6 +1569,7 @@ static void oz_process_ep0_urb(struct oz_hcd *ozhcd, struct urb *urb,
 	}
 	if (!rc && !complete) {
 		int data_len = 0;
+
 		if ((setup->bRequestType & USB_DIR_IN) == 0)
 			data_len = wlength;
 		urb->actual_length = data_len;
@@ -1761,6 +1774,7 @@ static void oz_hcd_clear_orphanage(struct oz_hcd *ozhcd, int status)
 {
 	if (ozhcd) {
 		struct oz_urb_link *urbl;
+
 		while (!list_empty(&ozhcd->orphanage)) {
 			urbl = list_first_entry(&ozhcd->orphanage,
 				struct oz_urb_link, link);
@@ -2258,6 +2272,7 @@ static int oz_plat_probe(struct platform_device *dev)
 	spin_lock_init(&ozhcd->hcd_lock);
 	for (i = 0; i < OZ_NB_PORTS; i++) {
 		struct oz_port *port = &ozhcd->ports[i];
+
 		port->ozhcd = ozhcd;
 		port->flags = 0;
 		port->status = 0;
-- 
1.7.9.5

