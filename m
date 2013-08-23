Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab3HWPLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:11:30 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:51024 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327Ab3HWPL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:11:28 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <sergei.shtylyov@cogentembedded.com>, <dan.carpenter@oracle.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 3/3] staging: ozwpan: Fix Documentation style.
Date: Fri, 23 Aug 2013 16:11:02 +0100
Message-ID: <1377270662-10379-3-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377270662-10379-1-git-send-email-rupesh.gujare@atmel.com>
References: <1377270662-10379-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes Kernel Documentation style.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozcdev.c        |   40 +++++-----
 drivers/staging/ozwpan/ozeltbuf.c      |   27 ++-----
 drivers/staging/ozwpan/ozhcd.c         |  134 ++++++++++++++++----------------
 drivers/staging/ozwpan/ozmain.c        |    8 +-
 drivers/staging/ozwpan/ozpd.c          |   82 ++++++++++---------
 drivers/staging/ozwpan/ozproto.c       |   56 ++++++-------
 drivers/staging/ozwpan/ozurbparanoia.c |    6 +-
 drivers/staging/ozwpan/ozusbsvc.c      |   20 ++---
 drivers/staging/ozwpan/ozusbsvc1.c     |   24 +++---
 9 files changed, 179 insertions(+), 218 deletions(-)

diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index 01673d4..03b41ee 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -18,8 +18,7 @@
 #include "ozpd.h"
 #include "ozproto.h"
 #include "ozcdev.h"
