Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab3GABNJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 21:13:09 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44946 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752211Ab3GABNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 21:13:07 -0400
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] cdrom: Move mmc_ioctls above cdrom_ioctl to remove unnecessary prototype
Date: Sun, 30 Jun 2013 18:12:02 -0700
Message-Id: <2ac061307a3b6ddbfa7a25e2729517634ae2abd7.1372640818.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1372640818.git.joe@perches.com>
References: <cover.1372640818.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neaten the spacing too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cdrom/cdrom.c | 246 +++++++++++++++++++++++++-------------------------
 1 file changed, 122 insertions(+), 124 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 70ef0134..5148547 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -337,8 +337,6 @@ do {							\
 #define CDROM_DEF_TIMEOUT	(7 * HZ)
 
 /* Not-exported routines. */
-static int mmc_ioctl(struct cdrom_device_info *cdi, unsigned int cmd,
-		     unsigned long arg);
 
 int cdrom_get_last_written(struct cdrom_device_info *, long *);
 static int cdrom_get_next_writable(struct cdrom_device_info *, long *);
@@ -2714,103 +2712,6 @@ static int cdrom_ioctl_audioctl(struct cdrom_device_info *cdi,
 }
 
 /*
- * Just about every imaginable ioctl is supported in the Uniform layer
- * these days.
- * ATAPI / SCSI specific code now mainly resides in mmc_ioctl().
- */
-int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
-		fmode_t mode, unsigned int cmd, unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int ret;
-
-	/*
-	 * Try the generic SCSI command ioctl's first.
-	 */
-	ret = scsi_cmd_blk_ioctl(bdev, mode, cmd, argp);
-	if (ret != -ENOTTY)
-		return ret;
-
-	switch (cmd) {
-	case CDROMMULTISESSION:
-		return cdrom_ioctl_multisession(cdi, argp);
-	case CDROMEJECT:
-		return cdrom_ioctl_eject(cdi);
-	case CDROMCLOSETRAY:
-		return cdrom_ioctl_closetray(cdi);
-	case CDROMEJECT_SW:
-		return cdrom_ioctl_eject_sw(cdi, arg);
-	case CDROM_MEDIA_CHANGED:
-		return cdrom_ioctl_media_changed(cdi, arg);
-	case CDROM_SET_OPTIONS:
-		return cdrom_ioctl_set_options(cdi, arg);
-	case CDROM_CLEAR_OPTIONS:
-		return cdrom_ioctl_clear_options(cdi, arg);
-	case CDROM_SELECT_SPEED:
-		return cdrom_ioctl_select_speed(cdi, arg);
-	case CDROM_SELECT_DISC:
-		return cdrom_ioctl_select_disc(cdi, arg);
-	case CDROMRESET:
-		return cdrom_ioctl_reset(cdi, bdev);
-	case CDROM_LOCKDOOR:
-		return cdrom_ioctl_lock_door(cdi, arg);
-	case CDROM_DEBUG:
-		return cdrom_ioctl_debug(cdi, arg);
-	case CDROM_GET_CAPABILITY:
-		return cdrom_ioctl_get_capability(cdi);
-	case CDROM_GET_MCN:
-		return cdrom_ioctl_get_mcn(cdi, argp);
-	case CDROM_DRIVE_STATUS:
-		return cdrom_ioctl_drive_status(cdi, arg);
-	case CDROM_DISC_STATUS:
-		return cdrom_ioctl_disc_status(cdi);
-	case CDROM_CHANGER_NSLOTS:
-		return cdrom_ioctl_changer_nslots(cdi);
-	}
-
-	/*
-	 * Use the ioctls that are implemented through the generic_packet()
-	 * interface. this may look at bit funny, but if -ENOTTY is
-	 * returned that particular ioctl is not implemented and we
-	 * let it go through the device specific ones.
-	 */
-	if (CDROM_CAN(CDC_GENERIC_PACKET)) {
-		ret = mmc_ioctl(cdi, cmd, arg);
-		if (ret != -ENOTTY)
-			return ret;
-	}
-
-	/*
-	 * Note: most of the cd_dbg() calls are commented out here,
-	 * because they fill up the sys log when CD players poll
-	 * the drive.
-	 */
-	switch (cmd) {
-	case CDROMSUBCHNL:
-		return cdrom_ioctl_get_subchnl(cdi, argp);
-	case CDROMREADTOCHDR:
-		return cdrom_ioctl_read_tochdr(cdi, argp);
-	case CDROMREADTOCENTRY:
-		return cdrom_ioctl_read_tocentry(cdi, argp);
-	case CDROMPLAYMSF:
-		return cdrom_ioctl_play_msf(cdi, argp);
-	case CDROMPLAYTRKIND:
-		return cdrom_ioctl_play_trkind(cdi, argp);
-	case CDROMVOLCTRL:
-		return cdrom_ioctl_volctrl(cdi, argp);
-	case CDROMVOLREAD:
-		return cdrom_ioctl_volread(cdi, argp);
-	case CDROMSTART:
-	case CDROMSTOP:
-	case CDROMPAUSE:
-	case CDROMRESUME:
-		return cdrom_ioctl_audioctl(cdi, cmd);
-	}
-
-	return -ENOSYS;
-}
-
-/*
  * Required when we need to use READ_10 to issue other than 2048 block
  * reads
  */
