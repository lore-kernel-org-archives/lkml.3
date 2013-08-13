Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941Ab3HMRZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:25:07 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:52379 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758910Ab3HMRZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:25:01 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <dan.carpenter@oracle.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH 02/10] staging: ozwpan: Add a blank line between functions & declarations.
Date: Tue, 13 Aug 2013 18:24:22 +0100
Message-ID: <1376414670-23257-3-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376414670-23257-1-git-send-email-rupesh.gujare@atmel.com>
References: <1376414670-23257-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a blank line between global declarations &
functions for readability.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozcdev.c        |   17 ++++++++
 drivers/staging/ozwpan/ozeltbuf.c      |   12 ++++++
 drivers/staging/ozwpan/ozhcd.c         |   68 ++++++++++++++++++++++++++++++++
 drivers/staging/ozwpan/ozmain.c        |    3 ++
 drivers/staging/ozwpan/ozpd.c          |   40 +++++++++++++++++++
 drivers/staging/ozwpan/ozproto.c       |   26 ++++++++++++
 drivers/staging/ozwpan/ozurbparanoia.c |    2 +
 drivers/staging/ozwpan/ozusbsvc.c      |    9 +++++
 drivers/staging/ozwpan/ozusbsvc1.c     |   12 ++++++
 9 files changed, 189 insertions(+)

diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index 0c79fd0..01673d4 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -43,6 +43,7 @@ struct oz_serial_ctx {
  */
 static struct oz_cdev g_cdev;
 static struct class *g_oz_class;
+
 /*------------------------------------------------------------------------------
  * Context: process and softirq
  */
@@ -57,6 +58,7 @@ static struct oz_serial_ctx *oz_cdev_claim_ctx(struct oz_pd *pd)
 	spin_unlock_bh(&pd->app_lock[OZ_APPID_SERIAL-1]);
 	return ctx;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
@@ -67,6 +69,7 @@ static void oz_cdev_release_ctx(struct oz_serial_ctx *ctx)
 		kfree(ctx);
 	}
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -79,6 +82,7 @@ static int oz_cdev_open(struct inode *inode, struct file *filp)
 	filp->private_data = dev;
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -86,6 +90,7 @@ static int oz_cdev_release(struct inode *inode, struct file *filp)
 {
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -138,6 +143,7 @@ out2:
 	oz_pd_put(pd);
 	return count;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -195,6 +201,7 @@ out:
 	oz_pd_put(pd);
 	return count;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -229,6 +236,7 @@ static int oz_set_active_pd(const u8 *addr)
 	}
 	return rc;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -296,6 +304,7 @@ static long oz_cdev_ioctl(struct file *filp, unsigned int cmd,
 	}
 	return rc;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -319,6 +328,7 @@ static unsigned int oz_cdev_poll(struct file *filp, poll_table *wait)
 		poll_wait(filp, &dev->rdq, wait);
 	return ret;
 }
+
 /*------------------------------------------------------------------------------
  */
 static const struct file_operations oz_fops = {
@@ -330,6 +340,7 @@ static const struct file_operations oz_fops = {
 	.unlocked_ioctl = oz_cdev_ioctl,
 	.poll =		oz_cdev_poll
 };
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -374,6 +385,7 @@ unregister:
 	unregister_chrdev_region(g_cdev.devnum, 1);
 	return err;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -387,6 +399,7 @@ int oz_cdev_deregister(void)
 	}
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -395,6 +408,7 @@ int oz_cdev_init(void)
 	oz_app_enable(OZ_APPID_SERIAL, 1);
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -402,6 +416,7 @@ void oz_cdev_term(void)
 {
 	oz_app_enable(OZ_APPID_SERIAL, 0);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
@@ -439,6 +454,7 @@ int oz_cdev_start(struct oz_pd *pd, int resume)
 	oz_dbg(ON, "Serial service started\n");
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
@@ -468,6 +484,7 @@ void oz_cdev_stop(struct oz_pd *pd, int pause)
 	}
 	oz_dbg(ON, "Serial service stopped\n");
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
diff --git a/drivers/staging/ozwpan/ozeltbuf.c b/drivers/staging/ozwpan/ozeltbuf.c
index 0b8b468..4844d9f 100644
--- a/drivers/staging/ozwpan/ozeltbuf.c
+++ b/drivers/staging/ozwpan/ozeltbuf.c
@@ -28,6 +28,7 @@ int oz_elt_buf_init(struct oz_elt_buf *buf)
 	spin_lock_init(&buf->lock);
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
@@ -60,6 +61,7 @@ void oz_elt_buf_term(struct oz_elt_buf *buf)
 	}
 	buf->free_elts = 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
@@ -93,6 +95,7 @@ struct oz_elt_info *oz_elt_info_alloc(struct oz_elt_buf *buf)
 	}
 	return ei;
 }
+
 /*------------------------------------------------------------------------------
  * Precondition: oz_elt_buf.lock must be held.
  * Context: softirq or process
@@ -111,6 +114,7 @@ void oz_elt_info_free(struct oz_elt_buf *buf, struct oz_elt_info *ei)
 		}
 	}
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -128,6 +132,7 @@ void oz_elt_info_free_chain(struct oz_elt_buf *buf, struct list_head *list)
 	}
 	spin_unlock_bh(&buf->lock);
 }
+
 /*------------------------------------------------------------------------------
  */
 int oz_elt_stream_create(struct oz_elt_buf *buf, u8 id, int max_buf_count)
