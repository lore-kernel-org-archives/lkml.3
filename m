Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab3BOUNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 15:13:04 -0500
Received: from mout.gmx.net ([212.227.15.19]:61348 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab3BOUNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 15:13:01 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18DxT9jsRwDGaDvdKdM+IrMpzfSSNqqiRuVzjDHBK
	SE2toWXBrRc56T
From: Peter Huewe <peterhuewe@gmx.de>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 2/4] staging/ozwpan: Mark local functions as static (fix sparse warnings)
Date: Fri, 15 Feb 2013 21:17:22 +0100
Message-Id: <1360959444-5961-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360959444-5961-1-git-send-email-peterhuewe@gmx.de>
References: <1360959444-5961-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse complains about the following functions

ozhcd.c:330:20: warning: symbol 'oz_uncancel_urb' was not declared.  Should it be static?
ozhcd.c:420:6: warning: symbol 'oz_complete_buffered_urb' was not declared. Should it be static?
ozmain.c:25:6: warning: symbol 'g_net_dev' was not declared. Should it be static?
ozevent.c:95:5: warning: symbol 'oz_events_open' was not declared.  Should it be static?
ozevent.c:110:5: warning: symbol 'oz_events_release' was not declared.  Should it be static?
ozevent.c:121:9: warning: symbol 'oz_events_read' was not declared.  Should it be static?
ozevent.c:160:30: warning: symbol 'oz_events_fops' was not declared.  Should it be static?
ozcdev.c:47:14: warning: symbol 'g_oz_class' was not declared. Should it be static?
ozcdev.c:74:5: warning: symbol 'oz_cdev_open' was not declared. Should it be static?
ozcdev.c:86:5: warning: symbol 'oz_cdev_release' was not declared.  Should it be static?
ozcdev.c:94:9: warning: symbol 'oz_cdev_read' was not declared. Should it be static?
ozcdev.c:146:9: warning: symbol 'oz_cdev_write' was not declared. Should it be static?
ozcdev.c:236:6: warning: symbol 'oz_cdev_ioctl' was not declared. Should it be static?
ozcdev.c:300:14: warning: symbol 'oz_cdev_poll' was not declared. Should it be static?
ozcdev.c:321:30: warning: symbol 'oz_fops' was not declared. Should it be static?
ozproto.c:958:6: warning: context imbalance in 'oz_polling_lock_bh' - wrong count at exit
ozproto.c:964:6: warning: context imbalance in 'oz_polling_unlock_bh' - unexpected unlock
ozusbsvc1.c:308:6: warning: symbol 'oz_usb_handle_ep_data' was not declared. Should it be static?
ozpd.c:410:6: warning: symbol 'oz_set_more_bit' was not declared. Should it be static?
ozpd.c:418:6: warning: symbol 'oz_set_last_pkt_nb' was not declared.  Should it be static?