@@ -2840,9 +2741,9 @@ static int cdrom_switch_blocksize(struct cdrom_device_info *cdi, int size)
 }
 
 static noinline int mmc_ioctl_cdrom_read_data(struct cdrom_device_info *cdi,
-					void __user *arg,
-					struct packet_command *cgc,
-					int cmd)
+					      void __user *arg,
+					      struct packet_command *cgc,
+					      int cmd)
 {
 	struct request_sense sense;
 	struct cdrom_msf msf;
@@ -2877,8 +2778,8 @@ static noinline int mmc_ioctl_cdrom_read_data(struct cdrom_device_info *cdi,
 	cgc->data_direction = CGC_DATA_READ;
 	ret = cdrom_read_block(cdi, cgc, lba, 1, format, blocksize);
 	if (ret && sense.sense_key == 0x05 &&
-		   sense.asc == 0x20 &&
-		   sense.ascq == 0x00) {
+	    sense.asc == 0x20 &&
+	    sense.ascq == 0x00) {
 		/*
 		 * SCSI-II devices are not required to support
 		 * READ_CD, so let's try switching block size
@@ -2899,7 +2800,7 @@ out:
 }
 
 static noinline int mmc_ioctl_cdrom_read_audio(struct cdrom_device_info *cdi,
-					void __user *arg)
+					       void __user *arg)
 {
 	struct cdrom_read_audio ra;
 	int lba;
@@ -2925,7 +2826,7 @@ static noinline int mmc_ioctl_cdrom_read_audio(struct cdrom_device_info *cdi,
 }
 
 static noinline int mmc_ioctl_cdrom_subchannel(struct cdrom_device_info *cdi,
-					void __user *arg)
+					       void __user *arg)
 {
 	int ret;
 	struct cdrom_subchnl q;
@@ -2950,8 +2851,8 @@ static noinline int mmc_ioctl_cdrom_subchannel(struct cdrom_device_info *cdi,
 }
 
 static noinline int mmc_ioctl_cdrom_play_msf(struct cdrom_device_info *cdi,
-					void __user *arg,
-					struct packet_command *cgc)
+					     void __user *arg,
+					     struct packet_command *cgc)
 {
 	struct cdrom_device_ops *cdo = cdi->ops;
 	struct cdrom_msf msf;
@@ -2970,8 +2871,8 @@ static noinline int mmc_ioctl_cdrom_play_msf(struct cdrom_device_info *cdi,
 }
 
 static noinline int mmc_ioctl_cdrom_play_blk(struct cdrom_device_info *cdi,
-					void __user *arg,
-					struct packet_command *cgc)
+					     void __user *arg,
+					     struct packet_command *cgc)
 {
 	struct cdrom_device_ops *cdo = cdi->ops;
 	struct cdrom_blk blk;
@@ -2990,9 +2891,9 @@ static noinline int mmc_ioctl_cdrom_play_blk(struct cdrom_device_info *cdi,
 }
 
 static noinline int mmc_ioctl_cdrom_volume(struct cdrom_device_info *cdi,
-					void __user *arg,
-					struct packet_command *cgc,
-					unsigned int cmd)
+					   void __user *arg,
+					   struct packet_command *cgc,
+					   unsigned int cmd)
 {
 	struct cdrom_volctrl volctrl;
 	unsigned char buffer[32];
@@ -3024,14 +2925,14 @@ static noinline int mmc_ioctl_cdrom_volume(struct cdrom_device_info *cdi,
 	if (offset + 16 > cgc->buflen) {
 		cgc->buflen = offset + 16;
 		ret = cdrom_mode_sense(cdi, cgc,
-					GPMODE_AUDIO_CTL_PAGE, 0);
+				       GPMODE_AUDIO_CTL_PAGE, 0);
 		if (ret)
 			return ret;
 	}
 
 	/* sanity check */
 	if ((buffer[offset] & 0x3f) != GPMODE_AUDIO_CTL_PAGE ||
-			buffer[offset + 1] < 14)
+	    buffer[offset + 1] < 14)
 		return -EINVAL;
 
 	/* now we have the current volume settings. if it was only
@@ -3065,8 +2966,8 @@ static noinline int mmc_ioctl_cdrom_volume(struct cdrom_device_info *cdi,
 }
 
 static noinline int mmc_ioctl_cdrom_start_stop(struct cdrom_device_info *cdi,
-					struct packet_command *cgc,
-					int cmd)
+					       struct packet_command *cgc,
+					       int cmd)
 {
 	struct cdrom_device_ops *cdo = cdi->ops;
 	cd_dbg(CD_DO_IOCTL, "entering CDROMSTART/CDROMSTOP\n");
@@ -3078,8 +2979,8 @@ static noinline int mmc_ioctl_cdrom_start_stop(struct cdrom_device_info *cdi,
 }
 
 static noinline int mmc_ioctl_cdrom_pause_resume(struct cdrom_device_info *cdi,
-					struct packet_command *cgc,
-					int cmd)
+						 struct packet_command *cgc,
+						 int cmd)
 {
 	struct cdrom_device_ops *cdo = cdi->ops;
 	cd_dbg(CD_DO_IOCTL, "entering CDROMPAUSE/CDROMRESUME\n");
@@ -3090,8 +2991,8 @@ static noinline int mmc_ioctl_cdrom_pause_resume(struct cdrom_device_info *cdi,
 }
 
 static noinline int mmc_ioctl_dvd_read_struct(struct cdrom_device_info *cdi,
-						void __user *arg,
-						struct packet_command *cgc)
+					      void __user *arg,
+					      struct packet_command *cgc)
 {
 	int ret;
 	dvd_struct *s;
@@ -3122,7 +3023,7 @@ out:
 }
 
 static noinline int mmc_ioctl_dvd_auth(struct cdrom_device_info *cdi,
-					void __user *arg)
+				       void __user *arg)
 {
 	int ret;
 	dvd_authinfo ai;
@@ -3140,7 +3041,7 @@ static noinline int mmc_ioctl_dvd_auth(struct cdrom_device_info *cdi,
 }
 
 static noinline int mmc_ioctl_cdrom_next_writable(struct cdrom_device_info *cdi,
-						void __user *arg)
+						  void __user *arg)
 {
 	int ret;
 	long next = 0;
@@ -3154,7 +3055,7 @@ static noinline int mmc_ioctl_cdrom_next_writable(struct cdrom_device_info *cdi,
 }
 
 static noinline int mmc_ioctl_cdrom_last_written(struct cdrom_device_info *cdi,
-						void __user *arg)
+						 void __user *arg)
 {
 	int ret;
 	long last = 0;
@@ -3212,6 +3113,103 @@ static int mmc_ioctl(struct cdrom_device_info *cdi, unsigned int cmd,
 	return -ENOTTY;
 }
 
+/*
+ * Just about every imaginable ioctl is supported in the Uniform layer
+ * these days.
+ * ATAPI / SCSI specific code now mainly resides in mmc_ioctl().
+ */
+int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
+		fmode_t mode, unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int ret;
+
+	/*
+	 * Try the generic SCSI command ioctl's first.
+	 */
+	ret = scsi_cmd_blk_ioctl(bdev, mode, cmd, argp);
+	if (ret != -ENOTTY)
+		return ret;
+
+	switch (cmd) {
+	case CDROMMULTISESSION:
+		return cdrom_ioctl_multisession(cdi, argp);
+	case CDROMEJECT:
+		return cdrom_ioctl_eject(cdi);
+	case CDROMCLOSETRAY:
+		return cdrom_ioctl_closetray(cdi);
+	case CDROMEJECT_SW:
+		return cdrom_ioctl_eject_sw(cdi, arg);
+	case CDROM_MEDIA_CHANGED:
+		return cdrom_ioctl_media_changed(cdi, arg);
+	case CDROM_SET_OPTIONS:
+		return cdrom_ioctl_set_options(cdi, arg);
+	case CDROM_CLEAR_OPTIONS:
+		return cdrom_ioctl_clear_options(cdi, arg);
+	case CDROM_SELECT_SPEED:
+		return cdrom_ioctl_select_speed(cdi, arg);
+	case CDROM_SELECT_DISC:
+		return cdrom_ioctl_select_disc(cdi, arg);
+	case CDROMRESET:
+		return cdrom_ioctl_reset(cdi, bdev);
+	case CDROM_LOCKDOOR:
+		return cdrom_ioctl_lock_door(cdi, arg);
+	case CDROM_DEBUG:
+		return cdrom_ioctl_debug(cdi, arg);
+	case CDROM_GET_CAPABILITY:
+		return cdrom_ioctl_get_capability(cdi);
+	case CDROM_GET_MCN:
+		return cdrom_ioctl_get_mcn(cdi, argp);
+	case CDROM_DRIVE_STATUS:
+		return cdrom_ioctl_drive_status(cdi, arg);
+	case CDROM_DISC_STATUS:
+		return cdrom_ioctl_disc_status(cdi);
+	case CDROM_CHANGER_NSLOTS:
+		return cdrom_ioctl_changer_nslots(cdi);
+	}
+
+	/*
+	 * Use the ioctls that are implemented through the generic_packet()
+	 * interface. this may look at bit funny, but if -ENOTTY is
+	 * returned that particular ioctl is not implemented and we
+	 * let it go through the device specific ones.
+	 */
+	if (CDROM_CAN(CDC_GENERIC_PACKET)) {
+		ret = mmc_ioctl(cdi, cmd, arg);
+		if (ret != -ENOTTY)
+			return ret;
+	}
+
+	/*
+	 * Note: most of the cd_dbg() calls are commented out here,
+	 * because they fill up the sys log when CD players poll
+	 * the drive.
+	 */
+	switch (cmd) {
+	case CDROMSUBCHNL:
+		return cdrom_ioctl_get_subchnl(cdi, argp);
+	case CDROMREADTOCHDR:
+		return cdrom_ioctl_read_tochdr(cdi, argp);
+	case CDROMREADTOCENTRY:
+		return cdrom_ioctl_read_tocentry(cdi, argp);
+	case CDROMPLAYMSF:
+		return cdrom_ioctl_play_msf(cdi, argp);
+	case CDROMPLAYTRKIND:
+		return cdrom_ioctl_play_trkind(cdi, argp);
+	case CDROMVOLCTRL:
+		return cdrom_ioctl_volctrl(cdi, argp);
+	case CDROMVOLREAD:
+		return cdrom_ioctl_volread(cdi, argp);
+	case CDROMSTART:
+	case CDROMSTOP:
+	case CDROMPAUSE:
+	case CDROMRESUME:
+		return cdrom_ioctl_audioctl(cdi, cmd);
+	}
+
+	return -ENOSYS;
+}
+
 static int cdrom_get_track_info(struct cdrom_device_info *cdi, __u16 track, __u8 type,
 			 track_information *ti)
 {
-- 
1.8.1.2.459.gbcd45b4.dirty

