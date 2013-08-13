Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab3HMRab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:30:31 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:25278 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab3HMRa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:30:27 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <dan.carpenter@oracle.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH 08/10] staging: ozwpan: Remove unneeded initializers
Date: Tue, 13 Aug 2013 18:29:24 +0100
Message-ID: <1376414966-23525-4-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376414966-23525-1-git-send-email-rupesh.gujare@atmel.com>
References: <1376414966-23525-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove variable initialization wherever it is not required.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozeltbuf.c |    2 +-
 drivers/staging/ozwpan/ozhcd.c    |   18 +++++++++---------
 drivers/staging/ozwpan/ozpd.c     |    4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/ozwpan/ozeltbuf.c b/drivers/staging/ozwpan/ozeltbuf.c
index 4844d9f..cfc0f39 100644
--- a/drivers/staging/ozwpan/ozeltbuf.c
+++ b/drivers/staging/ozwpan/ozeltbuf.c
@@ -67,7 +67,7 @@ void oz_elt_buf_term(struct oz_elt_buf *buf)
  */
 struct oz_elt_info *oz_elt_info_alloc(struct oz_elt_buf *buf)
 {
-	struct oz_elt_info *ei = NULL;
+	struct oz_elt_info *ei;
 
 	spin_lock_bh(&buf->lock);
 	if (buf->free_elts && buf->elt_pool) {
diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index ed3ffeb..0fd3fea 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -373,7 +373,7 @@ static void oz_complete_urb(struct usb_hcd *hcd, struct urb *urb,
 {
 	struct oz_hcd *ozhcd = oz_hcd_private(hcd);
 	unsigned long irq_state;
-	struct oz_urb_link *cancel_urbl = NULL;
+	struct oz_urb_link *cancel_urbl;
 
 	spin_lock_irqsave(&g_tasklet_lock, irq_state);
 	usb_hcd_unlink_urb_from_ep(hcd, urb);
@@ -585,7 +585,7 @@ static struct urb *oz_find_urb_by_id(struct oz_port *port, int ep_ix,
 {
 	struct oz_hcd *ozhcd = port->ozhcd;
 	struct urb *urb = NULL;
-	struct oz_urb_link *urbl = NULL;
+	struct oz_urb_link *urbl;
 	struct oz_endpoint *ep;
 
 	spin_lock_bh(&ozhcd->hcd_lock);
@@ -664,7 +664,7 @@ struct oz_port *oz_hcd_pd_arrived(void *hpd)
 {
 	int i;
 	struct oz_port *hport = NULL;
-	struct oz_hcd *ozhcd = NULL;
+	struct oz_hcd *ozhcd;
 	struct oz_endpoint *ep;
 
 	ozhcd = oz_hcd_claim();
@@ -1423,7 +1423,7 @@ static void oz_clean_endpoints_for_config(struct usb_hcd *hcd,
  */
 static void *oz_claim_hpd(struct oz_port *port)
 {
-	void *hpd = NULL;
+	void *hpd;
 	struct oz_hcd *ozhcd = port->ozhcd;
 
 	spin_lock_bh(&ozhcd->hcd_lock);
@@ -1444,7 +1444,7 @@ static void oz_process_ep0_urb(struct oz_hcd *ozhcd, struct urb *urb,
 	unsigned windex;
 	unsigned wvalue;
 	unsigned wlength;
-	void *hpd = NULL;
+	void *hpd;
 	u8 req_id;
 	int rc = 0;
 	unsigned complete = 0;
@@ -1798,7 +1798,7 @@ static int oz_hcd_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 				gfp_t mem_flags)
 {
 	struct oz_hcd *ozhcd = oz_hcd_private(hcd);
-	int rc = 0;
+	int rc;
 	int port_ix;
 	struct oz_port *port;
 	unsigned long irq_state;
@@ -1851,7 +1851,7 @@ static int oz_hcd_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 static struct oz_urb_link *oz_remove_urb(struct oz_endpoint *ep,
 				struct urb *urb)
 {
-	struct oz_urb_link *urbl = NULL;
+	struct oz_urb_link *urbl;
 	struct list_head *e;
 
 	if (unlikely(ep == NULL))
@@ -1878,7 +1878,7 @@ static struct oz_urb_link *oz_remove_urb(struct oz_endpoint *ep,
 static int oz_hcd_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 {
 	struct oz_hcd *ozhcd = oz_hcd_private(hcd);
-	struct oz_urb_link *urbl = NULL;
+	struct oz_urb_link *urbl;
 	int rc;
 	unsigned long irq_state;
 
@@ -2141,7 +2141,7 @@ static int oz_clear_port_feature(struct usb_hcd *hcd, u16 wvalue, u16 windex)
 static int oz_get_port_status(struct usb_hcd *hcd, u16 windex, char *buf)
 {
 	struct oz_hcd *ozhcd;
-	u32 status = 0;
+	u32 status;
 
 	if ((windex < 1) || (windex > OZ_NB_PORTS))
 		return -EPIPE;
diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index 95109fd..2514d79 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -337,7 +337,7 @@ void oz_pd_heartbeat(struct oz_pd *pd, u16 apps)
  */
 void oz_pd_stop(struct oz_pd *pd)
 {
-	u16 stop_apps = 0;
+	u16 stop_apps;
 
 	oz_dbg(ON, "oz_pd_stop() State = 0x%x\n", pd->state);
 	oz_pd_indicate_farewells(pd);
@@ -362,7 +362,7 @@ void oz_pd_stop(struct oz_pd *pd)
 int oz_pd_sleep(struct oz_pd *pd)
 {
 	int do_stop = 0;
-	u16 stop_apps = 0;
+	u16 stop_apps;
 
 	oz_polling_lock_bh();
 	if (pd->state & (OZ_PD_S_SLEEP | OZ_PD_S_STOPPED)) {
-- 
1.7.9.5

