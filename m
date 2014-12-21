Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaLUVnc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 16:43:32 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:57731 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaLUVna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 16:43:30 -0500
From: Efstathios Chatzikyriakidis <contact@efxa.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org,
        Efstathios Chatzikyriakidis <contact@efxa.org>
Subject: [PATCH] CDROM: cdrom: Applying checkpatch rules against cdrom.c file.
Date: Sun, 21 Dec 2014 23:53:28 +0200
Message-Id: <1419198808-5818-1-git-send-email-contact@efxa.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apply the rules of checkpatch perl script against cdrom.c file.

Signed-off-by: Efstathios Chatzikyriakidis <contact@efxa.org>
---
 drivers/cdrom/cdrom.c |  385 +++++++++++++++++++++++++++++--------------------
 1 file changed, 225 insertions(+), 160 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 5d28a45..2a30672 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -63,8 +63,8 @@
 
 2.12  Jan  24, 1998 -- Erik Andersen <andersee@debian.org>
   -- Fixed a bug in the IOCTL_IN and IOCTL_OUT macros.  It turns out that
-  copy_*_user does not return EFAULT on error, but instead returns the number 
-  of bytes not copied.  I was returning whatever non-zero stuff came back from 
+  copy_*_user does not return EFAULT on error, but instead returns the number
+  of bytes not copied.  I was returning whatever non-zero stuff came back from
   the copy_*_user functions directly, which would result in strange errors.
 
 2.13  July 17, 1998 -- Erik Andersen <andersee@debian.org>
@@ -78,7 +78,7 @@
 
   2.14 August 17, 1998 -- Erik Andersen <andersee@debian.org>
   -- Fixed a bug in cdrom_media_changed and handling of reporting that
-  the media had changed for devices that _don't_ implement media_changed.  
+  the media had changed for devices that _don't_ implement media_changed.
   Thanks to Grant R. Guenther <grant@torque.net> for spotting this bug.
   -- Made a few things more pedanticly correct.
 
@@ -86,12 +86,12 @@
   -- New maintainers! Erik was too busy to continue the work on the driver,
   so now Chris Zwilling <chris@cloudnet.com> and Jens Axboe <axboe@image.dk>
   will do their best to follow in his footsteps
-  
+
   2.51 Dec 20, 1998 - Jens Axboe <axboe@image.dk>
   -- Check if drive is capable of doing what we ask before blindly changing
   cdi->options in various ioctl.
   -- Added version to proc entry.
-  
+
   2.52 Jan 16, 1999 - Jens Axboe <axboe@image.dk>
   -- Fixed an error in open_for_data where we would sometimes not return
   the correct error value. Thanks Huba Gaspar <huba@softcell.hu>.
@@ -100,7 +100,7 @@
   modules had entries in dev. Feb 02 - real bug was in sysctl.c where
   dev would be removed even though it was used. cdrom.c just illuminated
   that bug.
-  
+
   2.53 Feb 22, 1999 - Jens Axboe <axboe@image.dk>
   -- Fixup of several ioctl calls, in particular CDROM_SET_OPTIONS has
   been "rewritten" because capabilities and options aren't in sync. They
@@ -110,16 +110,16 @@
   -- Added CDROM_DEBUG ioctl. Enable debug messages on-the-fly.
   -- Added CDROM_GET_CAPABILITY ioctl. This relieves userspace programs
   from parsing /proc/sys/dev/cdrom/info.
-  
+
   2.54 Mar 15, 1999 - Jens Axboe <axboe@image.dk>
   -- Check capability mask from low level driver when counting tracks as
   per suggestion from Corey J. Scotts <cstotts@blue.weeg.uiowa.edu>.
-  
+
   2.55 Apr 25, 1999 - Jens Axboe <axboe@image.dk>
   -- autoclose was mistakenly checked against CDC_OPEN_TRAY instead of
   CDC_CLOSE_TRAY.
   -- proc info didn't mask against capabilities mask.
-  
+
   3.00 Aug 5, 1999 - Jens Axboe <axboe@image.dk>
   -- Unified audio ioctl handling across CD-ROM drivers. A lot of the
   code was duplicated before. Drives that support the generic packet
@@ -137,13 +137,13 @@
   -- Now default to checking media type.
   -- CDROM_SEND_PACKET ioctl added. The infrastructure was in place for
   doing this anyway, with the generic_packet addition.
-  
+
   3.01 Aug 6, 1999 - Jens Axboe <axboe@image.dk>
   -- Fix up the sysctl handling so that the option flags get set
   correctly.
   -- Fix up ioctl handling so the device specific ones actually get
   called :).
-  
+
   3.02 Aug 8, 1999 - Jens Axboe <axboe@image.dk>
   -- Fixed volume control on SCSI drives (or others with longer audio
   page).
@@ -152,7 +152,7 @@
   DVD structures and ioctls in the first place! He designed the original
   DVD patches for ide-cd and while I rearranged and unified them, the
   interface is still the same.
-  
+
   3.03 Sep 1, 1999 - Jens Axboe <axboe@image.dk>
   -- Moved the rest of the audio ioctls from the CD-ROM drivers here. Only
   CDROMREADTOCENTRY and CDROMREADTOCHDR are left.
@@ -177,7 +177,7 @@
   for ide-cd to handle multisession discs.
   -- Export cdrom_mode_sense and cdrom_mode_select.
   -- init_cdrom_command() for setting up a cgc command.
-  
+
   3.05 Oct 24, 1999 - Jens Axboe <axboe@image.dk>
   -- Changed the interface for CDROM_SEND_PACKET. Before it was virtually
   impossible to send the drive data in a sensible way.
@@ -210,7 +210,7 @@
   DVD_HOST_SEND_RPC_STATE did not set buffer size in cdb, and
   dvd_do_auth passed uninitialized data to drive because init_cdrom_command
   did not clear a 0 sized buffer.
-  
+
   3.09 May 12, 2000 - Jens Axboe <axboe@suse.de>
   -- Fix Video-CD on SCSI drives that don't support READ_CD command. In
   that case switch block size and issue plain READ_10 again, then switch
@@ -262,8 +262,18 @@
 /* Define this to remove _all_ the debugging messages */
 /* #define ERRLOGMASK CD_NOTHING */
 #define ERRLOGMASK CD_WARNING