@@ -148,6 +153,7 @@ int oz_elt_stream_create(struct oz_elt_buf *buf, u8 id, int max_buf_count)
 	spin_unlock_bh(&buf->lock);
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  */
 int oz_elt_stream_delete(struct oz_elt_buf *buf, u8 id)
@@ -187,12 +193,14 @@ int oz_elt_stream_delete(struct oz_elt_buf *buf, u8 id)
 	oz_elt_stream_put(st);
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  */
 void oz_elt_stream_get(struct oz_elt_stream *st)
 {
 	atomic_inc(&st->ref_count);
 }
+
 /*------------------------------------------------------------------------------
  */
 void oz_elt_stream_put(struct oz_elt_stream *st)
@@ -202,6 +210,7 @@ void oz_elt_stream_put(struct oz_elt_stream *st)
 		kfree(st);
 	}
 }
+
 /*------------------------------------------------------------------------------
  * Precondition: Element buffer lock must be held.
  * If this function fails the caller is responsible for deallocating the elt
@@ -265,6 +274,7 @@ int oz_queue_elt_info(struct oz_elt_buf *buf, u8 isoc, u8 id,
 		&buf->isoc_list : &buf->order_list);
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  */
 int oz_select_elts_for_tx(struct oz_elt_buf *buf, u8 isoc, unsigned *len,
@@ -311,12 +321,14 @@ int oz_select_elts_for_tx(struct oz_elt_buf *buf, u8 isoc, unsigned *len,
 	spin_unlock_bh(&buf->lock);
 	return count;
 }
+
 /*------------------------------------------------------------------------------
  */
 int oz_are_elts_available(struct oz_elt_buf *buf)
 {
 	return buf->order_list.next != &buf->order_list;
 }
+
 /*------------------------------------------------------------------------------
  */
 void oz_trim_elt_pool(struct oz_elt_buf *buf)
diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 8ec125c..5a417c8 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -34,23 +34,29 @@
 #include "ozusbif.h"
 #include "ozurbparanoia.h"
 #include "ozhcd.h"
+
 /*------------------------------------------------------------------------------
  * Number of units of buffering to capture for an isochronous IN endpoint before
  * allowing data to be indicated up.
  */
 #define OZ_IN_BUFFERING_UNITS	50
+
 /* Name of our platform device.
  */
 #define OZ_PLAT_DEV_NAME	"ozwpan"
+
 /* Maximum number of free urb links that can be kept in the pool.
  */
 #define OZ_MAX_LINK_POOL_SIZE	16
+
 /* Get endpoint object from the containing link.
  */
 #define ep_from_link(__e) container_of((__e), struct oz_endpoint, link)
+
 /*EP0 timeout before ep0 request is again added to TX queue. (13*8 = 98mSec)
  */
 #define EP0_TIMEOUT_COUNTER 13
+
 /*------------------------------------------------------------------------------
  * Used to link urbs together and also store some status information for each
  * urb.
@@ -84,6 +90,7 @@ struct oz_endpoint {
 	unsigned flags;
 	int start_frame;
 };
+
 /* Bits in the flags field. */
 #define OZ_F_EP_BUFFERING	0x1
 #define OZ_F_EP_HAVE_STREAM	0x2
@@ -114,6 +121,7 @@ struct oz_port {
 	struct list_head isoc_out_ep;
 	struct list_head isoc_in_ep;
 };
+
 #define OZ_PORT_F_PRESENT	0x1
 #define OZ_PORT_F_CHANGED	0x2
 #define OZ_PORT_F_DYING		0x4
@@ -131,6 +139,7 @@ struct oz_hcd {
 	uint flags;
 	struct usb_hcd *hcd;
 };
+
 /* Bits in flags field.
  */
 #define OZ_HDC_F_SUSPENDED	0x1
@@ -175,6 +184,7 @@ static void oz_process_ep0_urb(struct oz_hcd *ozhcd, struct urb *urb,
 static struct oz_urb_link *oz_remove_urb(struct oz_endpoint *ep,
 		struct urb *urb);
 static void oz_hcd_clear_orphanage(struct oz_hcd *ozhcd, int status);
+
 /*------------------------------------------------------------------------------
  * Static external variables.
  */
@@ -220,6 +230,7 @@ static struct platform_driver g_oz_plat_drv = {
 		.owner = THIS_MODULE,
 	},
 };
+
 /*------------------------------------------------------------------------------
  * Gets our private context area (which is of type struct oz_hcd) from the
  * usb_hcd structure.
@@ -229,6 +240,7 @@ static inline struct oz_hcd *oz_hcd_private(struct usb_hcd *hcd)
 {
 	return (struct oz_hcd *)hcd->hcd_priv;
 }
+
 /*------------------------------------------------------------------------------
  * Searches list of ports to find the index of the one with a specified  USB
  * bus address. If none of the ports has the bus address then the connection
@@ -245,6 +257,7 @@ static int oz_get_port_from_addr(struct oz_hcd *ozhcd, u8 bus_addr)
 	}
 	return ozhcd->conn_port;
 }
+
 /*------------------------------------------------------------------------------
  * Allocates an urb link, first trying the pool but going to heap if empty.
  * Context: any
@@ -265,6 +278,7 @@ static struct oz_urb_link *oz_alloc_urb_link(void)
 		urbl = kmalloc(sizeof(struct oz_urb_link), GFP_ATOMIC);
 	return urbl;
 }
+
 /*------------------------------------------------------------------------------
  * Frees an urb link by putting it in the pool if there is enough space or
  * deallocating it to heap otherwise.
@@ -285,6 +299,7 @@ static void oz_free_urb_link(struct oz_urb_link *urbl)
 		kfree(urbl);
 	}
 }
+
 /*------------------------------------------------------------------------------
  * Deallocates all the urb links in the pool.
  * Context: unknown
@@ -306,6 +321,7 @@ static void oz_empty_link_pool(void)
 		kfree(urbl);
 	}
 }
+
 /*------------------------------------------------------------------------------
  * Allocates endpoint structure and optionally a buffer. If a buffer is
  * allocated it immediately follows the endpoint structure.
@@ -326,6 +342,7 @@ static struct oz_endpoint *oz_ep_alloc(gfp_t mem_flags, int buffer_size)
 	}
 	return ep;
 }
+
 /*------------------------------------------------------------------------------
  * Pre-condition: Must be called with g_tasklet_lock held and interrupts
  * disabled.
@@ -345,6 +362,7 @@ static struct oz_urb_link *oz_uncancel_urb(struct oz_hcd *ozhcd, struct urb *urb
 	}
 	return NULL;
 }
+
 /*------------------------------------------------------------------------------
  * This is called when we have finished processing an urb. It unlinks it from
  * the ep and returns it to the core.
@@ -388,6 +406,7 @@ static void oz_complete_urb(struct usb_hcd *hcd, struct urb *urb,
 	if (cancel_urbl)
 		oz_free_urb_link(cancel_urbl);
 }
+
 /*------------------------------------------------------------------------------
  * Deallocates an endpoint including deallocating any associated stream and
  * returning any queued urbs to the core.
@@ -412,6 +431,7 @@ static void oz_ep_free(struct oz_port *port, struct oz_endpoint *ep)
 	oz_dbg(ON, "Freeing endpoint memory\n");
 	kfree(ep);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -521,6 +541,7 @@ out:
 		oz_free_urb_link(urbl);
 	return err;
 }
+
 /*------------------------------------------------------------------------------
  * Removes an urb from the queue in the endpoint.
  * Returns 0 if it is found and -EIDRM otherwise.
@@ -553,6 +574,7 @@ static int oz_dequeue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
 		oz_free_urb_link(urbl);
 	return urbl ? 0 : -EIDRM;
 }
+
 /*------------------------------------------------------------------------------
  * Finds an urb given its request id.
  * Context: softirq
@@ -585,6 +607,7 @@ static struct urb *oz_find_urb_by_id(struct oz_port *port, int ep_ix,
 		oz_free_urb_link(urbl);
 	return urb;
 }
+
 /*------------------------------------------------------------------------------
  * Pre-condition: Port lock must be held.
  * Context: softirq
@@ -599,6 +622,7 @@ static void oz_acquire_port(struct oz_port *port, void *hpd)
 	oz_usb_get(hpd);
 	port->hpd = hpd;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -613,6 +637,7 @@ static struct oz_hcd *oz_hcd_claim(void)
 	spin_unlock_bh(&g_hcdlock);
 	return ozhcd;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -621,6 +646,7 @@ static inline void oz_hcd_put(struct oz_hcd *ozhcd)
 	if (ozhcd)
 		usb_put_hcd(ozhcd->hcd);
 }
+
 /*------------------------------------------------------------------------------
  * This is called by the protocol handler to notify that a PD has arrived.
  * We allocate a port to associate with the PD and create a structure for
@@ -686,6 +712,7 @@ out:
 	oz_hcd_put(ozhcd);
 	return hport;
 }
+
 /*------------------------------------------------------------------------------
  * This is called by the protocol handler to notify that the PD has gone away.
  * We need to deallocate all resources and then request that the root hub is
@@ -742,6 +769,7 @@ void oz_hcd_pd_departed(void *hport)
 	usb_hcd_poll_rh_status(ozhcd->hcd);
 	oz_usb_put(hpd);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -761,6 +789,7 @@ void oz_hcd_pd_reset(void *hpd, void *hport)
 	oz_clean_endpoints_for_config(ozhcd->hcd, port);
 	usb_hcd_poll_rh_status(ozhcd->hcd);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -806,6 +835,7 @@ void oz_hcd_get_desc_cnf(void *hport, u8 req_id, int status, const u8 *desc,
 	urb->actual_length = total_size;
 	oz_complete_urb(port->ozhcd->hcd, urb, 0);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -869,6 +899,7 @@ static void oz_hcd_complete_set_config(struct oz_port *port, struct urb *urb,
 	}
 	oz_complete_urb(hcd, urb, rc);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -895,6 +926,7 @@ static void oz_hcd_complete_set_interface(struct oz_port *port, struct urb *urb,
 	}
 	oz_complete_urb(hcd, urb, rc);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -947,6 +979,7 @@ void oz_hcd_control_cnf(void *hport, u8 req_id, u8 rcode, const u8 *data,
 		oz_complete_urb(hcd, urb, 0);
 	}
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
@@ -984,6 +1017,7 @@ static int oz_hcd_buffer_data(struct oz_endpoint *ep, const u8 *data,
 	ep->buffered_units++;
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
@@ -1030,6 +1064,7 @@ void oz_hcd_data_ind(void *hport, u8 endpoint, const u8 *data, int data_len)
 done:
 	spin_unlock_bh(&ozhcd->hcd_lock);
 }
+
 /*------------------------------------------------------------------------------
  * Context: unknown
  */
@@ -1037,6 +1072,7 @@ static inline int oz_usb_get_frame_number(void)
 {
 	return atomic_inc_return(&g_usb_frame_number);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -1197,6 +1233,7 @@ int oz_hcd_heartbeat(void *hport)
 	}
 	return rc;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -1275,6 +1312,7 @@ static int oz_build_endpoints_for_interface(struct usb_hcd *hcd,
 	}
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -1320,6 +1358,7 @@ static void oz_clean_endpoints_for_interface(struct usb_hcd *hcd,
 		oz_ep_free(port, ep);
 	}
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -1355,6 +1394,7 @@ fail:
 	oz_clean_endpoints_for_config(hcd, port);
 	return -1;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -1376,6 +1416,7 @@ static void oz_clean_endpoints_for_config(struct usb_hcd *hcd,
 	port->num_iface = 0;
 	spin_unlock_bh(&ozhcd->hcd_lock);
 }
+
 /*------------------------------------------------------------------------------
  * Context: tasklet
  */
@@ -1391,6 +1432,7 @@ static void *oz_claim_hpd(struct oz_port *port)
 	spin_unlock_bh(&ozhcd->hcd_lock);
 	return hpd;
 }
