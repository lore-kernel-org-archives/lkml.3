Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192AbaFZRnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:43:40 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:49272 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756597AbaFZRnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:43:37 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqUHAI5arFNXQz8N/2dsb2JhbABagw2rSgEBAQEBAQUBbZh/AYEMF3WEBAEFJy8jEFE5HhmIRgHCKReFZIkcB4RDBZpZizqIO4IAgUQ7L4ECBA
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: wein@de.ibm.com, stefan.haberland@de.ibm.com,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 2/4] drivers/s390/block/dasd.c: Move EXPORT_SYMBOL after function/variable
Date: Thu, 26 Jun 2014 19:41:47 +0200
Message-Id: <1403804509-9565-3-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1403804509-9565-1-git-send-email-fabf@skynet.be>
References: <1403804509-9565-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warnings:
"WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable"

Cc: Stefan Weinhuber <wein@de.ibm.com>
Cc: Stefan Haberland <stefan.haberland@de.ibm.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/s390/block/dasd.c | 69 +++++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 36 deletions(-)

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index ea2729f..32650fd 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -42,8 +42,10 @@
  * SECTION: exported variables of dasd.c
  */
 debug_info_t *dasd_debug_area;
+EXPORT_SYMBOL(dasd_debug_area);
 static struct dentry *dasd_debugfs_root_entry;
 struct dasd_discipline *dasd_diag_discipline_pointer;
+EXPORT_SYMBOL(dasd_diag_discipline_pointer);
 void dasd_int_handler(struct ccw_device *, unsigned long, struct irb *);
 
 MODULE_AUTHOR("Holger Smolinski <Holger.Smolinski@de.ibm.com>");
@@ -164,6 +166,7 @@ struct dasd_block *dasd_alloc_block(void)
 
 	return block;
 }
+EXPORT_SYMBOL_GPL(dasd_alloc_block);
 
 /*
  * Free memory of a device structure.
@@ -172,6 +175,7 @@ void dasd_free_block(struct dasd_block *block)
 {
 	kfree(block);
 }
+EXPORT_SYMBOL_GPL(dasd_free_block);
 
 /*
  * Make a new device known to the system.
@@ -576,6 +580,7 @@ void dasd_kick_device(struct dasd_device *device)
 	/* queue call to dasd_kick_device to the kernel event daemon. */
 	schedule_work(&device->kick_work);
 }