-/* #define ERRLOGMASK (CD_WARNING|CD_OPEN|CD_COUNT_TRACKS|CD_CLOSE) */
-/* #define ERRLOGMASK (CD_WARNING|CD_REG_UNREG|CD_DO_IOCTL|CD_OPEN|CD_CLOSE|CD_COUNT_TRACKS) */
+
+/* #define ERRLOGMASK (CD_WARNING |
+		       CD_OPEN |
+		       CD_COUNT_TRACKS |
+		       CD_CLOSE) */
+
+/* #define ERRLOGMASK (CD_WARNING |
+		       CD_REG_UNREG |
+		       CD_DO_IOCTL |
+		       CD_OPEN |
+		       CD_CLOSE |
+		       CD_COUNT_TRACKS) */
 
 #include <linux/module.h>
 #include <linux/fs.h>
@@ -272,7 +282,7 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
-#include <linux/slab.h> 
+#include <linux/slab.h>
 #include <linux/cdrom.h>
 #include <linux/sysctl.h>
 #include <linux/proc_fs.h>
@@ -282,12 +292,12 @@
 #include <linux/blkdev.h>
 #include <linux/times.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 /* used to tell the module to turn on full debugging messages */
 static bool debug;
 /* default compatibility mode */
-static bool autoclose=1;
+static bool autoclose = 1;
 static bool autoeject;
 static bool lockdoor = 1;
 /* will we ever get to use this... sigh. */
@@ -303,14 +313,14 @@ module_param(mrw_format_restart, bool, 0);
 
 static DEFINE_MUTEX(cdrom_mutex);
 
-static const char *mrw_format_status[] = {
+static const char * const mrw_format_status[] = {
 	"not mrw",
 	"bgformat inactive",
 	"bgformat active",
 	"mrw complete",
 };
 
-static const char *mrw_address_space[] = { "DMA", "GAA" };
+static const char * const mrw_address_space[] = { "DMA", "GAA" };
 
 #if (ERRLOGMASK != CD_NOTHING)
 #define cd_dbg(type, fmt, ...)				\
@@ -455,7 +465,8 @@ static int cdrom_is_mrw(struct cdrom_device_info *cdi, int *write)
 	cgc.cmd[8] = sizeof(buffer);
 	cgc.quiet = 1;
 
-	if ((ret = cdi->ops->generic_packet(cdi, &cgc)))
+	ret = cdi->ops->generic_packet(cdi, &cgc);
+	if (ret)
 		return ret;
 
 	mfd = (struct mrw_feature_desc *)&buffer[sizeof(struct feature_header)];
@@ -463,7 +474,8 @@ static int cdrom_is_mrw(struct cdrom_device_info *cdi, int *write)
 		return 1;
 	*write = mfd->write;
 
-	if ((ret = cdrom_mrw_probe_pc(cdi))) {
+	ret = cdrom_mrw_probe_pc(cdi);
+	if (ret) {
 		*write = 0;
 		return ret;
 	}
@@ -536,7 +548,7 @@ static int cdrom_mrw_exit(struct cdrom_device_info *cdi)
 	int ret;
 
 	ret = cdrom_get_disc_info(cdi, &di);
-	if (ret < 0 || ret < (int)offsetof(typeof(di),disc_type))
+	if (ret < 0 || ret < (int)offsetof(typeof(di), disc_type))
 		return 1;
 
 	ret = 0;
@@ -639,6 +651,7 @@ int register_cdrom(struct cdrom_device_info *cdi)
 	mutex_unlock(&cdrom_mutex);
 	return 0;
 }
+EXPORT_SYMBOL(register_cdrom);
 #undef ENSURE
 
 void unregister_cdrom(struct cdrom_device_info *cdi)
@@ -655,6 +668,7 @@ void unregister_cdrom(struct cdrom_device_info *cdi)
 	cdi->ops->n_minors--;
 	cd_dbg(CD_REG_UNREG, "drive \"/dev/%s\" unregistered\n", cdi->name);
 }
+EXPORT_SYMBOL(unregister_cdrom);
 
 int cdrom_get_media_event(struct cdrom_device_info *cdi,
 			  struct media_event_desc *med)
@@ -682,6 +696,7 @@ int cdrom_get_media_event(struct cdrom_device_info *cdi,
 	memcpy(med, &buffer[sizeof(*eh)], sizeof(*med));
 	return 0;
 }
+EXPORT_SYMBOL(cdrom_get_media_event);
 
 static int cdrom_get_random_writable(struct cdrom_device_info *cdi,
 			      struct rwrt_feature_desc *rfd)
@@ -697,10 +712,11 @@ static int cdrom_get_random_writable(struct cdrom_device_info *cdi,
 	cgc.cmd[8] = sizeof(buffer);		/* often 0x18 */
 	cgc.quiet = 1;
 
-	if ((ret = cdi->ops->generic_packet(cdi, &cgc)))
+	ret = cdi->ops->generic_packet(cdi, &cgc);
+	if (ret)
 		return ret;
 
-	memcpy(rfd, &buffer[sizeof(struct feature_header)], sizeof (*rfd));
+	memcpy(rfd, &buffer[sizeof(struct feature_header)], sizeof(*rfd));
 	return 0;
 }
 
@@ -718,7 +734,8 @@ static int cdrom_has_defect_mgt(struct cdrom_device_info *cdi)
 	cgc.cmd[8] = sizeof(buffer);
 	cgc.quiet = 1;
 
-	if ((ret = cdi->ops->generic_packet(cdi, &cgc)))
+	ret = cdi->ops->generic_packet(cdi, &cgc);
+	if (ret)
 		return ret;
 
 	feature_code = (__be16 *) &buffer[sizeof(struct feature_header)];
@@ -736,7 +753,8 @@ static int cdrom_is_random_writable(struct cdrom_device_info *cdi, int *write)
 
 	*write = 0;
 
-	if ((ret = cdrom_get_random_writable(cdi, &rfd)))
+	ret = cdrom_get_random_writable(cdi, &rfd);
+	if (ret)
 		return ret;
 
 	if (CDF_RWRT == be16_to_cpu(rfd.feature_code))
@@ -788,7 +806,7 @@ static int cdrom_mrw_open_write(struct cdrom_device_info *cdi)
 	}
 
 	ret = cdrom_get_disc_info(cdi, &di);
-	if (ret < 0 || ret < offsetof(typeof(di),disc_type))
+	if (ret < 0 || ret < offsetof(typeof(di), disc_type))
 		return 1;
 
 	if (!di.erasable)
