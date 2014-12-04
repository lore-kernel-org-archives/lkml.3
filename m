Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146AbaLDWfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:35:54 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:50279 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbaLDWfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:35:52 -0500
Date: Thu, 4 Dec 2014 22:35:24 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: m.chehab@samsung.com
Cc: jarod@wilsonet.com, gregkh@linuxfoundation.org,
        mahfouz.saif.elyazal@gmail.com, gulsah.1004@gmail.com,
        tuomas.tynkkynen@iki.fi, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] staging: media: lirc: lirc_zilog.c: keep consistency
 in dev functions
Message-ID: <20141204223524.GA17650@biggie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patch switched some dev functions to move the string to a second
line. Doing this for all similar functions because it makes the driver easier
to read if all similar lines use the same criteria.

Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
---
 drivers/staging/media/lirc/lirc_zilog.c | 155 +++++++++++++++++++++-----------
 1 file changed, 102 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 8814a7e..af46827 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -322,7 +322,8 @@ static int add_to_buf(struct IR *ir)
 	struct IR_tx *tx;
 
 	if (lirc_buffer_full(rbuf)) {
-		dev_dbg(ir->l.dev, "buffer overflow\n");
+		dev_dbg(ir->l.dev,
+			"buffer overflow\n");
 		return -EOVERFLOW;
 	}
 
@@ -368,8 +369,9 @@ static int add_to_buf(struct IR *ir)
 		 */
 		ret = i2c_master_send(rx->c, sendbuf, 1);
 		if (ret != 1) {
-			dev_err(ir->l.dev, "i2c_master_send failed with %d\n",
-					   ret);
+			dev_err(ir->l.dev,
+				"i2c_master_send failed with %d\n",
+				ret);
 			if (failures >= 3) {
 				mutex_unlock(&ir->ir_lock);
 				dev_err(ir->l.dev,
@@ -412,8 +414,9 @@ static int add_to_buf(struct IR *ir)
 			rx->b[0] = keybuf[3];
 			rx->b[1] = keybuf[4];
 			rx->b[2] = keybuf[5];
-			dev_dbg(ir->l.dev, "key (0x%02x/0x%02x)\n",
-					   rx->b[0], rx->b[1]);
+			dev_dbg(ir->l.dev,
+				"key (0x%02x/0x%02x)\n",
+				rx->b[0], rx->b[1]);
 		}
 
 		/* key pressed ? */
@@ -464,7 +467,8 @@ static int lirc_thread(void *arg)
 	struct IR *ir = arg;
 	struct lirc_buffer *rbuf = ir->l.rbuf;
 
-	dev_dbg(ir->l.dev, "poll thread started\n");
+	dev_dbg(ir->l.dev,
+		"poll thread started\n");
 
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -492,7 +496,8 @@ static int lirc_thread(void *arg)
 			wake_up_interruptible(&rbuf->wait_poll);
 	}
 
-	dev_dbg(ir->l.dev, "poll thread ended\n");
+	dev_dbg(ir->l.dev,
+		"poll thread ended\n");
 	return 0;
 }
 
@@ -654,11 +659,14 @@ static int send_data_block(struct IR_tx *tx, unsigned char *data_block)
 		buf[0] = (unsigned char)(i + 1);
 		for (j = 0; j < tosend; ++j)
 			buf[1 + j] = data_block[i + j];
-		dev_dbg(tx->ir->l.dev, "%*ph", 5, buf);
+		dev_dbg(tx->ir->l.dev,
+			"%*ph",
+			5, buf);
 		ret = i2c_master_send(tx->c, buf, tosend + 1);
 		if (ret != tosend + 1) {
-			dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n",
-					       ret);
+			dev_err(tx->ir->l.dev,
+				"i2c_master_send failed with %d\n",
+				ret);
 			return ret < 0 ? ret : -EFAULT;
 		}
 		i += tosend;
