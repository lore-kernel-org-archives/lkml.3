Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaKJUXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:23:09 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:12383 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634AbaKJUXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:23:07 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuMNAMAdYVRXQ4qy/2dsb2JhbABcgw5UWbgoBQF0iRiJPYdXAoEnFwEBAQEBfYQDAQUnLxoJEFE5HhmIRQG9HI9/AQEBAQYihjqKWweESwWGOpBKhyGBcZRvg3s8L4JLAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Jens Axboe <axboe@kernel.dk>,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH v2 03/10 linux-next] cdrom: fix spaces required errors
Date: Mon, 10 Nov 2014 21:21:48 +0100
Message-Id: <1415650916-9975-4-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415650916-9975-1-git-send-email-fabf@skynet.be>
References: <1415650916-9975-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/cdrom/cdrom.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index c311e0d..deda0f1 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -286,7 +286,7 @@
 /* used to tell the module to turn on full debugging messages */
 static bool debug;
 /* default compatibility mode */
-static bool autoclose=1;
+static bool autoclose = 1;
 static bool autoeject;
 static bool lockdoor = 1;
 /* will we ever get to use this... sigh. */
@@ -535,7 +535,7 @@ static int cdrom_mrw_exit(struct cdrom_device_info *cdi)
 	int ret;
 
 	ret = cdrom_get_disc_info(cdi, &di);
-	if (ret < 0 || ret < (int)offsetof(typeof(di),disc_type))
+	if (ret < 0 || ret < (int)offsetof(typeof(di), disc_type))
 		return 1;
 
 	ret = 0;
@@ -699,7 +699,7 @@ static int cdrom_get_random_writable(struct cdrom_device_info *cdi,
 	if ((ret = cdi->ops->generic_packet(cdi, &cgc)))
 		return ret;
 
-	memcpy(rfd, &buffer[sizeof(struct feature_header)], sizeof (*rfd));
+	memcpy(rfd, &buffer[sizeof(struct feature_header)], sizeof(*rfd));
 	return 0;
 }
 
@@ -787,7 +787,7 @@ static int cdrom_mrw_open_write(struct cdrom_device_info *cdi)
 	}
 
 	ret = cdrom_get_disc_info(cdi, &di);
-	if (ret < 0 || ret < offsetof(typeof(di),disc_type))
+	if (ret < 0 || ret < offsetof(typeof(di), disc_type))
 		return 1;
 
 	if (!di.erasable)
@@ -1048,7 +1048,7 @@ int open_for_data(struct cdrom_device_info *cdi)
 			if (CDROM_CAN(CDC_CLOSE_TRAY) &&
 			    cdi->options & CDO_AUTO_CLOSE) {
 				cd_dbg(CD_OPEN, "trying to close the tray\n");
-				ret=cdo->tray_move(cdi,0);
+				ret = cdo->tray_move(cdi, 0);
 				if (ret) {
 					cd_dbg(CD_OPEN, "bummer. tried to close the tray but failed.\n");
 					/* Ignore the error from the low
@@ -1056,27 +1056,27 @@ int open_for_data(struct cdrom_device_info *cdi)
 					couldn't close the tray.  We only care 
 					that there is no disc in the drive, 
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
@@ -1084,19 +1084,19 @@ int open_for_data(struct cdrom_device_info *cdi)
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
 		    /* give people a warning shot, now that CDO_CHECK_TYPE
 		       is the default case! */
 		    cd_dbg(CD_OPEN, "bummer. wrong media type.\n");
 		    cd_dbg(CD_WARNING, "pid %d must open device O_NONBLOCK!\n",
 			   (unsigned int)task_pid_nr(current));
-		    ret=-EMEDIUMTYPE;
+		    ret = -EMEDIUMTYPE;
 		    goto clean_up_and_return;
 		}
 		else {
@@ -1213,7 +1213,7 @@ static int check_for_audio_disc(struct cdrom_device_info * cdi,
 			if (CDROM_CAN(CDC_CLOSE_TRAY) &&
 			    cdi->options & CDO_AUTO_CLOSE) {
 				cd_dbg(CD_OPEN, "trying to close the tray\n");
-				ret=cdo->tray_move(cdi,0);
+				ret = cdo->tray_move(cdi, 0);
 				if (ret) {
 					cd_dbg(CD_OPEN, "bummer. tried to close tray but failed.\n");
 					/* Ignore the error from the low
@@ -1229,11 +1229,11 @@ static int check_for_audio_disc(struct cdrom_device_info * cdi,
 			}
 			/* Ok, the door should be closed now.. Check again */
 			ret = cdo->drive_status(cdi, CDSL_CURRENT);
-			if ((ret == CDS_NO_DISC) || (ret==CDS_TRAY_OPEN)) {
+			if ((ret == CDS_NO_DISC) || (ret == CDS_TRAY_OPEN)) {
 				cd_dbg(CD_OPEN, "bummer. the tray is still not closed.\n");
 				return -ENOMEDIUM;
 			}	
-			if (ret!=CDS_DISC_OK) {
+			if (ret != CDS_DISC_OK) {
 				cd_dbg(CD_OPEN, "bummer. disc isn't ready.\n");
 				return -EIO;
 			}	
@@ -1244,7 +1244,7 @@ static int check_for_audio_disc(struct cdrom_device_info * cdi,
 	if (tracks.error) 
 		return(tracks.error);
 
-	if (tracks.audio==0)
+	if (tracks.audio == 0)
 		return -EMEDIUMTYPE;
 
 	return 0;
@@ -1589,8 +1589,8 @@ void init_cdrom_command(struct packet_command *cgc, void *buf, int len,
 
 /* DVD handling */
 
-#define copy_key(dest,src)	memcpy((dest), (src), sizeof(dvd_key))
-#define copy_chal(dest,src)	memcpy((dest), (src), sizeof(dvd_challenge))
+#define copy_key(dest, src)	memcpy((dest), (src), sizeof(dvd_key))
+#define copy_chal(dest, src)	memcpy((dest), (src), sizeof(dvd_challenge))
 
 static void setup_report_key(struct packet_command *cgc, unsigned agid, unsigned type)
 {
-- 
1.9.1