@@ -844,12 +862,13 @@ static int mo_open_write(struct cdrom_device_info *cdi)
 static int cdrom_ram_open_write(struct cdrom_device_info *cdi)
 {
 	struct rwrt_feature_desc rfd;
-	int ret;
+	int ret = cdrom_has_defect_mgt(cdi);
 
-	if ((ret = cdrom_has_defect_mgt(cdi)))
+	if (ret)
 		return ret;
 
-	if ((ret = cdrom_get_random_writable(cdi, &rfd)))
+	ret = cdrom_get_random_writable(cdi, &rfd);
+	if (ret)
 		return ret;
 	else if (CDF_RWRT == be16_to_cpu(rfd.feature_code))
 		ret = !rfd.curr;
@@ -872,10 +891,9 @@ static void cdrom_mmc3_profile(struct cdrom_device_info *cdi)
 	cgc.cmd[8] = sizeof(buffer);		/* Allocation Length */
 	cgc.quiet = 1;
 
-	if ((ret = cdi->ops->generic_packet(cdi, &cgc)))
-		mmc3_profile = 0xffff;
-	else
-		mmc3_profile = (buffer[6] << 8) | buffer[7];
+	ret = cdi->ops->generic_packet(cdi, &cgc);
+
+	mmc3_profile = ret ? 0xffff : (buffer[6] << 8) | buffer[7];
 
 	cdi->mmc3_profile = mmc3_profile;
 }
@@ -907,7 +925,7 @@ static int cdrom_open_write(struct cdrom_device_info *cdi)
 		ram_write = 1;
 	else
 		(void) cdrom_is_random_writable(cdi, &ram_write);
-	
+
 	if (mrw)
 		cdi->mask &= ~CDC_MRW;
 	else
@@ -927,9 +945,13 @@ static int cdrom_open_write(struct cdrom_device_info *cdi)
 		ret = cdrom_mrw_open_write(cdi);
 	else if (CDROM_CAN(CDC_DVD_RAM))
 		ret = cdrom_dvdram_open_write(cdi);
- 	else if (CDROM_CAN(CDC_RAM) &&
- 		 !CDROM_CAN(CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_MRW|CDC_MO_DRIVE))
- 		ret = cdrom_ram_open_write(cdi);
+	else if (CDROM_CAN(CDC_RAM) && !CDROM_CAN(CDC_CD_R |
+						  CDC_CD_RW |
+						  CDC_DVD |
+						  CDC_DVD_R |
+						  CDC_MRW |
+						  CDC_MO_DRIVE))
+		ret = cdrom_ram_open_write(cdi);
 	else if (CDROM_CAN(CDC_MO_DRIVE))
 		ret = mo_open_write(cdi);
 	else if (!cdrom_is_dvd_rw(cdi))
@@ -990,6 +1012,7 @@ static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype *tracks)
 	struct cdrom_tochdr header;
 	struct cdrom_tocentry entry;
 	int ret, i;
+
 	tracks->data = 0;
 	tracks->audio = 0;
 	tracks->cdi = 0;
@@ -1020,9 +1043,9 @@ static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype *tracks)
 				tracks->xa++;
 			else
 				tracks->data++;
-		} else {
+		} else
 			tracks->audio++;
-		}
+
 		cd_dbg(CD_COUNT_TRACKS, "track %d: format=%d, ctrl=%d\n",
 		       i, entry.cdte_format, entry.cdte_ctrl);
 	}
@@ -1037,6 +1060,7 @@ int open_for_data(struct cdrom_device_info *cdi)
 	int ret;
 	struct cdrom_device_ops *cdo = cdi->ops;
 	tracktype tracks;
+
 	cd_dbg(CD_OPEN, "entering open_for_data\n");
 	/* Check if the driver can report drive status.  If it can, we
 	   can do clever things.  If it can't, well, we at least tried! */
@@ -1049,35 +1073,35 @@ int open_for_data(struct cdrom_device_info *cdi)
 			if (CDROM_CAN(CDC_CLOSE_TRAY) &&
 			    cdi->options & CDO_AUTO_CLOSE) {
 				cd_dbg(CD_OPEN, "trying to close the tray\n");
-				ret=cdo->tray_move(cdi,0);
+				ret = cdo->tray_move(cdi, 0);
 				if (ret) {
 					cd_dbg(CD_OPEN, "bummer. tried to close the tray but failed.\n");
 					/* Ignore the error from the low
 					level driver.  We don't care why it
-					couldn't close the tray.  We only care 
-					that there is no disc in the drive, 
+					couldn't close the tray.  We only care
+					that there is no disc in the drive,
 					since that is the _REAL_ problem here.*/
-					ret=-ENOMEDIUM;
+					ret = -ENOMEDIUM;
 					goto clean_up_and_return;
 				}
 			} else {
 				cd_dbg(CD_OPEN, "bummer. this drive can't close the tray.\n");
-				ret=-ENOMEDIUM;
+				ret = -ENOMEDIUM;
 				goto clean_up_and_return;
 			}
 			/* Ok, the door should be closed now.. Check again */
 			ret = cdo->drive_status(cdi, CDSL_CURRENT);
-			if ((ret == CDS_NO_DISC) || (ret==CDS_TRAY_OPEN)) {
+			if ((ret == CDS_NO_DISC) || (ret == CDS_TRAY_OPEN)) {
 				cd_dbg(CD_OPEN, "bummer. the tray is still not closed.\n");
 				cd_dbg(CD_OPEN, "tray might not contain a medium\n");
-				ret=-ENOMEDIUM;
+				ret = -ENOMEDIUM;
 				goto clean_up_and_return;
 			}
 			cd_dbg(CD_OPEN, "the tray is now closed\n");
 		}
 		/* the door should be closed now, check for the disc */
 		ret = cdo->drive_status(cdi, CDSL_CURRENT);
