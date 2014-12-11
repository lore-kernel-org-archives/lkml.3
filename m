Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350AbaLKAXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 19:23:30 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:42964 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125AbaLKAX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 19:23:29 -0500
Date: Thu, 11 Dec 2014 00:22:52 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: m.chehab@samsung.com
Cc: jarod@wilsonet.com, gregkh@linuxfoundation.org,
        mahfouz.saif.elyazal@gmail.com, gulsah.1004@gmail.com,
        tuomas.tynkkynen@iki.fi, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/3] staging: media: lirc: lirc_zilog.c: keep consistency
 in dev functions
Message-ID: <20141211002252.GA11088@biggie>
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
 drivers/staging/media/lirc/lirc_zilog.c | 57 ++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 8814a7e..27464da 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -369,7 +369,7 @@ static int add_to_buf(struct IR *ir)
 		ret = i2c_master_send(rx->c, sendbuf, 1);
 		if (ret != 1) {
 			dev_err(ir->l.dev, "i2c_master_send failed with %d\n",
-					   ret);
+				ret);
 			if (failures >= 3) {
 				mutex_unlock(&ir->ir_lock);
 				dev_err(ir->l.dev,
@@ -412,8 +412,9 @@ static int add_to_buf(struct IR *ir)
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
@@ -657,8 +658,8 @@ static int send_data_block(struct IR_tx *tx, unsigned char *data_block)
 		dev_dbg(tx->ir->l.dev, "%*ph", 5, buf);
 		ret = i2c_master_send(tx->c, buf, tosend + 1);
 		if (ret != tosend + 1) {
-			dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n",
-					       ret);
+			dev_err(tx->ir->l.dev,
+				"i2c_master_send failed with %d\n", ret);
 			return ret < 0 ? ret : -EFAULT;
 		}
 		i += tosend;
@@ -711,7 +712,7 @@ static int send_boot_data(struct IR_tx *tx)
 	}
 	if ((buf[0] != 0x80) && (buf[0] != 0xa0)) {
 		dev_err(tx->ir->l.dev, "unexpected IR TX init response: %02x\n",
-				       buf[0]);
+			buf[0]);
 		return 0;
 	}
 	dev_notice(tx->ir->l.dev,
@@ -763,8 +764,9 @@ static int fw_load(struct IR_tx *tx)
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
@@ -814,7 +816,7 @@ static int fw_load(struct IR_tx *tx)
 		goto corrupt;
 
 	dev_dbg(tx->ir->l.dev, "%u IR blaster codesets loaded\n",
-			       tx_data->num_code_sets);
+		tx_data->num_code_sets);
 
 	tx_data->code_sets = vmalloc(
 		tx_data->num_code_sets * sizeof(char *));
@@ -944,8 +946,9 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
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
@@ -968,8 +971,8 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
 	put_ir_rx(rx, false);
 	set_current_state(TASK_RUNNING);
 
-	dev_dbg(ir->l.dev, "read result = %d (%s)\n",
-			   ret, ret ? "Error" : "OK");
+	dev_dbg(ir->l.dev, "read result = %d (%s)\n", ret,
+		ret ? "Error" : "OK");
 
 	return ret ? ret : written;
 }
@@ -1081,7 +1084,7 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	}
 	if (buf[0] != 0x80) {
 		dev_err(tx->ir->l.dev, "unexpected IR TX response #2: %02x\n",
-				       buf[0]);
+			buf[0]);
 		return -EFAULT;
 	}
 
@@ -1233,7 +1236,7 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 	ret = lirc_buffer_empty(rbuf) ? 0 : (POLLIN|POLLRDNORM);
 
 	dev_dbg(ir->l.dev, "poll result = %s\n",
-			   ret ? "POLLIN|POLLRDNORM" : "none");
+		ret ? "POLLIN|POLLRDNORM" : "none");
 	return ret;
 }
 
@@ -1340,7 +1343,8 @@ static int close(struct inode *node, struct file *filep)
 	struct IR *ir = filep->private_data;
 
 	if (ir == NULL) {
-		dev_err(ir->l.dev, "close: no private_data attached to the file!\n");
+		dev_err(ir->l.dev,
+			"close: no private_data attached to the file!\n");
 		return -ENODEV;
 	}
 
@@ -1611,13 +1615,15 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
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
@@ -1625,8 +1631,9 @@ out_ok:
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
 
@@ -1638,9 +1645,9 @@ out_put_xx:
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