+
 /*------------------------------------------------------------------------------
  * Context: tasklet
  */
@@ -1537,6 +1579,7 @@ out:
 		oz_usb_request_heartbeat(port->hpd);
 	}
 }
+
 /*------------------------------------------------------------------------------
  * Context: tasklet
  */
@@ -1571,6 +1614,7 @@ static int oz_urb_process(struct oz_hcd *ozhcd, struct urb *urb)
 	}
 	return rc;
 }
+
 /*------------------------------------------------------------------------------
  * Context: tasklet
  */
@@ -1604,6 +1648,7 @@ static void oz_urb_process_tasklet(unsigned long unused)
 	spin_unlock_irqrestore(&g_tasklet_lock, irq_state);
 	oz_hcd_put(ozhcd);
 }
+
 /*------------------------------------------------------------------------------
  * This function searches for the urb in any of the lists it could be in.
  * If it is found it is removed from the list and completed. If the urb is
@@ -1671,6 +1716,7 @@ out2:
 		oz_complete_urb(ozhcd->hcd, urb, -EPIPE);
 	}
 }
+
 /*------------------------------------------------------------------------------
  * Context: tasklet
  */
@@ -1698,6 +1744,7 @@ static void oz_urb_cancel_tasklet(unsigned long unused)
 	spin_unlock_irqrestore(&g_tasklet_lock, irq_state);
 	oz_hcd_put(ozhcd);
 }