-> add static keyword to silence the warning and make sparse happy.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/ozwpan/ozcdev.c    |   19 ++++++++++---------
 drivers/staging/ozwpan/ozevent.c   |    8 ++++----
 drivers/staging/ozwpan/ozhcd.c     |    5 +++--
 drivers/staging/ozwpan/ozmain.c    |    2 +-
 drivers/staging/ozwpan/ozpd.c      |    4 ++--
 drivers/staging/ozwpan/ozusbsvc1.c |    2 +-
 6 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index 25f677ad..04e0054 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -44,7 +44,7 @@ struct oz_serial_ctx {
 /*------------------------------------------------------------------------------
  */
 static struct oz_cdev g_cdev;
-struct class *g_oz_class;
+static struct class *g_oz_class;
 /*------------------------------------------------------------------------------
  * Context: process and softirq
  */
@@ -71,7 +71,7 @@ static void oz_cdev_release_ctx(struct oz_serial_ctx *ctx)
 /*------------------------------------------------------------------------------
  * Context: process
  */
-int oz_cdev_open(struct inode *inode, struct file *filp)
+static int oz_cdev_open(struct inode *inode, struct file *filp)
 {
 	struct oz_cdev *dev;
 	oz_trace("oz_cdev_open()\n");
@@ -83,7 +83,7 @@ int oz_cdev_open(struct inode *inode, struct file *filp)
 /*------------------------------------------------------------------------------
  * Context: process
  */
-int oz_cdev_release(struct inode *inode, struct file *filp)
+static int oz_cdev_release(struct inode *inode, struct file *filp)
 {
 	oz_trace("oz_cdev_release()\n");
 	return 0;
@@ -91,7 +91,7 @@ int oz_cdev_release(struct inode *inode, struct file *filp)
 /*------------------------------------------------------------------------------
  * Context: process
  */
-ssize_t oz_cdev_read(struct file *filp, char __user *buf, size_t count,
+static ssize_t oz_cdev_read(struct file *filp, char __user *buf, size_t count,
 		loff_t *fpos)
 {
 	int n;
@@ -143,8 +143,8 @@ out2:
 /*------------------------------------------------------------------------------
  * Context: process
  */
-ssize_t oz_cdev_write(struct file *filp, const char __user *buf, size_t count,
-		loff_t *fpos)
+static ssize_t oz_cdev_write(struct file *filp, const char __user *buf,
+		size_t count, loff_t *fpos)
 {
 	struct oz_pd *pd;
 	struct oz_elt_buf *eb;
@@ -233,7 +233,8 @@ static int oz_set_active_pd(u8 *addr)
 /*------------------------------------------------------------------------------
  * Context: process
  */
-long oz_cdev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+static long oz_cdev_ioctl(struct file *filp, unsigned int cmd,
+			  unsigned long arg)
 {
 	int rc = 0;
 	if (_IOC_TYPE(cmd) != OZ_IOCTL_MAGIC)
@@ -297,7 +298,7 @@ long oz_cdev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 /*------------------------------------------------------------------------------
  * Context: process
  */
-unsigned int oz_cdev_poll(struct file *filp, poll_table *wait)
+static unsigned int oz_cdev_poll(struct file *filp, poll_table *wait)
 {
 	unsigned int ret = 0;
 	struct oz_cdev *dev = filp->private_data;
@@ -318,7 +319,7 @@ unsigned int oz_cdev_poll(struct file *filp, poll_table *wait)
 }
 /*------------------------------------------------------------------------------
  */
-const struct file_operations oz_fops = {
+static const struct file_operations oz_fops = {
 	.owner =	THIS_MODULE,
 	.open =		oz_cdev_open,
 	.release =	oz_cdev_release,
diff --git a/drivers/staging/ozwpan/ozevent.c b/drivers/staging/ozwpan/ozevent.c
index 50578ba..77e8675 100644
--- a/drivers/staging/ozwpan/ozevent.c
+++ b/drivers/staging/ozwpan/ozevent.c
@@ -92,7 +92,7 @@ static void oz_events_clear(struct oz_evtdev *dev)
 /*------------------------------------------------------------------------------
  * Context: process
  */
-int oz_events_open(struct inode *inode, struct file *filp)
+static int oz_events_open(struct inode *inode, struct file *filp)
 {
 	oz_trace("oz_evt_open()\n");
 	oz_trace("Open flags: 0x%x\n", filp->f_flags);
@@ -107,7 +107,7 @@ int oz_events_open(struct inode *inode, struct file *filp)
 /*------------------------------------------------------------------------------
  * Context: process
  */
-int oz_events_release(struct inode *inode, struct file *filp)
+static int oz_events_release(struct inode *inode, struct file *filp)
 {
 	oz_events_clear(&g_evtdev);
 	atomic_dec(&g_evtdev.users);
@@ -118,7 +118,7 @@ int oz_events_release(struct inode *inode, struct file *filp)
 /*------------------------------------------------------------------------------
  * Context: process
  */
-ssize_t oz_events_read(struct file *filp, char __user *buf, size_t count,
+static ssize_t oz_events_read(struct file *filp, char __user *buf, size_t count,
 		loff_t *fpos)
 {
 	struct oz_evtdev *dev = &g_evtdev;
@@ -157,7 +157,7 @@ out:
 }
 /*------------------------------------------------------------------------------
  */
-const struct file_operations oz_events_fops = {
+static const struct file_operations oz_events_fops = {
 	.owner =	THIS_MODULE,
 	.open =		oz_events_open,
 	.release =	oz_events_release,
diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 417a52d..ed2addb 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -327,7 +327,7 @@ static struct oz_endpoint *oz_ep_alloc(gfp_t mem_flags, int buffer_size)
  * disabled.
  * Context: softirq or process
  */
-struct oz_urb_link *oz_uncancel_urb(struct oz_hcd *ozhcd, struct urb *urb)
+static struct oz_urb_link *oz_uncancel_urb(struct oz_hcd *ozhcd, struct urb *urb)
 {
 	struct oz_urb_link *urbl;
 	struct list_head *e;
@@ -417,7 +417,8 @@ static void oz_ep_free(struct oz_port *port, struct oz_endpoint *ep)
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
-void oz_complete_buffered_urb(struct oz_port *port, struct oz_endpoint *ep,
+static void oz_complete_buffered_urb(struct oz_port *port,
+			struct oz_endpoint *ep,
 			struct urb *urb)
 {
 	u8 data_len, available_space, copy_len;
diff --git a/drivers/staging/ozwpan/ozmain.c b/drivers/staging/ozwpan/ozmain.c
index ef6c5ab..57a0cbd 100644
--- a/drivers/staging/ozwpan/ozmain.c
+++ b/drivers/staging/ozwpan/ozmain.c
@@ -22,7 +22,7 @@
  * bind to nothing. '*' means bind to all netcards - this includes non-802.11
  * netcards. Bindings can be added later using an IOCTL.
  */
-char *g_net_dev = "";
+static char *g_net_dev = "";
 /*------------------------------------------------------------------------------
  * Context: process
  */
diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index d969ed7..a54f89c 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -407,7 +407,7 @@ static void oz_tx_frame_free(struct oz_pd *pd, struct oz_tx_frame *f)
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
-void oz_set_more_bit(struct sk_buff *skb)
+static void oz_set_more_bit(struct sk_buff *skb)
 {
 	struct oz_hdr *oz_hdr = (struct oz_hdr *)skb_network_header(skb);
 	oz_hdr->control |= OZ_F_MORE_DATA;
@@ -415,7 +415,7 @@ void oz_set_more_bit(struct sk_buff *skb)
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
-void oz_set_last_pkt_nb(struct oz_pd *pd, struct sk_buff *skb)
+static void oz_set_last_pkt_nb(struct oz_pd *pd, struct sk_buff *skb)
 {
 	struct oz_hdr *oz_hdr = (struct oz_hdr *)skb_network_header(skb);
 	oz_hdr->last_pkt_num = pd->trigger_pkt_num & OZ_LAST_PN_MASK;
diff --git a/drivers/staging/ozwpan/ozusbsvc1.c b/drivers/staging/ozwpan/ozusbsvc1.c
index ea4a238b..c54614d 100644
--- a/drivers/staging/ozwpan/ozusbsvc1.c
+++ b/drivers/staging/ozwpan/ozusbsvc1.c
@@ -305,7 +305,7 @@ int oz_usb_send_isoc(void *hpd, u8 ep_num, struct urb *urb)
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
-void oz_usb_handle_ep_data(struct oz_usb_ctx *usb_ctx,
+static void oz_usb_handle_ep_data(struct oz_usb_ctx *usb_ctx,
 	struct oz_usb_hdr *usb_hdr, int len)
 {
 	struct oz_data *data_hdr = (struct oz_data *)usb_hdr;
-- 
1.7.8.6

