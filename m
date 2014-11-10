Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaKJUXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:23:08 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:12383 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751437AbaKJUXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:23:05 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtsNAMAdYVRXQ4qy/2dsb2JhbABcgw6BLbgoBQF0miwCgScXAQEBAQF9hAMBBScvIxBROR4ZiEUBvRyPfwEBAQEGIoY6ilsHhEsFhjqXa40DiV2DezwvgksBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Jens Axboe <axboe@kernel.dk>,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH v2 04/10 linux-next] cdrom: move EXPORT_SYMBOL after functions
Date: Mon, 10 Nov 2014 21:21:49 +0100
Message-Id: <1415650916-9975-5-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415650916-9975-1-git-send-email-fabf@skynet.be>
References: <1415650916-9975-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/cdrom/cdrom.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index deda0f1..ca47919 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -638,6 +638,8 @@ int register_cdrom(struct cdrom_device_info *cdi)
 	mutex_unlock(&cdrom_mutex);
 	return 0;
 }
+EXPORT_SYMBOL(register_cdrom);
+
 #undef ENSURE
 
 void unregister_cdrom(struct cdrom_device_info *cdi)
@@ -654,6 +656,7 @@ void unregister_cdrom(struct cdrom_device_info *cdi)
 	cdi->ops->n_minors--;
 	cd_dbg(CD_REG_UNREG, "drive \"/dev/%s\" unregistered\n", cdi->name);
 }
+EXPORT_SYMBOL(unregister_cdrom);
 
 int cdrom_get_media_event(struct cdrom_device_info *cdi,
 			  struct media_event_desc *med)
@@ -681,6 +684,7 @@ int cdrom_get_media_event(struct cdrom_device_info *cdi,
 	memcpy(med, &buffer[sizeof(*eh)], sizeof(*med));
 	return 0;
 }
+EXPORT_SYMBOL(cdrom_get_media_event);
 
 static int cdrom_get_random_writable(struct cdrom_device_info *cdi,
 			      struct rwrt_feature_desc *rfd)
@@ -1192,6 +1196,7 @@ err:
 	cdi->use_count--;
 	return ret;
 }
+EXPORT_SYMBOL(cdrom_open);
 
 /* This code is similar to that in open_for_data. The routine is called
    whenever an audio play operation is requested.
@@ -1287,6 +1292,7 @@ void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode)
 			cdo->tray_move(cdi, 1);
 	}
 }
+EXPORT_SYMBOL(cdrom_release);
 
 static int cdrom_read_mech_status(struct cdrom_device_info *cdi, 
 				  struct cdrom_changer_info *buf)
@@ -1369,6 +1375,7 @@ int cdrom_number_of_slots(struct cdrom_device_info *cdi)
 	kfree(info);
 	return nslots;
 }
+EXPORT_SYMBOL(cdrom_number_of_slots);
 
 
 /* If SLOT < 0, unload the current slot.  Otherwise, try to load SLOT. */
@@ -1538,6 +1545,7 @@ int cdrom_media_changed(struct cdrom_device_info *cdi)
 		return 0;
 	return media_changed(cdi, 0);
 }
+EXPORT_SYMBOL(cdrom_media_changed);
 
 /* Requests to the low-level drivers will /always/ be done in the
    following format convention:
@@ -1586,6 +1594,7 @@ void init_cdrom_command(struct packet_command *cgc, void *buf, int len,
 	cgc->data_direction = type;
 	cgc->timeout = CDROM_DEF_TIMEOUT;
 }
+EXPORT_SYMBOL(init_cdrom_command);
 
 /* DVD handling */
 
@@ -2004,6 +2013,7 @@ int cdrom_mode_sense(struct cdrom_device_info *cdi,
 	cgc->data_direction = CGC_DATA_READ;
 	return cdo->generic_packet(cdi, cgc);
 }
+EXPORT_SYMBOL(cdrom_mode_sense);
 
 int cdrom_mode_select(struct cdrom_device_info *cdi,
 		      struct packet_command *cgc)
@@ -2019,6 +2029,7 @@ int cdrom_mode_select(struct cdrom_device_info *cdi,
 	cgc->data_direction = CGC_DATA_WRITE;
 	return cdo->generic_packet(cdi, cgc);
 }
+EXPORT_SYMBOL(cdrom_mode_select);
 
 static int cdrom_read_subchannel(struct cdrom_device_info *cdi,
 				 struct cdrom_subchnl *subchnl, int mcn)
@@ -2871,6 +2882,7 @@ use_toc:
 	*last_written = toc.cdte_addr.lba;
 	return 0;
 }
+EXPORT_SYMBOL(cdrom_get_last_written);
 
 /* return the next writable block. also for udf file system. */
 static int cdrom_get_next_writable(struct cdrom_device_info *cdi,
@@ -3392,19 +3404,7 @@ int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
 
 	return -ENOSYS;
 }
-
-EXPORT_SYMBOL(cdrom_get_last_written);
-EXPORT_SYMBOL(register_cdrom);
-EXPORT_SYMBOL(unregister_cdrom);
-EXPORT_SYMBOL(cdrom_open);
-EXPORT_SYMBOL(cdrom_release);
 EXPORT_SYMBOL(cdrom_ioctl);
-EXPORT_SYMBOL(cdrom_media_changed);
-EXPORT_SYMBOL(cdrom_number_of_slots);
-EXPORT_SYMBOL(cdrom_mode_select);
-EXPORT_SYMBOL(cdrom_mode_sense);
-EXPORT_SYMBOL(init_cdrom_command);
-EXPORT_SYMBOL(cdrom_get_media_event);
 
 #ifdef CONFIG_SYSCTL
 
-- 
1.9.1