+
 /*------------------------------------------------------------------------------
  * Context: unknown
  */
@@ -1714,6 +1761,7 @@ static void oz_hcd_clear_orphanage(struct oz_hcd *ozhcd, int status)
 		}
 	}
 }
+
 /*------------------------------------------------------------------------------
  * Context: unknown
  */
@@ -1724,18 +1772,21 @@ static int oz_hcd_start(struct usb_hcd *hcd)
 	hcd->uses_new_polling = 1;
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: unknown
  */
 static void oz_hcd_stop(struct usb_hcd *hcd)
 {
 }
+
 /*------------------------------------------------------------------------------
  * Context: unknown
  */
 static void oz_hcd_shutdown(struct usb_hcd *hcd)
 {
 }
+
 /*------------------------------------------------------------------------------
  * Called to queue an urb for the device.
  * This function should return a non-zero error code if it fails the urb but
@@ -1792,6 +1843,7 @@ static int oz_hcd_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	atomic_inc(&g_pending_urbs);
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: tasklet
  */
@@ -1817,6 +1869,7 @@ static struct oz_urb_link *oz_remove_urb(struct oz_endpoint *ep,
 	}
 	return NULL;
 }
+
 /*------------------------------------------------------------------------------
  * Called to dequeue a previously submitted urb for the device.
  * Context: any
@@ -1858,6 +1911,7 @@ static int oz_hcd_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 	}
 	return rc;
 }
+
 /*------------------------------------------------------------------------------
  * Context: unknown
  */
@@ -1865,6 +1919,7 @@ static void oz_hcd_endpoint_disable(struct usb_hcd *hcd,
 				struct usb_host_endpoint *ep)
 {
 }
+
 /*------------------------------------------------------------------------------
  * Context: unknown
  */
@@ -1872,6 +1927,7 @@ static void oz_hcd_endpoint_reset(struct usb_hcd *hcd,
 				struct usb_host_endpoint *ep)
 {
 }
+
 /*------------------------------------------------------------------------------
  * Context: unknown
  */