-/*------------------------------------------------------------------------------
- */
+
 #define OZ_RD_BUF_SZ	256
 struct oz_cdev {
 	dev_t devnum;
@@ -39,12 +38,11 @@ struct oz_serial_ctx {
 	int rd_in;
 	int rd_out;
 };
-/*------------------------------------------------------------------------------
- */
+
 static struct oz_cdev g_cdev;
 static struct class *g_oz_class;
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process and softirq
  */
 static struct oz_serial_ctx *oz_cdev_claim_ctx(struct oz_pd *pd)
@@ -59,7 +57,7 @@ static struct oz_serial_ctx *oz_cdev_claim_ctx(struct oz_pd *pd)
 	return ctx;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq or process
  */
 static void oz_cdev_release_ctx(struct oz_serial_ctx *ctx)
@@ -70,7 +68,7 @@ static void oz_cdev_release_ctx(struct oz_serial_ctx *ctx)
 	}
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 static int oz_cdev_open(struct inode *inode, struct file *filp)
@@ -83,7 +81,7 @@ static int oz_cdev_open(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 static int oz_cdev_release(struct inode *inode, struct file *filp)
@@ -91,7 +89,7 @@ static int oz_cdev_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 static ssize_t oz_cdev_read(struct file *filp, char __user *buf, size_t count,
@@ -144,7 +142,7 @@ out2:
 	return count;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 static ssize_t oz_cdev_write(struct file *filp, const char __user *buf,
@@ -202,7 +200,7 @@ out:
 	return count;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 static int oz_set_active_pd(const u8 *addr)
@@ -237,7 +235,7 @@ static int oz_set_active_pd(const u8 *addr)
 	return rc;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 static long oz_cdev_ioctl(struct file *filp, unsigned int cmd,
@@ -305,7 +303,7 @@ static long oz_cdev_ioctl(struct file *filp, unsigned int cmd,
 	return rc;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 static unsigned int oz_cdev_poll(struct file *filp, poll_table *wait)
@@ -329,7 +327,7 @@ static unsigned int oz_cdev_poll(struct file *filp, poll_table *wait)
 	return ret;
 }
 
-/*------------------------------------------------------------------------------
+/*
  */
 static const struct file_operations oz_fops = {
 	.owner =	THIS_MODULE,
@@ -341,7 +339,7 @@ static const struct file_operations oz_fops = {
 	.poll =		oz_cdev_poll
 };
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 int oz_cdev_register(void)
@@ -386,7 +384,7 @@ unregister:
 	return err;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 int oz_cdev_deregister(void)
@@ -400,7 +398,7 @@ int oz_cdev_deregister(void)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 int oz_cdev_init(void)
@@ -409,7 +407,7 @@ int oz_cdev_init(void)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 void oz_cdev_term(void)
@@ -417,7 +415,7 @@ void oz_cdev_term(void)
 	oz_app_enable(OZ_APPID_SERIAL, 0);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq-serialized
  */
 int oz_cdev_start(struct oz_pd *pd, int resume)
@@ -455,7 +453,7 @@ int oz_cdev_start(struct oz_pd *pd, int resume)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq or process
  */
 void oz_cdev_stop(struct oz_pd *pd, int pause)
@@ -485,7 +483,7 @@ void oz_cdev_stop(struct oz_pd *pd, int pause)
 	oz_dbg(ON, "Serial service stopped\n");
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq-serialized
  */
 void oz_cdev_rx(struct oz_pd *pd, struct oz_elt *elt)
diff --git a/drivers/staging/ozwpan/ozeltbuf.c b/drivers/staging/ozwpan/ozeltbuf.c
index cfc0f39..9b86486 100644
--- a/drivers/staging/ozwpan/ozeltbuf.c
+++ b/drivers/staging/ozwpan/ozeltbuf.c
@@ -11,11 +11,10 @@
 #include "ozeltbuf.h"
 #include "ozpd.h"
 
-/*------------------------------------------------------------------------------
- */
 #define OZ_ELT_INFO_MAGIC_USED	0x35791057
 #define OZ_ELT_INFO_MAGIC_FREE	0x78940102
-/*------------------------------------------------------------------------------
+
+/*
  * Context: softirq-serialized
  */
 int oz_elt_buf_init(struct oz_elt_buf *buf)
@@ -29,7 +28,7 @@ int oz_elt_buf_init(struct oz_elt_buf *buf)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq or process
  */
 void oz_elt_buf_term(struct oz_elt_buf *buf)
@@ -62,7 +61,7 @@ void oz_elt_buf_term(struct oz_elt_buf *buf)
 	buf->free_elts = 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq or process
  */
 struct oz_elt_info *oz_elt_info_alloc(struct oz_elt_buf *buf)
@@ -96,7 +95,7 @@ struct oz_elt_info *oz_elt_info_alloc(struct oz_elt_buf *buf)
 	return ei;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Precondition: oz_elt_buf.lock must be held.
  * Context: softirq or process
  */
@@ -133,8 +132,6 @@ void oz_elt_info_free_chain(struct oz_elt_buf *buf, struct list_head *list)
 	spin_unlock_bh(&buf->lock);
 }
 
-/*------------------------------------------------------------------------------
- */
 int oz_elt_stream_create(struct oz_elt_buf *buf, u8 id, int max_buf_count)
 {
 	struct oz_elt_stream *st;
@@ -154,8 +151,6 @@ int oz_elt_stream_create(struct oz_elt_buf *buf, u8 id, int max_buf_count)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
- */
 int oz_elt_stream_delete(struct oz_elt_buf *buf, u8 id)
 {
 	struct list_head *e;
@@ -194,15 +189,11 @@ int oz_elt_stream_delete(struct oz_elt_buf *buf, u8 id)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
- */
 void oz_elt_stream_get(struct oz_elt_stream *st)
 {
 	atomic_inc(&st->ref_count);
 }
 
-/*------------------------------------------------------------------------------
- */
 void oz_elt_stream_put(struct oz_elt_stream *st)
 {
 	if (atomic_dec_and_test(&st->ref_count)) {
@@ -211,7 +202,7 @@ void oz_elt_stream_put(struct oz_elt_stream *st)
 	}
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Precondition: Element buffer lock must be held.
  * If this function fails the caller is responsible for deallocating the elt
  * info structure.
@@ -275,8 +266,6 @@ int oz_queue_elt_info(struct oz_elt_buf *buf, u8 isoc, u8 id,
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
- */
 int oz_select_elts_for_tx(struct oz_elt_buf *buf, u8 isoc, unsigned *len,
 		unsigned max_len, struct list_head *list)
 {
@@ -322,15 +311,11 @@ int oz_select_elts_for_tx(struct oz_elt_buf *buf, u8 isoc, unsigned *len,
 	return count;
 }
 
-/*------------------------------------------------------------------------------
- */
 int oz_are_elts_available(struct oz_elt_buf *buf)
 {
 	return buf->order_list.next != &buf->order_list;
 }
 
-/*------------------------------------------------------------------------------
- */
 void oz_trim_elt_pool(struct oz_elt_buf *buf)
 {
 	struct list_head *free = NULL;
diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index d5a3900..ab93b74 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -35,7 +35,7 @@
 #include "ozurbparanoia.h"
 #include "ozhcd.h"
 
-/*------------------------------------------------------------------------------
+/*
  * Number of units of buffering to capture for an isochronous IN endpoint before
  * allowing data to be indicated up.
  */
@@ -57,7 +57,7 @@
  */
 #define EP0_TIMEOUT_COUNTER 13
 
-/*------------------------------------------------------------------------------
+/*
  * Used to link urbs together and also store some status information for each
  * urb.
  * A cache of these are kept in a pool to reduce number of calls to kmalloc.
@@ -144,7 +144,7 @@ struct oz_hcd {
  */
 #define OZ_HDC_F_SUSPENDED	0x1
 
-/*------------------------------------------------------------------------------
+/*
  * Static function prototypes.
  */
 static int oz_hcd_start(struct usb_hcd *hcd);
@@ -185,7 +185,7 @@ static struct oz_urb_link *oz_remove_urb(struct oz_endpoint *ep,
 		struct urb *urb);
 static void oz_hcd_clear_orphanage(struct oz_hcd *ozhcd, int status);
 
-/*------------------------------------------------------------------------------
+/*
  * Static external variables.
  */
 static struct platform_device *g_plat_dev;
@@ -231,7 +231,7 @@ static struct platform_driver g_oz_plat_drv = {
 	},
 };
 
-/*------------------------------------------------------------------------------
+/*
  * Gets our private context area (which is of type struct oz_hcd) from the
  * usb_hcd structure.
  * Context: any
@@ -241,7 +241,7 @@ static inline struct oz_hcd *oz_hcd_private(struct usb_hcd *hcd)
 	return (struct oz_hcd *)hcd->hcd_priv;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Searches list of ports to find the index of the one with a specified  USB
  * bus address. If none of the ports has the bus address then the connection
  * port is returned, if there is one or -1 otherwise.
@@ -258,7 +258,7 @@ static int oz_get_port_from_addr(struct oz_hcd *ozhcd, u8 bus_addr)
 	return ozhcd->conn_port;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Allocates an urb link, first trying the pool but going to heap if empty.
  * Context: any
  */
@@ -279,7 +279,7 @@ static struct oz_urb_link *oz_alloc_urb_link(void)
 	return urbl;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Frees an urb link by putting it in the pool if there is enough space or
  * deallocating it to heap otherwise.
  * Context: any
@@ -300,7 +300,7 @@ static void oz_free_urb_link(struct oz_urb_link *urbl)
 	}
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Deallocates all the urb links in the pool.
  * Context: unknown
  */
@@ -322,7 +322,7 @@ static void oz_empty_link_pool(void)
 	}
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Allocates endpoint structure and optionally a buffer. If a buffer is
  * allocated it immediately follows the endpoint structure.
  * Context: softirq
@@ -343,7 +343,7 @@ static struct oz_endpoint *oz_ep_alloc(int buffer_size, gfp_t mem_flags)
 	return ep;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Pre-condition: Must be called with g_tasklet_lock held and interrupts
  * disabled.
  * Context: softirq or process
@@ -363,7 +363,7 @@ static struct oz_urb_link *oz_uncancel_urb(struct oz_hcd *ozhcd, struct urb *urb
 	return NULL;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * This is called when we have finished processing an urb. It unlinks it from
  * the ep and returns it to the core.
  * Context: softirq or process
@@ -407,7 +407,7 @@ static void oz_complete_urb(struct usb_hcd *hcd, struct urb *urb,
 		oz_free_urb_link(cancel_urbl);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Deallocates an endpoint including deallocating any associated stream and
  * returning any queued urbs to the core.
  * Context: softirq
@@ -432,7 +432,7 @@ static void oz_ep_free(struct oz_port *port, struct oz_endpoint *ep)
 	kfree(ep);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 static void oz_complete_buffered_urb(struct oz_port *port,
@@ -471,7 +471,7 @@ static void oz_complete_buffered_urb(struct oz_port *port,
 	oz_complete_urb(port->ozhcd->hcd, urb, 0);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 static int oz_enqueue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
@@ -543,7 +543,7 @@ out:
 	return err;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Removes an urb from the queue in the endpoint.
  * Returns 0 if it is found and -EIDRM otherwise.
  * Context: softirq
@@ -576,7 +576,7 @@ static int oz_dequeue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
 	return urbl ? 0 : -EIDRM;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Finds an urb given its request id.
  * Context: softirq
  */
@@ -609,7 +609,7 @@ static struct urb *oz_find_urb_by_id(struct oz_port *port, int ep_ix,
 	return urb;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Pre-condition: Port lock must be held.
  * Context: softirq
  */
@@ -624,7 +624,7 @@ static void oz_acquire_port(struct oz_port *port, void *hpd)
 	port->hpd = hpd;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 static struct oz_hcd *oz_hcd_claim(void)
@@ -639,7 +639,7 @@ static struct oz_hcd *oz_hcd_claim(void)
 	return ozhcd;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 static inline void oz_hcd_put(struct oz_hcd *ozhcd)
@@ -648,7 +648,7 @@ static inline void oz_hcd_put(struct oz_hcd *ozhcd)
 		usb_put_hcd(ozhcd->hcd);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * This is called by the protocol handler to notify that a PD has arrived.
  * We allocate a port to associate with the PD and create a structure for
  * endpoint 0. This port is made the connection port.
@@ -714,7 +714,7 @@ err_put:
 	return NULL;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * This is called by the protocol handler to notify that the PD has gone away.
  * We need to deallocate all resources and then request that the root hub is
  * polled. We release the reference we hold on the PD.
@@ -770,7 +770,7 @@ void oz_hcd_pd_departed(struct oz_port *port)
 	oz_usb_put(hpd);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 void oz_hcd_pd_reset(void *hpd, void *hport)
@@ -790,7 +790,7 @@ void oz_hcd_pd_reset(void *hpd, void *hport)
 	usb_hcd_poll_rh_status(ozhcd->hcd);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 void oz_hcd_get_desc_cnf(void *hport, u8 req_id, int status, const u8 *desc,
@@ -836,7 +836,7 @@ void oz_hcd_get_desc_cnf(void *hport, u8 req_id, int status, const u8 *desc,
 	oz_complete_urb(port->ozhcd->hcd, urb, 0);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 static void oz_display_conf_type(u8 t)
@@ -878,7 +878,7 @@ static void oz_display_conf_type(u8 t)
 	}
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 static void oz_hcd_complete_set_config(struct oz_port *port, struct urb *urb,
@@ -900,7 +900,7 @@ static void oz_hcd_complete_set_config(struct oz_port *port, struct urb *urb,
 	oz_complete_urb(hcd, urb, rc);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 static void oz_hcd_complete_set_interface(struct oz_port *port, struct urb *urb,
@@ -927,7 +927,7 @@ static void oz_hcd_complete_set_interface(struct oz_port *port, struct urb *urb,
 	oz_complete_urb(hcd, urb, rc);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 void oz_hcd_control_cnf(void *hport, u8 req_id, u8 rcode, const u8 *data,
@@ -980,7 +980,7 @@ void oz_hcd_control_cnf(void *hport, u8 req_id, u8 rcode, const u8 *data,
 	}
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq-serialized
  */
 static int oz_hcd_buffer_data(struct oz_endpoint *ep, const u8 *data,
@@ -1018,7 +1018,7 @@ static int oz_hcd_buffer_data(struct oz_endpoint *ep, const u8 *data,
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq-serialized
  */
 void oz_hcd_data_ind(void *hport, u8 endpoint, const u8 *data, int data_len)
@@ -1065,7 +1065,7 @@ done:
 	spin_unlock_bh(&ozhcd->hcd_lock);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: unknown
  */
 static inline int oz_usb_get_frame_number(void)
@@ -1073,7 +1073,7 @@ static inline int oz_usb_get_frame_number(void)
 	return atomic_inc_return(&g_usb_frame_number);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 int oz_hcd_heartbeat(void *hport)
@@ -1234,7 +1234,7 @@ int oz_hcd_heartbeat(void *hport)
 	return rc;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 static int oz_build_endpoints_for_interface(struct usb_hcd *hcd,
@@ -1315,7 +1315,7 @@ static int oz_build_endpoints_for_interface(struct usb_hcd *hcd,
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 static void oz_clean_endpoints_for_interface(struct usb_hcd *hcd,
@@ -1361,7 +1361,7 @@ static void oz_clean_endpoints_for_interface(struct usb_hcd *hcd,
 	}
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 static int oz_build_endpoints_for_config(struct usb_hcd *hcd,
@@ -1397,7 +1397,7 @@ fail:
 	return -1;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 static void oz_clean_endpoints_for_config(struct usb_hcd *hcd,
@@ -1419,7 +1419,7 @@ static void oz_clean_endpoints_for_config(struct usb_hcd *hcd,
 	spin_unlock_bh(&ozhcd->hcd_lock);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: tasklet
  */
 static void *oz_claim_hpd(struct oz_port *port)
@@ -1435,7 +1435,7 @@ static void *oz_claim_hpd(struct oz_port *port)
 	return hpd;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: tasklet
  */
 static void oz_process_ep0_urb(struct oz_hcd *ozhcd, struct urb *urb,
@@ -1582,7 +1582,7 @@ out:
 	}
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: tasklet
  */
 static int oz_urb_process(struct oz_hcd *ozhcd, struct urb *urb)
@@ -1617,7 +1617,7 @@ static int oz_urb_process(struct oz_hcd *ozhcd, struct urb *urb)
 	return rc;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: tasklet
  */
 static void oz_urb_process_tasklet(unsigned long unused)
@@ -1651,7 +1651,7 @@ static void oz_urb_process_tasklet(unsigned long unused)
 	oz_hcd_put(ozhcd);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * This function searches for the urb in any of the lists it could be in.
  * If it is found it is removed from the list and completed. If the urb is
  * being processed then it won't be in a list so won't be found. However, the
@@ -1719,7 +1719,7 @@ out2:
 	}
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: tasklet
  */
 static void oz_urb_cancel_tasklet(unsigned long unused)
@@ -1747,7 +1747,7 @@ static void oz_urb_cancel_tasklet(unsigned long unused)
 	oz_hcd_put(ozhcd);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: unknown
  */
 static void oz_hcd_clear_orphanage(struct oz_hcd *ozhcd, int status)
@@ -1764,7 +1764,7 @@ static void oz_hcd_clear_orphanage(struct oz_hcd *ozhcd, int status)
 	}
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: unknown
  */
 static int oz_hcd_start(struct usb_hcd *hcd)
@@ -1775,21 +1775,21 @@ static int oz_hcd_start(struct usb_hcd *hcd)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: unknown
  */
 static void oz_hcd_stop(struct usb_hcd *hcd)
 {
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: unknown
  */
 static void oz_hcd_shutdown(struct usb_hcd *hcd)
 {
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Called to queue an urb for the device.
  * This function should return a non-zero error code if it fails the urb but
  * should not call usb_hcd_giveback_urb().
@@ -1847,7 +1847,7 @@ static int oz_hcd_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: tasklet
  */
 static struct oz_urb_link *oz_remove_urb(struct oz_endpoint *ep,
@@ -1873,7 +1873,7 @@ static struct oz_urb_link *oz_remove_urb(struct oz_endpoint *ep,
 	return NULL;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Called to dequeue a previously submitted urb for the device.
  * Context: any
  */
@@ -1915,7 +1915,7 @@ static int oz_hcd_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 	return rc;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: unknown
  */
 static void oz_hcd_endpoint_disable(struct usb_hcd *hcd,
@@ -1923,7 +1923,7 @@ static void oz_hcd_endpoint_disable(struct usb_hcd *hcd,
 {
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: unknown
  */
 static void oz_hcd_endpoint_reset(struct usb_hcd *hcd,
@@ -1931,7 +1931,7 @@ static void oz_hcd_endpoint_reset(struct usb_hcd *hcd,
 {
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: unknown
  */
 static int oz_hcd_get_frame_number(struct usb_hcd *hcd)
@@ -1940,7 +1940,7 @@ static int oz_hcd_get_frame_number(struct usb_hcd *hcd)
 	return oz_usb_get_frame_number();
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  * This is called as a consquence of us calling usb_hcd_poll_rh_status() and we
  * always do that in softirq context.
@@ -1971,7 +1971,7 @@ static int oz_hcd_hub_status_data(struct usb_hcd *hcd, char *buf)
 		return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 static void oz_get_hub_descriptor(struct usb_hcd *hcd,
@@ -1985,7 +1985,7 @@ static void oz_get_hub_descriptor(struct usb_hcd *hcd,
 	desc->bNbrPorts = OZ_NB_PORTS;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 static int oz_set_port_feature(struct usb_hcd *hcd, u16 wvalue, u16 windex)
@@ -2061,7 +2061,7 @@ static int oz_set_port_feature(struct usb_hcd *hcd, u16 wvalue, u16 windex)
 	return err;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 static int oz_clear_port_feature(struct usb_hcd *hcd, u16 wvalue, u16 windex)
@@ -2137,7 +2137,7 @@ static int oz_clear_port_feature(struct usb_hcd *hcd, u16 wvalue, u16 windex)
 	return err;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 static int oz_get_port_status(struct usb_hcd *hcd, u16 windex, char *buf)
@@ -2155,7 +2155,7 @@ static int oz_get_port_status(struct usb_hcd *hcd, u16 windex, char *buf)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 static int oz_hcd_hub_control(struct usb_hcd *hcd, u16 req_type, u16 wvalue,
@@ -2193,7 +2193,7 @@ static int oz_hcd_hub_control(struct usb_hcd *hcd, u16 req_type, u16 wvalue,
 	return err;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 static int oz_hcd_bus_suspend(struct usb_hcd *hcd)
@@ -2208,7 +2208,7 @@ static int oz_hcd_bus_suspend(struct usb_hcd *hcd)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 static int oz_hcd_bus_resume(struct usb_hcd *hcd)
@@ -2223,13 +2223,11 @@ static int oz_hcd_bus_resume(struct usb_hcd *hcd)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
- */
 static void oz_plat_shutdown(struct platform_device *dev)
 {
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 static int oz_plat_probe(struct platform_device *dev)
@@ -2272,7 +2270,7 @@ static int oz_plat_probe(struct platform_device *dev)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: unknown
  */
 static int oz_plat_remove(struct platform_device *dev)
@@ -2296,7 +2294,7 @@ static int oz_plat_remove(struct platform_device *dev)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: unknown
  */
 static int oz_plat_suspend(struct platform_device *dev, pm_message_t msg)
@@ -2305,7 +2303,7 @@ static int oz_plat_suspend(struct platform_device *dev, pm_message_t msg)
 }
 
 
-/*------------------------------------------------------------------------------
+/*
  * Context: unknown
  */
 static int oz_plat_resume(struct platform_device *dev)
@@ -2313,7 +2311,7 @@ static int oz_plat_resume(struct platform_device *dev)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 int oz_hcd_init(void)
@@ -2350,7 +2348,7 @@ error:
 	return err;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 void oz_hcd_term(void)
diff --git a/drivers/staging/ozwpan/ozmain.c b/drivers/staging/ozwpan/ozmain.c
index 707ab28..d1a5b7a 100644
--- a/drivers/staging/ozwpan/ozmain.c
+++ b/drivers/staging/ozwpan/ozmain.c
@@ -18,7 +18,7 @@
 
 unsigned int oz_dbg_mask = OZ_DEFAULT_DBG_MASK;
 
-/*------------------------------------------------------------------------------
+/*
  * The name of the 802.11 mac device. Empty string is the default value but a
  * value can be supplied as a parameter to the module. An empty string means
  * bind to nothing. '*' means bind to all netcards - this includes non-802.11
@@ -26,7 +26,7 @@ unsigned int oz_dbg_mask = OZ_DEFAULT_DBG_MASK;
  */
 static char *g_net_dev = "";
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 static int __init ozwpan_init(void)
@@ -38,7 +38,7 @@ static int __init ozwpan_init(void)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 static void __exit ozwpan_exit(void)
@@ -48,8 +48,6 @@ static void __exit ozwpan_exit(void)
 	oz_cdev_deregister();
 }
 
-/*------------------------------------------------------------------------------
- */
 module_param(g_net_dev, charp, S_IRUGO);
 module_init(ozwpan_init);
 module_exit(ozwpan_exit);
diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index d39a3df..daaff2a 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -21,12 +21,8 @@
 #include <linux/uaccess.h>
 #include <net/psnap.h>
 
-/*------------------------------------------------------------------------------
- */
 #define OZ_MAX_TX_POOL_SIZE	6
 
-/*------------------------------------------------------------------------------
- */
 static struct oz_tx_frame *oz_tx_frame_alloc(struct oz_pd *pd);
 static void oz_tx_frame_free(struct oz_pd *pd, struct oz_tx_frame *f);
 static void oz_tx_isoc_free(struct oz_pd *pd, struct oz_tx_frame *f);
@@ -42,7 +38,7 @@ static int oz_def_app_start(struct oz_pd *pd, int resume);
 static void oz_def_app_stop(struct oz_pd *pd, int pause);
 static void oz_def_app_rx(struct oz_pd *pd, struct oz_elt *elt);
 
-/*------------------------------------------------------------------------------
+/*
  * Counts the uncompleted isoc frames submitted to netcard.
  */
 static atomic_t g_submitted_isoc = ATOMIC_INIT(0);
@@ -87,7 +83,7 @@ static const struct oz_app_if g_app_if[OZ_APPID_MAX] = {
 	OZ_APPID_SERIAL},
 };
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 static int oz_def_app_init(void)
@@ -95,14 +91,14 @@ static int oz_def_app_init(void)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 static void oz_def_app_term(void)
 {
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 static int oz_def_app_start(struct oz_pd *pd, int resume)
@@ -110,21 +106,21 @@ static int oz_def_app_start(struct oz_pd *pd, int resume)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 static void oz_def_app_stop(struct oz_pd *pd, int pause)
 {
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 static void oz_def_app_rx(struct oz_pd *pd, struct oz_elt *elt)
 {
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq or process
  */
 void oz_pd_set_state(struct oz_pd *pd, unsigned state)
@@ -146,7 +142,7 @@ void oz_pd_set_state(struct oz_pd *pd, unsigned state)
 	}
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq or process
  */
 void oz_pd_get(struct oz_pd *pd)
@@ -154,7 +150,7 @@ void oz_pd_get(struct oz_pd *pd)
 	atomic_inc(&pd->ref_count);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq or process
  */
 void oz_pd_put(struct oz_pd *pd)
@@ -163,7 +159,7 @@ void oz_pd_put(struct oz_pd *pd)
 		oz_pd_destroy(pd);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq-serialized
  */
 struct oz_pd *oz_pd_alloc(const u8 *mac_addr)
@@ -201,7 +197,7 @@ struct oz_pd *oz_pd_alloc(const u8 *mac_addr)
 	return pd;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq or process
  */
 void oz_pd_free(struct work_struct *work)
@@ -256,7 +252,7 @@ void oz_pd_free(struct work_struct *work)
 	kfree(pd);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq or Process
  */
 void oz_pd_destroy(struct oz_pd *pd)
@@ -271,7 +267,7 @@ void oz_pd_destroy(struct oz_pd *pd)
 		oz_pd_dbg(pd, ON, "failed to schedule workitem\n");
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq-serialized
  */
 int oz_services_start(struct oz_pd *pd, u16 apps, int resume)
@@ -299,7 +295,7 @@ int oz_services_start(struct oz_pd *pd, u16 apps, int resume)
 	return rc;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq or process
  */
 void oz_services_stop(struct oz_pd *pd, u16 apps, int pause)
@@ -322,7 +318,7 @@ void oz_services_stop(struct oz_pd *pd, u16 apps, int pause)
 	}
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 void oz_pd_heartbeat(struct oz_pd *pd, u16 apps)
@@ -345,7 +341,7 @@ void oz_pd_heartbeat(struct oz_pd *pd, u16 apps)
 	}
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq or process
  */
 void oz_pd_stop(struct oz_pd *pd)
@@ -369,7 +365,7 @@ void oz_pd_stop(struct oz_pd *pd)
 	oz_pd_put(pd);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 int oz_pd_sleep(struct oz_pd *pd)
@@ -398,7 +394,7 @@ int oz_pd_sleep(struct oz_pd *pd)
 	return do_stop;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 static struct oz_tx_frame *oz_tx_frame_alloc(struct oz_pd *pd)
@@ -422,7 +418,7 @@ static struct oz_tx_frame *oz_tx_frame_alloc(struct oz_pd *pd)
 	return f;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq or process
  */
 static void oz_tx_isoc_free(struct oz_pd *pd, struct oz_tx_frame *f)
@@ -440,7 +436,7 @@ static void oz_tx_isoc_free(struct oz_pd *pd, struct oz_tx_frame *f)
 	       pd->nb_queued_isoc_frames);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq or process
  */
 static void oz_tx_frame_free(struct oz_pd *pd, struct oz_tx_frame *f)
@@ -456,7 +452,7 @@ static void oz_tx_frame_free(struct oz_pd *pd, struct oz_tx_frame *f)
 	kfree(f);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq-serialized
  */
 static void oz_set_more_bit(struct sk_buff *skb)
@@ -466,7 +462,7 @@ static void oz_set_more_bit(struct sk_buff *skb)
 	oz_hdr->control |= OZ_F_MORE_DATA;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq-serialized
  */
 static void oz_set_last_pkt_nb(struct oz_pd *pd, struct sk_buff *skb)
@@ -476,7 +472,7 @@ static void oz_set_last_pkt_nb(struct oz_pd *pd, struct sk_buff *skb)
 	oz_hdr->last_pkt_num = pd->trigger_pkt_num & OZ_LAST_PN_MASK;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 int oz_prepare_frame(struct oz_pd *pd, int empty)
@@ -508,7 +504,7 @@ int oz_prepare_frame(struct oz_pd *pd, int empty)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq-serialized
  */
 static struct sk_buff *oz_build_frame(struct oz_pd *pd, struct oz_tx_frame *f)
@@ -554,7 +550,7 @@ fail:
 	return NULL;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq or process
  */
 static void oz_retire_frame(struct oz_pd *pd, struct oz_tx_frame *f)
@@ -578,7 +574,7 @@ static void oz_retire_frame(struct oz_pd *pd, struct oz_tx_frame *f)
 		oz_trim_elt_pool(&pd->elt_buff);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq-serialized
  */
 static int oz_send_next_queued_frame(struct oz_pd *pd, int more_data)
@@ -633,7 +629,7 @@ static int oz_send_next_queued_frame(struct oz_pd *pd, int more_data)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq-serialized
  */
 void oz_send_queued_frames(struct oz_pd *pd, int backlog)
@@ -672,7 +668,7 @@ out:	oz_prepare_frame(pd, 1);
 	oz_send_next_queued_frame(pd, 0);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 static int oz_send_isoc_frame(struct oz_pd *pd)
@@ -722,7 +718,7 @@ static int oz_send_isoc_frame(struct oz_pd *pd)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq-serialized
  */
 void oz_retire_tx_frames(struct oz_pd *pd, u8 lpn)
@@ -764,7 +760,7 @@ void oz_retire_tx_frames(struct oz_pd *pd, u8 lpn)
 	}
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Precondition: stream_lock must be held.
  * Context: softirq
  */
@@ -781,7 +777,7 @@ static struct oz_isoc_stream *pd_stream_find(struct oz_pd *pd, u8 ep_num)
 	return NULL;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 int oz_isoc_stream_create(struct oz_pd *pd, u8 ep_num)
@@ -801,7 +797,7 @@ int oz_isoc_stream_create(struct oz_pd *pd, u8 ep_num)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq or process
  */
 static void oz_isoc_stream_free(struct oz_isoc_stream *st)
@@ -810,7 +806,7 @@ static void oz_isoc_stream_free(struct oz_isoc_stream *st)
 	kfree(st);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 int oz_isoc_stream_delete(struct oz_pd *pd, u8 ep_num)
@@ -827,7 +823,7 @@ int oz_isoc_stream_delete(struct oz_pd *pd, u8 ep_num)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: any
  */
 static void oz_isoc_destructor(struct sk_buff *skb)
@@ -835,7 +831,7 @@ static void oz_isoc_destructor(struct sk_buff *skb)
 	atomic_dec(&g_submitted_isoc);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 int oz_send_isoc_unit(struct oz_pd *pd, u8 ep_num, const u8 *data, int len)
@@ -957,7 +953,7 @@ out:	kfree_skb(skb);
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 void oz_apps_init(void)
@@ -969,7 +965,7 @@ void oz_apps_init(void)
 			g_app_if[i].init();
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 void oz_apps_term(void)
@@ -982,7 +978,7 @@ void oz_apps_term(void)
 			g_app_if[i].term();
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq-serialized
  */
 void oz_handle_app_elt(struct oz_pd *pd, u8 app_id, struct oz_elt *elt)
@@ -995,7 +991,7 @@ void oz_handle_app_elt(struct oz_pd *pd, u8 app_id, struct oz_elt *elt)
 	ai->rx(pd, elt);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq or process
  */
 void oz_pd_indicate_farewells(struct oz_pd *pd)
diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index d8ac823..88714ec 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -23,8 +23,6 @@
 #include <linux/uaccess.h>
 #include <net/psnap.h>
 
-/*------------------------------------------------------------------------------
- */
 #define OZ_CF_CONN_SUCCESS	1
 #define OZ_CF_CONN_FAILURE	2
 
@@ -33,15 +31,13 @@
 
 #define OZ_MAX_TIMER_POOL_SIZE	16
 
-/*------------------------------------------------------------------------------
- */
 struct oz_binding {
 	struct packet_type ptype;
 	char name[OZ_MAX_BINDING_LEN];
 	struct list_head link;
 };
 
-/*------------------------------------------------------------------------------
+/*
  * Static external variables.
  */
 static DEFINE_SPINLOCK(g_polling_lock);
@@ -53,7 +49,7 @@ static u8 g_session_id;
 static u16 g_apps = 0x1;
 static int g_processing_rx;
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq-serialized
  */
 static u8 oz_get_new_session_id(u8 exclude)
@@ -67,7 +63,7 @@ static u8 oz_get_new_session_id(u8 exclude)
 	return g_session_id;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq-serialized
  */
 static void oz_send_conn_rsp(struct oz_pd *pd, u8 status)
@@ -113,7 +109,7 @@ static void oz_send_conn_rsp(struct oz_pd *pd, u8 status)
 	return;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq-serialized
  */
 static void pd_set_keepalive(struct oz_pd *pd, u8 kalive)
@@ -139,7 +135,7 @@ static void pd_set_keepalive(struct oz_pd *pd, u8 kalive)
 	oz_dbg(ON, "Keepalive = %lu mSec\n", pd->keep_alive);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq-serialized
  */
 static void pd_set_presleep(struct oz_pd *pd, u8 presleep, u8 start_timer)
@@ -156,7 +152,7 @@ static void pd_set_presleep(struct oz_pd *pd, u8 presleep, u8 start_timer)
 	oz_dbg(ON, "Presleep time = %lu mSec\n", pd->presleep);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq-serialized
  */
 static struct oz_pd *oz_connect_req(struct oz_pd *cur_pd, struct oz_elt *elt,
@@ -291,7 +287,7 @@ done:
 	return pd;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq-serialized
  */
 static void oz_add_farewell(struct oz_pd *pd, u8 ep_num, u8 index,
@@ -323,7 +319,7 @@ static void oz_add_farewell(struct oz_pd *pd, u8 ep_num, u8 index,
 		kfree(f2);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq-serialized
  */
 static void oz_rx_frame(struct sk_buff *skb)
@@ -445,7 +441,7 @@ done:
 	consume_skb(skb);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 void oz_protocol_term(void)
@@ -483,7 +479,7 @@ void oz_protocol_term(void)
 	oz_dbg(ON, "Protocol stopped\n");
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 void oz_pd_heartbeat_handler(unsigned long data)
@@ -500,7 +496,7 @@ void oz_pd_heartbeat_handler(unsigned long data)
 	oz_pd_put(pd);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 void oz_pd_timeout_handler(unsigned long data)
@@ -522,7 +518,7 @@ void oz_pd_timeout_handler(unsigned long data)
 	oz_pd_put(pd);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: Interrupt
  */
 enum hrtimer_restart oz_pd_heartbeat_event(struct hrtimer *timer)
@@ -537,7 +533,7 @@ enum hrtimer_restart oz_pd_heartbeat_event(struct hrtimer *timer)
 	return HRTIMER_RESTART;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: Interrupt
  */
 enum hrtimer_restart oz_pd_timeout_event(struct hrtimer *timer)
@@ -550,7 +546,7 @@ enum hrtimer_restart oz_pd_timeout_event(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq or process
  */
 void oz_timer_add(struct oz_pd *pd, int type, unsigned long due_time)
@@ -581,7 +577,7 @@ void oz_timer_add(struct oz_pd *pd, int type, unsigned long due_time)
 	spin_unlock_bh(&g_polling_lock);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq or process
  */
 void oz_pd_request_heartbeat(struct oz_pd *pd)
@@ -590,7 +586,7 @@ void oz_pd_request_heartbeat(struct oz_pd *pd)
 					pd->pulse_period : OZ_QUANTUM);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq or process
  */
 struct oz_pd *oz_pd_find(const u8 *mac_addr)
@@ -611,7 +607,7 @@ struct oz_pd *oz_pd_find(const u8 *mac_addr)
 	return NULL;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 void oz_app_enable(int app_id, int enable)
@@ -626,7 +622,7 @@ void oz_app_enable(int app_id, int enable)
 	}
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 static int oz_pkt_recv(struct sk_buff *skb, struct net_device *dev,
@@ -661,7 +657,7 @@ static int oz_pkt_recv(struct sk_buff *skb, struct net_device *dev,
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 void oz_binding_add(const char *net_dev)
@@ -695,7 +691,7 @@ void oz_binding_add(const char *net_dev)
 	}
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 static void pd_stop_all_for_device(struct net_device *net_dev)
@@ -720,7 +716,7 @@ static void pd_stop_all_for_device(struct net_device *net_dev)
 	}
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 void oz_binding_remove(const char *net_dev)
@@ -749,7 +745,7 @@ void oz_binding_remove(const char *net_dev)
 	}
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 static char *oz_get_next_device_name(char *s, char *dname, int max_size)
@@ -764,7 +760,7 @@ static char *oz_get_next_device_name(char *s, char *dname, int max_size)
 	return s;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 int oz_protocol_init(char *devs)
@@ -783,7 +779,7 @@ int oz_protocol_init(char *devs)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: process
  */
 int oz_get_pd_list(struct oz_mac_addr *addr, int max_count)
@@ -803,15 +799,11 @@ int oz_get_pd_list(struct oz_mac_addr *addr, int max_count)
 	return count;
 }
 
-/*------------------------------------------------------------------------------
-*/
 void oz_polling_lock_bh(void)
 {
 	spin_lock_bh(&g_polling_lock);
 }
 
-/*------------------------------------------------------------------------------
-*/
 void oz_polling_unlock_bh(void)
 {
 	spin_unlock_bh(&g_polling_lock);
diff --git a/drivers/staging/ozwpan/ozurbparanoia.c b/drivers/staging/ozwpan/ozurbparanoia.c
index d779877..cf6278a 100644
--- a/drivers/staging/ozwpan/ozurbparanoia.c
+++ b/drivers/staging/ozwpan/ozurbparanoia.c
@@ -10,15 +10,11 @@
 
 #include "ozurbparanoia.h"
 
-/*-----------------------------------------------------------------------------
- */
 #define OZ_MAX_URBS	1000
 struct urb *g_urb_memory[OZ_MAX_URBS];
 int g_nb_urbs;
 DEFINE_SPINLOCK(g_urb_mem_lock);
 
-/*-----------------------------------------------------------------------------
- */
 void oz_remember_urb(struct urb *urb)
 {
 	unsigned long irq_state;
@@ -33,7 +29,7 @@ void oz_remember_urb(struct urb *urb)
 	spin_unlock_irqrestore(&g_urb_mem_lock, irq_state);
 }
 
-/*------------------------------------------------------------------------------
+/*
  */
 int oz_forget_urb(struct urb *urb)
 {
diff --git a/drivers/staging/ozwpan/ozusbsvc.c b/drivers/staging/ozwpan/ozusbsvc.c
index 404941d..cf26379 100644
--- a/drivers/staging/ozwpan/ozusbsvc.c
+++ b/drivers/staging/ozwpan/ozusbsvc.c
@@ -28,7 +28,7 @@
 #include "ozhcd.h"
 #include "ozusbsvc.h"
 
-/*------------------------------------------------------------------------------
+/*
  * This is called once when the driver is loaded to initialise the USB service.
  * Context: process
  */
@@ -37,7 +37,7 @@ int oz_usb_init(void)
 	return oz_hcd_init();
 }
 
-/*------------------------------------------------------------------------------
+/*
  * This is called once when the driver is unloaded to terminate the USB service.
  * Context: process
  */
@@ -46,7 +46,7 @@ void oz_usb_term(void)
 	oz_hcd_term();
 }
 
-/*------------------------------------------------------------------------------
+/*
  * This is called when the USB service is started or resumed for a PD.
  * Context: softirq
  */
@@ -111,7 +111,7 @@ int oz_usb_start(struct oz_pd *pd, int resume)
 	return rc;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * This is called when the USB service is stopped or paused for a PD.
  * Context: softirq or process
  */
@@ -152,7 +152,7 @@ void oz_usb_stop(struct oz_pd *pd, int pause)
 	}
 }
 
-/*------------------------------------------------------------------------------
+/*
  * This increments the reference count of the context area for a specific PD.
  * This ensures this context area does not disappear while still in use.
  * Context: softirq
@@ -164,7 +164,7 @@ void oz_usb_get(void *hpd)
 	atomic_inc(&usb_ctx->ref_count);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * This decrements the reference count of the context area for a specific PD
  * and destroys the context area if the reference count becomes zero.
  * Context: irq or process
@@ -180,7 +180,7 @@ void oz_usb_put(void *hpd)
 	}
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 int oz_usb_heartbeat(struct oz_pd *pd)
@@ -205,7 +205,7 @@ done:
 	return rc;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 int oz_usb_stream_create(void *hpd, u8 ep_num)
@@ -227,7 +227,7 @@ int oz_usb_stream_create(void *hpd, u8 ep_num)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 int oz_usb_stream_delete(void *hpd, u8 ep_num)
@@ -250,7 +250,7 @@ int oz_usb_stream_delete(void *hpd, u8 ep_num)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq or process
  */
 void oz_usb_request_heartbeat(void *hpd)
diff --git a/drivers/staging/ozwpan/ozusbsvc1.c b/drivers/staging/ozwpan/ozusbsvc1.c
index 4ec21b5..228bffa 100644
--- a/drivers/staging/ozwpan/ozusbsvc1.c
+++ b/drivers/staging/ozwpan/ozusbsvc1.c
@@ -22,11 +22,9 @@
 #include "ozhcd.h"
 #include "ozusbsvc.h"
 
-/*------------------------------------------------------------------------------
- */
 #define MAX_ISOC_FIXED_DATA	(253-sizeof(struct oz_isoc_fixed))
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 static int oz_usb_submit_elt(struct oz_elt_buf *eb, struct oz_elt_info *ei,
@@ -53,7 +51,7 @@ static int oz_usb_submit_elt(struct oz_elt_buf *eb, struct oz_elt_info *ei,
 	return ret;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 int oz_usb_get_desc_req(void *hpd, u8 req_id, u8 req_type, u8 desc_type,
@@ -90,7 +88,7 @@ int oz_usb_get_desc_req(void *hpd, u8 req_id, u8 req_type, u8 desc_type,
 	return oz_usb_submit_elt(eb, ei, usb_ctx, 0, 0);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: tasklet
  */
 static int oz_usb_set_config_req(void *hpd, u8 req_id, u8 index)
@@ -113,7 +111,7 @@ static int oz_usb_set_config_req(void *hpd, u8 req_id, u8 index)
 	return oz_usb_submit_elt(eb, ei, usb_ctx, 0, 0);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: tasklet
  */
 static int oz_usb_set_interface_req(void *hpd, u8 req_id, u8 index, u8 alt)
@@ -137,7 +135,7 @@ static int oz_usb_set_interface_req(void *hpd, u8 req_id, u8 index, u8 alt)
 	return oz_usb_submit_elt(eb, ei, usb_ctx, 0, 0);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: tasklet
  */
 static int oz_usb_set_clear_feature_req(void *hpd, u8 req_id, u8 type,
@@ -163,7 +161,7 @@ static int oz_usb_set_clear_feature_req(void *hpd, u8 req_id, u8 type,
 	return oz_usb_submit_elt(eb, ei, usb_ctx, 0, 0);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: tasklet
  */
 static int oz_usb_vendor_class_req(void *hpd, u8 req_id, u8 req_type,
@@ -192,7 +190,7 @@ static int oz_usb_vendor_class_req(void *hpd, u8 req_id, u8 req_type,
 	return oz_usb_submit_elt(eb, ei, usb_ctx, 0, 0);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: tasklet
  */
 int oz_usb_control_req(void *hpd, u8 req_id, struct usb_ctrlrequest *setup,
@@ -241,7 +239,7 @@ int oz_usb_control_req(void *hpd, u8 req_id, struct usb_ctrlrequest *setup,
 	return rc;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq
  */
 int oz_usb_send_isoc(void *hpd, u8 ep_num, struct urb *urb)
@@ -313,7 +311,7 @@ int oz_usb_send_isoc(void *hpd, u8 ep_num, struct urb *urb)
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq-serialized
  */
 static void oz_usb_handle_ep_data(struct oz_usb_ctx *usb_ctx,
@@ -357,7 +355,7 @@ static void oz_usb_handle_ep_data(struct oz_usb_ctx *usb_ctx,
 
 }
 
-/*------------------------------------------------------------------------------
+/*
  * This is called when the PD has received a USB element. The type of element
  * is determined and is then passed to an appropriate handler function.
  * Context: softirq-serialized
@@ -430,7 +428,7 @@ done:
 	oz_usb_put(usb_ctx);
 }
 
-/*------------------------------------------------------------------------------
+/*
  * Context: softirq, process
  */
 void oz_usb_farewell(struct oz_pd *pd, u8 ep_num, u8 *data, u8 len)
-- 
1.7.9.5

