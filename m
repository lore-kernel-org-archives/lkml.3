Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab3BOUNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 15:13:16 -0500
Received: from mout.gmx.net ([212.227.15.18]:59450 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab3BOUNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 15:13:14 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/jV8Nwl27jH6bwgvIEoGTLChQDM/CEyUPhUVqaA6
	NzteMssHqH9utB
From: Peter Huewe <peterhuewe@gmx.de>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 4/4] staging/ozwpan: Mark read only parameters and structs as const
Date: Fri, 15 Feb 2013 21:17:24 +0100
Message-Id: <1360959444-5961-4-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360959444-5961-1-git-send-email-peterhuewe@gmx.de>
References: <1360959444-5961-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks function parameters that are used read only
as well as readonly structs (and corresponding pointers) as const.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/ozwpan/ozcdev.c    |    2 +-
 drivers/staging/ozwpan/ozhcd.c     |    9 +++++----
 drivers/staging/ozwpan/ozpd.c      |   16 ++++++++--------
 drivers/staging/ozwpan/ozpd.h      |    4 ++--
 drivers/staging/ozwpan/ozproto.c   |    6 +++---
 drivers/staging/ozwpan/ozproto.h   |    2 +-
 drivers/staging/ozwpan/ozusbif.h   |    8 ++++----
 drivers/staging/ozwpan/ozusbsvc1.c |    4 ++--
 8 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index 89d454e..ba15aeb 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -200,7 +200,7 @@ out:
 /*------------------------------------------------------------------------------
  * Context: process
  */