-		if (ret!=CDS_DISC_OK) {
+		if (ret != CDS_DISC_OK) {
 			ret = -ENOMEDIUM;
 			goto clean_up_and_return;
 		}
@@ -1085,24 +1109,24 @@ int open_for_data(struct cdrom_device_info *cdi)
 	cdrom_count_tracks(cdi, &tracks);
 	if (tracks.error == CDS_NO_DISC) {
 		cd_dbg(CD_OPEN, "bummer. no disc.\n");
-		ret=-ENOMEDIUM;
+		ret = -ENOMEDIUM;
 		goto clean_up_and_return;
 	}
 	/* CD-Players which don't use O_NONBLOCK, workman
 	 * for example, need bit CDO_CHECK_TYPE cleared! */
-	if (tracks.data==0) {
+	if (tracks.data == 0) {
 		if (cdi->options & CDO_CHECK_TYPE) {
-		    /* give people a warning shot, now that CDO_CHECK_TYPE
-		       is the default case! */
-		    cd_dbg(CD_OPEN, "bummer. wrong media type.\n");
-		    cd_dbg(CD_WARNING, "pid %d must open device O_NONBLOCK!\n",
-			   (unsigned int)task_pid_nr(current));
-		    ret=-EMEDIUMTYPE;
-		    goto clean_up_and_return;
-		}
-		else {
-		    cd_dbg(CD_OPEN, "wrong media type, but CDO_CHECK_TYPE not set\n");
-		}
+			/* give people a warning shot, now that
+			   CDO_CHECK_TYPE is the default case! */
+			cd_dbg(CD_OPEN, "bummer. wrong media type.\n");
+			cd_dbg(CD_WARNING,
+			       "pid %d must open device O_NONBLOCK!\n",
+			       (unsigned int) task_pid_nr(current));
+
+			ret = -EMEDIUMTYPE;
+			goto clean_up_and_return;
+		} else
+			cd_dbg(CD_OPEN, "wrong media type, but CDO_CHECK_TYPE not set\n");
 	}
 
 	cd_dbg(CD_OPEN, "all seems well, opening the devicen");
@@ -1111,7 +1135,7 @@ int open_for_data(struct cdrom_device_info *cdi)
 	ret = cdo->open(cdi, 0); /* open for data */
 	cd_dbg(CD_OPEN, "opening the device gave me %d\n", ret);
 	/* After all this careful checking, we shouldn't have problems
-	   opening the device, but we don't want the device locked if 
+	   opening the device, but we don't want the device locked if
 	   this somehow fails... */
 	if (ret) {
 		cd_dbg(CD_OPEN, "open device failed\n");
@@ -1126,9 +1150,9 @@ int open_for_data(struct cdrom_device_info *cdi)
 
 	/* Something failed.  Try to unlock the drive, because some drivers
 	(notably ide-cd) lock the drive after every command.  This produced
-	a nasty bug where after mount failed, the drive would remain locked!  
-	This ensures that the drive gets unlocked after a mount fails.  This 
-	is a goto to avoid bloating the driver with redundant code. */ 
+	a nasty bug where after mount failed, the drive would remain locked!
+	This ensures that the drive gets unlocked after a mount fails.  This
+	is a goto to avoid bloating the driver with redundant code. */
 clean_up_and_return:
 	cd_dbg(CD_OPEN, "open failed\n");
 	if (CDROM_CAN(CDC_LOCK) && cdi->options & CDO_LOCK) {
@@ -1193,15 +1217,17 @@ err:
 	cdi->use_count--;
 	return ret;
 }
+EXPORT_SYMBOL(cdrom_open);
 
 /* This code is similar to that in open_for_data. The routine is called
    whenever an audio play operation is requested.
 */
-static int check_for_audio_disc(struct cdrom_device_info * cdi,
-				struct cdrom_device_ops * cdo)
+static int check_for_audio_disc(struct cdrom_device_info *cdi,
+				struct cdrom_device_ops *cdo)
 {
-        int ret;
+	int ret;
 	tracktype tracks;
+
 	cd_dbg(CD_OPEN, "entering check_for_audio_disc\n");
 	if (!(cdi->options & CDO_CHECK_TYPE))
 		return 0;
@@ -1214,13 +1240,13 @@ static int check_for_audio_disc(struct cdrom_device_info * cdi,
 			if (CDROM_CAN(CDC_CLOSE_TRAY) &&
 			    cdi->options & CDO_AUTO_CLOSE) {
 				cd_dbg(CD_OPEN, "trying to close the tray\n");
-				ret=cdo->tray_move(cdi,0);
+				ret = cdo->tray_move(cdi, 0);
 				if (ret) {
 					cd_dbg(CD_OPEN, "bummer. tried to close tray but failed.\n");
 					/* Ignore the error from the low
 					level driver.  We don't care why it
-					couldn't close the tray.  We only care 
-					that there is no disc in the drive, 
+					couldn't close the tray.  We only care
+					that there is no disc in the drive,
 					since that is the _REAL_ problem here.*/
 					return -ENOMEDIUM;
 				}
@@ -1230,22 +1256,22 @@ static int check_for_audio_disc(struct cdrom_device_info * cdi,
 			}
 			/* Ok, the door should be closed now.. Check again */
 			ret = cdo->drive_status(cdi, CDSL_CURRENT);
-			if ((ret == CDS_NO_DISC) || (ret==CDS_TRAY_OPEN)) {
+			if ((ret == CDS_NO_DISC) || (ret == CDS_TRAY_OPEN)) {
 				cd_dbg(CD_OPEN, "bummer. the tray is still not closed.\n");
 				return -ENOMEDIUM;
-			}	
-			if (ret!=CDS_DISC_OK) {
+			}
+			if (ret != CDS_DISC_OK) {
 				cd_dbg(CD_OPEN, "bummer. disc isn't ready.\n");
 				return -EIO;
-			}	
+			}
 			cd_dbg(CD_OPEN, "the tray is now closed\n");
-		}	
+		}
 	}
 	cdrom_count_tracks(cdi, &tracks);
-	if (tracks.error) 
-		return(tracks.error);
+	if (tracks.error)
+		return tracks.error;
 
-	if (tracks.audio==0)
+	if (tracks.audio == 0)
 		return -EMEDIUMTYPE;
 
 	return 0;
@@ -1288,8 +1314,9 @@ void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode)
 			cdo->tray_move(cdi, 1);
 	}
 }
+EXPORT_SYMBOL(cdrom_release);
 