@@ -1880,6 +1936,7 @@ static int oz_hcd_get_frame_number(struct usb_hcd *hcd)
 	oz_dbg(ON, "oz_hcd_get_frame_number\n");
 	return oz_usb_get_frame_number();
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  * This is called as a consquence of us calling usb_hcd_poll_rh_status() and we
@@ -1910,6 +1967,7 @@ static int oz_hcd_hub_status_data(struct usb_hcd *hcd, char *buf)
 	else
 		return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -1923,6 +1981,7 @@ static void oz_get_hub_descriptor(struct usb_hcd *hcd,
 			__constant_cpu_to_le16(0x0001);
 	desc->bNbrPorts = OZ_NB_PORTS;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -1998,6 +2057,7 @@ static int oz_set_port_feature(struct usb_hcd *hcd, u16 wvalue, u16 windex)
 	oz_dbg(HUB, "Port[%d] status = 0x%x\n", port_id, port->status);
 	return err;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -2073,6 +2133,7 @@ static int oz_clear_port_feature(struct usb_hcd *hcd, u16 wvalue, u16 windex)
 	       port_id, ozhcd->ports[port_id-1].status);
 	return err;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -2090,6 +2151,7 @@ static int oz_get_port_status(struct usb_hcd *hcd, u16 windex, char *buf)
 	oz_dbg(HUB, "Port[%d] status = %x\n", windex, status);
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -2127,6 +2189,7 @@ static int oz_hcd_hub_control(struct usb_hcd *hcd, u16 req_type, u16 wvalue,
 	}
 	return err;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -2141,6 +2204,7 @@ static int oz_hcd_bus_suspend(struct usb_hcd *hcd)
 	spin_unlock_bh(&ozhcd->hcd_lock);
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -2155,6 +2219,7 @@ static int oz_hcd_bus_resume(struct usb_hcd *hcd)
 	spin_unlock_bh(&ozhcd->hcd_lock);
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  */
 static void oz_plat_shutdown(struct platform_device *dev)
@@ -2203,6 +2268,7 @@ static int oz_plat_probe(struct platform_device *dev)
 	spin_unlock_bh(&g_hcdlock);
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: unknown
  */
@@ -2235,6 +2301,7 @@ static int oz_plat_suspend(struct platform_device *dev, pm_message_t msg)
 	return 0;
 }
 
+
 /*------------------------------------------------------------------------------
  * Context: unknown
  */
@@ -2279,6 +2346,7 @@ error:
 	oz_dbg(ON, "oz_hcd_init() failed %d\n", err);
 	return err;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
diff --git a/drivers/staging/ozwpan/ozmain.c b/drivers/staging/ozwpan/ozmain.c
index e26d6be..707ab28 100644
--- a/drivers/staging/ozwpan/ozmain.c
+++ b/drivers/staging/ozwpan/ozmain.c
@@ -25,6 +25,7 @@ unsigned int oz_dbg_mask = OZ_DEFAULT_DBG_MASK;
  * netcards. Bindings can be added later using an IOCTL.
  */
 static char *g_net_dev = "";
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -36,6 +37,7 @@ static int __init ozwpan_init(void)
 	oz_apps_init();
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -45,6 +47,7 @@ static void __exit ozwpan_exit(void)
 	oz_apps_term();
 	oz_cdev_deregister();
 }
+
 /*------------------------------------------------------------------------------
  */
 module_param(g_net_dev, charp, S_IRUGO);
diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index 14fea77..95109fd 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -24,6 +24,7 @@
 /*------------------------------------------------------------------------------
  */
 #define OZ_MAX_TX_POOL_SIZE	6
+
 /*------------------------------------------------------------------------------
  */
 static struct oz_tx_frame *oz_tx_frame_alloc(struct oz_pd *pd);
@@ -40,10 +41,12 @@ static void oz_def_app_term(void);
 static int oz_def_app_start(struct oz_pd *pd, int resume);
 static void oz_def_app_stop(struct oz_pd *pd, int pause);
 static void oz_def_app_rx(struct oz_pd *pd, struct oz_elt *elt);
+
 /*------------------------------------------------------------------------------
  * Counts the uncompleted isoc frames submitted to netcard.
  */
 static atomic_t g_submitted_isoc = ATOMIC_INIT(0);
+
 /* Application handler functions.
  */
 static const struct oz_app_if g_app_if[OZ_APPID_MAX] = {
@@ -83,6 +86,7 @@ static const struct oz_app_if g_app_if[OZ_APPID_MAX] = {
 	NULL,
 	OZ_APPID_SERIAL},
 };
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -90,12 +94,14 @@ static int oz_def_app_init(void)
 {
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
 static void oz_def_app_term(void)
 {
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -103,18 +109,21 @@ static int oz_def_app_start(struct oz_pd *pd, int resume)
 {
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
 static void oz_def_app_stop(struct oz_pd *pd, int pause)
 {
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
 static void oz_def_app_rx(struct oz_pd *pd, struct oz_elt *elt)
 {
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
@@ -136,6 +145,7 @@ void oz_pd_set_state(struct oz_pd *pd, unsigned state)
 		break;
 	}
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
@@ -143,6 +153,7 @@ void oz_pd_get(struct oz_pd *pd)
 {
 	atomic_inc(&pd->ref_count);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
@@ -151,6 +162,7 @@ void oz_pd_put(struct oz_pd *pd)
 	if (atomic_dec_and_test(&pd->ref_count))
 		oz_pd_destroy(pd);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
@@ -188,6 +200,7 @@ struct oz_pd *oz_pd_alloc(const u8 *mac_addr)
 	}
 	return pd;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
@@ -244,6 +257,7 @@ void oz_pd_destroy(struct oz_pd *pd)
 		dev_put(pd->net_dev);
 	kfree(pd);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
@@ -271,6 +285,7 @@ int oz_services_start(struct oz_pd *pd, u16 apps, int resume)
 	}
 	return rc;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
@@ -293,6 +308,7 @@ void oz_services_stop(struct oz_pd *pd, u16 apps, int pause)
 		}
 	}
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -315,6 +331,7 @@ void oz_pd_heartbeat(struct oz_pd *pd, u16 apps)
 			;
 	}
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
@@ -338,6 +355,7 @@ void oz_pd_stop(struct oz_pd *pd)
 	oz_dbg(ON, "pd ref count = %d\n", atomic_read(&pd->ref_count));
 	oz_pd_put(pd);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -366,6 +384,7 @@ int oz_pd_sleep(struct oz_pd *pd)
 	}
 	return do_stop;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -389,6 +408,7 @@ static struct oz_tx_frame *oz_tx_frame_alloc(struct oz_pd *pd)
 	}
 	return f;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
