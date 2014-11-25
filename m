Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaKYUTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:19:23 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:53638 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaKYUTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:19:21 -0500
Date: Tue, 25 Nov 2014 20:19:05 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: linux-kernel@vger.kernel.org
Cc: jarod@wilsonet.com, m.chehab@samsung.com, gregkh@linuxfoundation.org,
        mahfouz.saif.elyazal@gmail.com, dan.carpenter@oracle.com,
        tuomas.tynkkynen@iki.fi, gulsah.1004@gmail.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: lirc: lirc_zilog.c: fix quoted strings split
 across lines
Message-ID: <20141125201905.GA10900@biggie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch makes an exception to the 80-colum rule for quotes strings, and
Documentation/CodingStyle recommends not splitting quotes strings across lines
because it breaks the ability to grep for the string. Fixing these.

WARNING: quoted string split across lines

Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
---
 drivers/staging/media/lirc/lirc_zilog.c | 39 ++++++++++++++-------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index dca806a..07675f1 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -372,14 +372,12 @@ static int add_to_buf(struct IR *ir)
 					   ret);
 			if (failures >= 3) {
 				mutex_unlock(&ir->ir_lock);
-				dev_err(ir->l.dev, "unable to read from the IR chip "
-					    "after 3 resets, giving up\n");
+				dev_err(ir->l.dev, "unable to read from the IR chip after 3 resets, giving up\n");
 				break;
 			}
 
 			/* Looks like the chip crashed, reset it */
-			dev_err(ir->l.dev, "polling the IR receiver chip failed, "
-				    "trying reset\n");
+			dev_err(ir->l.dev, "polling the IR receiver chip failed, trying reset\n");
 
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			if (kthread_should_stop()) {
@@ -405,8 +403,8 @@ static int add_to_buf(struct IR *ir)
 		ret = i2c_master_recv(rx->c, keybuf, sizeof(keybuf));
 		mutex_unlock(&ir->ir_lock);
 		if (ret != sizeof(keybuf)) {
-			dev_err(ir->l.dev, "i2c_master_recv failed with %d -- "
-				    "keeping last read buffer\n", ret);
+			dev_err(ir->l.dev, "i2c_master_recv failed with %d -- keeping last read buffer\n",
+				    ret);
 		} else {
 			rx->b[0] = keybuf[3];
 			rx->b[1] = keybuf[4];
@@ -713,8 +711,8 @@ static int send_boot_data(struct IR_tx *tx)
 				       buf[0]);
 		return 0;
 	}
-	dev_notice(tx->ir->l.dev, "Zilog/Hauppauge IR blaster firmware version "
-		     "%d.%d.%d loaded\n", buf[1], buf[2], buf[3]);
+	dev_notice(tx->ir->l.dev, "Zilog/Hauppauge IR blaster firmware version %d.%d.%d loaded\n",
+		     buf[1], buf[2], buf[3]);
 
 	return 0;
 }
@@ -794,8 +792,7 @@ static int fw_load(struct IR_tx *tx)
 	if (!read_uint8(&data, tx_data->endp, &version))
 		goto corrupt;
 	if (version != 1) {
-		dev_err(tx->ir->l.dev, "unsupported code set file version (%u, expected"
-			    "1) -- please upgrade to a newer driver",
+		dev_err(tx->ir->l.dev, "unsupported code set file version (%u, expected1) -- please upgrade to a newer driver",
 			    version);
 		fw_unload_locked();
 		ret = -EFAULT;
@@ -983,8 +980,8 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	ret = get_key_data(data_block, code, key);
 
 	if (ret == -EPROTO) {
-		dev_err(tx->ir->l.dev, "failed to get data for code %u, key %u -- check "
-			    "lircd.conf entries\n", code, key);
+		dev_err(tx->ir->l.dev, "failed to get data for code %u, key %u -- check lircd.conf entries\n",
+			    code, key);
 		return ret;
 	} else if (ret != 0)
 		return ret;
@@ -1059,8 +1056,8 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 		ret = i2c_master_send(tx->c, buf, 1);
 		if (ret == 1)
 			break;
-		dev_dbg(tx->ir->l.dev, "NAK expected: i2c_master_send "
-			"failed with %d (try %d)\n", ret, i+1);
+		dev_dbg(tx->ir->l.dev, "NAK expected: i2c_master_send failed with %d (try %d)\n",
+			ret, i+1);
 	}
 	if (ret != 1) {
 		dev_err(tx->ir->l.dev, "IR TX chip never got ready: last i2c_master_send "
@@ -1167,12 +1164,10 @@ static ssize_t write(struct file *filep, const char __user *buf, size_t n,
 		 */
 		if (ret != 0) {
 			/* Looks like the chip crashed, reset it */
-			dev_err(tx->ir->l.dev, "sending to the IR transmitter chip "
-				    "failed, trying reset\n");
+			dev_err(tx->ir->l.dev, "sending to the IR transmitter chip failed, trying reset\n");
 
 			if (failures >= 3) {
-				dev_err(tx->ir->l.dev, "unable to send to the IR chip "
-					    "after 3 resets, giving up\n");
+				dev_err(tx->ir->l.dev, "unable to send to the IR chip after 3 resets, giving up\n");
 				mutex_unlock(&ir->ir_lock);
 				mutex_unlock(&tx->client_lock);
 				put_ir_tx(tx, false);
@@ -1581,8 +1576,8 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 				       "zilog-rx-i2c-%d", adap->nr);
 		if (IS_ERR(rx->task)) {
 			ret = PTR_ERR(rx->task);
-			dev_err(tx->ir->l.dev, "%s: could not start IR Rx polling thread"
-				    "\n", __func__);
+			dev_err(tx->ir->l.dev, "%s: could not start IR Rx polling thread\n",
+				    __func__);
 			/* Failed kthread, so put back the ir ref */
 			put_ir_device(ir, true);
 			/* Failure exit, so put back rx ref from i2c_client */
@@ -1594,8 +1589,8 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 		/* Proceed only if the Tx client is also ready */
 		if (tx == NULL) {
-			pr_info("probe of IR Rx on %s (i2c-%d) done. Waiting"
-				   " on IR Tx.\n", adap->name, adap->nr);
+			pr_info("probe of IR Rx on %s (i2c-%d) done. Waiting on IR Tx.\n",
+				   adap->name, adap->nr);
 			goto out_ok;
 		}
 	}
-- 
2.1.3