@@ -682,7 +690,9 @@ static int send_boot_data(struct IR_tx *tx)
 	buf[1] = 0x20;
 	ret = i2c_master_send(tx->c, buf, 2);
 	if (ret != 2) {
-		dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n", ret);
+		dev_err(tx->ir->l.dev,
+			"i2c_master_send failed with %d\n",
+			ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 
@@ -699,19 +709,24 @@ static int send_boot_data(struct IR_tx *tx)
 	}
 
 	if (ret != 1) {
-		dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n", ret);
+		dev_err(tx->ir->l.dev,
+			"i2c_master_send failed with %d\n",
+			ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 
 	/* Here comes the firmware version... (hopefully) */
 	ret = i2c_master_recv(tx->c, buf, 4);
 	if (ret != 4) {
-		dev_err(tx->ir->l.dev, "i2c_master_recv failed with %d\n", ret);
+		dev_err(tx->ir->l.dev,
+			"i2c_master_recv failed with %d\n",
+			ret);
 		return 0;
 	}
 	if ((buf[0] != 0x80) && (buf[0] != 0xa0)) {
-		dev_err(tx->ir->l.dev, "unexpected IR TX init response: %02x\n",
-				       buf[0]);
+		dev_err(tx->ir->l.dev,
+			"unexpected IR TX init response: %02x\n",
+			buf[0]);
 		return 0;
 	}
 	dev_notice(tx->ir->l.dev,
@@ -763,12 +778,15 @@ static int fw_load(struct IR_tx *tx)
 	/* Request codeset data file */
 	ret = request_firmware(&fw_entry, "haup-ir-blaster.bin", tx->ir->l.dev);
 	if (ret != 0) {
-		dev_err(tx->ir->l.dev, "firmware haup-ir-blaster.bin not available (%d)\n",
-			    ret);
+		dev_err(tx->ir->l.dev,
+			"firmware haup-ir-blaster.bin not available (%d)\n",
+			ret);
 		ret = ret < 0 ? ret : -EFAULT;
 		goto out;
 	}
-	dev_dbg(tx->ir->l.dev, "firmware of size %zu loaded\n", fw_entry->size);
+	dev_dbg(tx->ir->l.dev,
+		"firmware of size %zu loaded\n",
+		fw_entry->size);
 
 	/* Parse the file */
 	tx_data = vmalloc(sizeof(*tx_data));
@@ -813,8 +831,9 @@ static int fw_load(struct IR_tx *tx)
 			      &tx_data->num_code_sets))
 		goto corrupt;
 
-	dev_dbg(tx->ir->l.dev, "%u IR blaster codesets loaded\n",
-			       tx_data->num_code_sets);
+	dev_dbg(tx->ir->l.dev,
+		"%u IR blaster codesets loaded\n",
+		tx_data->num_code_sets);
 
 	tx_data->code_sets = vmalloc(
 		tx_data->num_code_sets * sizeof(char *));
@@ -878,7 +897,8 @@ static int fw_load(struct IR_tx *tx)
 	goto out;
 
 corrupt:
-	dev_err(tx->ir->l.dev, "firmware is corrupt\n");
+	dev_err(tx->ir->l.dev,
+		"firmware is corrupt\n");
 	fw_unload_locked();
 	ret = -EFAULT;
 
@@ -898,9 +918,11 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
 	unsigned int m;
 	DECLARE_WAITQUEUE(wait, current);
 
-	dev_dbg(ir->l.dev, "read called\n");
+	dev_dbg(ir->l.dev,
+		"read called\n");
 	if (n % rbuf->chunk_size) {
-		dev_dbg(ir->l.dev, "read result = -EINVAL\n");
+		dev_dbg(ir->l.dev,
+			"read result = -EINVAL\n");
 		return -EINVAL;
 	}
 
@@ -944,8 +966,9 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
 			unsigned char buf[MAX_XFER_SIZE];
 
 			if (rbuf->chunk_size > sizeof(buf)) {
-				dev_err(ir->l.dev, "chunk_size is too big (%d)!\n",
-					    rbuf->chunk_size);
+				dev_err(ir->l.dev,
+					"chunk_size is too big (%d)!\n",
+					rbuf->chunk_size);
 				ret = -EINVAL;
 				break;
 			}
@@ -958,7 +981,8 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
 				retries++;
 			}
 			if (retries >= 5) {
-				dev_err(ir->l.dev, "Buffer read failed!\n");
+				dev_err(ir->l.dev,
+					"Buffer read failed!\n");
 				ret = -EIO;
 			}
 		}
