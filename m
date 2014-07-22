Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaGVLJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:09:04 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:56930 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaGVLJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:09:03 -0400
From: Enric Balletbo i Serra <eballetbo@iseebcn.com>
To: gregkh@linuxfoundation.org, pavan_savoy@ti.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Enric Balletbo i Serra <eballetbo@iseebcn.com>
Subject: [PATCH] drivers/misc/ti-st: Load firmware from ti-connectivity directory.
Date: Tue, 22 Jul 2014 13:08:38 +0200
Message-Id: <1406027318-26186-1-git-send-email-eballetbo@iseebcn.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like the default location for TI firmware is inside the ti-connectivity
directory, to be coherent with other firmware request used by TI drivers, load
the TIInit firmware from this directory instead of /lib/firmware directly.

Signed-off-by: Enric Balletbo i Serra <eballetbo@iseebcn.com>
---
 drivers/misc/ti-st/st_kim.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 9d3dbb2..fa6a900 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -244,7 +244,8 @@ static long read_local_version(struct kim_data_s *kim_gdata, char *bts_scr_name)
 	if (version & 0x8000)
 		maj_ver |= 0x0008;
 
-	sprintf(bts_scr_name, "TIInit_%d.%d.%d.bts", chip, maj_ver, min_ver);
+	sprintf(bts_scr_name, "ti-connectivity/TIInit_%d.%d.%d.bts",
+		chip, maj_ver, min_ver);
 
 	/* to be accessed later via sysfs entry */
 	kim_gdata->version.full = version;
@@ -287,7 +288,7 @@ static long download_firmware(struct kim_data_s *kim_gdata)
 	long len = 0;
 	unsigned char *ptr = NULL;
 	unsigned char *action_ptr = NULL;
-	unsigned char bts_scr_name[30] = { 0 };	/* 30 char long bts scr name? */
+	unsigned char bts_scr_name[40] = { 0 };	/* 40 char long bts scr name? */
 	int wr_room_space;
 	int cmd_size;
 	unsigned long timeout;
-- 
1.9.1

