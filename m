Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab3HPWYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:24:31 -0400
Received: from mail-ea0-f193.google.com ([209.85.215.193]:39169 "EHLO
	mail-ea0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab3HPWY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:24:29 -0400
From: Imededdine Aimene Bounab <aimene.kernel@gmail.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, ai_bounab@esi.dz,
        Imededdine Aimene Bounab <aimene.kernel@gmail.com>
Subject: [PATCH] cdrom: fixed a brace coding style issue
Date: Fri, 16 Aug 2013 23:07:39 +0100
Message-Id: <1376690859-16632-1-git-send-email-aimene.kernel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Imededdine Aimene Bounab <aimene.kernel@gmail.com>
---
 drivers/cdrom/cdrom.c |  110 +++++++++++++++++++++++++------------------------
 1 file changed, 57 insertions(+), 53 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 8a3aff7..429d44d 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -272,7 +272,7 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
-#include <linux/slab.h> 
+#include <linux/slab.h>
 #include <linux/cdrom.h>
 #include <linux/sysctl.h>
 #include <linux/proc_fs.h>
@@ -287,7 +287,7 @@
 /* used to tell the module to turn on full debugging messages */
 static bool debug;
 /* default compatibility mode */
-static bool autoclose=1;
+static bool autoclose = 1;
 static bool autoeject;
 static bool lockdoor = 1;
 /* will we ever get to use this... sigh. */
@@ -312,7 +312,7 @@ static const char *mrw_format_status[] = {
 
 static const char *mrw_address_space[] = { "DMA", "GAA" };
 
-#if (ERRLOGMASK!=CD_NOTHING)
+#if (ERRLOGMASK != CD_NOTHING)
 #define cdinfo(type, fmt, args...)			\
 do {							\
 	if ((ERRLOGMASK & type) || debug == 1)		\
@@ -328,11 +328,11 @@ do {							\
 
 /* These are used to simplify getting data in from and back to user land */
 #define IOCTL_IN(arg, type, in)					\
-	if (copy_from_user(&(in), (type __user *) (arg), sizeof (in)))	\
+	if (copy_from_user(&(in), (type __user *) (arg), sizeof(in)))	\
 		return -EFAULT;
 
 #define IOCTL_OUT(arg, type, out) \
-	if (copy_to_user((type __user *) (arg), &(out), sizeof (out)))	\
+	if (copy_to_user((type __user *) (arg), &(out), sizeof(out)))	\
 		return -EFAULT;
 
 /* The (cdo->capability & ~cdi->mask & CDC_XXX) construct was used in
@@ -340,7 +340,7 @@ do {							\
 #define CDROM_CAN(type) (cdi->ops->capability & ~cdi->mask & (type))
 
 /* used in the audio ioctls */
-#define CHECKAUDIO if ((ret=check_for_audio_disc(cdi, cdo))) return ret
+#define CHECKAUDIO if ((ret = check_for_audio_disc(cdi, cdo))) return ret
 
 /*
  * Another popular OS uses 7 seconds as the hard timeout for default
@@ -349,11 +349,11 @@ do {							\
 #define CDROM_DEF_TIMEOUT	(7 * HZ)
 
 /* Not-exported routines. */
-static int open_for_data(struct cdrom_device_info * cdi);
-static int check_for_audio_disc(struct cdrom_device_info * cdi,
-			 struct cdrom_device_ops * cdo);
+static int open_for_data(struct cdrom_device_info *cdi);
+static int check_for_audio_disc(struct cdrom_device_info *cdi,
+			 struct cdrom_device_ops *cdo);
 static void sanitize_format(union cdrom_addr *addr, 
-		u_char * curr, u_char requested);
+		u_char *curr, u_char requested);
 static int mmc_ioctl(struct cdrom_device_info *cdi, unsigned int cmd,
 		     unsigned long arg);
 
@@ -363,7 +363,8 @@ static void cdrom_count_tracks(struct cdrom_device_info *, tracktype*);
 
 static int cdrom_mrw_exit(struct cdrom_device_info *cdi);
 
-static int cdrom_get_disc_info(struct cdrom_device_info *cdi, disc_information *di);
+static int cdrom_get_disc_info(struct cdrom_device_info *cdi,
+		disc_information *di);
 
 static void cdrom_sysctl_register(void);
 
@@ -392,8 +393,8 @@ static int cdrom_dummy_generic_packet(struct cdrom_device_info *cdi,
 int register_cdrom(struct cdrom_device_info *cdi)
 {
 	static char banner_printed;
-        struct cdrom_device_ops *cdo = cdi->ops;
-        int *change_capability = (int *)&cdo->capability; /* hack */
+	struct cdrom_device_ops *cdo = cdi->ops;
+	int *change_capability = (int *)&cdo->capability; /* hack */
 
 	cdinfo(CD_OPEN, "entering register_cdrom\n"); 
 
@@ -405,7 +406,7 @@ int register_cdrom(struct cdrom_device_info *cdi)
 		cdrom_sysctl_register();
 	}
 
-	ENSURE(drive_status, CDC_DRIVE_STATUS );
+	ENSURE(drive_status, CDC_DRIVE_STATUS);
 	if (cdo->check_events == NULL && cdo->media_changed == NULL)
 		*change_capability = ~(CDC_MEDIA_CHANGED | CDC_SELECT_DISC);
 	ENSURE(tray_move, CDC_CLOSE_TRAY | CDC_OPEN_TRAY);
@@ -417,15 +418,15 @@ int register_cdrom(struct cdrom_device_info *cdi)
 	ENSURE(generic_packet, CDC_GENERIC_PACKET);
 	cdi->mc_flags = 0;
 	cdo->n_minors = 0;
-        cdi->options = CDO_USE_FFLAGS;
+	cdi->options = CDO_USE_FFLAGS;
 	
-	if (autoclose==1 && CDROM_CAN(CDC_CLOSE_TRAY))
+	if (autoclose == 1 && CDROM_CAN(CDC_CLOSE_TRAY))
 		cdi->options |= (int) CDO_AUTO_CLOSE;
-	if (autoeject==1 && CDROM_CAN(CDC_OPEN_TRAY))
+	if (autoeject == 1 && CDROM_CAN(CDC_OPEN_TRAY))
 		cdi->options |= (int) CDO_AUTO_EJECT;
-	if (lockdoor==1)
+	if (lockdoor == 1)
 		cdi->options |= (int) CDO_LOCK;
-	if (check_media_type==1)
+	if (check_media_type == 1)
 		cdi->options |= (int) CDO_CHECK_TYPE;
 
 	if (CDROM_CAN(CDC_MRW_W))
@@ -449,7 +450,7 @@ int register_cdrom(struct cdrom_device_info *cdi)
 
 void unregister_cdrom(struct cdrom_device_info *cdi)
 {
-	cdinfo(CD_OPEN, "entering unregister_cdrom\n"); 
+	cdinfo(CD_OPEN, "entering unregister_cdrom\n");
 
 	mutex_lock(&cdrom_mutex);
 	list_del(&cdi->list);
@@ -623,7 +624,7 @@ static int cdrom_mrw_exit(struct cdrom_device_info *cdi)
 	int ret;
 
 	ret = cdrom_get_disc_info(cdi, &di);
-	if (ret < 0 || ret < (int)offsetof(typeof(di),disc_type))
+	if (ret < 0 || ret < (int)offsetof(typeof(di), disc_type))
 		return 1;
 
 	ret = 0;
@@ -685,7 +686,7 @@ static int cdrom_get_random_writable(struct cdrom_device_info *cdi,
 	if ((ret = cdi->ops->generic_packet(cdi, &cgc)))
 		return ret;
 
-	memcpy(rfd, &buffer[sizeof(struct feature_header)], sizeof (*rfd));
+	memcpy(rfd, &buffer[sizeof(struct feature_header)], sizeof(*rfd));
 	return 0;
 }
 
@@ -773,7 +774,7 @@ static int cdrom_mrw_open_write(struct cdrom_device_info *cdi)
 	}
 
 	ret = cdrom_get_disc_info(cdi, &di);
-	if (ret < 0 || ret < offsetof(typeof(di),disc_type))
+	if (ret < 0 || ret < offsetof(typeof(di), disc_type))
 		return 1;
 
 	if (!di.erasable)
@@ -892,7 +893,7 @@ static int cdrom_open_write(struct cdrom_device_info *cdi)
 		ram_write = 1;
 	else
 		(void) cdrom_is_random_writable(cdi, &ram_write);
-	
+
 	if (mrw)
 		cdi->mask &= ~CDC_MRW;
 	else
@@ -912,9 +913,10 @@ static int cdrom_open_write(struct cdrom_device_info *cdi)
 		ret = cdrom_mrw_open_write(cdi);
 	else if (CDROM_CAN(CDC_DVD_RAM))
 		ret = cdrom_dvdram_open_write(cdi);
- 	else if (CDROM_CAN(CDC_RAM) &&
- 		 !CDROM_CAN(CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_MRW|CDC_MO_DRIVE))
- 		ret = cdrom_ram_open_write(cdi);
+	else if (CDROM_CAN(CDC_RAM) &&
+		!CDROM_CAN(CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_MRW
+		|CDC_MO_DRIVE))
+		ret = cdrom_ram_open_write(cdi);
 	else if (CDROM_CAN(CDC_MO_DRIVE))
 		ret = mo_open_write(cdi);
 	else if (!cdrom_is_dvd_rw(cdi))
@@ -981,7 +983,7 @@ int cdrom_open(struct cdrom_device_info *cdi, struct block_device *bdev, fmode_t
 {
 	int ret;
 
-	cdinfo(CD_OPEN, "entering cdrom_open\n"); 
+	cdinfo(CD_OPEN, "entering cdrom_open\n");
 
 	/* open is event synchronization point, check events first */
 	check_disk_change(bdev);
@@ -1025,7 +1027,7 @@ err:
 }
 
 static
-int open_for_data(struct cdrom_device_info * cdi)
+int open_for_data(struct cdrom_device_info *cdi)
 {
 	int ret;
 	struct cdrom_device_ops *cdo = cdi->ops;
@@ -1035,33 +1037,35 @@ int open_for_data(struct cdrom_device_info * cdi)
 	   can do clever things.  If it can't, well, we at least tried! */
 	if (cdo->drive_status != NULL) {
 		ret = cdo->drive_status(cdi, CDSL_CURRENT);
-		cdinfo(CD_OPEN, "drive_status=%d\n", ret); 
+		cdinfo(CD_OPEN, "drive_status=%d\n", ret);
 		if (ret == CDS_TRAY_OPEN) {
-			cdinfo(CD_OPEN, "the tray is open...\n"); 
+			cdinfo(CD_OPEN, "the tray is open...\n");
 			/* can/may i close it? */
 			if (CDROM_CAN(CDC_CLOSE_TRAY) &&
 			    cdi->options & CDO_AUTO_CLOSE) {
-				cdinfo(CD_OPEN, "trying to close the tray.\n"); 
-				ret=cdo->tray_move(cdi,0);
+				cdinfo(CD_OPEN, "trying to close the tray.\n");
+				ret = cdo->tray_move(cdi, 0);
 				if (ret) {
-					cdinfo(CD_OPEN, "bummer. tried to close the tray but failed.\n"); 
+					cdinfo(CD_OPEN,
+					"bummer. tried to close the tray but failed.\n");
 					/* Ignore the error from the low
 					level driver.  We don't care why it
 					couldn't close the tray.  We only care 
 					that there is no disc in the drive, 
 					since that is the _REAL_ problem here.*/
-					ret=-ENOMEDIUM;
+					ret = -ENOMEDIUM;
 					goto clean_up_and_return;
 				}
 			} else {
-				cdinfo(CD_OPEN, "bummer. this drive can't close the tray.\n"); 
-				ret=-ENOMEDIUM;
+				cdinfo(CD_OPEN,
+				"bummer. this drive can't close the tray.\n");
+				ret = -ENOMEDIUM;
 				goto clean_up_and_return;
 			}
 			/* Ok, the door should be closed now.. Check again */
 			ret = cdo->drive_status(cdi, CDSL_CURRENT);
-			if ((ret == CDS_NO_DISC) || (ret==CDS_TRAY_OPEN)) {
-				cdinfo(CD_OPEN, "bummer. the tray is still not closed.\n"); 
+			if ((ret == CDS_NO_DISC) || (ret == CDS_TRAY_OPEN)) {
+				cdinfo(CD_OPEN, "bummer. the tray is still not closed.\n");
 				cdinfo(CD_OPEN, "tray might not contain a medium.\n");
 				ret=-ENOMEDIUM;
 				goto clean_up_and_return;
@@ -1070,7 +1074,7 @@ int open_for_data(struct cdrom_device_info * cdi)
 		}
 		/* the door should be closed now, check for the disc */
 		ret = cdo->drive_status(cdi, CDSL_CURRENT);
-		if (ret!=CDS_DISC_OK) {
+		if (ret != CDS_DISC_OK) {
 			ret = -ENOMEDIUM;
 			goto clean_up_and_return;
 		}
@@ -1078,16 +1082,16 @@ int open_for_data(struct cdrom_device_info * cdi)
 	cdrom_count_tracks(cdi, &tracks);
 	if (tracks.error == CDS_NO_DISC) {
 		cdinfo(CD_OPEN, "bummer. no disc.\n");
-		ret=-ENOMEDIUM;
+		ret = -ENOMEDIUM;
 		goto clean_up_and_return;
 	}
 	/* CD-Players which don't use O_NONBLOCK, workman
 	 * for example, need bit CDO_CHECK_TYPE cleared! */
-	if (tracks.data==0) {
+	if (tracks.data == 0) {
 		if (cdi->options & CDO_CHECK_TYPE) {
 		    /* give people a warning shot, now that CDO_CHECK_TYPE
 		       is the default case! */
-		    cdinfo(CD_OPEN, "bummer. wrong media type.\n"); 
+		    cdinfo(CD_OPEN, "bummer. wrong media type.\n");
 		    cdinfo(CD_WARNING, "pid %d must open device O_NONBLOCK!\n",
 					(unsigned int)task_pid_nr(current));
 		    ret=-EMEDIUMTYPE;
@@ -1098,7 +1102,7 @@ int open_for_data(struct cdrom_device_info * cdi)
 		}
 	}
 
-	cdinfo(CD_OPEN, "all seems well, opening the device.\n"); 
+	cdinfo(CD_OPEN, "all seems well, opening the device.\n");
 
 	/* all seems well, we can open the device */
 	ret = cdo->open(cdi, 0); /* open for data */
@@ -1151,9 +1155,9 @@ static int check_for_audio_disc(struct cdrom_device_info * cdi,
 			if (CDROM_CAN(CDC_CLOSE_TRAY) &&
 			    cdi->options & CDO_AUTO_CLOSE) {
 				cdinfo(CD_OPEN, "trying to close the tray.\n"); 
-				ret=cdo->tray_move(cdi,0);
+				ret = cdo->tray_move(cdi,0);
 				if (ret) {
-					cdinfo(CD_OPEN, "bummer. tried to close tray but failed.\n"); 
+					cdinfo(CD_OPEN, "bummer. tried to close tray but failed.\n");
 					/* Ignore the error from the low
 					level driver.  We don't care why it
 					couldn't close the tray.  We only care 
@@ -1162,27 +1166,27 @@ static int check_for_audio_disc(struct cdrom_device_info * cdi,
 					return -ENOMEDIUM;
 				}
 			} else {
-				cdinfo(CD_OPEN, "bummer. this driver can't close the tray.\n"); 
+				cdinfo(CD_OPEN, "bummer. this driver can't close the tray.\n");
 				return -ENOMEDIUM;
 			}
 			/* Ok, the door should be closed now.. Check again */
 			ret = cdo->drive_status(cdi, CDSL_CURRENT);
-			if ((ret == CDS_NO_DISC) || (ret==CDS_TRAY_OPEN)) {
-				cdinfo(CD_OPEN, "bummer. the tray is still not closed.\n"); 
+			if ((ret == CDS_NO_DISC) || (ret == CDS_TRAY_OPEN)) {
+				cdinfo(CD_OPEN, "bummer. the tray is still not closed.\n");
 				return -ENOMEDIUM;
 			}	
-			if (ret!=CDS_DISC_OK) {
-				cdinfo(CD_OPEN, "bummer. disc isn't ready.\n"); 
+			if (ret != CDS_DISC_OK) {
+				cdinfo(CD_OPEN, "bummer. disc isn't ready.\n");
 				return -EIO;
 			}	
-			cdinfo(CD_OPEN, "the tray is now closed.\n"); 
+			cdinfo(CD_OPEN, "the tray is now closed.\n");
 		}	
 	}
 	cdrom_count_tracks(cdi, &tracks);
 	if (tracks.error) 
 		return(tracks.error);
 
-	if (tracks.audio==0)
+	if (tracks.audio == 0)
 		return -EMEDIUMTYPE;
 
 	return 0;
-- 
1.7.10.4

