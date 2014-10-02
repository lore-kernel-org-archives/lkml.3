Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaJBCf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 22:35:57 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49071 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbaJBCfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 22:35:55 -0400
From: Amber Thrall <amber.rose.thrall@gmail.com>
To: greg@kroah.com, jarod@wilsonet.com
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amber Thrall <amber.rose.thrall@gmail.com>
Subject: [PATCH] Fixed all coding style issues for drivers/staging/media/lirc/
Date: Wed,  1 Oct 2014 19:35:51 -0700
Message-Id: <1412217351-27091-1-git-send-email-amber.rose.thrall@gmail.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed various coding sytles.

Signed-off-by: Amber Thrall <amber.rose.thrall@gmail.com>
---
 drivers/staging/media/lirc/lirc_bt829.c  |  2 +-
 drivers/staging/media/lirc/lirc_imon.c   |  4 +-
 drivers/staging/media/lirc/lirc_sasem.c  |  6 +--
 drivers/staging/media/lirc/lirc_serial.c | 29 ++++++--------
 drivers/staging/media/lirc/lirc_sir.c    |  3 +-
 drivers/staging/media/lirc/lirc_zilog.c  | 69 +++++++++++++++-----------------
 6 files changed, 52 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_bt829.c b/drivers/staging/media/lirc/lirc_bt829.c