@@ -968,8 +992,9 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
 	put_ir_rx(rx, false);
 	set_current_state(TASK_RUNNING);
 
-	dev_dbg(ir->l.dev, "read result = %d (%s)\n",
-			   ret, ret ? "Error" : "OK");
+	dev_dbg(ir->l.dev,
+		"read result = %d (%s)\n",
+		ret, ret ? "Error" : "OK");
 
 	return ret ? ret : written;
 }
@@ -1002,7 +1027,9 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	buf[1] = 0x40;
 	ret = i2c_master_send(tx->c, buf, 2);
 	if (ret != 2) {
-		dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n", ret);
+		dev_err(tx->ir->l.dev,
+			"i2c_master_send failed with %d\n",
+			ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 
@@ -1015,18 +1042,23 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	}
 
 	if (ret != 1) {
-		dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n", ret);
+		dev_err(tx->ir->l.dev,
+			"i2c_master_send failed with %d\n",
+			ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 
 	/* Send finished download? */
 	ret = i2c_master_recv(tx->c, buf, 1);
 	if (ret != 1) {
-		dev_err(tx->ir->l.dev, "i2c_master_recv failed with %d\n", ret);
+		dev_err(tx->ir->l.dev,
+			"i2c_master_recv failed with %d\n",
+			ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 	if (buf[0] != 0xA0) {
-		dev_err(tx->ir->l.dev, "unexpected IR TX response #1: %02x\n",
+		dev_err(tx->ir->l.dev,
+			"unexpected IR TX response #1: %02x\n",
 			buf[0]);
 		return -EFAULT;
 	}
@@ -1036,7 +1068,9 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	buf[1] = 0x80;
 	ret = i2c_master_send(tx->c, buf, 2);
 	if (ret != 2) {
-		dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n", ret);
+		dev_err(tx->ir->l.dev,
+			"i2c_master_send failed with %d\n",
+			ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 
@@ -1046,7 +1080,9 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	 * going to skip this whole mess and say we're done on the HD PVR
 	 */
 	if (!tx->post_tx_ready_poll) {
-		dev_dbg(tx->ir->l.dev, "sent code %u, key %u\n", code, key);
+		dev_dbg(tx->ir->l.dev,
+			"sent code %u, key %u\n",
+			code, key);
 		return 0;
 	}
 
@@ -1076,17 +1112,22 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	/* Seems to be an 'ok' response */
 	i = i2c_master_recv(tx->c, buf, 1);
 	if (i != 1) {
-		dev_err(tx->ir->l.dev, "i2c_master_recv failed with %d\n", ret);
+		dev_err(tx->ir->l.dev,
+			"i2c_master_recv failed with %d\n",
+			ret);
 		return -EFAULT;
 	}
 	if (buf[0] != 0x80) {
-		dev_err(tx->ir->l.dev, "unexpected IR TX response #2: %02x\n",
-				       buf[0]);
+		dev_err(tx->ir->l.dev,
+			"unexpected IR TX response #2: %02x\n",
+			buf[0]);
 		return -EFAULT;
 	}
 
 	/* Oh good, it worked */
-	dev_dbg(tx->ir->l.dev, "sent code %u, key %u\n", code, key);
+	dev_dbg(tx->ir->l.dev,
+		"sent code %u, key %u\n",
+		code, key);
 	return 0;
 }
 
@@ -1211,7 +1252,8 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 	struct lirc_buffer *rbuf = ir->l.rbuf;
 	unsigned int ret;
 
-	dev_dbg(ir->l.dev, "poll called\n");
+	dev_dbg(ir->l.dev,
+		"poll called\n");
 
 	rx = get_ir_rx(ir);
 	if (rx == NULL) {
@@ -1219,7 +1261,8 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 		 * Revisit this, if our poll function ever reports writeable
 		 * status for Tx
 		 */
-		dev_dbg(ir->l.dev, "poll result = POLLERR\n");
+		dev_dbg(ir->l.dev,
+			"poll result = POLLERR\n");
 		return POLLERR;
 	}
 
@@ -1232,8 +1275,9 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 	/* Indicate what ops could happen immediately without blocking */
 	ret = lirc_buffer_empty(rbuf) ? 0 : (POLLIN|POLLRDNORM);
 
-	dev_dbg(ir->l.dev, "poll result = %s\n",
-			   ret ? "POLLIN|POLLRDNORM" : "none");
+	dev_dbg(ir->l.dev,
+		"poll result = %s\n",
+		ret ? "POLLIN|POLLRDNORM" : "none");
 	return ret;
 }
 
@@ -1340,7 +1384,8 @@ static int close(struct inode *node, struct file *filep)
 	struct IR *ir = filep->private_data;
 
 	if (ir == NULL) {
-		dev_err(ir->l.dev, "close: no private_data attached to the file!\n");
+		dev_err(ir->l.dev,
+			"close: no private_data attached to the file!\n");
 		return -ENODEV;
 	}
 
@@ -1452,7 +1497,8 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	int ret;
 	bool tx_probe = false;
 
-	dev_dbg(&client->dev, "%s: %s on i2c-%d (%s), client addr=0x%02x\n",
+	dev_dbg(&client->dev,
+		"%s: %s on i2c-%d (%s), client addr=0x%02x\n",
 		__func__, id->name, adap->nr, adap->name, client->addr);
 
 	/*
@@ -1611,13 +1657,15 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	ir->l.minor = minor; /* module option: user requested minor number */
 	ir->l.minor = lirc_register_driver(&ir->l);
 	if (ir->l.minor < 0 || ir->l.minor >= MAX_IRCTL_DEVICES) {
-		dev_err(tx->ir->l.dev, "%s: \"minor\" must be between 0 and %d (%d)!\n",
-			    __func__, MAX_IRCTL_DEVICES-1, ir->l.minor);
+		dev_err(tx->ir->l.dev,
+			"%s: \"minor\" must be between 0 and %d (%d)!\n",
+			__func__, MAX_IRCTL_DEVICES-1, ir->l.minor);
 		ret = -EBADRQC;
 		goto out_put_xx;
 	}
-	dev_info(ir->l.dev, "IR unit on %s (i2c-%d) registered as lirc%d and ready\n",
-		   adap->name, adap->nr, ir->l.minor);
+	dev_info(ir->l.dev,
+		 "IR unit on %s (i2c-%d) registered as lirc%d and ready\n",
+		 adap->name, adap->nr, ir->l.minor);
 
 out_ok:
 	if (rx != NULL)
@@ -1625,8 +1673,9 @@ out_ok:
 	if (tx != NULL)
 		put_ir_tx(tx, true);
 	put_ir_device(ir, true);
-	dev_info(ir->l.dev, "probe of IR %s on %s (i2c-%d) done\n",
-		   tx_probe ? "Tx" : "Rx", adap->name, adap->nr);
+	dev_info(ir->l.dev,
+		 "probe of IR %s on %s (i2c-%d) done\n",
+		 tx_probe ? "Tx" : "Rx", adap->name, adap->nr);
 	mutex_unlock(&ir_devices_lock);
 	return 0;
 
@@ -1638,9 +1687,9 @@ out_put_xx:
 out_put_ir:
 	put_ir_device(ir, true);
 out_no_ir:
-	dev_err(&client->dev, "%s: probing IR %s on %s (i2c-%d) failed with %d\n",
-		    __func__, tx_probe ? "Tx" : "Rx", adap->name, adap->nr,
-		   ret);
+	dev_err(&client->dev,
+		"%s: probing IR %s on %s (i2c-%d) failed with %d\n",
+		__func__, tx_probe ? "Tx" : "Rx", adap->name, adap->nr, ret);
 	mutex_unlock(&ir_devices_lock);
 	return ret;
 }
-- 
2.1.3