+EXPORT_SYMBOL(dasd_kick_device);
 
 /*
  * dasd_reload_device will schedule a call do do_reload_device to the kernel
@@ -636,6 +641,7 @@ void dasd_set_target_state(struct dasd_device *device, int target)
 	mutex_unlock(&device->state_mutex);
 	dasd_put_device(device);
 }
+EXPORT_SYMBOL(dasd_set_target_state);
 
 /*
  * Enable devices with device numbers in [from..to].
@@ -658,6 +664,7 @@ void dasd_enable_device(struct dasd_device *device)
 	if (device->discipline->kick_validate)
 		device->discipline->kick_validate(device);
 }
+EXPORT_SYMBOL(dasd_enable_device);
 
 /*
  * SECTION: device operation (interrupt handler, start i/o, term i/o ...)
@@ -1234,6 +1241,7 @@ struct dasd_ccw_req *dasd_kmalloc_request(int magic, int cplength,
 	dasd_get_device(device);
 	return cqr;
 }
+EXPORT_SYMBOL(dasd_kmalloc_request);
 
 struct dasd_ccw_req *dasd_smalloc_request(int magic, int cplength,
 					  int datasize,
@@ -1273,6 +1281,7 @@ struct dasd_ccw_req *dasd_smalloc_request(int magic, int cplength,
 	dasd_get_device(device);
 	return cqr;
 }
+EXPORT_SYMBOL(dasd_smalloc_request);
 
 /*
  * Free memory of a channel program. This function needs to free all the
@@ -1295,6 +1304,7 @@ void dasd_kfree_request(struct dasd_ccw_req *cqr, struct dasd_device *device)
 	kfree(cqr);
 	dasd_put_device(device);
 }
+EXPORT_SYMBOL(dasd_kfree_request);
 
 void dasd_sfree_request(struct dasd_ccw_req *cqr, struct dasd_device *device)
 {
@@ -1305,6 +1315,7 @@ void dasd_sfree_request(struct dasd_ccw_req *cqr, struct dasd_device *device)
 	spin_unlock_irqrestore(&device->mem_lock, flags);
 	dasd_put_device(device);
 }
+EXPORT_SYMBOL(dasd_sfree_request);
 
 /*
  * Check discipline magic in cqr.
@@ -1382,6 +1393,7 @@ int dasd_term_IO(struct dasd_ccw_req *cqr)
 	dasd_schedule_device_bh(device);
 	return rc;
 }
+EXPORT_SYMBOL(dasd_term_IO);
 
 /*
  * Start the i/o. This start_IO can fail if the channel is really busy.
@@ -1500,6 +1512,7 @@ int dasd_start_IO(struct dasd_ccw_req *cqr)
 	cqr->intrc = rc;
 	return rc;
 }
+EXPORT_SYMBOL(dasd_start_IO);
 
 /*
  * Timeout function for dasd devices. This is used for different purposes
@@ -1532,6 +1545,7 @@ void dasd_device_set_timer(struct dasd_device *device, int expires)
 	else
 		mod_timer(&device->timer, jiffies + expires);
 }
+EXPORT_SYMBOL(dasd_device_set_timer);
 
 /*
  * Clear timeout for a device.
@@ -1540,6 +1554,7 @@ void dasd_device_clear_timer(struct dasd_device *device)
 {
 	del_timer(&device->timer);
 }
+EXPORT_SYMBOL(dasd_device_clear_timer);
 
 static void dasd_handle_killed_request(struct ccw_device *cdev,
 				       unsigned long intparm)
@@ -1592,6 +1607,7 @@ void dasd_generic_handle_state_change(struct dasd_device *device)
 	if (device->block)
 		dasd_schedule_block_bh(device->block);
 }
+EXPORT_SYMBOL_GPL(dasd_generic_handle_state_change);
 
 /*
  * Interrupt handler for "normal" ssch-io based dasd devices.
@@ -1713,6 +1729,7 @@ void dasd_int_handler(struct ccw_device *cdev, unsigned long intparm,
 		dasd_device_clear_timer(device);
 	dasd_schedule_device_bh(device);
 }
+EXPORT_SYMBOL(dasd_int_handler);
 
 enum uc_todo dasd_generic_uc_handler(struct ccw_device *cdev, struct irb *irb)
 {
@@ -1986,6 +2003,7 @@ finished:
 	__dasd_device_process_final_queue(device, &flush_queue);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(dasd_flush_device_queue);
 
 /*
  * Acquire the device lock and process queues for the device.
@@ -2025,6 +2043,7 @@ void dasd_schedule_device_bh(struct dasd_device *device)
 	dasd_get_device(device);
 	tasklet_hi_schedule(&device->tasklet);
 }
+EXPORT_SYMBOL(dasd_schedule_device_bh);
 
 void dasd_device_set_stop_bits(struct dasd_device *device, int bits)
 {
@@ -2057,6 +2076,7 @@ void dasd_add_request_head(struct dasd_ccw_req *cqr)
 	dasd_schedule_device_bh(device);
 	spin_unlock_irqrestore(get_ccwdev_lock(device->cdev), flags);
 }
+EXPORT_SYMBOL(dasd_add_request_head);
 
 /*
  * Queue a request to the tail of the device ccw_queue.
@@ -2075,6 +2095,7 @@ void dasd_add_request_tail(struct dasd_ccw_req *cqr)
 	dasd_schedule_device_bh(device);
 	spin_unlock_irqrestore(get_ccwdev_lock(device->cdev), flags);
 }
+EXPORT_SYMBOL(dasd_add_request_tail);
 
 /*
  * Wakeup helper for the 'sleep_on' functions.
@@ -2300,6 +2321,7 @@ int dasd_sleep_on(struct dasd_ccw_req *cqr)
 {
 	return _dasd_sleep_on(cqr, 0);
 }
+EXPORT_SYMBOL(dasd_sleep_on);
 
 /*
  * Start requests from a ccw_queue and wait for their completion.
@@ -2318,6 +2340,7 @@ int dasd_sleep_on_interruptible(struct dasd_ccw_req *cqr)
 {
 	return _dasd_sleep_on(cqr, 1);
 }
+EXPORT_SYMBOL(dasd_sleep_on_interruptible);
 
 /*
  * Whoa nelly now it gets really hairy. For some functions (e.g. steal lock
@@ -2392,6 +2415,7 @@ int dasd_sleep_on_immediatly(struct dasd_ccw_req *cqr)
 
 	return rc;
 }
+EXPORT_SYMBOL(dasd_sleep_on_immediatly);
 
 /*
  * Cancels a request that was started with dasd_sleep_on_req.
@@ -2433,6 +2457,7 @@ int dasd_cancel_req(struct dasd_ccw_req *cqr)
 	dasd_schedule_device_bh(device);
 	return rc;
 }
+EXPORT_SYMBOL(dasd_cancel_req);
 
 /*
  * SECTION: Operations of the dasd_block layer.
@@ -2466,6 +2491,7 @@ void dasd_block_set_timer(struct dasd_block *block, int expires)
 	else
 		mod_timer(&block->timer, jiffies + expires);
 }
+EXPORT_SYMBOL(dasd_block_set_timer);
 
 /*
  * Clear timeout for a dasd_block.
@@ -2474,6 +2500,7 @@ void dasd_block_clear_timer(struct dasd_block *block)
 {
 	del_timer(&block->timer);
 }
+EXPORT_SYMBOL(dasd_block_clear_timer);
 
 /*
  * Process finished error recovery ccw.
@@ -2855,6 +2882,7 @@ void dasd_schedule_block_bh(struct dasd_block *block)
 	dasd_get_device(block->base);
 	tasklet_hi_schedule(&block->tasklet);
 }
+EXPORT_SYMBOL(dasd_schedule_block_bh);
 
 
 /*
@@ -3225,6 +3253,7 @@ int dasd_generic_probe(struct ccw_device *cdev,
 		async_schedule(dasd_generic_auto_online, cdev);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(dasd_generic_probe);
 
 /*
  * This will one day be called from a global not_oper handler.
@@ -3267,6 +3296,7 @@ void dasd_generic_remove(struct ccw_device *cdev)
 
 	dasd_remove_sysfs_files(cdev);
 }
+EXPORT_SYMBOL_GPL(dasd_generic_remove);
 
 /*
  * Activate a device. This is called from dasd_{eckd,fba}_probe() when either
@@ -3339,6 +3369,7 @@ int dasd_generic_set_online(struct ccw_device *cdev,
 	dasd_put_device(device);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(dasd_generic_set_online);
 
 int dasd_generic_set_offline(struct ccw_device *cdev)
 {
@@ -3442,6 +3473,7 @@ interrupted:
 	dasd_put_device(device);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(dasd_generic_set_offline);
 
 int dasd_generic_last_path_gone(struct dasd_device *device)
 {
@@ -3514,6 +3546,7 @@ int dasd_generic_notify(struct ccw_device *cdev, int event)
 	dasd_put_device(device);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(dasd_generic_notify);
 
 void dasd_generic_path_event(struct ccw_device *cdev, int *path_event)
 {
@@ -3863,39 +3896,3 @@ failed:
 
 module_init(dasd_init);
 module_exit(dasd_exit);
-
-EXPORT_SYMBOL(dasd_debug_area);
-EXPORT_SYMBOL(dasd_diag_discipline_pointer);
-
-EXPORT_SYMBOL(dasd_add_request_head);
-EXPORT_SYMBOL(dasd_add_request_tail);
-EXPORT_SYMBOL(dasd_cancel_req);
-EXPORT_SYMBOL(dasd_device_clear_timer);
-EXPORT_SYMBOL(dasd_block_clear_timer);
-EXPORT_SYMBOL(dasd_enable_device);
-EXPORT_SYMBOL(dasd_int_handler);
-EXPORT_SYMBOL(dasd_kfree_request);
-EXPORT_SYMBOL(dasd_kick_device);
-EXPORT_SYMBOL(dasd_kmalloc_request);
-EXPORT_SYMBOL(dasd_schedule_device_bh);
-EXPORT_SYMBOL(dasd_schedule_block_bh);
-EXPORT_SYMBOL(dasd_set_target_state);
-EXPORT_SYMBOL(dasd_device_set_timer);
-EXPORT_SYMBOL(dasd_block_set_timer);
-EXPORT_SYMBOL(dasd_sfree_request);
-EXPORT_SYMBOL(dasd_sleep_on);
-EXPORT_SYMBOL(dasd_sleep_on_immediatly);
-EXPORT_SYMBOL(dasd_sleep_on_interruptible);
-EXPORT_SYMBOL(dasd_smalloc_request);
-EXPORT_SYMBOL(dasd_start_IO);
-EXPORT_SYMBOL(dasd_term_IO);
-
-EXPORT_SYMBOL_GPL(dasd_generic_probe);
-EXPORT_SYMBOL_GPL(dasd_generic_remove);
-EXPORT_SYMBOL_GPL(dasd_generic_notify);
-EXPORT_SYMBOL_GPL(dasd_generic_set_online);
-EXPORT_SYMBOL_GPL(dasd_generic_set_offline);
-EXPORT_SYMBOL_GPL(dasd_generic_handle_state_change);
-EXPORT_SYMBOL_GPL(dasd_flush_device_queue);
-EXPORT_SYMBOL_GPL(dasd_alloc_block);
-EXPORT_SYMBOL_GPL(dasd_free_block);
-- 
1.8.4.5