@@ -406,6 +426,7 @@ static void oz_tx_isoc_free(struct oz_pd *pd, struct oz_tx_frame *f)
 	oz_dbg(TX_FRAMES, "Releasing ISOC Frame isoc_nb= %d\n",
 	       pd->nb_queued_isoc_frames);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
@@ -421,6 +442,7 @@ static void oz_tx_frame_free(struct oz_pd *pd, struct oz_tx_frame *f)
 	spin_unlock_bh(&pd->tx_frame_lock);
 	kfree(f);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
@@ -430,6 +452,7 @@ static void oz_set_more_bit(struct sk_buff *skb)
 
 	oz_hdr->control |= OZ_F_MORE_DATA;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
@@ -439,6 +462,7 @@ static void oz_set_last_pkt_nb(struct oz_pd *pd, struct sk_buff *skb)
 
 	oz_hdr->last_pkt_num = pd->trigger_pkt_num & OZ_LAST_PN_MASK;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -470,6 +494,7 @@ int oz_prepare_frame(struct oz_pd *pd, int empty)
 	spin_unlock(&pd->tx_frame_lock);
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
@@ -515,6 +540,7 @@ fail:
 	kfree_skb(skb);
 	return NULL;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
@@ -538,6 +564,7 @@ static void oz_retire_frame(struct oz_pd *pd, struct oz_tx_frame *f)
 	if (pd->elt_buff.free_elts > pd->elt_buff.max_free_elts)
 		oz_trim_elt_pool(&pd->elt_buff);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
@@ -592,6 +619,7 @@ static int oz_send_next_queued_frame(struct oz_pd *pd, int more_data)
 	}
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
@@ -630,6 +658,7 @@ void oz_send_queued_frames(struct oz_pd *pd, int backlog)
 out:	oz_prepare_frame(pd, 1);
 	oz_send_next_queued_frame(pd, 0);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -679,6 +708,7 @@ static int oz_send_isoc_frame(struct oz_pd *pd)
 	oz_elt_info_free_chain(&pd->elt_buff, &list);
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
@@ -720,6 +750,7 @@ void oz_retire_tx_frames(struct oz_pd *pd, u8 lpn)
 		oz_retire_frame(pd, f);
 	}
 }
+
 /*------------------------------------------------------------------------------
  * Precondition: stream_lock must be held.
  * Context: softirq
@@ -736,6 +767,7 @@ static struct oz_isoc_stream *pd_stream_find(struct oz_pd *pd, u8 ep_num)
 	}
 	return NULL;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -755,6 +787,7 @@ int oz_isoc_stream_create(struct oz_pd *pd, u8 ep_num)
 	kfree(st);
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
@@ -763,6 +796,7 @@ static void oz_isoc_stream_free(struct oz_isoc_stream *st)
 	kfree_skb(st->skb);
 	kfree(st);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -779,6 +813,7 @@ int oz_isoc_stream_delete(struct oz_pd *pd, u8 ep_num)
 		oz_isoc_stream_free(st);
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: any
  */
@@ -786,6 +821,7 @@ static void oz_isoc_destructor(struct sk_buff *skb)
 {
 	atomic_dec(&g_submitted_isoc);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -907,6 +943,7 @@ out:	kfree_skb(skb);
 	}
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -918,6 +955,7 @@ void oz_apps_init(void)
 		if (g_app_if[i].init)
 			g_app_if[i].init();
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -930,6 +968,7 @@ void oz_apps_term(void)
 		if (g_app_if[i].term)
 			g_app_if[i].term();
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
@@ -942,6 +981,7 @@ void oz_handle_app_elt(struct oz_pd *pd, u8 app_id, struct oz_elt *elt)
 	ai = &g_app_if[app_id-1];
 	ai->rx(pd, elt);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index 7072f53..8c2200b 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -22,6 +22,7 @@
 #include <asm/unaligned.h>
 #include <linux/uaccess.h>
 #include <net/psnap.h>
+
 /*------------------------------------------------------------------------------
  */
 #define OZ_CF_CONN_SUCCESS	1
@@ -51,6 +52,7 @@ static struct sk_buff_head g_rx_queue;
 static u8 g_session_id;
 static u16 g_apps = 0x1;
 static int g_processing_rx;
+
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
@@ -64,6 +66,7 @@ static u8 oz_get_new_session_id(u8 exclude)
 	}
 	return g_session_id;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