-static int cdrom_read_mech_status(struct cdrom_device_info *cdi, 
+static int cdrom_read_mech_status(struct cdrom_device_info *cdi,
 				  struct cdrom_changer_info *buf)
 {
 	struct packet_command cgc;
@@ -1329,12 +1356,13 @@ static int cdrom_slot_status(struct cdrom_device_info *cdi, int slot)
 	cd_dbg(CD_CHANGER, "entering cdrom_slot_status()\n");
 	if (cdi->sanyo_slot)
 		return CDS_NO_INFO;
-	
+
 	info = kmalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
-	if ((ret = cdrom_read_mech_status(cdi, info)))
+	ret = cdrom_read_mech_status(cdi, info);
+	if (ret)
 		goto out_free;
 
 	if (info->slots[slot].disc_present)
@@ -1347,10 +1375,10 @@ out_free:
 	return ret;
 }
 
-/* Return the number of slots for an ATAPI/SCSI cdrom, 
- * return 1 if not a changer. 
+/* Return the number of slots for an ATAPI/SCSI cdrom,
+ * return 1 if not a changer.
  */
-int cdrom_number_of_slots(struct cdrom_device_info *cdi) 
+int cdrom_number_of_slots(struct cdrom_device_info *cdi)
 {
 	int status;
 	int nslots = 1;
@@ -1358,22 +1386,23 @@ int cdrom_number_of_slots(struct cdrom_device_info *cdi)
 
 	cd_dbg(CD_CHANGER, "entering cdrom_number_of_slots()\n");
 	/* cdrom_read_mech_status requires a valid value for capacity: */
-	cdi->capacity = 0; 
+	cdi->capacity = 0;
 
 	info = kmalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
-	if ((status = cdrom_read_mech_status(cdi, info)) == 0)
+	status = cdrom_read_mech_status(cdi, info);
+	if (!status)
 		nslots = info->hdr.nslots;
 
 	kfree(info);
 	return nslots;
 }
-
+EXPORT_SYMBOL(cdrom_number_of_slots);
 
 /* If SLOT < 0, unload the current slot.  Otherwise, try to load SLOT. */
-static int cdrom_load_unload(struct cdrom_device_info *cdi, int slot) 
+static int cdrom_load_unload(struct cdrom_device_info *cdi, int slot)
 {
 	struct packet_command cgc;
 
@@ -1387,7 +1416,7 @@ static int cdrom_load_unload(struct cdrom_device_info *cdi, int slot)
 	cgc.cmd[8] = slot;
 	cgc.timeout = 60 * HZ;
 
-	/* The Sanyo 3 CD changer uses byte 7 of the 
+	/* The Sanyo 3 CD changer uses byte 7 of the
 	GPCMD_TEST_UNIT_READY to command to switch CDs instead of
 	using the GPCMD_LOAD_UNLOAD opcode. */
 	if (cdi->sanyo_slot && -1 < slot) {
@@ -1425,7 +1454,8 @@ static int cdrom_select_disc(struct cdrom_device_info *cdi, int slot)
 	if (!info)
 		return -ENOMEM;
 
-	if ((ret = cdrom_read_mech_status(cdi, info))) {
+	ret = cdrom_read_mech_status(cdi, info);
+	if (ret) {
 		kfree(info);
 		return ret;
 	}
@@ -1433,17 +1463,12 @@ static int cdrom_select_disc(struct cdrom_device_info *cdi, int slot)
 	curslot = info->hdr.curslot;
 	kfree(info);
 
-	if (cdi->use_count > 1 || cdi->keeplocked) {
-		if (slot == CDSL_CURRENT) {
-	    		return curslot;
-		} else {
-			return -EBUSY;
-		}
-	}
+	if (cdi->use_count > 1 || cdi->keeplocked)
+		return (slot == CDSL_CURRENT) ? curslot : -EBUSY;
 
 	/* Specifying CDSL_CURRENT will attempt to load the currnet slot,
 	which is useful if it had been previously unloaded.
-	Whether it can or not, it returns the current slot. 
+	Whether it can or not, it returns the current slot.
 	Similarly,  if slot happens to be the current one, we still
 	try and load it. */
 	if (slot == CDSL_CURRENT)
@@ -1451,7 +1476,9 @@ static int cdrom_select_disc(struct cdrom_device_info *cdi, int slot)
 
 	/* set media changed bits on both queues */
 	cdi->mc_flags = 0x3;
-	if ((ret = cdrom_load_unload(cdi, slot)))
+
+	ret = cdrom_load_unload(cdi, slot);
+	if (ret)
 		return ret;
 
 	return slot;
@@ -1491,14 +1518,12 @@ unsigned int cdrom_check_events(struct cdrom_device_info *cdi,
 	cdi->vfs_events = 0;
 	return events;
 }
-EXPORT_SYMBOL(cdrom_check_events);
 
 /* We want to make media_changed accessible to the user through an
  * ioctl. The main problem now is that we must double-buffer the
  * low-level implementation, to assure that the VFS and the user both
  * see a medium change once.
  */
-
 static
 int media_changed(struct cdrom_device_info *cdi, int queue)
 {
@@ -1527,18 +1552,20 @@ int media_changed(struct cdrom_device_info *cdi, int queue)
 	cdi->mc_flags &= ~mask;         /* clear bit */
 	return ret;
 }
+EXPORT_SYMBOL(cdrom_check_events);
 
 int cdrom_media_changed(struct cdrom_device_info *cdi)
 {
-	/* This talks to the VFS, which doesn't like errors - just 1 or 0.  
-	 * Returning "0" is always safe (media hasn't been changed). Do that 
-	 * if the low-level cdrom driver dosn't support media changed. */ 
+	/* This talks to the VFS, which doesn't like errors - just 1 or 0.
+	 * Returning "0" is always safe (media hasn't been changed). Do that
+	 * if the low-level cdrom driver dosn't support media changed. */
 	if (cdi == NULL || cdi->ops->media_changed == NULL)
 		return 0;
 	if (!CDROM_CAN(CDC_MEDIA_CHANGED))
 		return 0;
 	return media_changed(cdi, 0);
 }
+EXPORT_SYMBOL(cdrom_media_changed);
 
 /* Requests to the low-level drivers will /always/ be done in the
    following format convention:
@@ -1558,7 +1585,8 @@ int cdrom_media_changed(struct cdrom_device_info *cdi)
 
 static
 void sanitize_format(union cdrom_addr *addr,
-		     u_char * curr, u_char requested)
+		     u_char *curr,
+		     u_char requested)
 {
 	if (*curr == requested)
 		return;                 /* nothing to be done! */
@@ -1567,6 +1595,7 @@ void sanitize_format(union cdrom_addr *addr,
 			75 * (addr->msf.second - 2 + 60 * addr->msf.minute);
 	} else {                        /* CDROM_MSF */
 		int lba = addr->lba;
+
 		addr->msf.frame = lba % 75;
 		lba /= 75;
 		lba += 2;
@@ -1587,13 +1616,16 @@ void init_cdrom_command(struct packet_command *cgc, void *buf, int len,
 	cgc->data_direction = type;
 	cgc->timeout = CDROM_DEF_TIMEOUT;
 }
+EXPORT_SYMBOL(init_cdrom_command);
 
 /* DVD handling */
 
-#define copy_key(dest,src)	memcpy((dest), (src), sizeof(dvd_key))
-#define copy_chal(dest,src)	memcpy((dest), (src), sizeof(dvd_challenge))
+#define copy_key(dest, src)	memcpy((dest), (src), sizeof(dvd_key))
+#define copy_chal(dest, src)	memcpy((dest), (src), sizeof(dvd_challenge))
 
-static void setup_report_key(struct packet_command *cgc, unsigned agid, unsigned type)
+static void setup_report_key(struct packet_command *cgc,
+			     unsigned agid,
+			     unsigned type)
 {
 	cgc->cmd[0] = GPCMD_REPORT_KEY;
 	cgc->cmd[10] = type | (agid << 6);
@@ -1615,7 +1647,9 @@ static void setup_report_key(struct packet_command *cgc, unsigned agid, unsigned
 	cgc->data_direction = CGC_DATA_READ;
 }
 
-static void setup_send_key(struct packet_command *cgc, unsigned agid, unsigned type)
+static void setup_send_key(struct packet_command *cgc,
+			   unsigned agid,
+			   unsigned type)
 {
 	cgc->cmd[0] = GPCMD_SEND_KEY;
 	cgc->cmd[10] = type | (agid << 6);
@@ -1655,7 +1689,8 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		cgc.quiet = 1;
 		setup_report_key(&cgc, ai->lsa.agid, 0);
 
-		if ((ret = cdo->generic_packet(cdi, &cgc)))
+		ret = cdo->generic_packet(cdi, &cgc);
+		if (ret)
 			return ret;
 
 		ai->lsa.agid = buf[7] >> 6;
@@ -1666,7 +1701,8 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		cd_dbg(CD_DVD, "entering DVD_LU_SEND_KEY1\n");
 		setup_report_key(&cgc, ai->lsk.agid, 2);
 
-		if ((ret = cdo->generic_packet(cdi, &cgc)))
+		ret = cdo->generic_packet(cdi, &cgc);
+		if (ret)
 			return ret;
 
 		copy_key(ai->lsk.key, &buf[4]);
@@ -1677,7 +1713,8 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		cd_dbg(CD_DVD, "entering DVD_LU_SEND_CHALLENGE\n");
 		setup_report_key(&cgc, ai->lsc.agid, 1);
 
-		if ((ret = cdo->generic_packet(cdi, &cgc)))
+		ret = cdo->generic_packet(cdi, &cgc);
+		if (ret)
 			return ret;
 
 		copy_chal(ai->lsc.chal, &buf[4]);
@@ -1694,7 +1731,8 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		cgc.cmd[3] = ai->lstk.lba >> 16;
 		cgc.cmd[2] = ai->lstk.lba >> 24;
 
-		if ((ret = cdo->generic_packet(cdi, &cgc)))
+		ret = cdo->generic_packet(cdi, &cgc);
+		if (ret)
 			return ret;
 
 		ai->lstk.cpm = (buf[4] >> 7) & 1;
@@ -1707,8 +1745,9 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 	case DVD_LU_SEND_ASF:
 		cd_dbg(CD_DVD, "entering DVD_LU_SEND_ASF\n");
 		setup_report_key(&cgc, ai->lsasf.agid, 5);
-		
-		if ((ret = cdo->generic_packet(cdi, &cgc)))
+
+		ret = cdo->generic_packet(cdi, &cgc);
+		if (ret)
 			return ret;
 
 		ai->lsasf.asf = buf[7] & 1;
@@ -1721,7 +1760,8 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		buf[1] = 0xe;
 		copy_chal(&buf[4], ai->hsc.chal);
 
-		if ((ret = cdo->generic_packet(cdi, &cgc)))
+		ret = cdo->generic_packet(cdi, &cgc);
+		if (ret)
 			return ret;
 
 		ai->type = DVD_LU_SEND_KEY1;
@@ -1733,7 +1773,8 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		buf[1] = 0xa;
 		copy_key(&buf[4], ai->hsk.key);
 
-		if ((ret = cdo->generic_packet(cdi, &cgc))) {
+		ret = cdo->generic_packet(cdi, &cgc);
+		if (ret) {
 			ai->type = DVD_AUTH_FAILURE;
 			return ret;
 		}
@@ -1745,7 +1786,9 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		cgc.quiet = 1;
 		cd_dbg(CD_DVD, "entering DVD_INVALIDATE_AGID\n");
 		setup_report_key(&cgc, ai->lsa.agid, 0x3f);
-		if ((ret = cdo->generic_packet(cdi, &cgc)))
+
+		ret = cdo->generic_packet(cdi, &cgc);
+		if (ret)
 			return ret;
 		break;
 
@@ -1756,7 +1799,8 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		memset(&rpc_state, 0, sizeof(rpc_state_t));
 		cgc.buffer = (char *) &rpc_state;
 
-		if ((ret = cdo->generic_packet(cdi, &cgc)))
+		ret = cdo->generic_packet(cdi, &cgc);
+		if (ret)
 			return ret;
 
 		ai->lrpcs.type = rpc_state.type_code;
@@ -1773,7 +1817,8 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 		buf[1] = 6;
 		buf[4] = ai->hrpcs.pdrc;
 
-		if ((ret = cdo->generic_packet(cdi, &cgc)))
+		ret = cdo->generic_packet(cdi, &cgc);
+		if (ret)
 			return ret;
 		break;
 
@@ -1816,7 +1861,7 @@ static int dvd_read_physical(struct cdrom_device_info *cdi, dvd_struct *s,
 
 	/*
 	 * place the data... really ugly, but at least we won't have to
-	 * worry about endianess in userspace.
+	 * worry about endianness in userspace.
 	 */
 	memset(layer, 0, sizeof(*layer));
 	layer->book_version = base[0] & 0xf;
@@ -1982,7 +2027,7 @@ static int dvd_read_struct(struct cdrom_device_info *cdi, dvd_struct *s,
 
 	case DVD_STRUCT_MANUFACT:
 		return dvd_read_manufact(cdi, s, cgc);
-		
+
 	default:
 		cd_dbg(CD_WARNING, ": Invalid DVD structure read requested (%d)\n",
 		       s->type);
@@ -2005,6 +2050,7 @@ int cdrom_mode_sense(struct cdrom_device_info *cdi,
 	cgc->data_direction = CGC_DATA_READ;
 	return cdo->generic_packet(cdi, cgc);
 }
+EXPORT_SYMBOL(cdrom_mode_sense);
 
 int cdrom_mode_select(struct cdrom_device_info *cdi,
 		      struct packet_command *cgc)
@@ -2020,6 +2066,7 @@ int cdrom_mode_select(struct cdrom_device_info *cdi,
 	cgc->data_direction = CGC_DATA_WRITE;
 	return cdo->generic_packet(cdi, cgc);
 }
+EXPORT_SYMBOL(cdrom_mode_select);
 
 static int cdrom_read_subchannel(struct cdrom_device_info *cdi,
 				 struct cdrom_subchnl *subchnl, int mcn)
@@ -2036,7 +2083,8 @@ static int cdrom_read_subchannel(struct cdrom_device_info *cdi,
 	cgc.cmd[3] = mcn ? 2 : 1;
 	cgc.cmd[8] = 16;
 
-	if ((ret = cdo->generic_packet(cdi, &cgc)))
+	ret = cdo->generic_packet(cdi, &cgc);
+	if (ret)
 		return ret;
 
 	subchnl->cdsc_audiostatus = cgc.buffer[1];
@@ -2098,15 +2146,22 @@ static int cdrom_read_block(struct cdrom_device_info *cdi,
 	cgc->cmd[7] = (nblocks >>  8) & 0xff;
 	cgc->cmd[8] = nblocks & 0xff;
 	cgc->buflen = blksize * nblocks;
-	
+
 	/* set the header info returned */
 	switch (blksize) {
-	case CD_FRAMESIZE_RAW0	: cgc->cmd[9] = 0x58; break;
-	case CD_FRAMESIZE_RAW1	: cgc->cmd[9] = 0x78; break;
-	case CD_FRAMESIZE_RAW	: cgc->cmd[9] = 0xf8; break;
-	default			: cgc->cmd[9] = 0x10;
+	case CD_FRAMESIZE_RAW0:
+		cgc->cmd[9] = 0x58;
+		break;
+	case CD_FRAMESIZE_RAW1:
+		cgc->cmd[9] = 0x78;
+		break;
+	case CD_FRAMESIZE_RAW:
+		cgc->cmd[9] = 0xf8;
+		break;
+	default:
+		cgc->cmd[9] = 0x10;
 	}
-	
+
 	return cdo->generic_packet(cdi, cgc);
 }
 
@@ -2209,6 +2264,7 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 
 		if (blk_execute_rq(q, cdi->disk, rq, 0)) {
 			struct request_sense *s = rq->sense;
+
 			ret = -EIO;
 			cdi->last_sense = s->sense_key;
 		}
@@ -2264,7 +2320,7 @@ retry:
 
 	pr_info("dropping to old style cdda (sense=%x)\n", cdi->last_sense);
 	cdi->cdda_method = CDDA_OLD;
-	return cdrom_read_cdda_old(cdi, ubuf, lba, nframes);	
+	return cdrom_read_cdda_old(cdi, ubuf, lba, nframes);
 }
 
 static int cdrom_ioctl_multisession(struct cdrom_device_info *cdi,
@@ -2310,6 +2366,7 @@ static int cdrom_ioctl_eject(struct cdrom_device_info *cdi)
 		return -EBUSY;
 	if (CDROM_CAN(CDC_LOCK)) {
 		int ret = cdi->ops->lock_door(cdi, 0);
+
 		if (ret)
 			return ret;
 	}
@@ -2866,12 +2923,16 @@ int cdrom_get_last_written(struct cdrom_device_info *cdi, long *last_written)
 use_toc:
 	toc.cdte_format = CDROM_MSF;
 	toc.cdte_track = CDROM_LEADOUT;
-	if ((ret = cdi->ops->audio_ioctl(cdi, CDROMREADTOCENTRY, &toc)))
+
+	ret = cdi->ops->audio_ioctl(cdi, CDROMREADTOCENTRY, &toc);
+	if (ret)
 		return ret;
+
 	sanitize_format(&toc.cdte_addr, &toc.cdte_format, CDROM_LBA);
 	*last_written = toc.cdte_addr.lba;
 	return 0;
 }
+EXPORT_SYMBOL(cdrom_get_last_written);
 
 /* return the next writable block. also for udf file system. */
 static int cdrom_get_next_writable(struct cdrom_device_info *cdi,
@@ -2918,10 +2979,10 @@ use_last_written:
 	if (ret) {
 		*next_writable = 0;
 		return ret;
-	} else {
-		*next_writable += 7;
-		return 0;
 	}
+
+	*next_writable += 7;
+	return 0;
 }
 
 static noinline int mmc_ioctl_cdrom_read_data(struct cdrom_device_info *cdi,
@@ -3015,6 +3076,7 @@ static noinline int mmc_ioctl_cdrom_subchannel(struct cdrom_device_info *cdi,
 	int ret;
 	struct cdrom_subchnl q;
 	u_char requested, back;
+
 	if (copy_from_user(&q, (struct cdrom_subchnl __user *)arg, sizeof(q)))
 		return -EFAULT;
 	requested = q.cdsc_format;
@@ -3040,6 +3102,7 @@ static noinline int mmc_ioctl_cdrom_play_msf(struct cdrom_device_info *cdi,
 {
 	struct cdrom_device_ops *cdo = cdi->ops;
 	struct cdrom_msf msf;
+
 	cd_dbg(CD_DO_IOCTL, "entering CDROMPLAYMSF\n");
 	if (copy_from_user(&msf, (struct cdrom_msf __user *)arg, sizeof(msf)))
 		return -EFAULT;
@@ -3060,6 +3123,7 @@ static noinline int mmc_ioctl_cdrom_play_blk(struct cdrom_device_info *cdi,
 {
 	struct cdrom_device_ops *cdo = cdi->ops;
 	struct cdrom_blk blk;
+
 	cd_dbg(CD_DO_IOCTL, "entering CDROMPLAYBLK\n");
 	if (copy_from_user(&blk, (struct cdrom_blk __user *)arg, sizeof(blk)))
 		return -EFAULT;
@@ -3096,10 +3160,10 @@ static noinline int mmc_ioctl_cdrom_volume(struct cdrom_device_info *cdi,
 	ret = cdrom_mode_sense(cdi, cgc, GPMODE_AUDIO_CTL_PAGE, 0);
 	if (ret)
 		return ret;
-		
+
 	/* originally the code depended on buffer[1] to determine
 	   how much data is available for transfer. buffer[1] is
-	   unfortunately ambigious and the only reliable way seem
+	   unfortunately ambiguous and the only reliable way seem
 	   to be to simply skip over the block descriptor... */
 	offset = 8 + be16_to_cpu(*(__be16 *)(buffer + 6));
 
@@ -3131,7 +3195,7 @@ static noinline int mmc_ioctl_cdrom_volume(struct cdrom_device_info *cdi,
 			return -EFAULT;
 		return 0;
 	}
-		
+
 	/* get the volume mask */
 	cgc->buffer = mask;
 	ret = cdrom_mode_sense(cdi, cgc, GPMODE_AUDIO_CTL_PAGE, 1);
@@ -3154,11 +3218,13 @@ static noinline int mmc_ioctl_cdrom_start_stop(struct cdrom_device_info *cdi,
 					       int cmd)
 {
 	struct cdrom_device_ops *cdo = cdi->ops;
+
 	cd_dbg(CD_DO_IOCTL, "entering CDROMSTART/CDROMSTOP\n");
 	cgc->cmd[0] = GPCMD_START_STOP_UNIT;
 	cgc->cmd[1] = 1;
 	cgc->cmd[4] = (cmd == CDROMSTART) ? 1 : 0;
 	cgc->data_direction = CGC_DATA_NONE;
+
 	return cdo->generic_packet(cdi, cgc);
 }
 
@@ -3167,10 +3233,12 @@ static noinline int mmc_ioctl_cdrom_pause_resume(struct cdrom_device_info *cdi,
 						 int cmd)
 {
 	struct cdrom_device_ops *cdo = cdi->ops;
+
 	cd_dbg(CD_DO_IOCTL, "entering CDROMPAUSE/CDROMRESUME\n");
 	cgc->cmd[0] = GPCMD_PAUSE_RESUME;
 	cgc->cmd[8] = (cmd == CDROMRESUME) ? 1 : 0;
 	cgc->data_direction = CGC_DATA_NONE;
+
 	return cdo->generic_packet(cdi, cgc);
 }
 
@@ -3211,6 +3279,7 @@ static noinline int mmc_ioctl_dvd_auth(struct cdrom_device_info *cdi,
 {
 	int ret;
 	dvd_authinfo ai;
+
 	if (!CDROM_CAN(CDC_DVD))
 		return -ENOSYS;
 	cd_dbg(CD_DO_IOCTL, "entering DVD_AUTH\n");
@@ -3221,6 +3290,7 @@ static noinline int mmc_ioctl_dvd_auth(struct cdrom_device_info *cdi,
 		return ret;
 	if (copy_to_user((dvd_authinfo __user *)arg, &ai, sizeof(ai)))
 		return -EFAULT;
+
 	return 0;
 }
 
@@ -3229,12 +3299,14 @@ static noinline int mmc_ioctl_cdrom_next_writable(struct cdrom_device_info *cdi,
 {
 	int ret;
 	long next = 0;
+
 	cd_dbg(CD_DO_IOCTL, "entering CDROM_NEXT_WRITABLE\n");
 	ret = cdrom_get_next_writable(cdi, &next);
 	if (ret)
 		return ret;
 	if (copy_to_user((long __user *)arg, &next, sizeof(next)))
 		return -EFAULT;
+
 	return 0;
 }
 
@@ -3243,12 +3315,14 @@ static noinline int mmc_ioctl_cdrom_last_written(struct cdrom_device_info *cdi,
 {
 	int ret;
 	long last = 0;
+
 	cd_dbg(CD_DO_IOCTL, "entering CDROM_LAST_WRITTEN\n");
 	ret = cdrom_get_last_written(cdi, &last);
 	if (ret)
 		return ret;
 	if (copy_to_user((long __user *)arg, &last, sizeof(last)))
 		return -EFAULT;
+
 	return 0;
 }
 
@@ -3393,19 +3467,7 @@ int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
 
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
 
@@ -3470,13 +3532,16 @@ static int cdrom_print_info(const char *header, int val, char *info,
 	return 0;
 }
 
-static int cdrom_sysctl_info(struct ctl_table *ctl, int write,
-                           void __user *buffer, size_t *lenp, loff_t *ppos)
+static int cdrom_sysctl_info(struct ctl_table *ctl,
+			     int write,
+			     void __user *buffer,
+			     size_t *lenp,
+			     loff_t *ppos)
 {
 	int pos;
 	char *info = cdrom_sysctl_settings.info;
 	const int max_size = sizeof(cdrom_sysctl_settings.info);
-	
+
 	if (!*lenp || (*ppos && !write)) {
 		*lenp = 0;
 		return 0;
@@ -3485,7 +3550,7 @@ static int cdrom_sysctl_info(struct ctl_table *ctl, int write,
 	mutex_lock(&cdrom_mutex);
 
 	pos = sprintf(info, "CD-ROM information, " VERSION "\n");
-	
+
 	if (cdrom_print_info("\ndrive name:\t", 0, info, &pos, CTL_NAME))
 		goto done;
 	if (cdrom_print_info("\ndrive speed:\t", 0, info, &pos, CTL_SPEED))
@@ -3587,11 +3652,11 @@ static int cdrom_sysctl_handler(struct ctl_table *ctl, int write,
 				void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int ret;
-	
+
 	ret = proc_dointvec(ctl, write, buffer, lenp, ppos);
 
 	if (write) {
-	
+
 		/* we only care for 1 or 0. */
 		autoclose        = !!cdrom_sysctl_settings.autoclose;
 		autoeject        = !!cdrom_sysctl_settings.autoeject;
@@ -3605,14 +3670,14 @@ static int cdrom_sysctl_handler(struct ctl_table *ctl, int write,
 		cdrom_update_settings();
 	}
 
-        return ret;
+	return ret;
 }
 
 /* Place files in /proc/sys/dev/cdrom */
 static struct ctl_table cdrom_table[] = {
 	{
 		.procname	= "info",
-		.data		= &cdrom_sysctl_settings.info, 
+		.data		= &cdrom_sysctl_settings.info,
 		.maxlen		= CDROM_STR_SIZE,
 		.mode		= 0444,
 		.proc_handler	= cdrom_sysctl_info,
-- 
1.7.10.4