-static int oz_set_active_pd(u8 *addr)
+static int oz_set_active_pd(const u8 *addr)
 {
 	int rc = 0;
 	struct oz_pd *pd;
diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index ed2addb..8ac26f5 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -759,7 +759,7 @@ void oz_hcd_pd_reset(void *hpd, void *hport)
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
-void oz_hcd_get_desc_cnf(void *hport, u8 req_id, int status, u8 *desc,
+void oz_hcd_get_desc_cnf(void *hport, u8 req_id, int status, const u8 *desc,
 			int length, int offset, int total_size)
 {
 	struct oz_port *port = (struct oz_port *)hport;
@@ -895,7 +895,7 @@ static void oz_hcd_complete_set_interface(struct oz_port *port, struct urb *urb,
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
-void oz_hcd_control_cnf(void *hport, u8 req_id, u8 rcode, u8 *data,
+void oz_hcd_control_cnf(void *hport, u8 req_id, u8 rcode, const u8 *data,
 	int data_len)
 {
 	struct oz_port *port = (struct oz_port *)hport;
@@ -948,7 +948,8 @@ void oz_hcd_control_cnf(void *hport, u8 req_id, u8 rcode, u8 *data,
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
-static int oz_hcd_buffer_data(struct oz_endpoint *ep, u8 *data, int data_len)
+static int oz_hcd_buffer_data(struct oz_endpoint *ep, const u8 *data,
+			      int data_len)
 {
 	int space;
 	int copy_len;
@@ -983,7 +984,7 @@ static int oz_hcd_buffer_data(struct oz_endpoint *ep, u8 *data, int data_len)
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
-void oz_hcd_data_ind(void *hport, u8 endpoint, u8 *data, int data_len)
+void oz_hcd_data_ind(void *hport, u8 endpoint, const u8 *data, int data_len)
 {
 	struct oz_port *port = (struct oz_port *)hport;
 	struct oz_endpoint *ep;
diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index a54f89c..f8b9da0 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -46,7 +46,7 @@ static void oz_def_app_rx(struct oz_pd *pd, struct oz_elt *elt);
 static atomic_t g_submitted_isoc = ATOMIC_INIT(0);
 /* Application handler functions.
  */
-static struct oz_app_if g_app_if[OZ_APPID_MAX] = {
+static const struct oz_app_if g_app_if[OZ_APPID_MAX] = {
 	{oz_usb_init,
 	oz_usb_term,
 	oz_usb_start,
@@ -157,7 +157,7 @@ void oz_pd_put(struct oz_pd *pd)
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
-struct oz_pd *oz_pd_alloc(u8 *mac_addr)
+struct oz_pd *oz_pd_alloc(const u8 *mac_addr)
 {
 	struct oz_pd *pd = kzalloc(sizeof(struct oz_pd), GFP_ATOMIC);
 	if (pd) {
@@ -235,7 +235,7 @@ void oz_pd_destroy(struct oz_pd *pd)
  */
 int oz_services_start(struct oz_pd *pd, u16 apps, int resume)
 {
-	struct oz_app_if *ai;
+	const struct oz_app_if *ai;
 	int rc = 0;
 	oz_trace("oz_services_start(0x%x) resume(%d)\n", apps, resume);
 	for (ai = g_app_if; ai < &g_app_if[OZ_APPID_MAX]; ai++) {
@@ -260,7 +260,7 @@ int oz_services_start(struct oz_pd *pd, u16 apps, int resume)
  */
 void oz_services_stop(struct oz_pd *pd, u16 apps, int pause)
 {
-	struct oz_app_if *ai;
+	const struct oz_app_if *ai;
 	oz_trace("oz_stop_services(0x%x) pause(%d)\n", apps, pause);
 	for (ai = g_app_if; ai < &g_app_if[OZ_APPID_MAX]; ai++) {
 		if (apps & (1<<ai->app_id)) {
@@ -281,7 +281,7 @@ void oz_services_stop(struct oz_pd *pd, u16 apps, int pause)
  */
 void oz_pd_heartbeat(struct oz_pd *pd, u16 apps)
 {
-	struct oz_app_if *ai;
+	const struct oz_app_if *ai;
 	int more = 0;
 	for (ai = g_app_if; ai < &g_app_if[OZ_APPID_MAX]; ai++) {
 		if (ai->heartbeat && (apps & (1<<ai->app_id))) {
@@ -774,7 +774,7 @@ static void oz_isoc_destructor(struct sk_buff *skb)
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
-int oz_send_isoc_unit(struct oz_pd *pd, u8 ep_num, u8 *data, int len)
+int oz_send_isoc_unit(struct oz_pd *pd, u8 ep_num, const u8 *data, int len)
 {
 	struct net_device *dev = pd->net_dev;
 	struct oz_isoc_stream *st;
@@ -913,7 +913,7 @@ void oz_apps_term(void)
  */
 void oz_handle_app_elt(struct oz_pd *pd, u8 app_id, struct oz_elt *elt)
 {
-	struct oz_app_if *ai;
+	const struct oz_app_if *ai;
 	if (app_id == 0 || app_id > OZ_APPID_MAX)
 		return;
 	ai = &g_app_if[app_id-1];
@@ -925,7 +925,7 @@ void oz_handle_app_elt(struct oz_pd *pd, u8 app_id, struct oz_elt *elt)
 void oz_pd_indicate_farewells(struct oz_pd *pd)
 {
 	struct oz_farewell *f;
-	struct oz_app_if *ai = &g_app_if[OZ_APPID_USB-1];
+	const struct oz_app_if *ai = &g_app_if[OZ_APPID_USB-1];
 	while (1) {
 		oz_polling_lock_bh();
 		if (list_empty(&pd->farewell_list)) {
diff --git a/drivers/staging/ozwpan/ozpd.h b/drivers/staging/ozwpan/ozpd.h
index d35b0ea..fbf47cb 100644
--- a/drivers/staging/ozwpan/ozpd.h
+++ b/drivers/staging/ozwpan/ozpd.h
@@ -99,7 +99,7 @@ struct oz_pd {
 
 #define OZ_MAX_QUEUED_FRAMES	4
 
-struct oz_pd *oz_pd_alloc(u8 *mac_addr);
+struct oz_pd *oz_pd_alloc(const u8 *mac_addr);
 void oz_pd_destroy(struct oz_pd *pd);
 void oz_pd_get(struct oz_pd *pd);
 void oz_pd_put(struct oz_pd *pd);
@@ -115,7 +115,7 @@ void oz_send_queued_frames(struct oz_pd *pd, int backlog);
 void oz_retire_tx_frames(struct oz_pd *pd, u8 lpn);
 int oz_isoc_stream_create(struct oz_pd *pd, u8 ep_num);
 int oz_isoc_stream_delete(struct oz_pd *pd, u8 ep_num);
-int oz_send_isoc_unit(struct oz_pd *pd, u8 ep_num, u8 *data, int len);
+int oz_send_isoc_unit(struct oz_pd *pd, u8 ep_num, const u8 *data, int len);
 void oz_handle_app_elt(struct oz_pd *pd, u8 app_id, struct oz_elt *elt);
 void oz_apps_init(void);
 void oz_apps_term(void);
diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index 40c283c..3badf15 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -171,7 +171,7 @@ static void pd_set_presleep(struct oz_pd *pd, u8 presleep)
  * Context: softirq-serialized
  */
 static struct oz_pd *oz_connect_req(struct oz_pd *cur_pd, struct oz_elt *elt,
-			u8 *pd_addr, struct net_device *net_dev)
+			const u8 *pd_addr, struct net_device *net_dev)
 {
 	struct oz_pd *pd;
 	struct oz_elt_connect_req *body =
@@ -306,7 +306,7 @@ done:
  * Context: softirq-serialized
  */
 static void oz_add_farewell(struct oz_pd *pd, u8 ep_num, u8 index,
-			u8 *report, u8 len)
+			const u8 *report, u8 len)
 {
 	struct oz_farewell *f;
 	struct oz_farewell *f2;
@@ -734,7 +734,7 @@ void oz_pd_request_heartbeat(struct oz_pd *pd)
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
-struct oz_pd *oz_pd_find(u8 *mac_addr)
+struct oz_pd *oz_pd_find(const u8 *mac_addr)
 {
 	struct oz_pd *pd;
 	struct list_head *e;
diff --git a/drivers/staging/ozwpan/ozproto.h b/drivers/staging/ozwpan/ozproto.h
index 755a08d..93bb4c0 100644
--- a/drivers/staging/ozwpan/ozproto.h
+++ b/drivers/staging/ozwpan/ozproto.h
@@ -62,7 +62,7 @@ int oz_protocol_init(char *devs);
 void oz_protocol_term(void);
 int oz_get_pd_list(struct oz_mac_addr *addr, int max_count);
 void oz_app_enable(int app_id, int enable);
-struct oz_pd *oz_pd_find(u8 *mac_addr);
+struct oz_pd *oz_pd_find(const u8 *mac_addr);
 void oz_binding_add(char *net_dev);
 void oz_binding_remove(char *net_dev);
 void oz_timer_add(struct oz_pd *pd, int type, unsigned long due_time,
diff --git a/drivers/staging/ozwpan/ozusbif.h b/drivers/staging/ozwpan/ozusbif.h
index 3acf598..8531438 100644
--- a/drivers/staging/ozwpan/ozusbif.h
+++ b/drivers/staging/ozwpan/ozusbif.h
@@ -21,7 +21,7 @@ int oz_usb_stream_delete(void *hpd, u8 ep_num);
 /* Request functions.
  */
 int oz_usb_control_req(void *hpd, u8 req_id, struct usb_ctrlrequest *setup,
-		u8 *data, int data_len);
+		const u8 *data, int data_len);
 int oz_usb_get_desc_req(void *hpd, u8 req_id, u8 req_type, u8 desc_type,
 	u8 index, u16 windex, int offset, int len);
 int oz_usb_send_isoc(void *hpd, u8 ep_num, struct urb *urb);
@@ -30,13 +30,13 @@ void oz_usb_request_heartbeat(void *hpd);
 /* Confirmation functions.
  */
 void oz_hcd_get_desc_cnf(void *hport, u8 req_id, int status,
-	u8 *desc, int length, int offset, int total_size);
+	const u8 *desc, int length, int offset, int total_size);
 void oz_hcd_control_cnf(void *hport, u8 req_id, u8 rcode,
-	u8 *data, int data_len);
+	const u8 *data, int data_len);
 
 /* Indication functions.
  */
-void oz_hcd_data_ind(void *hport, u8 endpoint, u8 *data, int data_len);
+void oz_hcd_data_ind(void *hport, u8 endpoint, const u8 *data, int data_len);
 
 int oz_hcd_heartbeat(void *hport);
 
diff --git a/drivers/staging/ozwpan/ozusbsvc1.c b/drivers/staging/ozwpan/ozusbsvc1.c
index c54614d..4e4b650 100644
--- a/drivers/staging/ozwpan/ozusbsvc1.c
+++ b/drivers/staging/ozwpan/ozusbsvc1.c
@@ -157,7 +157,7 @@ static int oz_usb_set_clear_feature_req(void *hpd, u8 req_id, u8 type,
  * Context: tasklet
  */
 static int oz_usb_vendor_class_req(void *hpd, u8 req_id, u8 req_type,
-	u8 request, __le16 value, __le16 index, u8 *data, int data_len)
+	u8 request, __le16 value, __le16 index, const u8 *data, int data_len)
 {
 	struct oz_usb_ctx *usb_ctx = (struct oz_usb_ctx *)hpd;
 	struct oz_pd *pd = usb_ctx->pd;
@@ -184,7 +184,7 @@ static int oz_usb_vendor_class_req(void *hpd, u8 req_id, u8 req_type,
  * Context: tasklet
  */
 int oz_usb_control_req(void *hpd, u8 req_id, struct usb_ctrlrequest *setup,
-			u8 *data, int data_len)
+			const u8 *data, int data_len)
 {
 	unsigned wvalue = le16_to_cpu(setup->wValue);
 	unsigned windex = le16_to_cpu(setup->wIndex);
-- 
1.7.8.6

