Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab3GDMhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:37:20 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:18686 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab3GDMfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:35:51 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <joe@perches.com>, <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH v2 1/5] staging: ozwpan: Remove extra debug logs.
Date: Thu, 4 Jul 2013 13:35:27 +0100
Message-ID: <1372941331-9586-2-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372255013.2076.4.camel@joe-AO722>
References: <1372255013.2076.4.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozcdev.c |    2 --
 drivers/staging/ozwpan/ozhcd.c  |   28 ++++++++--------------------
 2 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index 374fdc3..284c26d 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -73,7 +73,6 @@ static void oz_cdev_release_ctx(struct oz_serial_ctx *ctx)
 static int oz_cdev_open(struct inode *inode, struct file *filp)
 {
 	struct oz_cdev *dev;
-	oz_trace("oz_cdev_open()\n");
 	oz_trace("major = %d minor = %d\n", imajor(inode), iminor(inode));
 	dev = container_of(inode->i_cdev, struct oz_cdev, cdev);
 	filp->private_data = dev;
@@ -84,7 +83,6 @@ static int oz_cdev_open(struct inode *inode, struct file *filp)
  */
 static int oz_cdev_release(struct inode *inode, struct file *filp)
 {
-	oz_trace("oz_cdev_release()\n");
 	return 0;
 }
 /*------------------------------------------------------------------------------
diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index d68d63a..9d1bd44 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -394,7 +394,6 @@ static void oz_complete_urb(struct usb_hcd *hcd, struct urb *urb,
  */
 static void oz_ep_free(struct oz_port *port, struct oz_endpoint *ep)
 {
-	oz_trace("oz_ep_free()\n");
 	if (port) {
 		struct list_head list;
 		struct oz_hcd *ozhcd = port->ozhcd;
@@ -631,7 +630,6 @@ void *oz_hcd_pd_arrived(void *hpd)
 	void *hport = NULL;
 	struct oz_hcd *ozhcd = NULL;
 	struct oz_endpoint *ep;
-	oz_trace("oz_hcd_pd_arrived()\n");
 	ozhcd = oz_hcd_claim();
 	if (ozhcd == NULL)
 		return NULL;
@@ -691,7 +689,6 @@ void oz_hcd_pd_departed(void *hport)
 	void *hpd;
 	struct oz_endpoint *ep = NULL;
 
-	oz_trace("oz_hcd_pd_departed()\n");
 	if (port == NULL) {
 		oz_trace("oz_hcd_pd_departed() port = 0\n");
 		return;
@@ -1696,7 +1693,6 @@ static void oz_hcd_clear_orphanage(struct oz_hcd *ozhcd, int status)
  */
 static int oz_hcd_start(struct usb_hcd *hcd)
 {
-	oz_trace("oz_hcd_start()\n");
 	hcd->power_budget = 200;
 	hcd->state = HC_STATE_RUNNING;
 	hcd->uses_new_polling = 1;
@@ -1707,14 +1703,12 @@ static int oz_hcd_start(struct usb_hcd *hcd)
  */
 static void oz_hcd_stop(struct usb_hcd *hcd)
 {
-	oz_trace("oz_hcd_stop()\n");
 }
 /*------------------------------------------------------------------------------
  * Context: unknown
  */
 static void oz_hcd_shutdown(struct usb_hcd *hcd)
 {
-	oz_trace("oz_hcd_shutdown()\n");
 }
 /*------------------------------------------------------------------------------
  * Called to queue an urb for the device.
@@ -1844,7 +1838,6 @@ static int oz_hcd_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 static void oz_hcd_endpoint_disable(struct usb_hcd *hcd,
 				struct usb_host_endpoint *ep)
 {
-	oz_trace("oz_hcd_endpoint_disable\n");
 }
 /*------------------------------------------------------------------------------
  * Context: unknown
@@ -1852,7 +1845,6 @@ static void oz_hcd_endpoint_disable(struct usb_hcd *hcd,
 static void oz_hcd_endpoint_reset(struct usb_hcd *hcd,
 				struct usb_host_endpoint *ep)
 {
-	oz_trace("oz_hcd_endpoint_reset\n");
 }
 /*------------------------------------------------------------------------------
  * Context: unknown
@@ -1872,7 +1864,6 @@ static int oz_hcd_hub_status_data(struct usb_hcd *hcd, char *buf)
 	struct oz_hcd *ozhcd = oz_hcd_private(hcd);
 	int i;
 
-	oz_trace2(OZ_TRACE_HUB, "oz_hcd_hub_status_data()\n");
 	buf[0] = 0;
 
 	spin_lock_bh(&ozhcd->hcd_lock);
@@ -1892,7 +1883,6 @@ static int oz_hcd_hub_status_data(struct usb_hcd *hcd, char *buf)
 static void oz_get_hub_descriptor(struct usb_hcd *hcd,
 				struct usb_hub_descriptor *desc)
 {
-	oz_trace2(OZ_TRACE_HUB, "GetHubDescriptor\n");
 	memset(desc, 0, sizeof(*desc));
 	desc->bDescriptorType = 0x29;
 	desc->bDescLength = 9;
@@ -1911,7 +1901,7 @@ static int oz_set_port_feature(struct usb_hcd *hcd, u16 wvalue, u16 windex)
 	struct oz_hcd *ozhcd = oz_hcd_private(hcd);
 	unsigned set_bits = 0;
 	unsigned clear_bits = 0;
-	oz_trace2(OZ_TRACE_HUB, "SetPortFeature\n");
+
 	if ((port_id < 1) || (port_id > OZ_NB_PORTS))
 		return -EPIPE;
 	port = &ozhcd->ports[port_id-1];
@@ -1986,7 +1976,7 @@ static int oz_clear_port_feature(struct usb_hcd *hcd, u16 wvalue, u16 windex)
 	u8 port_id = (u8)windex;
 	struct oz_hcd *ozhcd = oz_hcd_private(hcd);
 	unsigned clear_bits = 0;
-	oz_trace2(OZ_TRACE_HUB, "ClearPortFeature\n");
+
 	if ((port_id < 1) || (port_id > OZ_NB_PORTS))
 		return -EPIPE;
 	port = &ozhcd->ports[port_id-1];
@@ -2074,7 +2064,7 @@ static int oz_hcd_hub_control(struct usb_hcd *hcd, u16 req_type, u16 wvalue,
 				u16 windex, char *buf, u16 wlength)
 {
 	int err = 0;
-	oz_trace2(OZ_TRACE_HUB, "oz_hcd_hub_control()\n");
+
 	switch (req_type) {
 	case ClearHubFeature:
 		oz_trace2(OZ_TRACE_HUB, "ClearHubFeature: %d\n", req_type);
@@ -2111,7 +2101,7 @@ static int oz_hcd_hub_control(struct usb_hcd *hcd, u16 req_type, u16 wvalue,
 static int oz_hcd_bus_suspend(struct usb_hcd *hcd)
 {
 	struct oz_hcd *ozhcd;
-	oz_trace2(OZ_TRACE_HUB, "oz_hcd_hub_suspend()\n");
+
 	ozhcd = oz_hcd_private(hcd);
 	spin_lock_bh(&ozhcd->hcd_lock);
 	hcd->state = HC_STATE_SUSPENDED;
@@ -2125,7 +2115,7 @@ static int oz_hcd_bus_suspend(struct usb_hcd *hcd)
 static int oz_hcd_bus_resume(struct usb_hcd *hcd)
 {
 	struct oz_hcd *ozhcd;
-	oz_trace2(OZ_TRACE_HUB, "oz_hcd_hub_resume()\n");
+
 	ozhcd = oz_hcd_private(hcd);
 	spin_lock_bh(&ozhcd->hcd_lock);
 	ozhcd->flags &= ~OZ_HDC_F_SUSPENDED;
@@ -2137,8 +2127,8 @@ static int oz_hcd_bus_resume(struct usb_hcd *hcd)
  */
 static void oz_plat_shutdown(struct platform_device *dev)
 {
-	oz_trace("oz_plat_shutdown()\n");
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -2148,7 +2138,7 @@ static int oz_plat_probe(struct platform_device *dev)
 	int err;
 	struct usb_hcd *hcd;
 	struct oz_hcd *ozhcd;
-	oz_trace("oz_plat_probe()\n");
+
 	hcd = usb_create_hcd(&g_oz_hc_drv, &dev->dev, dev_name(&dev->dev));
 	if (hcd == NULL) {
 		oz_trace("Failed to created hcd object OK\n");
@@ -2188,7 +2178,7 @@ static int oz_plat_remove(struct platform_device *dev)
 {
 	struct usb_hcd *hcd = platform_get_drvdata(dev);
 	struct oz_hcd *ozhcd;
-	oz_trace("oz_plat_remove()\n");
+
 	if (hcd == NULL)
 		return -1;
 	ozhcd = oz_hcd_private(hcd);
@@ -2209,7 +2199,6 @@ static int oz_plat_remove(struct platform_device *dev)
  */
 static int oz_plat_suspend(struct platform_device *dev, pm_message_t msg)
 {
-	oz_trace("oz_plat_suspend()\n");
 	return 0;
 }
 /*------------------------------------------------------------------------------
@@ -2217,7 +2206,6 @@ static int oz_plat_suspend(struct platform_device *dev, pm_message_t msg)
  */
 static int oz_plat_resume(struct platform_device *dev)
 {
-	oz_trace("oz_plat_resume()\n");
 	return 0;
 }
 /*------------------------------------------------------------------------------
-- 
1.7.9.5

