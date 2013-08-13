Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907Ab3HMRY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:24:59 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:24686 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab3HMRY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:24:56 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <dan.carpenter@oracle.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH 01/10] staging: ozwpan: Add a blank line between declaraction and code.
Date: Tue, 13 Aug 2013 18:24:21 +0100
Message-ID: <1376414670-23257-2-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376414670-23257-1-git-send-email-rupesh.gujare@atmel.com>
References: <1376414670-23257-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds blank line between declaration &
code for readability.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozcdev.c        |    6 ++++++
 drivers/staging/ozwpan/ozeltbuf.c      |    7 +++++++
 drivers/staging/ozwpan/ozhcd.c         |   28 ++++++++++++++++++++++++++++
 drivers/staging/ozwpan/ozpd.c          |   22 ++++++++++++++++++++++
 drivers/staging/ozwpan/ozproto.c       |    7 +++++++
 drivers/staging/ozwpan/ozurbparanoia.c |    2 ++
 drivers/staging/ozwpan/ozusbsvc.c      |    8 ++++++++
 drivers/staging/ozwpan/ozusbsvc1.c     |    9 +++++++++
 8 files changed, 89 insertions(+)

diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index 73b582c..0c79fd0 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -49,6 +49,7 @@ static struct class *g_oz_class;
 static struct oz_serial_ctx *oz_cdev_claim_ctx(struct oz_pd *pd)
 {
 	struct oz_serial_ctx *ctx;
+
 	spin_lock_bh(&pd->app_lock[OZ_APPID_SERIAL-1]);
 	ctx = (struct oz_serial_ctx *)pd->app_ctx[OZ_APPID_SERIAL-1];
 	if (ctx)
@@ -202,6 +203,7 @@ static int oz_set_active_pd(const u8 *addr)
 	int rc = 0;
 	struct oz_pd *pd;
 	struct oz_pd *old_pd;
+
 	pd = oz_pd_find(addr);
 	if (pd) {
 		spin_lock_bh(&g_cdev.lock);
@@ -234,6 +236,7 @@ static long oz_cdev_ioctl(struct file *filp, unsigned int cmd,
 			  unsigned long arg)
 {
 	int rc = 0;
+
 	if (_IOC_TYPE(cmd) != OZ_IOCTL_MAGIC)
 		return -ENOTTY;
 	if (_IOC_NR(cmd) > OZ_IOCTL_MAX)
@@ -300,6 +303,7 @@ static unsigned int oz_cdev_poll(struct file *filp, poll_table *wait)
 {
 	unsigned int ret = 0;
 	struct oz_cdev *dev = filp->private_data;
+
 	oz_dbg(ON, "Poll called wait = %p\n", wait);
 	spin_lock_bh(&dev->lock);
 	if (dev->active_pd) {
@@ -405,6 +409,7 @@ int oz_cdev_start(struct oz_pd *pd, int resume)
 {
 	struct oz_serial_ctx *ctx;
 	struct oz_serial_ctx *old_ctx;
+
 	if (resume) {
 		oz_dbg(ON, "Serial service resumed\n");
 		return 0;
@@ -440,6 +445,7 @@ int oz_cdev_start(struct oz_pd *pd, int resume)
 void oz_cdev_stop(struct oz_pd *pd, int pause)
 {
 	struct oz_serial_ctx *ctx;
+
 	if (pause) {
 		oz_dbg(ON, "Serial service paused\n");
 		return;
diff --git a/drivers/staging/ozwpan/ozeltbuf.c b/drivers/staging/ozwpan/ozeltbuf.c
index 5e98aeb..0b8b468 100644
--- a/drivers/staging/ozwpan/ozeltbuf.c
+++ b/drivers/staging/ozwpan/ozeltbuf.c
@@ -35,6 +35,7 @@ void oz_elt_buf_term(struct oz_elt_buf *buf)
 {
 	struct list_head *e;
 	int i;
+
 	/* Free any elements in the order or isoc lists. */
 	for (i = 0; i < 2; i++) {
 		struct list_head *list;
@@ -65,6 +66,7 @@ void oz_elt_buf_term(struct oz_elt_buf *buf)
 struct oz_elt_info *oz_elt_info_alloc(struct oz_elt_buf *buf)
 {
 	struct oz_elt_info *ei = NULL;
+
 	spin_lock_bh(&buf->lock);
 	if (buf->free_elts && buf->elt_pool) {
 		ei = container_of(buf->elt_pool, struct oz_elt_info, link);
@@ -115,6 +117,7 @@ void oz_elt_info_free(struct oz_elt_buf *buf, struct oz_elt_info *ei)
 void oz_elt_info_free_chain(struct oz_elt_buf *buf, struct list_head *list)
 {
 	struct list_head *e;
+
 	e = list->next;
 	spin_lock_bh(&buf->lock);
 	while (e != list) {
@@ -151,6 +154,7 @@ int oz_elt_stream_delete(struct oz_elt_buf *buf, u8 id)
 {
 	struct list_head *e;
 	struct oz_elt_stream *st = NULL;
+
 	oz_dbg(ON, "%s: (0x%x)\n", __func__, id);
 	spin_lock_bh(&buf->lock);
 	e = buf->stream_list.next;
@@ -208,6 +212,7 @@ int oz_queue_elt_info(struct oz_elt_buf *buf, u8 isoc, u8 id,
 {
 	struct oz_elt_stream *st = NULL;
 	struct list_head *e;
+
 	if (id) {
 		list_for_each(e, &buf->stream_list) {
 			st = container_of(e, struct oz_elt_stream, link);
@@ -269,6 +274,7 @@ int oz_select_elts_for_tx(struct oz_elt_buf *buf, u8 isoc, unsigned *len,
 	struct list_head *e;
 	struct list_head *el;
 	struct oz_elt_info *ei;
+
 	spin_lock_bh(&buf->lock);
 	if (isoc)
 		el = &buf->isoc_list;
@@ -317,6 +323,7 @@ void oz_trim_elt_pool(struct oz_elt_buf *buf)
 {
 	struct list_head *free = NULL;
 	struct list_head *e;
+
 	spin_lock_bh(&buf->lock);
 	while (buf->free_elts > buf->max_free_elts) {
 		e = buf->elt_pool;
diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index f38d036..8ec125c 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -238,6 +238,7 @@ static inline struct oz_hcd *oz_hcd_private(struct usb_hcd *hcd)
 static int oz_get_port_from_addr(struct oz_hcd *ozhcd, u8 bus_addr)
 {
 	int i;
+
 	for (i = 0; i < OZ_NB_PORTS; i++) {
 		if (ozhcd->ports[i].bus_addr == bus_addr)
 			return i;
@@ -252,6 +253,7 @@ static struct oz_urb_link *oz_alloc_urb_link(void)
 {
 	struct oz_urb_link *urbl = NULL;
 	unsigned long irq_state;
+
 	spin_lock_irqsave(&g_link_lock, irq_state);
 	if (g_link_pool) {
 		urbl = container_of(g_link_pool, struct oz_urb_link, link);
@@ -291,6 +293,7 @@ static void oz_empty_link_pool(void)
 {
 	struct list_head *e;
 	unsigned long irq_state;
+
 	spin_lock_irqsave(&g_link_lock, irq_state);
 	e = g_link_pool;
 	g_link_pool = NULL;
@@ -332,6 +335,7 @@ static struct oz_urb_link *oz_uncancel_urb(struct oz_hcd *ozhcd, struct urb *urb
 {
 	struct oz_urb_link *urbl;
 	struct list_head *e;
+
 	list_for_each(e, &ozhcd->urb_cancel_list) {
 		urbl = container_of(e, struct oz_urb_link, link);
 		if (urb == urbl->urb) {
@@ -352,6 +356,7 @@ static void oz_complete_urb(struct usb_hcd *hcd, struct urb *urb,
 	struct oz_hcd *ozhcd = oz_hcd_private(hcd);
 	unsigned long irq_state;
 	struct oz_urb_link *cancel_urbl = NULL;
+
 	spin_lock_irqsave(&g_tasklet_lock, irq_state);
 	usb_hcd_unlink_urb_from_ep(hcd, urb);
 	/* Clear hcpriv which will prevent it being put in the cancel list
@@ -455,6 +460,7 @@ static int oz_enqueue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
 	struct oz_urb_link *urbl;
 	struct oz_endpoint *ep;
 	int err = 0;
+
 	if (ep_addr >= OZ_NB_ENDPOINTS) {
 		oz_dbg(ON, "%s: Invalid endpoint number\n", __func__);
 		return -EINVAL;
@@ -525,6 +531,7 @@ static int oz_dequeue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
 {
 	struct oz_urb_link *urbl = NULL;
 	struct oz_endpoint *ep;
+
 	spin_lock_bh(&port->ozhcd->hcd_lock);
 	if (in_dir)
 		ep = port->in_ep[ep_addr];
@@ -598,6 +605,7 @@ static void oz_acquire_port(struct oz_port *port, void *hpd)
 static struct oz_hcd *oz_hcd_claim(void)
 {
 	struct oz_hcd *ozhcd;
+
 	spin_lock_bh(&g_hcdlock);
 	ozhcd = g_ozhcd;
 	if (ozhcd)
@@ -631,6 +639,7 @@ void *oz_hcd_pd_arrived(void *hpd)
 	void *hport = NULL;
 	struct oz_hcd *ozhcd = NULL;
 	struct oz_endpoint *ep;
+
 	ozhcd = oz_hcd_claim();
 	if (ozhcd == NULL)
 		return NULL;
@@ -742,6 +751,7 @@ void oz_hcd_pd_reset(void *hpd, void *hport)
 	 */
 	struct oz_port *port = (struct oz_port *)hport;
 	struct oz_hcd *ozhcd = port->ozhcd;
+
 	oz_dbg(ON, "PD Reset\n");
 	spin_lock_bh(&port->port_lock);
 	port->flags |= OZ_PORT_F_CHANGED;
@@ -846,6 +856,7 @@ static void oz_hcd_complete_set_config(struct oz_port *port, struct urb *urb,
 {
 	int rc = 0;
 	struct usb_hcd *hcd = port->ozhcd->hcd;
+
 	if (rcode == 0) {
 		port->config_num = config_num;
 		oz_clean_endpoints_for_config(hcd, port);
@@ -866,6 +877,7 @@ static void oz_hcd_complete_set_interface(struct oz_port *port, struct urb *urb,
 {
 	struct usb_hcd *hcd = port->ozhcd->hcd;
 	int rc = 0;
+
 	if (rcode == 0) {
 		struct usb_host_config *config;
 		struct usb_host_interface *intf;
@@ -943,6 +955,7 @@ static int oz_hcd_buffer_data(struct oz_endpoint *ep, const u8 *data,
 {
 	int space;
 	int copy_len;
+
 	if (!ep->buffer)
 		return -1;
 	space = ep->out_ix-ep->in_ix-1;
@@ -979,6 +992,7 @@ void oz_hcd_data_ind(void *hport, u8 endpoint, const u8 *data, int data_len)
 	struct oz_port *port = (struct oz_port *)hport;
 	struct oz_endpoint *ep;
 	struct oz_hcd *ozhcd = port->ozhcd;
+
 	spin_lock_bh(&ozhcd->hcd_lock);
 	ep = port->in_ep[endpoint & USB_ENDPOINT_NUMBER_MASK];
 	if (ep == NULL)
@@ -1038,6 +1052,7 @@ int oz_hcd_heartbeat(void *hport)
 	struct urb *urb;
 	struct oz_endpoint *ep;
 	struct timespec ts, delta;
+
 	getrawmonotonic(&ts);
 	INIT_LIST_HEAD(&xfr_list);
 	/* Check the OUT isoc endpoints to see if any URB data can be sent.
@@ -1193,6 +1208,7 @@ static int oz_build_endpoints_for_interface(struct usb_hcd *hcd,
 	int i;
 	int if_ix = intf->desc.bInterfaceNumber;
 	int request_heartbeat = 0;
+
 	oz_dbg(ON, "interface[%d] = %p\n", if_ix, intf);
 	for (i = 0; i < intf->desc.bNumEndpoints; i++) {
 		struct usb_host_endpoint *hep = &intf->endpoint[i];
@@ -1314,6 +1330,7 @@ static int oz_build_endpoints_for_config(struct usb_hcd *hcd,
 	struct oz_hcd *ozhcd = port->ozhcd;
 	int i;
 	int num_iface = config->desc.bNumInterfaces;
+
 	if (num_iface) {
 		struct oz_interface *iface;
 
@@ -1346,6 +1363,7 @@ static void oz_clean_endpoints_for_config(struct usb_hcd *hcd,
 {
 	struct oz_hcd *ozhcd = port->ozhcd;
 	int i;
+
 	oz_dbg(ON, "Deleting endpoints for configuration\n");
 	for (i = 0; i < port->num_iface; i++)
 		oz_clean_endpoints_for_interface(hcd, port, i);
@@ -1365,6 +1383,7 @@ static void *oz_claim_hpd(struct oz_port *port)
 {
 	void *hpd = NULL;
 	struct oz_hcd *ozhcd = port->ozhcd;
+
 	spin_lock_bh(&ozhcd->hcd_lock);
 	hpd = port->hpd;
 	if (hpd)
@@ -1526,6 +1545,7 @@ static int oz_urb_process(struct oz_hcd *ozhcd, struct urb *urb)
 	int rc = 0;
 	struct oz_port *port = urb->hcpriv;
 	u8 ep_addr;
+
 	/* When we are paranoid we keep a list of urbs which we check against
 	 * before handing one back. This is just for debugging during
 	 * development and should be turned off in the released driver.
@@ -1560,6 +1580,7 @@ static void oz_urb_process_tasklet(unsigned long unused)
 	struct urb *urb;
 	struct oz_hcd *ozhcd = oz_hcd_claim();
 	int rc = 0;
+
 	if (ozhcd == NULL)
 		return;
 	/* This is called from a tasklet so is in softirq context but the urb
@@ -1599,6 +1620,7 @@ static void oz_urb_cancel(struct oz_port *port, u8 ep_num, struct urb *urb)
 	struct oz_hcd *ozhcd;
 	unsigned long irq_state;
 	u8 ix;
+
 	if (port == NULL) {
 		oz_dbg(ON, "%s: ERROR: (%p) port is null\n", __func__, urb);
 		return;
@@ -1657,6 +1679,7 @@ static void oz_urb_cancel_tasklet(unsigned long unused)
 	unsigned long irq_state;
 	struct urb *urb;
 	struct oz_hcd *ozhcd = oz_hcd_claim();
+
 	if (ozhcd == NULL)
 		return;
 	spin_lock_irqsave(&g_tasklet_lock, irq_state);
@@ -1728,6 +1751,7 @@ static int oz_hcd_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	struct oz_port *port;
 	unsigned long irq_state;
 	struct oz_urb_link *urbl;
+
 	oz_dbg(URB, "%s: (%p)\n",  __func__, urb);
 	if (unlikely(ozhcd == NULL)) {
 		oz_dbg(URB, "Refused urb(%p) not ozhcd\n", urb);
@@ -1776,6 +1800,7 @@ static struct oz_urb_link *oz_remove_urb(struct oz_endpoint *ep,
 {
 	struct oz_urb_link *urbl = NULL;
 	struct list_head *e;
+
 	if (unlikely(ep == NULL))
 		return NULL;
 	list_for_each(e, &ep->urb_list) {
@@ -1802,6 +1827,7 @@ static int oz_hcd_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 	struct oz_urb_link *urbl = NULL;
 	int rc;
 	unsigned long irq_state;
+
 	oz_dbg(URB, "%s: (%p)\n",  __func__, urb);
 	urbl = oz_alloc_urb_link();
 	if (unlikely(urbl == NULL))
@@ -2054,6 +2080,7 @@ static int oz_get_port_status(struct usb_hcd *hcd, u16 windex, char *buf)
 {
 	struct oz_hcd *ozhcd;
 	u32 status = 0;
+
 	if ((windex < 1) || (windex > OZ_NB_PORTS))
 		return -EPIPE;
 	ozhcd = oz_hcd_private(hcd);
@@ -2222,6 +2249,7 @@ static int oz_plat_resume(struct platform_device *dev)
 int oz_hcd_init(void)
 {
 	int err;
+
 	if (usb_disabled())
 		return -ENODEV;
 	tasklet_init(&g_urb_process_tasklet, oz_urb_process_tasklet, 0);
diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index 17fd7b2..14fea77 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -157,6 +157,7 @@ void oz_pd_put(struct oz_pd *pd)
 struct oz_pd *oz_pd_alloc(const u8 *mac_addr)
 {
 	struct oz_pd *pd = kzalloc(sizeof(struct oz_pd), GFP_ATOMIC);
+
 	if (pd) {
 		int i;
 		atomic_set(&pd->ref_count, 2);
@@ -196,6 +197,7 @@ void oz_pd_destroy(struct oz_pd *pd)
 	struct oz_tx_frame *f;
 	struct oz_isoc_stream *st;
 	struct oz_farewell *fwell;
+
 	oz_pd_dbg(pd, ON, "Destroying PD\n");
 	if (hrtimer_active(&pd->timeout))
 		hrtimer_cancel(&pd->timeout);
@@ -249,6 +251,7 @@ int oz_services_start(struct oz_pd *pd, u16 apps, int resume)
 {
 	const struct oz_app_if *ai;
 	int rc = 0;
+
 	oz_pd_dbg(pd, ON, "%s: (0x%x) resume(%d)\n", __func__, apps, resume);
 	for (ai = g_app_if; ai < &g_app_if[OZ_APPID_MAX]; ai++) {
 		if (apps & (1<<ai->app_id)) {
@@ -274,6 +277,7 @@ int oz_services_start(struct oz_pd *pd, u16 apps, int resume)
 void oz_services_stop(struct oz_pd *pd, u16 apps, int pause)
 {
 	const struct oz_app_if *ai;
+
 	oz_pd_dbg(pd, ON, "%s: (0x%x) pause(%d)\n", __func__, apps, pause);
 	for (ai = g_app_if; ai < &g_app_if[OZ_APPID_MAX]; ai++) {
 		if (apps & (1<<ai->app_id)) {
@@ -296,6 +300,7 @@ void oz_pd_heartbeat(struct oz_pd *pd, u16 apps)
 {
 	const struct oz_app_if *ai;
 	int more = 0;
+
 	for (ai = g_app_if; ai < &g_app_if[OZ_APPID_MAX]; ai++) {
 		if (ai->heartbeat && (apps & (1<<ai->app_id))) {
 			if (ai->heartbeat(pd))
@@ -316,6 +321,7 @@ void oz_pd_heartbeat(struct oz_pd *pd, u16 apps)
 void oz_pd_stop(struct oz_pd *pd)
 {
 	u16 stop_apps = 0;
+
 	oz_dbg(ON, "oz_pd_stop() State = 0x%x\n", pd->state);
 	oz_pd_indicate_farewells(pd);
 	oz_polling_lock_bh();
@@ -339,6 +345,7 @@ int oz_pd_sleep(struct oz_pd *pd)
 {
 	int do_stop = 0;
 	u16 stop_apps = 0;
+
 	oz_polling_lock_bh();
 	if (pd->state & (OZ_PD_S_SLEEP | OZ_PD_S_STOPPED)) {
 		oz_polling_unlock_bh();
@@ -365,6 +372,7 @@ int oz_pd_sleep(struct oz_pd *pd)
 static struct oz_tx_frame *oz_tx_frame_alloc(struct oz_pd *pd)
 {
 	struct oz_tx_frame *f = NULL;
+
 	spin_lock_bh(&pd->tx_frame_lock);
 	if (pd->tx_pool) {
 		f = container_of(pd->tx_pool, struct oz_tx_frame, link);
@@ -419,6 +427,7 @@ static void oz_tx_frame_free(struct oz_pd *pd, struct oz_tx_frame *f)
 static void oz_set_more_bit(struct sk_buff *skb)
 {
 	struct oz_hdr *oz_hdr = (struct oz_hdr *)skb_network_header(skb);
+
 	oz_hdr->control |= OZ_F_MORE_DATA;
 }
 /*------------------------------------------------------------------------------
@@ -427,6 +436,7 @@ static void oz_set_more_bit(struct sk_buff *skb)
 static void oz_set_last_pkt_nb(struct oz_pd *pd, struct sk_buff *skb)
 {
 	struct oz_hdr *oz_hdr = (struct oz_hdr *)skb_network_header(skb);
+
 	oz_hdr->last_pkt_num = pd->trigger_pkt_num & OZ_LAST_PN_MASK;
 }
 /*------------------------------------------------------------------------------
@@ -435,6 +445,7 @@ static void oz_set_last_pkt_nb(struct oz_pd *pd, struct sk_buff *skb)
 int oz_prepare_frame(struct oz_pd *pd, int empty)
 {
 	struct oz_tx_frame *f;
+
 	if ((pd->mode & OZ_MODE_MASK) != OZ_MODE_TRIGGERED)
 		return -1;
 	if (pd->nb_queued_frames >= OZ_MAX_QUEUED_FRAMES)
@@ -469,6 +480,7 @@ static struct sk_buff *oz_build_frame(struct oz_pd *pd, struct oz_tx_frame *f)
 	struct oz_hdr *oz_hdr;
 	struct oz_elt *elt;
 	struct list_head *e;
+
 	/* Allocate skb with enough space for the lower layers as well
 	 * as the space we need.
 	 */
@@ -510,6 +522,7 @@ static void oz_retire_frame(struct oz_pd *pd, struct oz_tx_frame *f)
 {
 	struct list_head *e;
 	struct oz_elt_info *ei;
+
 	e = f->elt_list.next;
 	while (e != &f->elt_list) {
 		ei = container_of(e, struct oz_elt_info, link);
@@ -533,6 +546,7 @@ static int oz_send_next_queued_frame(struct oz_pd *pd, int more_data)
 	struct sk_buff *skb;
 	struct oz_tx_frame *f;
 	struct list_head *e;
+
 	spin_lock(&pd->tx_frame_lock);
 	e = pd->last_sent_frame->next;
 	if (e == &pd->tx_queue) {
@@ -628,6 +642,7 @@ static int oz_send_isoc_frame(struct oz_pd *pd)
 	struct list_head *e;
 	struct list_head list;
 	int total_size = sizeof(struct oz_hdr);
+
 	INIT_LIST_HEAD(&list);
 
 	oz_select_elts_for_tx(&pd->elt_buff, 1, &total_size,
@@ -713,6 +728,7 @@ static struct oz_isoc_stream *pd_stream_find(struct oz_pd *pd, u8 ep_num)
 {
 	struct list_head *e;
 	struct oz_isoc_stream *st;
+
 	list_for_each(e, &pd->stream_list) {
 		st = container_of(e, struct oz_isoc_stream, link);
 		if (st->ep_num == ep_num)
@@ -753,6 +769,7 @@ static void oz_isoc_stream_free(struct oz_isoc_stream *st)
 int oz_isoc_stream_delete(struct oz_pd *pd, u8 ep_num)
 {
 	struct oz_isoc_stream *st;
+
 	spin_lock_bh(&pd->stream_lock);
 	st = pd_stream_find(pd, ep_num);
 	if (st)
@@ -780,6 +797,7 @@ int oz_send_isoc_unit(struct oz_pd *pd, u8 ep_num, const u8 *data, int len)
 	struct sk_buff *skb = NULL;
 	struct oz_hdr *oz_hdr = NULL;
 	int size = 0;
+
 	spin_lock_bh(&pd->stream_lock);
 	st = pd_stream_find(pd, ep_num);
 	if (st) {
@@ -895,6 +913,7 @@ out:	kfree_skb(skb);
 void oz_apps_init(void)
 {
 	int i;
+
 	for (i = 0; i < OZ_APPID_MAX; i++)
 		if (g_app_if[i].init)
 			g_app_if[i].init();
@@ -905,6 +924,7 @@ void oz_apps_init(void)
 void oz_apps_term(void)
 {
 	int i;
+
 	/* Terminate all the apps. */
 	for (i = 0; i < OZ_APPID_MAX; i++)
 		if (g_app_if[i].term)
@@ -916,6 +936,7 @@ void oz_apps_term(void)
 void oz_handle_app_elt(struct oz_pd *pd, u8 app_id, struct oz_elt *elt)
 {
 	const struct oz_app_if *ai;
+
 	if (app_id == 0 || app_id > OZ_APPID_MAX)
 		return;
 	ai = &g_app_if[app_id-1];
@@ -928,6 +949,7 @@ void oz_pd_indicate_farewells(struct oz_pd *pd)
 {
 	struct oz_farewell *f;
 	const struct oz_app_if *ai = &g_app_if[OZ_APPID_USB-1];
+
 	while (1) {
 		oz_polling_lock_bh();
 		if (list_empty(&pd->farewell_list)) {
diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index 3d1a89f..7072f53 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -74,6 +74,7 @@ static void oz_send_conn_rsp(struct oz_pd *pd, u8 status)
 	struct oz_hdr *oz_hdr;
 	struct oz_elt *elt;
 	struct oz_elt_connect_rsp *body;
+
 	int sz = sizeof(struct oz_hdr) + sizeof(struct oz_elt) +
 			sizeof(struct oz_elt_connect_rsp);
 	skb = alloc_skb(sz + OZ_ALLOCATED_SPACE(dev), GFP_ATOMIC);
@@ -163,6 +164,7 @@ static struct oz_pd *oz_connect_req(struct oz_pd *cur_pd, struct oz_elt *elt,
 	u16 new_apps = g_apps;
 	struct net_device *old_net_dev = NULL;
 	struct oz_pd *free_pd = NULL;
+
 	if (cur_pd) {
 		pd = cur_pd;
 		spin_lock_bh(&g_polling_lock);
@@ -291,6 +293,7 @@ static void oz_add_farewell(struct oz_pd *pd, u8 ep_num, u8 index,
 	struct oz_farewell *f;
 	struct oz_farewell *f2;
 	int found = 0;
+
 	f = kmalloc(sizeof(struct oz_farewell) + len, GFP_ATOMIC);
 	if (!f)
 		return;
@@ -477,6 +480,7 @@ void oz_pd_heartbeat_handler(unsigned long data)
 {
 	struct oz_pd *pd = (struct oz_pd *)data;
 	u16 apps = 0;
+
 	spin_lock_bh(&g_polling_lock);
 	if (pd->state & OZ_PD_S_CONNECTED)
 		apps = pd->total_apps;
@@ -574,6 +578,7 @@ struct oz_pd *oz_pd_find(const u8 *mac_addr)
 {
 	struct oz_pd *pd;
 	struct list_head *e;
+
 	spin_lock_bh(&g_polling_lock);
 	list_for_each(e, &g_pd_list) {
 		pd = container_of(e, struct oz_pd, link);
@@ -675,6 +680,7 @@ static void pd_stop_all_for_device(struct net_device *net_dev)
 	struct list_head h;
 	struct oz_pd *pd;
 	struct oz_pd *n;
+
 	INIT_LIST_HEAD(&h);
 	spin_lock_bh(&g_polling_lock);
 	list_for_each_entry_safe(pd, n, &g_pd_list, link) {
@@ -758,6 +764,7 @@ int oz_get_pd_list(struct oz_mac_addr *addr, int max_count)
 	struct oz_pd *pd;
 	struct list_head *e;
 	int count = 0;
+
 	spin_lock_bh(&g_polling_lock);
 	list_for_each(e, &g_pd_list) {
 		if (count >= max_count)
diff --git a/drivers/staging/ozwpan/ozurbparanoia.c b/drivers/staging/ozwpan/ozurbparanoia.c
index d69e8ab..6aab9a7 100644
--- a/drivers/staging/ozwpan/ozurbparanoia.c
+++ b/drivers/staging/ozwpan/ozurbparanoia.c
@@ -21,6 +21,7 @@ DEFINE_SPINLOCK(g_urb_mem_lock);
 void oz_remember_urb(struct urb *urb)
 {
 	unsigned long irq_state;
+
 	spin_lock_irqsave(&g_urb_mem_lock, irq_state);
 	if (g_nb_urbs < OZ_MAX_URBS) {
 		g_urb_memory[g_nb_urbs++] = urb;
@@ -37,6 +38,7 @@ int oz_forget_urb(struct urb *urb)
 	unsigned long irq_state;
 	int i;
 	int rc = -1;
+
 	spin_lock_irqsave(&g_urb_mem_lock, irq_state);
 	for (i = 0; i < g_nb_urbs; i++) {
 		if (g_urb_memory[i] == urb) {
diff --git a/drivers/staging/ozwpan/ozusbsvc.c b/drivers/staging/ozwpan/ozusbsvc.c
index 732face..ab9db8c 100644
--- a/drivers/staging/ozwpan/ozusbsvc.c
+++ b/drivers/staging/ozwpan/ozusbsvc.c
@@ -53,6 +53,7 @@ int oz_usb_start(struct oz_pd *pd, int resume)
 	int rc = 0;
 	struct oz_usb_ctx *usb_ctx;
 	struct oz_usb_ctx *old_ctx;
+
 	if (resume) {
 		oz_dbg(ON, "USB service resumed\n");
 		return 0;
@@ -114,6 +115,7 @@ int oz_usb_start(struct oz_pd *pd, int resume)
 void oz_usb_stop(struct oz_pd *pd, int pause)
 {
 	struct oz_usb_ctx *usb_ctx;
+
 	if (pause) {
 		oz_dbg(ON, "USB service paused\n");
 		return;
@@ -154,6 +156,7 @@ void oz_usb_stop(struct oz_pd *pd, int pause)
 void oz_usb_get(void *hpd)
 {
 	struct oz_usb_ctx *usb_ctx = (struct oz_usb_ctx *)hpd;
+
 	atomic_inc(&usb_ctx->ref_count);
 }
 /*------------------------------------------------------------------------------
@@ -164,6 +167,7 @@ void oz_usb_get(void *hpd)
 void oz_usb_put(void *hpd)
 {
 	struct oz_usb_ctx *usb_ctx = (struct oz_usb_ctx *)hpd;
+
 	if (atomic_dec_and_test(&usb_ctx->ref_count)) {
 		oz_dbg(ON, "Dealloc USB context\n");
 		oz_pd_put(usb_ctx->pd);
@@ -177,6 +181,7 @@ int oz_usb_heartbeat(struct oz_pd *pd)
 {
 	struct oz_usb_ctx *usb_ctx;
 	int rc = 0;
+
 	spin_lock_bh(&pd->app_lock[OZ_APPID_USB-1]);
 	usb_ctx = (struct oz_usb_ctx *)pd->app_ctx[OZ_APPID_USB-1];
 	if (usb_ctx)
@@ -200,6 +205,7 @@ int oz_usb_stream_create(void *hpd, u8 ep_num)
 {
 	struct oz_usb_ctx *usb_ctx = (struct oz_usb_ctx *)hpd;
 	struct oz_pd *pd = usb_ctx->pd;
+
 	oz_dbg(ON, "%s: (0x%x)\n", __func__, ep_num);
 	if (pd->mode & OZ_F_ISOC_NO_ELTS) {
 		oz_isoc_stream_create(pd, ep_num);
@@ -219,6 +225,7 @@ int oz_usb_stream_create(void *hpd, u8 ep_num)
 int oz_usb_stream_delete(void *hpd, u8 ep_num)
 {
 	struct oz_usb_ctx *usb_ctx = (struct oz_usb_ctx *)hpd;
+
 	if (usb_ctx) {
 		struct oz_pd *pd = usb_ctx->pd;
 		if (pd) {
@@ -240,6 +247,7 @@ int oz_usb_stream_delete(void *hpd, u8 ep_num)
 void oz_usb_request_heartbeat(void *hpd)
 {
 	struct oz_usb_ctx *usb_ctx = (struct oz_usb_ctx *)hpd;
+
 	if (usb_ctx && usb_ctx->pd)
 		oz_pd_request_heartbeat(usb_ctx->pd);
 }
diff --git a/drivers/staging/ozwpan/ozusbsvc1.c b/drivers/staging/ozwpan/ozusbsvc1.c
index 50d21bf..34133ef 100644
--- a/drivers/staging/ozwpan/ozusbsvc1.c
+++ b/drivers/staging/ozwpan/ozusbsvc1.c
@@ -33,6 +33,7 @@ static int oz_usb_submit_elt(struct oz_elt_buf *eb, struct oz_elt_info *ei,
 	int ret;
 	struct oz_elt *elt = (struct oz_elt *)ei->data;
 	struct oz_app_hdr *app_hdr = (struct oz_app_hdr *)(elt+1);
+
 	elt->type = OZ_ELT_APP_DATA;
 	ei->app_id = OZ_APPID_USB;
 	ei->length = elt->length + sizeof(struct oz_elt);
@@ -61,6 +62,7 @@ int oz_usb_get_desc_req(void *hpd, u8 req_id, u8 req_type, u8 desc_type,
 	struct oz_get_desc_req *body;
 	struct oz_elt_buf *eb = &pd->elt_buff;
 	struct oz_elt_info *ei = oz_elt_info_alloc(&pd->elt_buff);
+
 	oz_dbg(ON, "    req_type = 0x%x\n", req_type);
 	oz_dbg(ON, "    desc_type = 0x%x\n", desc_type);
 	oz_dbg(ON, "    index = 0x%x\n", index);
@@ -95,6 +97,7 @@ static int oz_usb_set_config_req(void *hpd, u8 req_id, u8 index)
 	struct oz_elt_buf *eb = &pd->elt_buff;
 	struct oz_elt_info *ei = oz_elt_info_alloc(&pd->elt_buff);
 	struct oz_set_config_req *body;
+
 	if (ei == NULL)
 		return -1;
 	elt = (struct oz_elt *)ei->data;
@@ -116,6 +119,7 @@ static int oz_usb_set_interface_req(void *hpd, u8 req_id, u8 index, u8 alt)
 	struct oz_elt_buf *eb = &pd->elt_buff;
 	struct oz_elt_info *ei = oz_elt_info_alloc(&pd->elt_buff);
 	struct oz_set_interface_req *body;
+
 	if (ei == NULL)
 		return -1;
 	elt = (struct oz_elt *)ei->data;
@@ -139,6 +143,7 @@ static int oz_usb_set_clear_feature_req(void *hpd, u8 req_id, u8 type,
 	struct oz_elt_buf *eb = &pd->elt_buff;
 	struct oz_elt_info *ei = oz_elt_info_alloc(&pd->elt_buff);
 	struct oz_feature_req *body;
+
 	if (ei == NULL)
 		return -1;
 	elt = (struct oz_elt *)ei->data;
@@ -163,6 +168,7 @@ static int oz_usb_vendor_class_req(void *hpd, u8 req_id, u8 req_type,
 	struct oz_elt_buf *eb = &pd->elt_buff;
 	struct oz_elt_info *ei = oz_elt_info_alloc(&pd->elt_buff);
 	struct oz_vendor_class_req *body;
+
 	if (ei == NULL)
 		return -1;
 	elt = (struct oz_elt *)ei->data;
@@ -188,6 +194,7 @@ int oz_usb_control_req(void *hpd, u8 req_id, struct usb_ctrlrequest *setup,
 	unsigned windex = le16_to_cpu(setup->wIndex);
 	unsigned wlength = le16_to_cpu(setup->wLength);
 	int rc = 0;
+
 	if ((setup->bRequestType & USB_TYPE_MASK) == USB_TYPE_STANDARD) {
 		switch (setup->bRequest) {
 		case USB_REQ_GET_DESCRIPTOR:
@@ -303,6 +310,7 @@ static void oz_usb_handle_ep_data(struct oz_usb_ctx *usb_ctx,
 	struct oz_usb_hdr *usb_hdr, int len)
 {
 	struct oz_data *data_hdr = (struct oz_data *)usb_hdr;
+
 	switch (data_hdr->format) {
 	case OZ_DATA_F_MULTIPLE_FIXED: {
 			struct oz_multiple_fixed *body =
@@ -416,6 +424,7 @@ done:
 void oz_usb_farewell(struct oz_pd *pd, u8 ep_num, u8 *data, u8 len)
 {
 	struct oz_usb_ctx *usb_ctx;
+
 	spin_lock_bh(&pd->app_lock[OZ_APPID_USB-1]);
 	usb_ctx = (struct oz_usb_ctx *)pd->app_ctx[OZ_APPID_USB-1];
 	if (usb_ctx)
-- 
1.7.9.5