@@ -109,6 +112,7 @@ static void oz_send_conn_rsp(struct oz_pd *pd, u8 status)
 	dev_queue_xmit(skb);
 	return;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
@@ -134,6 +138,7 @@ static void pd_set_keepalive(struct oz_pd *pd, u8 kalive)
 	}
 	oz_dbg(ON, "Keepalive = %lu mSec\n", pd->keep_alive);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
@@ -150,6 +155,7 @@ static void pd_set_presleep(struct oz_pd *pd, u8 presleep, u8 start_timer)
 	}
 	oz_dbg(ON, "Presleep time = %lu mSec\n", pd->presleep);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
@@ -284,6 +290,7 @@ done:
 		oz_pd_destroy(free_pd);
 	return pd;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
@@ -315,6 +322,7 @@ static void oz_add_farewell(struct oz_pd *pd, u8 ep_num, u8 index,
 	if (found)
 		kfree(f2);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
@@ -436,6 +444,7 @@ done:
 		oz_pd_put(pd);
 	consume_skb(skb);
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -473,6 +482,7 @@ void oz_protocol_term(void)
 	spin_unlock_bh(&g_polling_lock);
 	oz_dbg(ON, "Protocol stopped\n");
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -489,6 +499,7 @@ void oz_pd_heartbeat_handler(unsigned long data)
 		oz_pd_heartbeat(pd, apps);
 
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -509,6 +520,7 @@ void oz_pd_timeout_handler(unsigned long data)
 		break;
 	}
 }
+
 /*------------------------------------------------------------------------------
  * Context: Interrupt
  */
@@ -522,6 +534,7 @@ enum hrtimer_restart oz_pd_heartbeat_event(struct hrtimer *timer)
 	tasklet_schedule(&pd->heartbeat_tasklet);
 	return HRTIMER_RESTART;
 }
+
 /*------------------------------------------------------------------------------
  * Context: Interrupt
  */
@@ -533,6 +546,7 @@ enum hrtimer_restart oz_pd_timeout_event(struct hrtimer *timer)
 	tasklet_schedule(&pd->timeout_tasklet);
 	return HRTIMER_NORESTART;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
@@ -563,6 +577,7 @@ void oz_timer_add(struct oz_pd *pd, int type, unsigned long due_time)
 	}
 	spin_unlock_bh(&g_polling_lock);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
@@ -571,6 +586,7 @@ void oz_pd_request_heartbeat(struct oz_pd *pd)
 	oz_timer_add(pd, OZ_TIMER_HEARTBEAT, pd->pulse_period > 0 ?
 					pd->pulse_period : OZ_QUANTUM);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
@@ -591,6 +607,7 @@ struct oz_pd *oz_pd_find(const u8 *mac_addr)
 	spin_unlock_bh(&g_polling_lock);
 	return NULL;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -605,6 +622,7 @@ void oz_app_enable(int app_id, int enable)
 		spin_unlock_bh(&g_polling_lock);
 	}
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -639,6 +657,7 @@ static int oz_pkt_recv(struct sk_buff *skb, struct net_device *dev,
 	}
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -672,6 +691,7 @@ void oz_binding_add(const char *net_dev)
 		}
 	}
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -696,6 +716,7 @@ static void pd_stop_all_for_device(struct net_device *net_dev)
 		oz_pd_put(pd);
 	}
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -724,6 +745,7 @@ void oz_binding_remove(const char *net_dev)
 		kfree(binding);
 	}
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -738,6 +760,7 @@ static char *oz_get_next_device_name(char *s, char *dname, int max_size)
 	*dname = 0;
 	return s;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -756,6 +779,7 @@ int oz_protocol_init(char *devs)
 	}
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: process
  */
@@ -775,12 +799,14 @@ int oz_get_pd_list(struct oz_mac_addr *addr, int max_count)
 	spin_unlock_bh(&g_polling_lock);
 	return count;
 }
+
 /*------------------------------------------------------------------------------
 */
 void oz_polling_lock_bh(void)
 {
 	spin_lock_bh(&g_polling_lock);
 }
+
 /*------------------------------------------------------------------------------
 */
 void oz_polling_unlock_bh(void)
diff --git a/drivers/staging/ozwpan/ozurbparanoia.c b/drivers/staging/ozwpan/ozurbparanoia.c
index 6aab9a7..d779877 100644
--- a/drivers/staging/ozwpan/ozurbparanoia.c
+++ b/drivers/staging/ozwpan/ozurbparanoia.c
@@ -16,6 +16,7 @@
 struct urb *g_urb_memory[OZ_MAX_URBS];
 int g_nb_urbs;
 DEFINE_SPINLOCK(g_urb_mem_lock);
+
 /*-----------------------------------------------------------------------------
  */
 void oz_remember_urb(struct urb *urb)
@@ -31,6 +32,7 @@ void oz_remember_urb(struct urb *urb)
 	}
 	spin_unlock_irqrestore(&g_urb_mem_lock, irq_state);
 }
+
 /*------------------------------------------------------------------------------
  */
 int oz_forget_urb(struct urb *urb)
diff --git a/drivers/staging/ozwpan/ozusbsvc.c b/drivers/staging/ozwpan/ozusbsvc.c
index ab9db8c..404941d 100644
--- a/drivers/staging/ozwpan/ozusbsvc.c
+++ b/drivers/staging/ozwpan/ozusbsvc.c
@@ -36,6 +36,7 @@ int oz_usb_init(void)
 {
 	return oz_hcd_init();
 }