index 4c806ba..c70ca68 100644
--- a/drivers/staging/media/lirc/lirc_bt829.c
+++ b/drivers/staging/media/lirc/lirc_bt829.c
@@ -59,7 +59,7 @@ static bool debug;
 #define dprintk(fmt, args...)						 \
 	do {								 \
 		if (debug)						 \
-			printk(KERN_DEBUG DRIVER_NAME ": "fmt, ## args); \
+			dev_dbg(DRIVER_NAME, ": "fmt, ##args); \
 	} while (0)
 
 static int atir_minor;
diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index 7aca44f..bce0408 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -623,8 +623,8 @@ static void imon_incoming_packet(struct imon_context *context,
 	if (debug) {
 		dev_info(dev, "raw packet: ");
 		for (i = 0; i < len; ++i)
-			printk("%02x ", buf[i]);
-		printk("\n");
+			dev_info(dev, "%02x ", buf[i]);
+		dev_info(dev, "\n");
 	}
 
 	/*
diff --git a/drivers/staging/media/lirc/lirc_sasem.c b/drivers/staging/media/lirc/lirc_sasem.c
index c20ef56..e88e246 100644
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@ -583,10 +583,10 @@ static void incoming_packet(struct sasem_context *context,
 	}
 
 	if (debug) {
-		printk(KERN_INFO "Incoming data: ");
+		pr_info("Incoming data: ");
 		for (i = 0; i < 8; ++i)
-			printk(KERN_CONT "%02x ", buf[i]);
-		printk(KERN_CONT "\n");
+			pr_cont("%02x", buf[i]);
+		pr_cont("\n");
 	}
 
 	/*
diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index 181b92b..b07671b 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -116,8 +116,7 @@ static bool txsense;	/* 0 = active high, 1 = active low */
 #define dprintk(fmt, args...)					\
 	do {							\
 		if (debug)					\
-			printk(KERN_DEBUG LIRC_DRIVER_NAME ": "	\
-			       fmt, ## args);			\
+			dev_dbg(LIRC_DRIVER_NAME, ": "fmt, ##args); \
 	} while (0)
 
 /* forward declarations */
@@ -356,9 +355,8 @@ static int init_timing_params(unsigned int new_duty_cycle,
 	/* Derive pulse and space from the period */
 	pulse_width = period * duty_cycle / 100;
 	space_width = period - pulse_width;
-	dprintk("in init_timing_params, freq=%d, duty_cycle=%d, "
-		"clk/jiffy=%ld, pulse=%ld, space=%ld, "
-		"conv_us_to_clocks=%ld\n",
+	dprintk("in init_timing_params, freq=%d, duty_cycle=%d, clk/jiffy=%ld,
+			pulse=%ld, space=%ld, conv_us_to_clocks=%ld\n",
 		freq, duty_cycle, __this_cpu_read(cpu_info.loops_per_jiffy),
 		pulse_width, space_width, conv_us_to_clocks);
 	return 0;
@@ -1075,7 +1073,7 @@ static int __init lirc_serial_init(void)
 
 	result = platform_driver_register(&lirc_serial_driver);
 	if (result) {
-		printk("lirc register returned %d\n", result);
+		dprintk("lirc register returned %d\n", result);
 		goto exit_buffer_free;
 	}
 
@@ -1166,22 +1164,20 @@ module_init(lirc_serial_init_module);
 module_exit(lirc_serial_exit_module);
 
 MODULE_DESCRIPTION("Infra-red receiver driver for serial ports.");
-MODULE_AUTHOR("Ralph Metzler, Trent Piepho, Ben Pfaff, "
-	      "Christoph Bartelmus, Andrei Tanas");
+MODULE_AUTHOR("Ralph Metzler, Trent Piepho, Ben Pfaff, Christoph Bartelmus, Andrei Tanas");
 MODULE_LICENSE("GPL");
 
 module_param(type, int, S_IRUGO);
-MODULE_PARM_DESC(type, "Hardware type (0 = home-brew, 1 = IRdeo,"
-		 " 2 = IRdeo Remote, 3 = AnimaX, 4 = IgorPlug,"
-		 " 5 = NSLU2 RX:CTS2/TX:GreenLED)");
+MODULE_PARM_DESC(type, "Hardware type (0 = home-brew, 1 = IRdeo,
+	2 = IRdeo Remote, 3 = AnimaX, 4 = IgorPlug,
+	5 = NSLU2 RX:CTS2/TX:GreenLED)");
 
 module_param(io, int, S_IRUGO);
 MODULE_PARM_DESC(io, "I/O address base (0x3f8 or 0x2f8)");
 
 /* some architectures (e.g. intel xscale) have memory mapped registers */
 module_param(iommap, bool, S_IRUGO);
-MODULE_PARM_DESC(iommap, "physical base for memory mapped I/O"
-		" (0 = no memory mapped io)");
+MODULE_PARM_DESC(iommap, "physical base for memory mapped I/O (0 = no memory mapped io)");
 
 /*
  * some architectures (e.g. intel xscale) align the 8bit serial registers
@@ -1198,13 +1194,12 @@ module_param(share_irq, bool, S_IRUGO);
 MODULE_PARM_DESC(share_irq, "Share interrupts (0 = off, 1 = on)");
 
 module_param(sense, int, S_IRUGO);
-MODULE_PARM_DESC(sense, "Override autodetection of IR receiver circuit"
-		 " (0 = active high, 1 = active low )");
+MODULE_PARM_DESC(sense, "Override autodetection of IR receiver circuit
+		(0 = active high, 1 = active low )");
 
 #ifdef CONFIG_LIRC_SERIAL_TRANSMITTER
 module_param(txsense, bool, S_IRUGO);
-MODULE_PARM_DESC(txsense, "Sense of transmitter circuit"
-		 " (0 = active high, 1 = active low )");
+MODULE_PARM_DESC(txsense, "Sense of transmitter circuit (0 = active high, 1 = active low )");
 #endif
 
 module_param(softcarrier, bool, S_IRUGO);
diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index 2ee55ea..cdbb71f 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -143,8 +143,7 @@ static bool debug;
 #define dprintk(fmt, args...)						\
 	do {								\
 		if (debug)						\
-			printk(KERN_DEBUG LIRC_DRIVER_NAME ": "		\
-				fmt, ## args);				\
+			dev_dbg(LIRC_DRIVER_NAME, ": "fmt, ## args); \
 	} while (0)
 
 /* SECTION: Prototypes */
diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 567feba..9c3a3d7 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -152,10 +152,9 @@ struct tx_data_struct {
 static struct tx_data_struct *tx_data;
 static struct mutex tx_data_lock;
 
-#define zilog_notify(s, args...) printk(KERN_NOTICE KBUILD_MODNAME ": " s, \
-					## args)
-#define zilog_error(s, args...) printk(KERN_ERR KBUILD_MODNAME ": " s, ## args)
-#define zilog_info(s, args...) printk(KERN_INFO KBUILD_MODNAME ": " s, ## args)
+#define zilog_notify(s, args...) dev_notice(KBUILD_MODNAME, ": " s, ## args)
+#define zilog_error(s, args...) dev_err(KBUILD_MODNAME, ": " s, ## args)
+#define zilog_info(s, args...) dev_info(KBUILD_MODNAME, ": " s, ## args)
 
 /* module parameters */
 static bool debug;	/* debug output */
@@ -165,8 +164,7 @@ static int minor = -1;	/* minor number */
 #define dprintk(fmt, args...)						\
 	do {								\
 		if (debug)						\
-			printk(KERN_DEBUG KBUILD_MODNAME ": " fmt,	\
-				 ## args);				\
+			pr_dbg(KBUILD_MODNAME, ": " fmt, ## args); \
 	} while (0)
 
 
@@ -382,14 +380,14 @@ static int add_to_buf(struct IR *ir)
 			zilog_error("i2c_master_send failed with %d\n",	ret);
 			if (failures >= 3) {
 				mutex_unlock(&ir->ir_lock);
-				zilog_error("unable to read from the IR chip "
-					    "after 3 resets, giving up\n");
+				zilog_error("unable to read from the IR chip
+						after 3 resets, giving up\n");
 				break;
 			}
 
 			/* Looks like the chip crashed, reset it */
-			zilog_error("polling the IR receiver chip failed, "
-				    "trying reset\n");
+			zilog_error("polling the IR receiver chip failed,
+					trying reset\n");
 
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			if (kthread_should_stop()) {
@@ -415,8 +413,8 @@ static int add_to_buf(struct IR *ir)
 		ret = i2c_master_recv(rx->c, keybuf, sizeof(keybuf));
 		mutex_unlock(&ir->ir_lock);
 		if (ret != sizeof(keybuf)) {
-			zilog_error("i2c_master_recv failed with %d -- "
-				    "keeping last read buffer\n", ret);
+			zilog_error("i2c_master_recv failed with %d --
+					keeping last read buffer\n", ret);
 		} else {
 			rx->b[0] = keybuf[3];
 			rx->b[1] = keybuf[4];
@@ -720,8 +718,8 @@ static int send_boot_data(struct IR_tx *tx)
 		zilog_error("unexpected IR TX init response: %02x\n", buf[0]);
 		return 0;
 	}
-	zilog_notify("Zilog/Hauppauge IR blaster firmware version "
-		     "%d.%d.%d loaded\n", buf[1], buf[2], buf[3]);
+	zilog_notify("Zilog/Hauppauge IR blaster firmware version
+			%d.%d.%d loaded\n", buf[1], buf[2], buf[3]);
 
 	return 0;
 }
@@ -803,9 +801,8 @@ static int fw_load(struct IR_tx *tx)
 	if (!read_uint8(&data, tx_data->endp, &version))
 		goto corrupt;
 	if (version != 1) {
-		zilog_error("unsupported code set file version (%u, expected"
-			    "1) -- please upgrade to a newer driver",
-			    version);
+		zilog_error("unsupported code set file version (%u, expected
+			1) -- please upgrade to a newer driver", version);
 		fw_unload_locked();
 		ret = -EFAULT;
 		goto out;
@@ -990,8 +987,8 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	ret = get_key_data(data_block, code, key);
 
 	if (ret == -EPROTO) {
-		zilog_error("failed to get data for code %u, key %u -- check "
-			    "lircd.conf entries\n", code, key);
+		zilog_error("failed to get data for code %u, key %u -- check
+				lircd.conf entries\n", code, key);
 		return ret;
 	} else if (ret != 0)
 		return ret;
@@ -1066,12 +1063,12 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 		ret = i2c_master_send(tx->c, buf, 1);
 		if (ret == 1)
 			break;
-		dprintk("NAK expected: i2c_master_send "
-			"failed with %d (try %d)\n", ret, i+1);
+		dprintk("NAK expected: i2c_master_send
+				failed with %d (try %d)\n", ret, i+1);
 	}
 	if (ret != 1) {
-		zilog_error("IR TX chip never got ready: last i2c_master_send "
-			    "failed with %d\n", ret);
+		zilog_error("IR TX chip never got ready: last i2c_master_send
+				failed with %d\n", ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 
@@ -1173,12 +1170,12 @@ static ssize_t write(struct file *filep, const char __user *buf, size_t n,
 		 */
 		if (ret != 0) {
 			/* Looks like the chip crashed, reset it */
-			zilog_error("sending to the IR transmitter chip "
-				    "failed, trying reset\n");
+			zilog_error("sending to the IR transmitter chip
+					failed, trying reset\n");
 
 			if (failures >= 3) {
-				zilog_error("unable to send to the IR chip "
-					    "after 3 resets, giving up\n");
+				zilog_error("unable to send to the IR chip
+						after 3 resets, giving up\n");
 				mutex_unlock(&ir->ir_lock);
 				mutex_unlock(&tx->client_lock);
 				put_ir_tx(tx, false);
@@ -1547,8 +1544,8 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 		/* Proceed only if the Rx client is also ready or not needed */
 		if (rx == NULL && !tx_only) {
-			zilog_info("probe of IR Tx on %s (i2c-%d) done. Waiting"
-				   " on IR Rx.\n", adap->name, adap->nr);
+			zilog_info("probe of IR Tx on %s (i2c-%d) done. Waiting
+					on IR Rx.\n", adap->name, adap->nr);
 			goto out_ok;
 		}
 	} else {
@@ -1586,8 +1583,8 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 				       "zilog-rx-i2c-%d", adap->nr);
 		if (IS_ERR(rx->task)) {
 			ret = PTR_ERR(rx->task);
-			zilog_error("%s: could not start IR Rx polling thread"
-				    "\n", __func__);
+			zilog_error("%s: could not start IR Rx polling thread
+					\n", __func__);
 			/* Failed kthread, so put back the ir ref */
 			put_ir_device(ir, true);
 			/* Failure exit, so put back rx ref from i2c_client */
@@ -1599,8 +1596,8 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 		/* Proceed only if the Tx client is also ready */
 		if (tx == NULL) {
-			zilog_info("probe of IR Rx on %s (i2c-%d) done. Waiting"
-				   " on IR Tx.\n", adap->name, adap->nr);
+			zilog_info("probe of IR Rx on %s (i2c-%d) done. Waiting
+					on IR Tx.\n", adap->name, adap->nr);
 			goto out_ok;
 		}
 	}
@@ -1674,9 +1671,9 @@ module_init(zilog_init);
 module_exit(zilog_exit);
 
 MODULE_DESCRIPTION("Zilog/Hauppauge infrared transmitter driver (i2c stack)");
-MODULE_AUTHOR("Gerd Knorr, Michal Kochanowicz, Christoph Bartelmus, "
-	      "Ulrich Mueller, Stefan Jahn, Jerome Brock, Mark Weaver, "
-	      "Andy Walls");
+MODULE_AUTHOR("Gerd Knorr, Michal Kochanowicz, Christoph Bartelmus,
+		Ulrich Mueller, Stefan Jahn, Jerome Brock, Mark Weaver,
+		Andy Walls");
 MODULE_LICENSE("GPL");
 /* for compat with old name, which isn't all that accurate anymore */
 MODULE_ALIAS("lirc_pvr150");
-- 
2.1.2