+
 /*------------------------------------------------------------------------------
  * This is called once when the driver is unloaded to terminate the USB service.
  * Context: process
@@ -44,6 +45,7 @@ void oz_usb_term(void)
 {
 	oz_hcd_term();
 }
+
 /*------------------------------------------------------------------------------
  * This is called when the USB service is started or resumed for a PD.
  * Context: softirq
@@ -108,6 +110,7 @@ int oz_usb_start(struct oz_pd *pd, int resume)
 	oz_usb_put(usb_ctx);
 	return rc;
 }
+
 /*------------------------------------------------------------------------------
  * This is called when the USB service is stopped or paused for a PD.
  * Context: softirq or process
@@ -148,6 +151,7 @@ void oz_usb_stop(struct oz_pd *pd, int pause)
 		oz_usb_put(usb_ctx);
 	}
 }
+
 /*------------------------------------------------------------------------------
  * This increments the reference count of the context area for a specific PD.
  * This ensures this context area does not disappear while still in use.
@@ -159,6 +163,7 @@ void oz_usb_get(void *hpd)
 
 	atomic_inc(&usb_ctx->ref_count);
 }
+
 /*------------------------------------------------------------------------------
  * This decrements the reference count of the context area for a specific PD
  * and destroys the context area if the reference count becomes zero.
@@ -174,6 +179,7 @@ void oz_usb_put(void *hpd)
 		kfree(usb_ctx);
 	}
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -198,6 +204,7 @@ done:
 	oz_usb_put(usb_ctx);
 	return rc;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -219,6 +226,7 @@ int oz_usb_stream_create(void *hpd, u8 ep_num)
 	}
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -241,6 +249,7 @@ int oz_usb_stream_delete(void *hpd, u8 ep_num)
 	}
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
diff --git a/drivers/staging/ozwpan/ozusbsvc1.c b/drivers/staging/ozwpan/ozusbsvc1.c
index 34133ef..4ec21b5 100644
--- a/drivers/staging/ozwpan/ozusbsvc1.c
+++ b/drivers/staging/ozwpan/ozusbsvc1.c
@@ -21,9 +21,11 @@
 #include "ozusbif.h"
 #include "ozhcd.h"
 #include "ozusbsvc.h"
+
 /*------------------------------------------------------------------------------
  */
 #define MAX_ISOC_FIXED_DATA	(253-sizeof(struct oz_isoc_fixed))
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -50,6 +52,7 @@ static int oz_usb_submit_elt(struct oz_elt_buf *eb, struct oz_elt_info *ei,
 	spin_unlock_bh(&eb->lock);
 	return ret;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -86,6 +89,7 @@ int oz_usb_get_desc_req(void *hpd, u8 req_id, u8 req_type, u8 desc_type,
 	body->index = index;
 	return oz_usb_submit_elt(eb, ei, usb_ctx, 0, 0);
 }
+
 /*------------------------------------------------------------------------------
  * Context: tasklet
  */
@@ -108,6 +112,7 @@ static int oz_usb_set_config_req(void *hpd, u8 req_id, u8 index)
 	body->index = index;
 	return oz_usb_submit_elt(eb, ei, usb_ctx, 0, 0);
 }
+
 /*------------------------------------------------------------------------------
  * Context: tasklet
  */
@@ -131,6 +136,7 @@ static int oz_usb_set_interface_req(void *hpd, u8 req_id, u8 index, u8 alt)
 	body->alternative = alt;
 	return oz_usb_submit_elt(eb, ei, usb_ctx, 0, 0);
 }
+
 /*------------------------------------------------------------------------------
  * Context: tasklet
  */
@@ -156,6 +162,7 @@ static int oz_usb_set_clear_feature_req(void *hpd, u8 req_id, u8 type,
 	put_unaligned(feature, &body->feature);
 	return oz_usb_submit_elt(eb, ei, usb_ctx, 0, 0);
 }
+
 /*------------------------------------------------------------------------------
  * Context: tasklet
  */
@@ -184,6 +191,7 @@ static int oz_usb_vendor_class_req(void *hpd, u8 req_id, u8 req_type,
 		memcpy(body->data, data, data_len);
 	return oz_usb_submit_elt(eb, ei, usb_ctx, 0, 0);
 }
+
 /*------------------------------------------------------------------------------
  * Context: tasklet
  */
@@ -232,6 +240,7 @@ int oz_usb_control_req(void *hpd, u8 req_id, struct usb_ctrlrequest *setup,
 	}
 	return rc;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
@@ -303,6 +312,7 @@ int oz_usb_send_isoc(void *hpd, u8 ep_num, struct urb *urb)
 	}
 	return 0;
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
@@ -346,6 +356,7 @@ static void oz_usb_handle_ep_data(struct oz_usb_ctx *usb_ctx,
 	}
 
 }
+
 /*------------------------------------------------------------------------------
  * This is called when the PD has received a USB element. The type of element
  * is determined and is then passed to an appropriate handler function.
@@ -418,6 +429,7 @@ void oz_usb_rx(struct oz_pd *pd, struct oz_elt *elt)
 done:
 	oz_usb_put(usb_ctx);
 }
+
 /*------------------------------------------------------------------------------
  * Context: softirq, process
  */
-- 
1.7.9.5

